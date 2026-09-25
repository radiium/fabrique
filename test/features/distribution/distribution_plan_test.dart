import 'package:fabrique/app/routes.dart';
import 'package:fabrique/app/theme.dart';
import 'package:fabrique/core/calc/distribution.dart';
import 'package:fabrique/core/export/plan.dart';
import 'package:fabrique/core/export/plan_export.dart';
import 'package:fabrique/core/models/tool.dart';
import 'package:fabrique/core/widgets/app_card_actions.dart';
import 'package:fabrique/core/widgets/schema_card.dart';
import 'package:fabrique/features/distribution/distribution_controller.dart';
import 'package:fabrique/features/distribution/distribution_form.dart';
import 'package:fabrique/features/distribution/distribution_plan.dart';
import 'package:fabrique/features/distribution/distribution_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';
import '../../support/phone.dart';

/// Le plan est la seule image qui sorte de l'app : une fois partie, personne
/// ne peut plus la corriger. Ce qui se vérifie ici, c'est ce qu'aucune autre
/// couche ne voit — un cartouche qui lève sur une combinaison de saisie, une
/// liste de positions tronquée en silence, et le bouton qui resterait actif
/// sur une saisie refusée.
void main() {
  ProviderContainer container() {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    return c;
  }

  PlanPainter? planOf(ProviderContainer c) => buildDistributionPlan(
    input: c.read(distributionFormProvider),
    outcome: c.read(distributionResultProvider),
    date: DateTime(2026, 9, 23),
  );

  group('le contenu du cartouche', () {
    test('reprend toutes les positions, jamais une partie', () {
      // La troncature est impossible par construction : le plan passe la liste
      // entière, et c'est le painter qui choisit entre la poser en entier ou
      // la remplacer par son repli. Une liste coupée sur un plan d'atelier,
      // c'est une pièce percée en moins, et rien sur la feuille ne le dirait.
      final c = container();
      c.read(distributionFormProvider.notifier)
        ..setLength(20000)
        ..setCount(120);

      final result =
          (c.read(distributionResultProvider) as DistributionReady).best;
      final table = planOf(c)!.plan.tables.single;

      expect(table.rows, hasLength(result.positions.length));
      expect(table.fallback, contains('120'));
    });

    test('ne répète pas ce que le dessin cote déjà', () {
      // La largeur totale, la largeur d'élément et les marges sont sur le
      // schéma, aux mêmes chiffres. Les réécrire dans le cartouche serait une
      // redite, et chaque case coûte une position dans la table.
      final labels = planOf(container())!.plan.fields
          .map((f) => f.$1)
          .join(' ');

      expect(labels, isNot(contains('LARGEUR')));
      expect(labels, isNot(contains('MARGE')));
      expect(labels, isNot(contains('RÉPARTITION')));
    });

    test('garde l’écart visé, la seule saisie absente du dessin', () {
      // Le schéma ne porte que l'écart obtenu. Sans la cible, rien n'explique
      // le nombre d'éléments trouvé.
      final c = container();
      c.read(distributionFormProvider.notifier)
        ..setMode(DistributionMode.count)
        ..setTargetSpacing(150);

      final labels = planOf(c)!.plan.fields.map((f) => f.$1);
      expect(labels, containsAll(['ÉCART SOUHAITÉ', 'ÉCART OBTENU']));
    });

    test('n’existe pas quand la saisie est refusée', () {
      final c = container();
      c.read(distributionFormProvider.notifier).setElementWidth(1000);

      expect(c.read(distributionResultProvider), isA<DistributionFailure>());
      expect(planOf(c), isNull);
    });
  });

  testWidgets('le plan se rend sans lever, quels que soient mode et bords', (
    tester,
  ) async {
    final c = container();
    final form = c.read(distributionFormProvider.notifier);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const Scaffold(body: DistributionPlanView()),
        ),
      ),
    );

    for (final mode in DistributionMode.values) {
      for (final start in DistributionEdge.values) {
        for (final end in DistributionEdge.values) {
          form
            ..setMode(mode)
            ..setEdges(start, end);
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: '${mode.label} / $start / $end',
          );
        }
      }
    }
  });

  testWidgets('une table hors gabarit ne fait pas lever le rendu', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final c = container();
      c.read(distributionFormProvider.notifier)
        ..setLength(20000)
        ..setCount(kMaxDistributionCount);

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
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const DistributionScreen(),
        ),
      ),
    );

    final footer = find.byType(AppCardActions);
    List<CardAction> actions() => tester.widget<AppCardActions>(footer).actions;

    expect(actions().map((a) => a.label), ['Exporter', 'Partager']);
    expect(actions().every((a) => a.onTap != null), isTrue);

    c.read(distributionFormProvider.notifier).setElementWidth(1000);
    await tester.pumpAndSettle();

    // Éteints, jamais masqués : un bouton gris se lit, une chrome qui s'efface
    // se cherche.
    expect(footer, findsOneWidget);
    expect(actions().every((a) => a.onTap == null), isTrue);
  });

  testWidgets('aucun libellé d’action n’est tronqué sur un téléphone', (
    tester,
  ) async {
    // Deux boutons se partagent la largeur de la carte. La police des tests
    // donne à chaque glyphe la largeur de la taille de police, soit environ le
    // double d'une vraie : un libellé qui passe ici passe partout, et une
    // troncature ne se verrait nulle part ailleurs.
    usePhone(tester);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container(),
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const DistributionScreen(),
        ),
      ),
    );

    for (final label in ['Exporter', 'Partager']) {
      final text = tester.renderObject<RenderParagraph>(
        find.descendant(
          of: find.byType(AppCardActions),
          matching: find.text(label),
        ),
      );
      expect(
        text.didExceedMaxLines,
        isFalse,
        reason: '« $label » est tronqué dans son bouton',
      );
    }
  });

  testWidgets('la page plein écran montre le plan, cartouche compris', (
    tester,
  ) async {
    // L'aperçu et le fichier sont le même dessin. Une page qui montrerait le
    // schéma seul laisserait découvrir le cartouche dans le fichier, une fois
    // parti.
    await pumpApp(tester, AppRoutes.tool(Tool.distribution));

    await tester.tap(find.byType(SchemaCard));
    await tester.pumpAndSettle();

    expect(find.byType(DistributionPlanView), findsOneWidget);
    expect(find.byTooltip('Exporter le plan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
