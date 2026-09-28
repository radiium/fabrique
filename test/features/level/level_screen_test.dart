import 'dart:async';
import 'dart:math' as math;

import 'package:fabrique/core/calc/tilt.dart';
import 'package:fabrique/core/widgets/error_banner.dart';
import 'package:fabrique/features/level/level_controller.dart';
import 'package:fabrique/features/level/level_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';
import '../../support/phone.dart';

void main() {
  const g = 9.81;
  double rad(double deg) => deg * math.pi / 180;

  /// Monte le Niveau sur un capteur qui livre [readings].
  Future<ProviderContainer> pumpLevel(
    WidgetTester tester,
    Stream<AccelReading> readings,
  ) async {
    usePhone(tester);
    final container = ProviderContainer(
      overrides: [accelStreamProvider.overrideWith((ref) => readings)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: testApp(home: const LevelScreen()),
      ),
    );
    await tester.pump();
    return container;
  }

  /// Laisse passer le délai de silence : aucun `Timer` ne survit au test.
  Future<void> settle(WidgetTester tester) => tester.pump(kSensorSilenceDelay);

  testWidgets('l’écran se verrouille en portrait, et rend l’orientation en '
      'sortant', (tester) async {
    final calls = <Object?>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemChrome.setPreferredOrientations') {
          calls.add(call.arguments);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await pumpLevel(tester, Stream.value(const AccelReading(0, 0, g)));
    expect(calls, [
      ['DeviceOrientation.portraitUp'],
    ]);

    await tester.pumpWidget(const SizedBox());
    expect(calls.last, isEmpty);
    await settle(tester);
  });

  testWidgets('un capteur muet est dit indisponible, pas pris pour un niveau', (
    tester,
  ) async {
    await pumpLevel(tester, Stream.multi((_) {}));
    expect(find.text('Accéléromètre indisponible'), findsNothing);

    await settle(tester);
    expect(find.text('Accéléromètre indisponible'), findsOneWidget);
  });

  /// Debout, tourné de [deg] dans le sens antihoraire vu de face.
  AccelReading uprightBy(double deg) =>
      AccelReading(g * math.sin(rad(deg)), g * math.cos(rad(deg)), 0);

  const flat = AccelReading(0, 0, g);

  /// Livre [reading] au capteur : l'évènement arrive dans une frame, l'écran
  /// se reconstruit dans la suivante.
  Future<void> feed(
    WidgetTester tester,
    StreamController<AccelReading> sensor,
    AccelReading reading,
  ) async {
    sensor.add(reading);
    await tester.pump();
    await tester.pump();
  }

  /// Le temps d'une mesure immobile : attente, puis moyenne.
  Future<void> measure(WidgetTester tester) async {
    await tester.pump(kSettleDelay);
    await tester.pump(kSampleWindow);
    await tester.pump();
  }

  testWidgets('couché sur une grande tranche, la pente dit où caler', (
    tester,
  ) async {
    // Couché sur le bord gauche, extrémité droite levée de 1°.
    await pumpLevel(tester, Stream.value(uprightBy(91)));

    expect(find.text('Inclinaison'), findsOneWidget);
    expect(find.text('Pente'), findsOneWidget);
    // tan 1° × 1000.
    expect(find.text('17,5'), findsOneWidget);
    expect(find.text('Caler sous l’extrémité gauche'), findsOneWidget);
    await settle(tester);
  });

  testWidgets('la pente se lit sans signe, le côté dans la note', (
    tester,
  ) async {
    await pumpLevel(tester, Stream.value(uprightBy(89)));

    expect(
      find.text('-1,0'),
      findsOneWidget,
      reason: 'l’angle garde son signe',
    );
    expect(find.text('17,5'), findsOneWidget);
    expect(find.text('Caler sous l’extrémité droite'), findsOneWidget);
    await settle(tester);
  });

  testWidgets('debout, le faux aplomb dit de quel côté penche le haut', (
    tester,
  ) async {
    // Tourné de 1° dans le sens antihoraire : le haut part à gauche.
    await pumpLevel(tester, Stream.value(uprightBy(1)));

    expect(find.text('Écart d’aplomb'), findsOneWidget);
    expect(find.text('Le haut penche à gauche'), findsOneWidget);
    await settle(tester);
  });

  testWidgets('à plat, rien ne se mesure', (tester) async {
    await pumpLevel(tester, Stream.value(flat));

    expect(find.text('—'), findsNWidgets(2));
    expect(find.text('Non calibré sur cette tranche'), findsNothing);
    await settle(tester);
  });

  testWidgets('sans saisie, pas de « réinitialiser »', (tester) async {
    await pumpLevel(tester, Stream.value(uprightBy(0)));

    expect(find.byIcon(Icons.restart_alt), findsNothing);
    await settle(tester);
  });

  testWidgets('le calibrage par retournement corrige le biais, et se dit', (
    tester,
  ) async {
    // Surface penchée de 1,2°, capteur biaisé de 0,3° : 1,5° puis −0,9°.
    final sensor = StreamController<AccelReading>.broadcast();
    addTearDown(sensor.close);
    final container = await pumpLevel(tester, sensor.stream);
    await feed(tester, sensor, uprightBy(1.5));
    expect(find.text('Non calibré sur cette tranche'), findsOneWidget);

    await tester.tap(find.text('Calibrer le téléphone'));
    await tester.pumpAndSettle();
    expect(find.text('Étape 1 sur 2'), findsOneWidget);

    await tester.tap(find.text('Mesurer'));
    await tester.pump();
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    await measure(tester);
    expect(find.text('Étape 2 sur 2'), findsOneWidget);

    await feed(tester, sensor, uprightBy(-0.9));
    await tester.tap(find.text('Mesurer'));
    await measure(tester);
    expect(
      find.text('Calibrage enregistré. Écart corrigé : 0,3°.'),
      findsOneWidget,
    );
    expect(
      container.read(tiltCalibrationProvider).edgesDeg[0],
      closeTo(0.3, 1e-6),
    );

    await tester.tap(find.text('Terminer'));
    await tester.pumpAndSettle();
    expect(find.text('Calibré sur cette tranche'), findsOneWidget);
    // −0,9° lus, 0,3° de biais : la surface penche de −1,2°.
    expect(find.text('-1,2'), findsOneWidget);
    await settle(tester);
  });

  testWidgets('un téléphone qui bouge pendant la mesure est refusé', (
    tester,
  ) async {
    final sensor = StreamController<AccelReading>.broadcast();
    addTearDown(sensor.close);
    await pumpLevel(tester, sensor.stream);
    await feed(tester, sensor, uprightBy(0));

    await tester.tap(find.text('Calibrer le téléphone'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mesurer'));
    await tester.pump(kSettleDelay);
    sensor.add(uprightBy(2));
    await tester.pump(kSampleWindow);
    await tester.pump();

    expect(
      find.widgetWithText(
        ErrorBanner,
        'Le téléphone a bougé pendant la mesure. Posez-le, puis ne le touchez '
        'plus jusqu’à la fin.',
      ),
      findsOneWidget,
    );
    await settle(tester);
  });

  testWidgets('une mesure prise à plat est refusée, et se recommence', (
    tester,
  ) async {
    final sensor = StreamController<AccelReading>.broadcast();
    addTearDown(sensor.close);
    await pumpLevel(tester, sensor.stream);
    await feed(tester, sensor, uprightBy(0));

    await tester.tap(find.text('Calibrer le téléphone'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mesurer'));
    await measure(tester);

    await feed(tester, sensor, flat);
    await tester.tap(find.text('Mesurer'));
    await measure(tester);

    expect(
      find.widgetWithText(
        ErrorBanner,
        'Le téléphone était à plat. Posez-le sur une tranche pour le calibrer.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Recommencer'));
    await tester.pump();
    expect(find.text('Étape 1 sur 2'), findsOneWidget);
    await settle(tester);
  });

  testWidgets('la feuille de calibrage reste au-dessus de la barre de '
      'navigation', (tester) async {
    // Barre à trois boutons d'Android : 48 px.
    const navigationBar = 48.0;
    tester.view
      ..padding = const FakeViewPadding(bottom: navigationBar)
      ..viewPadding = const FakeViewPadding(bottom: navigationBar);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetViewPadding);
    await pumpLevel(tester, Stream.value(uprightBy(0)));

    await tester.tap(find.text('Calibrer le téléphone'));
    await tester.pumpAndSettle();

    final button = tester.getRect(find.widgetWithText(FilledButton, 'Mesurer'));
    expect(
      button.bottom,
      lessThanOrEqualTo(kReferencePhone.height - navigationBar),
    );
    await settle(tester);
  });
}
