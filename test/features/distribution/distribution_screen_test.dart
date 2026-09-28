import 'package:fabrique/app/theme.dart';
import 'package:fabrique/core/calc/distribution.dart';
import 'package:fabrique/features/distribution/distribution_controller.dart';
import 'package:fabrique/features/distribution/distribution_form.dart';
import 'package:fabrique/features/distribution/distribution_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';
import '../../support/l10n.dart';
import '../../support/phone.dart';

void main() {
  Future<ProviderContainer> pumpDistribution(
    WidgetTester tester, {
    Locale locale = const Locale('fr'),
  }) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: testApp(home: const DistributionScreen(), locale: locale),
      ),
    );
    return container;
  }

  testWidgets('la table et les tuiles suivent l’épaisseur', (tester) async {
    final container = await pumpDistribution(tester);
    expect(find.text('Bord (mm)'), findsOneWidget);
    expect(find.text('Centre (mm)'), findsOneWidget);
    expect(find.text('Entraxe'), findsOneWidget);

    container.read(distributionFormProvider.notifier).setElementWidth(0);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    // Sans épaisseur, entraxe et écart se confondent.
    expect(find.text('Entraxe'), findsNothing);
    expect(find.text('Centre (mm)'), findsNothing);
    expect(find.text('Position (mm)'), findsOneWidget);
  });

  testWidgets('la table a le même blanc à gauche qu’à droite', (tester) async {
    // Une largeur de colonne arrondie décalerait le N° à gauche, sans que rien
    // ne le signale.
    usePhone(tester);
    await pumpDistribution(tester);

    final row = tester.getRect(
      find.ancestor(of: find.text('N°'), matching: find.byType(Padding)).first,
    );
    final firstCell = tester.getRect(find.text('N°'));
    final lastCell = tester.getRect(find.text('Centre (mm)'));

    // Le blanc visible, pas la boîte : bord de rayure au premier glyphe, dernier
    // glyphe (cadré à droite) au bord opposé.
    final firstGlyphs = tester
        .renderObject<RenderParagraph>(find.text('N°'))
        .getMaxIntrinsicWidth(double.infinity);

    expect(
      firstCell.left + (firstCell.width - firstGlyphs) - row.left,
      moreOrLessEquals(row.right - lastCell.right, epsilon: 0.5),
      reason:
          'le blanc à gauche du N° doit valoir celui après le dernier '
          'chiffre — une largeur de colonne ronde y ajouterait du mou',
    );
  });

  testWidgets('une saisie refusée montre son motif, pas un tiret muet', (
    tester,
  ) async {
    final container = await pumpDistribution(tester);
    final form = container.read(distributionFormProvider.notifier);

    // 11 éléments de 20 dans 100 mm.
    form.setLength(100);
    form.setElementWidth(20);
    form.setCount(11);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      container.read(distributionResultProvider),
      isA<DistributionFailure>(),
    );
    expect(find.textContaining('220'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });

  testWidgets('seule la géométrie est dépliée, les marges sans effet', (
    tester,
  ) async {
    usePhone(tester);
    final container = await pumpDistribution(tester);

    expect(find.text('Largeur totale'), findsOneWidget);
    expect(find.text('Marges'), findsNothing);

    final input = container.read(distributionFormProvider);
    expect(input.startOffset, 0);
    expect(input.endOffset, 0);
    expect(input.startEdge, DistributionEdge.element);
    expect(input.endEdge, DistributionEdge.element);

    await tester.tap(find.text('Bords et marges'));
    await tester.pumpAndSettle();
    expect(find.text('Marges'), findsOneWidget);
  });

  testWidgets('le résumé de la géométrie dit ce qu’on connaît', (tester) async {
    usePhone(tester);
    final container = await pumpDistribution(tester);
    // Ouvert, un groupe masque son résumé.
    await tester.tap(find.text('Géométrie'));
    await tester.pumpAndSettle();

    expect(find.text('5 éléments de 18 sur 1800 mm'), findsOneWidget);

    final form = container.read(distributionFormProvider.notifier)
      ..setMode(DistributionMode.count);
    await tester.pump();
    expect(
      find.text('Éléments de 18 sur 1800 mm · écart visé 150 mm'),
      findsOneWidget,
    );

    form
      ..setMode(DistributionMode.spacing)
      ..setElementWidth(0)
      ..setCount(1);
    await tester.pump();
    expect(find.text('1 repère sur 1800 mm'), findsOneWidget);
  });

  testWidgets('le résumé des bords suit la disposition et les marges', (
    tester,
  ) async {
    usePhone(tester);
    final container = await pumpDistribution(tester);

    expect(find.text('Élément – Élément · marges 0 mm'), findsOneWidget);

    final form = container.read(distributionFormProvider.notifier)
      ..setEdges(DistributionEdge.gap, DistributionEdge.element)
      ..setStartOffset(12.5);
    await tester.pump();
    expect(find.text('Écart – Élément · marges 12,5 mm'), findsOneWidget);

    form
      ..setSymmetricOffsets(false)
      ..setEndOffset(1250);
    await tester.pump();
    final summary = find.text('Écart – Élément · marges 12,5 / 1250 mm');
    expect(summary, findsOneWidget);
    expect(
      tester.renderObject<RenderParagraph>(summary).didExceedMaxLines,
      isFalse,
    );
  });

  for (final l10n in allLocales) {
    testWidgets('aucun libellé de contrôle n’est tronqué sur un téléphone '
        '(${l10n.localeName})', (tester) async {
      // Segments et tuiles tronquent en silence (`overflow: ellipsis`).
      usePhone(tester);
      await pumpDistribution(tester, locale: Locale(l10n.localeName));

      final labels = [for (final c in kEdgeChoices) c.label(l10n)];

      // Plus larges que la police des tests (18 px par glyphe), vérifiés sur un
      // Pixel 5 le 22/09/2026. Cette liste ne doit que raccourcir.
      const knownWiderThanTestFont = [
        'Calcul écart',
        'Calcul nombre',
        'Symétriques',
        'Asymétriques',
      ];

      void expectLabels(List<String> shown) {
        for (final label in shown) {
          final finder = find.text(label);
          expect(finder, findsWidgets, reason: label);
          final expected = knownWiderThanTestFont.contains(label);
          expect(
            tester
                .renderObject<RenderParagraph>(finder.first)
                .didExceedMaxLines,
            expected,
            reason: expected
                ? '« $label » tient désormais : à retirer de la liste'
                : '« $label » tronqué',
          );
        }
      }

      // Un seul groupe ouvert à la fois : chacun se mesure ouvert.
      expectLabels([l10n.distributionModeSpacing, l10n.distributionModeCount]);

      await tester.tap(find.text(l10n.distributionEdgesGroup));
      await tester.pumpAndSettle();
      expectLabels([
        ...labels,
        l10n.distributionSymmetric,
        l10n.distributionAsymmetric,
      ]);
    });
  }

  testWidgets('le mode « écart voulu » propose l’autre borne', (tester) async {
    final container = await pumpDistribution(tester);
    final form = container.read(distributionFormProvider.notifier);

    form.setMode(DistributionMode.count);
    // Bords épinglés, indépendants du défaut de l'écran.
    form.setEdges(DistributionEdge.gap, DistributionEdge.gap);
    form.setLength(2000);
    form.setElementWidth(21);
    form.setTargetSpacing(100);
    await tester.pumpAndSettle();

    final outcome =
        container.read(distributionResultProvider) as DistributionReady;
    expect(outcome.best.count, 16);
    expect(outcome.other?.count, 15);
    expect(find.text('15 éléments → 105,31 mm réel'), findsOneWidget);
    expect(find.text('Nombre d’éléments'), findsWidgets);
  });

  /// Défauts de l'écran : 1800 mm, éléments de 18 bordés de deux éléments.
  /// 170 mm tombe entre 11 (160,2) et 10 (180) ; 180 tombe juste.
  group('la borne écartée', () {
    Future<ProviderContainer> pumpTarget(
      WidgetTester tester,
      double target,
    ) async {
      final container = await pumpDistribution(tester);
      final form = container.read(distributionFormProvider.notifier);
      form.setMode(DistributionMode.count);
      form.setTargetSpacing(target);
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('se prend d’un tap, et devient le calcul', (tester) async {
      final container = await pumpTarget(tester, 170);

      // L'en-tête du groupe pousse l'encart hors de l'écran de test.
      await tester.ensureVisible(find.text('10 éléments → 180 mm réel'));
      await tester.tap(find.text('10 éléments → 180 mm réel'));
      await tester.pumpAndSettle();

      final input = container.read(distributionFormProvider);
      expect(input.mode, DistributionMode.spacing);
      expect(input.count, 10);

      final outcome =
          container.read(distributionResultProvider) as DistributionReady;
      expect(outcome.best.spacing, closeTo(180, 1e-9));
      expect(outcome.other, isNull);
      expect(find.text('Prendre'), findsNothing);
    });

    testWidgets('n’a rien à offrir quand la cible tombe juste', (tester) async {
      final container = await pumpTarget(tester, 180);

      final outcome =
          container.read(distributionResultProvider) as DistributionReady;
      expect(outcome.best.count, 10);
      expect(outcome.other, isNull);

      // L'encart reste, pour que la carte ne saute pas.
      expect(find.text('10 éléments · 180 mm exact'), findsOneWidget);
      expect(find.text('Prendre'), findsNothing);
    });

    testWidgets('fait la cible tactile, sans tronquer', (tester) async {
      usePhone(tester);
      await pumpTarget(tester, 170);

      const label = '10 éléments → 180 mm réel';
      final callout = find.widgetWithText(InkWell, label);
      expect(
        tester.getSize(callout).height,
        greaterThanOrEqualTo(kFieldHeight),
      );
      expect(
        tester
            .renderObject<RenderParagraph>(find.text(label))
            .didExceedMaxLines,
        isFalse,
      );
    });
  });
}
