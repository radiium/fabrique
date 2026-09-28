import 'package:fabrique/app/theme.dart';
import 'package:fabrique/core/format.dart';
import 'package:fabrique/core/models/enums.dart';
import 'package:fabrique/core/widgets/app_dropdown.dart';
import 'package:fabrique/core/widgets/error_banner.dart';
import 'package:fabrique/core/widgets/schema_card.dart';
import 'package:fabrique/features/layout/layout_controller.dart';
import 'package:fabrique/features/layout/layout_presets.dart';
import 'package:fabrique/features/layout/layout_screen.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';
import '../../support/l10n.dart';
import '../../support/phone.dart';

void main() {
  Future<ProviderContainer> pumpLayout(
    WidgetTester tester, {
    Locale locale = const Locale('fr'),
  }) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: testApp(home: const LayoutScreen(), locale: locale),
      ),
    );
    return container;
  }

  Future<void> open(WidgetTester tester, String group) async {
    await tester.tap(find.text(group));
    await tester.pumpAndSettle();
  }

  testWidgets('seule la surface est dépliée à l’arrivée', (tester) async {
    usePhone(tester);
    await pumpLayout(tester);

    expect(find.text('Surface — largeur'), findsOneWidget);
    for (final label in const [
      'Matériau',
      'Élément — largeur',
      'Inverser l’orientation',
      'Jeu horizontal',
      'Jeu périphérique',
    ]) {
      expect(find.text(label), findsNothing, reason: label);
    }
  });

  testWidgets('chaque groupe résume ses valeurs, sans rien tronquer', (
    tester,
  ) async {
    usePhone(tester);
    await pumpLayout(tester);
    // Ouvert, un groupe masque son résumé.
    await tester.tap(find.text('Surface').first);
    await tester.pumpAndSettle();

    for (final summary in const [
      '3000 × 2000 mm',
      '1200 × 200 mm · décalage ½',
      'Aucun jeu',
    ]) {
      final finder = find.text(summary);
      expect(finder, findsOneWidget, reason: summary);
      expect(
        tester.renderObject<RenderParagraph>(finder).didExceedMaxLines,
        isFalse,
        reason: summary,
      );
    }
  });

  testWidgets('le résumé nomme le matériau, et les options allumées', (
    tester,
  ) async {
    usePhone(tester);
    final container = await pumpLayout(tester);
    container.read(layoutFormProvider.notifier)
      // Inversé d'abord : le preset traduit ses jeux selon le sens de pose.
      ..setFlip(true)
      ..applyPreset(
        kLayoutPresets.firstWhere((p) => p.material == LayoutMaterial.decking),
      )
      ..setBalanceRows(true);
    await tester.pump();

    final input = container.read(layoutFormProvider);
    expect(
      find.text(
        'Terrasse 4000×145 · décalage droit · orientation inversée · '
        'rangées équilibrées',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'entre éléments ${formatNumber(input.gapX)} × '
        '${formatNumber(input.gapY)} · périphérique 10 mm',
      ),
      findsOneWidget,
    );
  });

  testWidgets('la tuile des rangées de bord n’apparaît qu’équilibrée', (
    tester,
  ) async {
    usePhone(tester);
    final container = await pumpLayout(tester);
    final form = container.read(layoutFormProvider.notifier);

    expect(find.text('Rangées de bord'), findsNothing);

    // 2010 de long pour des éléments de 200 : la dernière rangée ferait 10 mm.
    form
      ..setSurfaceY(2010)
      ..setElementX(2000)
      ..setElementY(200)
      ..setSurfaceX(2000)
      ..setOffset(JointOffset.straight)
      ..setBalanceRows(true);
    await tester.pumpAndSettle();

    expect(find.text('Rangées de bord'), findsOneWidget);
    expect(find.text('105'), findsOneWidget);
  });

  testWidgets('une saisie refusée montre son motif, pas un tiret muet', (
    tester,
  ) async {
    // Huit contrôles : un tiret laisserait chercher lequel est fautif.
    usePhone(tester);
    final container = await pumpLayout(tester);
    final form = container.read(layoutFormProvider.notifier);

    expect(find.byType(ErrorBanner), findsNothing);

    form
      ..setElementX(1)
      ..setElementY(1);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(ErrorBanner), findsOneWidget);
    expect(find.text('Rangées de bord'), findsNothing);

    form
      ..setElementX(1200)
      ..setElementY(200);
    await tester.pumpAndSettle();
    expect(find.byType(ErrorBanner), findsNothing);
  });

  testWidgets('le refus se lit dans la carte de saisie, pas sous le schéma', (
    tester,
  ) async {
    usePhone(tester);
    final container = await pumpLayout(tester);
    container.read(layoutFormProvider.notifier).setElementX(9000);
    await tester.pumpAndSettle();

    final banner = tester.getRect(find.byType(ErrorBanner));
    final schema = tester.getRect(find.byType(SchemaCard));
    expect(banner.bottom, lessThan(schema.top));
  });

  group('presets', () {
    testWidgets('remplissent format, jeux et décalage d’un coup', (
      tester,
    ) async {
      usePhone(tester);
      final container = await pumpLayout(tester);
      await open(tester, 'Élément et pose');

      await tester.tap(find.byType(AppDropdown<LayoutPreset?>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Terrasse 4000×145').last);
      await tester.pumpAndSettle();

      final input = container.read(layoutFormProvider);
      expect(input.elementX, 4000);
      expect(input.elementY, 145);
      // Le seul preset dont les deux jeux diffèrent.
      expect(input.gapX, 3);
      expect(input.gapY, 5);
      expect(input.perimeterGap, 10);
      expect(input.offset, JointOffset.straight);
      expect(input.surfaceX, kLayoutDefaults.surfaceX);
      expect(input.surfaceY, kLayoutDefaults.surfaceY);
    });

    testWidgets('les jeux suivent le sens de pose', (tester) async {
      usePhone(tester);
      final container = await pumpLayout(tester);
      container.read(layoutFormProvider.notifier).setFlip(true);
      await open(tester, 'Élément et pose');

      await tester.tap(find.byType(AppDropdown<LayoutPreset?>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Terrasse 4000×145').last);
      await tester.pumpAndSettle();

      // Inversé, le jeu en bout passe en Y.
      final input = container.read(layoutFormProvider);
      expect(input.gapX, 5);
      expect(input.gapY, 3);
    });

    testWidgets('la valeur se dérive de la saisie', (tester) async {
      usePhone(tester);
      final container = await pumpLayout(tester);
      final form = container.read(layoutFormProvider.notifier);
      await open(tester, 'Élément et pose');

      expect(find.text('Personnalisé'), findsOneWidget);

      form.applyPreset(kLayoutPresets.first);
      await tester.pumpAndSettle();
      expect(find.text('Placo 1200×2500'), findsOneWidget);
      expect(find.text('Personnalisé'), findsNothing);

      form.setElementX(1201);
      await tester.pumpAndSettle();
      expect(find.text('Placo 1200×2500'), findsNothing);
      expect(find.text('Personnalisé'), findsOneWidget);
    });

    testWidgets('« Personnalisé » ne s’offre pas quand un preset est pris', (
      tester,
    ) async {
      usePhone(tester);
      final container = await pumpLayout(tester);
      container
          .read(layoutFormProvider.notifier)
          .applyPreset(kLayoutPresets.first);
      await open(tester, 'Élément et pose');

      await tester.tap(find.byType(AppDropdown<LayoutPreset?>));
      await tester.pumpAndSettle();

      expect(find.text('Personnalisé'), findsNothing);
      expect(find.text('Carrelage 600×600'), findsWidgets);
    });

    for (final l10n in allLocales) {
      testWidgets(
        'aucun libellé ne déborde la valeur fermée (${l10n.localeName})',
        (tester) async {
          usePhone(tester);
          await pumpLayout(tester, locale: Locale(l10n.localeName));
          await open(tester, l10n.layoutElementGroup);

          final field = find.byType(AppDropdown<LayoutPreset?>);
          final closed = tester.getRect(find.text(l10n.layoutCustom));
          final available = closed.width;
          final style = controlTextStyle(tester.element(field));

          // La police des tests double la largeur des glyphes : on garde le rapport,
          // pas le seuil brut.
          const testFontFactor = 2;
          for (final preset in kLayoutPresets) {
            final label = preset.label(l10n);
            final painter = TextPainter(
              text: TextSpan(text: label, style: style),
              textDirection: TextDirection.ltr,
            )..layout();
            expect(
              painter.width / testFontFactor,
              lessThan(available),
              reason: '« $label » déborde la valeur fermée',
            );
          }
        },
      );
    }
  });
}
