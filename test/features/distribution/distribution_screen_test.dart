import 'package:fabrique/app/theme.dart';
import 'package:fabrique/core/calc/distribution.dart';
import 'package:fabrique/core/widgets/zoomable_canvas.dart';
import 'package:fabrique/features/distribution/distribution_controller.dart';
import 'package:fabrique/features/distribution/distribution_form.dart';
import 'package:fabrique/features/distribution/distribution_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// L'écran change de forme avec la saisie — le champ piloté suit le mode, le
/// schéma passe des disques aux rectangles, les colonnes de la table
/// apparaissent avec l'épaisseur. Un painter qui lève sur une combinaison de
/// bords ne se verrait nulle part ailleurs : ni `flutter analyze` ni les tests
/// du cœur ne peuvent l'attraper.
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

  /// Le téléphone de référence.
  void usePhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(400, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('chaque combinaison de bords se rend sans lever', (tester) async {
    final container = await pumpDistribution(tester);
    final form = container.read(distributionFormProvider.notifier);

    for (final start in DistributionEdge.values) {
      for (final end in DistributionEdge.values) {
        form.setEdges(start, end);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$start / $end');
      }
    }
  });

  testWidgets('les deux modes se rendent sans lever', (tester) async {
    final container = await pumpDistribution(tester);
    final form = container.read(distributionFormProvider.notifier);

    for (final mode in DistributionMode.values) {
      form.setMode(mode);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: mode.label);
    }
  });

  testWidgets('largeur nulle : un trait, et deux tuiles qui disparaissent', (
    tester,
  ) async {
    final container = await pumpDistribution(tester);
    final form = container.read(distributionFormProvider.notifier);

    form.setElementWidth(0);
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

  testWidgets('avec une épaisseur, la table montre bord et centre', (
    tester,
  ) async {
    await pumpDistribution(tester);
    expect(find.text('Bord (mm)'), findsOneWidget);
    expect(find.text('Centre (mm)'), findsOneWidget);
    expect(find.text('Entraxe'), findsOneWidget);
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

  testWidgets('le schéma reste au-dessus de la ligne de flottaison', (
    tester,
  ) async {
    // La visualisation est la vedette de chaque écran. C'est
    // précisément ce que huit contrôles dépliés feraient sauter — d'où le
    // panneau replié par défaut.
    usePhone(tester);
    await pumpDistribution(tester);

    final canvas = tester.getRect(find.byType(ZoomableCanvas));
    // La règle, c'est que le schéma tienne entier sans scroll.
    expect(
      canvas.bottom,
      lessThan(844),
      reason: 'le schéma finit à ${canvas.bottom} px sur un écran de 844',
    );
    // Et le garde-fou : mesuré à ~540 px avec les cinq contrôles de premier
    // plan. Un sixième ajouté hors du panneau repliable ferait tomber ce test
    // avant de faire tomber le précédent.
    expect(
      canvas.top,
      lessThan(560),
      reason: 'le schéma commence à ${canvas.top} px sur un écran de 844',
    );
  });

  testWidgets('le pied « réglages avancés » touche les bords de la carte', (
    tester,
  ) async {
    // Une marge qui reviendrait — un rembourrage de carte rétabli, un panneau
    // remis dans la pile de contrôles — ferait une carte dans la carte, et ça
    // ne se voit qu'au rendu.
    usePhone(tester);
    await pumpDistribution(tester);

    final card = tester.getRect(
      find.ancestor(
        of: find.text('Largeur totale'),
        matching: find.byType(Card),
      ),
    );
    final header = tester.getRect(
      find.ancestor(
        of: find.text('Réglages avancés'),
        matching: find.byType(InkWell),
      ),
    );

    expect(header.left, card.left);
    expect(header.right, card.right);
    expect(header.bottom, card.bottom);
  });

  testWidgets('les réglages avancés sont repliés, et sans effet', (
    tester,
  ) async {
    usePhone(tester);
    final container = await pumpDistribution(tester);

    expect(find.text('Réglages avancés'), findsOneWidget);
    expect(find.text('Marges'), findsNothing);

    final input = container.read(distributionFormProvider);
    expect(input.startOffset, 0);
    expect(input.endOffset, 0);
    expect(input.startEdge, DistributionEdge.gap);
    expect(input.endEdge, DistributionEdge.gap);

    await tester.tap(find.text('Réglages avancés'));
    await tester.pumpAndSettle();
    expect(find.text('Marges'), findsOneWidget);
  });

  testWidgets('aucun libellé de contrôle n’est tronqué sur un téléphone', (
    tester,
  ) async {
    // Le segmented et les tuiles de bords tronquent en silence
    // (`overflow: ellipsis`) : un libellé trop large donnerait « Élément – Élé… »
    // sans que rien ne lève.
    usePhone(tester);
    await pumpDistribution(tester);

    await tester.tap(find.text('Réglages avancés'));
    await tester.pumpAndSettle();

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

    for (final label in [...labels, ...knownWiderThanTestFont]) {
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
  });

  testWidgets('le mode « écart voulu » propose l’autre borne', (tester) async {
    final container = await pumpDistribution(tester);
    final form = container.read(distributionFormProvider.notifier);

    form.setMode(DistributionMode.count);
    form.setLength(2000);
    form.setElementWidth(21);
    form.setTargetSpacing(100);
    await tester.pumpAndSettle();

    final outcome =
        container.read(distributionResultProvider) as DistributionReady;
    expect(outcome.best.count, 16);
    expect(outcome.other?.count, 15);
    expect(find.text('Autre possibilité'), findsOneWidget);
    expect(find.text('Nombre d’éléments'), findsWidgets);
  });
}
