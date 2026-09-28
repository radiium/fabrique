import 'package:fabrique/app/app.dart';
import 'package:fabrique/core/persistence/settings_controller.dart';
import 'package:fabrique/core/widgets/app_switch_field.dart';
import 'package:fabrique/core/widgets/count_field.dart';
import 'package:fabrique/core/widgets/haptics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/app.dart';

void main() {
  /// Les types de vibration demandés à la plateforme depuis le début du test.
  List<String> captureHaptics(WidgetTester tester) {
    final fired = <String>[];
    final messenger = tester.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'HapticFeedback.vibrate') {
        fired.add('${call.arguments}');
      }
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );
    return fired;
  }

  Future<void> pumpControls(WidgetTester tester, {bool? enabled}) async {
    final controls = Column(
      children: [
        CountField(
          label: 'Compteur',
          value: 3,
          min: 1,
          max: 10,
          onChanged: (_) {},
        ),
        AppSwitchField(label: 'Option', value: true, onChanged: (_) {}),
      ],
    );
    await tester.pumpWidget(
      testApp(
        home: Scaffold(
          body: enabled == null
              ? controls
              : HapticsScope(enabled: enabled, child: controls),
        ),
      ),
    );
  }

  Future<void> tapControls(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.text('Option'));
    await tester.pumpAndSettle();
  }

  testWidgets('le réglage coupé fait taire les contrôles', (tester) async {
    final fired = captureHaptics(tester);
    await pumpControls(tester, enabled: false);
    await tapControls(tester);

    expect(fired, isEmpty);
  });

  testWidgets('le réglage actif les laisse vibrer', (tester) async {
    final fired = captureHaptics(tester);
    await pumpControls(tester, enabled: true);
    await tapControls(tester);

    expect(fired, hasLength(2));
  });

  testWidgets('sans portée, un contrôle vibre quand même', (tester) async {
    // Sans portée, les contrôles vibrent : un oubli de câblage doit s'entendre.
    final fired = captureHaptics(tester);
    await pumpControls(tester);
    await tapControls(tester);

    expect(fired, hasLength(2));
  });

  testWidgets('la racine de l’app alimente la portée', (tester) async {
    // Le seul point de lecture du provider.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [hapticsEnabledProvider.overrideWithValue(false)],
        child: const FabriqueApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(HapticsScope.of(tester.element(find.byType(Scaffold).first)), false);
  });
}
