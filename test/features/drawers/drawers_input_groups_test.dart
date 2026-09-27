import 'package:fabrique/core/calc/drawers.dart';
import 'package:fabrique/features/drawers/drawers_controller.dart';
import 'package:fabrique/features/drawers/drawers_screen.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';
import '../../support/phone.dart';

void main() {
  Future<ProviderContainer> pumpDrawers(
    WidgetTester tester, {
    Locale locale = const Locale('fr'),
  }) async {
    usePhone(tester);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: testApp(home: const DrawersScreen(), locale: locale),
      ),
    );
    return container;
  }

  const defaultSummaries = [
    '564 × 684 × 540 mm · caisson 18 mm',
    '3 tiroirs · hauteurs égales · applique, façade 18 · jeu 3 mm',
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
    // Ouvert, un groupe tait son résumé : on replie celui de l'arrivée.
    await tester.tap(find.text('Ouverture'));
    await tester.pumpAndSettle();

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

  testWidgets('les résumés anglais tiennent aussi sans tronquer', (
    tester,
  ) async {
    // L'anglais n'a pas la longueur du français : ses résumés se mesurent à
    // part.
    const englishSummaries = [
      '564 × 684 × 540 mm · carcass 18 mm',
      '3 drawers · equal heights · overlay, front 18 · gap 3 mm',
      'Ball-bearing · automatic length',
      'sides 15, bottom 8 mm · sides overlap · bottom in a 6 mm groove',
    ];
    await pumpDrawers(tester, locale: const Locale('en'));
    await tester.tap(find.text('Opening'));
    await tester.pumpAndSettle();

    for (final summary in englishSummaries) {
      final finder = find.text(summary);
      expect(finder, findsOneWidget, reason: summary);
      expect(
        tester.renderObject<RenderParagraph>(finder).didExceedMaxLines,
        isFalse,
        reason: summary,
      );
    }
  });

  testWidgets('le résumé suit la saisie, groupe fermé', (tester) async {
    final container = await pumpDrawers(tester);

    container.read(drawersFormProvider.notifier)
      ..setDrawerCount(1)
      ..setSlide(SlideKind.undermount)
      ..setSlideLength(450);
    await tester.pump();

    expect(
      find.text('1 tiroir · hauteurs égales · applique, façade 18 · jeu 3 mm'),
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
        'Personnalisée · jeu 12,7, réduction 10 mm · longueur automatique',
      ),
      findsOneWidget,
    );
  });
}
