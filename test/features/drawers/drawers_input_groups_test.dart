import 'package:fabrique/app/theme.dart';
import 'package:fabrique/core/calc/drawers.dart';
import 'package:fabrique/features/drawers/drawers_controller.dart';
import 'package:fabrique/features/drawers/drawers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/phone.dart';

void main() {
  Future<ProviderContainer> pumpDrawers(WidgetTester tester) async {
    usePhone(tester);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: buildAppTheme(), home: const DrawersScreen()),
      ),
    );
    return container;
  }

  const defaultSummaries = [
    '562 × 720 × 540 mm · caisson 19 mm',
    '3 tiroirs · hauteurs égales · applique, façade 19 · jeu 3 mm',
    'À billes · longueur automatique',
    'côtés 15, fond 8 mm · côtés recouvrants · fond en rainure de 6 mm',
  ];

  testWidgets('seule l’ouverture est dépliée à l’arrivée', (tester) async {
    await pumpDrawers(tester);

    expect(find.text('Largeur intérieure'), findsOneWidget);
    expect(find.text('Nombre de tiroirs'), findsNothing);
    expect(find.text('Automatique'), findsNothing);
    expect(find.text('Assemblage'), findsNothing);
  });

  testWidgets('chaque groupe résume ses valeurs, sans rien tronquer', (
    tester,
  ) async {
    await pumpDrawers(tester);

    for (final summary in defaultSummaries) {
      final finder = find.text(summary);
      expect(finder, findsOneWidget, reason: summary);
      expect(
        tester.renderObject<RenderParagraph>(finder).didExceedMaxLines,
        isFalse,
        reason: summary,
      );
    }
  });

  testWidgets('les groupes vont de bord à bord de la carte', (tester) async {
    // Une marge de carte revenue ferait des groupes une carte dans la carte,
    // et ça ne se voit qu'au rendu.
    await pumpDrawers(tester);

    final card = tester.getRect(
      find.ancestor(of: find.text('Ouverture'), matching: find.byType(Card)),
    );
    Rect header(String title) => tester.getRect(
      find.ancestor(of: find.text(title), matching: find.byType(InkWell)),
    );

    expect(header('Ouverture').top, card.top);
    expect(header('Ouverture').left, card.left);
    expect(header('Caisse').right, card.right);
    expect(header('Caisse').bottom, card.bottom);
  });

  testWidgets('le résumé suit la saisie, groupe fermé', (tester) async {
    final container = await pumpDrawers(tester);

    container.read(drawersFormProvider.notifier)
      ..setDrawerCount(1)
      ..setSlide(SlideKind.undermount)
      ..setSlideLength(450);
    await tester.pump();

    expect(
      find.text('1 tiroir · hauteurs égales · applique, façade 19 · jeu 3 mm'),
      findsOneWidget,
    );
    expect(find.text('Sous tiroir · longueur 450 mm'), findsOneWidget);
    // La glissière impose le fond : le résumé de la caisse le dit, puisque
    // c'est là qu'on chercherait pourquoi le choix du fond a disparu.
    expect(
      find.text(
        'côtés 15, fond 8 mm · côtés recouvrants · fond en retrait de 13 mm',
      ),
      findsOneWidget,
    );
  });

  testWidgets('une glissière personnalisée résume ses jeux', (tester) async {
    final container = await pumpDrawers(tester);

    container.read(drawersFormProvider.notifier)
      ..setSlide(SlideKind.custom)
      ..setCustomLengthReduction(10);
    await tester.pump();

    expect(
      find.text(
        'Personnalisée · jeu 12.7, réduction 10 mm · longueur automatique',
      ),
      findsOneWidget,
    );
  });
}
