import 'package:fabrique/app/theme.dart';
import 'package:fabrique/core/calc/distribution.dart';
import 'package:fabrique/features/distribution/distribution_controller.dart';
import 'package:fabrique/features/distribution/distribution_form.dart';
import 'package:fabrique/features/distribution/distribution_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/phone.dart';

/// L'écran change de forme avec la saisie — le champ piloté suit le mode, le
/// schéma passe des disques aux rectangles, les colonnes de la table
/// apparaissent avec l'épaisseur. Ni `flutter analyze` ni les tests du cœur ne
/// voient ces bascules.
void main() {
  Future<ProviderContainer> pumpDistribution(WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const DistributionScreen(),
        ),
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

    // Le schéma reste sur des rectangles, réduits à un trait : c'est la même
    // grammaire à toute épaisseur, sans basculement au passage par zéro.
    expect(tester.takeException(), isNull);
    // Sans épaisseur, entraxe et écart se confondent : une seule tuile, et pas
    // de colonne « centre ».
    expect(find.text('Entraxe'), findsNothing);
    expect(find.text('Centre (mm)'), findsNothing);
    expect(find.text('Position (mm)'), findsOneWidget);
  });

  testWidgets('la table a le même blanc à gauche qu’à droite', (tester) async {
    // La colonne N° est cadrée à droite : si sa largeur était ronde plutôt que
    // mesurée, le mou tomberait entièrement à gauche du chiffre et la première
    // cellule aurait plusieurs fois le blanc de la dernière. Invisible à la
    // lecture du code.
    usePhone(tester);
    await pumpDistribution(tester);

    // Le rembourrage de cellule : sa boîte fait la largeur de la rayure.
    final row = tester.getRect(
      find.ancestor(of: find.text('N°'), matching: find.byType(Padding)).first,
    );
    final firstCell = tester.getRect(find.text('N°'));
    final lastCell = tester.getRect(find.text('Centre (mm)'));

    // Mesurer la boîte de la cellule ne suffit pas : elle est identique avec ou
    // sans mou, c'est le texte qui se décale dedans. On mesure donc le blanc
    // qu'on voit — du bord de la rayure au premier glyphe, et du dernier glyphe
    // au bord opposé. La dernière colonne étant cadrée à droite, ses glyphes
    // touchent le bord de sa boîte.
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

    // 11 éléments de 20 dans 100 mm : ça ne rentre pas.
    form.setLength(100);
    form.setElementWidth(20);
    form.setCount(11);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      container.read(distributionResultProvider),
      isA<DistributionFailure>(),
    );
    // Le message porte les deux cotes, c'est tout son intérêt.
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

    // Les marges sont sans effet au départ. La disposition des bords l'est
    // moins : élément – élément est le cas courant, et le résumé du groupe
    // le dit sans avoir à déplier.
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

    expect(find.text('5 éléments de 18 sur 1800 mm'), findsOneWidget);

    final form = container.read(distributionFormProvider.notifier)
      ..setMode(DistributionMode.count);
    await tester.pump();
    expect(
      find.text('Éléments de 18 sur 1800 mm · écart visé 150 mm'),
      findsOneWidget,
    );

    // Sans largeur, ce sont des repères : des axes de perçage, pas des lames.
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
    expect(find.text('Écart – Élément · marges 12.5 mm'), findsOneWidget);

    form
      ..setSymmetricOffsets(false)
      ..setEndOffset(1250);
    await tester.pump();
    final summary = find.text('Écart – Élément · marges 12.5 / 1250 mm');
    expect(summary, findsOneWidget);
    expect(
      tester.renderObject<RenderParagraph>(summary).didExceedMaxLines,
      isFalse,
    );
  });

  testWidgets('aucun libellé de contrôle n’est tronqué sur un téléphone', (
    tester,
  ) async {
    // Le segmented et les tuiles de bords tronquent en silence
    // (`overflow: ellipsis`) : un libellé trop large donnerait « Élément – Élé… »
    // sans que rien ne lève.
    usePhone(tester);
    await pumpDistribution(tester);

    const labels = [
      'Écart – Écart',
      'Élément – Élément',
      'Élément – Écart',
      'Écart – Élément',
    ];

    // Ces quatre-là dépassent la mesure des tests, et c'est accepté.
    //
    // Un segment dispose de 164 px et la police des tests donne 18 px à
    // *chaque* glyphe : le plafond y est de 9 caractères, soit le double de ce
    // qu'une vraie police consomme. « Symétriques » / « Asymétriques » ont été
    // vérifiés au rendu sur un Pixel 5 (22/09/2026) — ils passent. « Calcul
    // écart » / « Calcul nombre », à un caractère près, sont acceptés sur la
    // même base, par déduction et non par mesure.
    //
    // Cette liste se vide, elle ne s'allonge pas : chaque entrée coûte la
    // protection du libellé qu'elle contient. Tout nouveau libellé passe
    // d'abord par la mesure pessimiste, et n'atterrit ici qu'après vérification
    // sur appareil.
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
          tester.renderObject<RenderParagraph>(finder.first).didExceedMaxLines,
          expected,
          reason: expected
              ? '« $label » tient désormais : à retirer de la liste'
              : '« $label » tronqué',
        );
      }
    }

    // Un seul groupe ouvert à la fois : chacun se mesure pendant qu'il l'est.
    expectLabels(const ['Calcul écart', 'Calcul nombre']);

    await tester.tap(find.text('Bords et marges'));
    await tester.pumpAndSettle();
    expectLabels(const [...labels, 'Symétriques', 'Asymétriques']);
  });

  testWidgets('le mode « écart voulu » propose l’autre borne', (tester) async {
    final container = await pumpDistribution(tester);
    final form = container.read(distributionFormProvider.notifier);

    form.setMode(DistributionMode.count);
    // Bords épinglés : les deux bornes attendues sont celles d'une rangée
    // bordée de deux écarts, pas celles du défaut de l'écran.
    form.setEdges(DistributionEdge.gap, DistributionEdge.gap);
    form.setLength(2000);
    form.setElementWidth(21);
    form.setTargetSpacing(100);
    await tester.pumpAndSettle();

    final outcome =
        container.read(distributionResultProvider) as DistributionReady;
    expect(outcome.best.count, 16);
    expect(outcome.other?.count, 15);
    expect(find.text('15 éléments → 105.31 mm réel'), findsOneWidget);
    expect(find.text('Nombre d’éléments'), findsWidgets);
  });

  /// Ce que l'écran fait de la borne qu'il n'a pas retenue.
  ///
  /// Les chiffres viennent des défauts de l'écran (1800 mm, éléments de 18,
  /// bordés de deux éléments) : une cible de 170 mm tombe entre 11 éléments à
  /// 160,2 et 10 à 180, une cible de 180 tombe juste.
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

      // L'en-tête du groupe pousse l'encart sous le bas de l'écran de test.
      await tester.ensureVisible(find.text('10 éléments → 180 mm réel'));
      await tester.tap(find.text('10 éléments → 180 mm réel'));
      await tester.pumpAndSettle();

      final input = container.read(distributionFormProvider);
      expect(input.mode, DistributionMode.spacing);
      expect(input.count, 10);

      final outcome =
          container.read(distributionResultProvider) as DistributionReady;
      expect(outcome.best.spacing, closeTo(180, 1e-9));
      // Plus d'arbitrage dans ce mode : le nombre est donné, la question n'est
      // plus posée et l'encart n'a plus lieu d'être.
      expect(outcome.other, isNull);
      expect(find.text('Prendre'), findsNothing);
    });

    testWidgets('n’a rien à offrir quand la cible tombe juste', (tester) async {
      final container = await pumpTarget(tester, 180);

      final outcome =
          container.read(distributionResultProvider) as DistributionReady;
      expect(outcome.best.count, 10);
      expect(outcome.other, isNull);

      // L'encart reste, pour que la carte ne saute pas d'un pas de saisie à
      // l'autre — mais il n'est plus qu'une confirmation.
      expect(find.text('10 éléments · 180 mm exact'), findsOneWidget);
      expect(find.text('Prendre'), findsNothing);
    });

    testWidgets('fait la cible tactile, sans tronquer', (tester) async {
      // Le libellé porte un nombre : il passe à deux lignes plutôt que de
      // s'ellipser, et l'encart grandit avec lui. Sa surface entière est la
      // cible, le bouton n'étant qu'un repère visuel.
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
