import 'package:fabrique/app/routes.dart';
import 'package:fabrique/core/calc/layout.dart';
import 'package:fabrique/core/export/plan.dart';
import 'package:fabrique/core/export/plan_export.dart';
import 'package:fabrique/core/models/enums.dart';
import 'package:fabrique/core/models/tool.dart';
import 'package:fabrique/core/widgets/app_card_actions.dart';
import 'package:fabrique/core/widgets/schema_card.dart';
import 'package:fabrique/features/layout/layout_controller.dart';
import 'package:fabrique/features/layout/layout_plan.dart';
import 'package:fabrique/features/layout/layout_presets.dart';
import 'package:fabrique/features/layout/layout_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';
import '../../support/l10n.dart';

void main() {
  ProviderContainer container() {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    return c;
  }

  PlanPainter? planOf(ProviderContainer c) => buildLayoutPlan(
    l10n: fr,
    input: c.read(layoutFormProvider),
    outcome: c.read(layoutResultProvider),
    date: DateTime(2026, 9, 23),
  );

  group('le contenu du cartouche', () {
    test('ne répète pas ce que le dessin cote déjà', () {
      final plan = planOf(container())!.plan;
      final labels = plan.fields.map((f) => f.$1);

      expect(labels, isNot(contains('SURFACE X')));
      expect(labels, isNot(contains('LARGEUR')));
      expect(labels, isNot(contains('LONGUEUR')));
      expect(labels, contains('ÉLÉMENT'));
      expect(labels, contains('DÉCALAGE'));
    });

    test('les jeux n’occupent une case que s’ils agissent', () {
      final c = container();
      expect(planOf(c)!.plan.fields.map((f) => f.$1), isNot(contains('JEU')));

      c.read(layoutFormProvider.notifier)
        ..setGapX(2)
        ..setPerimeterGap(5);
      final labels = planOf(c)!.plan.fields.map((f) => f.$1);
      expect(labels, contains('JEU'));
      expect(labels, contains('JEU PÉRIPH.'));
    });

    test('reprend toutes les cotes de coupe, jamais une partie', () {
      final c = container();
      final table = planOf(c)!.plan.tables.single;
      final cuts = summarizeCuts(
        (c.read(layoutResultProvider) as LayoutReady).result,
      );

      expect(table.rows, hasLength(cuts.length));
      expect(
        table.rows.every((row) => row.length == table.headers.length),
        isTrue,
      );
      expect(table.headers.first, 'N°');
    });

    test('porte l’avertissement de l’outil', () {
      final note = planOf(container())!.plan.note;
      expect(note, isNotNull);
      expect(note, contains('réemploi'));
    });

    test('n’existe pas quand la saisie est refusée', () {
      final c = container();
      c.read(layoutFormProvider.notifier).setElementX(99999);
      expect(planOf(c), isNull);
    });
  });

  testWidgets(
    'le plan se rend sans lever, quels que soient preset et options',
    (tester) async {
      await tester.runAsync(() async {
        for (final preset in kLayoutPresets) {
          for (final balance in [false, true]) {
            for (final flip in [false, true]) {
              final c = container();
              // Une pièce assez grande pour tous les presets.
              c.read(layoutFormProvider.notifier)
                ..setSurfaceX(6000)
                ..setSurfaceY(5000)
                ..applyPreset(preset)
                ..setBalanceRows(balance)
                ..setFlip(flip);

              final bytes = await renderPlanPng(planOf(c)!, width: 400);
              expect(
                bytes,
                isNotEmpty,
                reason: '${preset.label} / $balance / $flip',
              );
            }
          }
        }
      });
    },
  );

  testWidgets('une liste de débit hors gabarit ne fait pas lever le rendu', (
    tester,
  ) async {
    await tester.runAsync(() async {
      // Un décalage au tiers sur une trame fine multiplie les cotes de coupe.
      final c = container();
      c.read(layoutFormProvider.notifier)
        ..setSurfaceX(2003)
        ..setSurfaceY(1007)
        ..setElementX(97)
        ..setElementY(53)
        ..setOffset(JointOffset.third);

      final bytes = await renderPlanPng(planOf(c)!, width: 600);
      expect(bytes, isNotEmpty);
    });
  });

  testWidgets('les deux actions s’éteignent sur une saisie refusée', (
    tester,
  ) async {
    final c = container();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: testApp(home: const LayoutScreen()),
      ),
    );

    final footer = find.byType(AppCardActions);
    List<CardAction> actions() => tester.widget<AppCardActions>(footer).actions;

    expect(actions().map((a) => a.label), ['Exporter', 'Partager']);
    expect(actions().every((a) => a.onTap != null), isTrue);

    c.read(layoutFormProvider.notifier).setElementX(99999);
    await tester.pumpAndSettle();

    expect(footer, findsOneWidget);
    expect(actions().every((a) => a.onTap == null), isTrue);
  });

  testWidgets('la page plein écran montre le plan, cartouche compris', (
    tester,
  ) async {
    await pumpApp(tester, AppRoutes.tool(Tool.layout));

    await tester.tap(find.byType(SchemaCard));
    await tester.pumpAndSettle();

    expect(find.byType(LayoutPlanView), findsOneWidget);
    expect(find.byTooltip('Exporter le plan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
