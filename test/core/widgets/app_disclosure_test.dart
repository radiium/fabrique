import 'package:fabrique/app/theme.dart';
import 'package:fabrique/core/widgets/app_disclosure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpDisclosure(
    WidgetTester tester, {
    String? summary,
    bool isWide = false,
  }) {
    final disclosure = AppDisclosure(
      title: 'Réglages avancés',
      summary: summary,
      child: const Text('Contenu'),
    );
    return tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Scaffold(
          // Deux parents de types différents, comme les corps étroit et large
          // de `ToolScaffold` : l'élément du panneau n'est pas réutilisé.
          body: isWide
              ? Center(child: disclosure)
              : Align(alignment: Alignment.topCenter, child: disclosure),
        ),
      ),
    );
  }

  Future<void> toggle(WidgetTester tester) async {
    await tester.tap(find.text('Réglages avancés'));
    await tester.pumpAndSettle();
  }

  testWidgets('le contenu replié est démonté, pas seulement masqué', (
    tester,
  ) async {
    await pumpDisclosure(tester);
    expect(find.text('Contenu'), findsNothing);

    await toggle(tester);
    expect(find.text('Contenu'), findsOneWidget);

    await toggle(tester);
    expect(find.text('Contenu'), findsNothing);
  });

  testWidgets('l’en-tête annonce son état à un lecteur d’écran', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpDisclosure(tester);

    final header = find.bySemanticsLabel('Réglages avancés');
    expect(
      tester.getSemantics(header.first),
      isSemantics(isButton: true, hasExpandedState: true, isExpanded: false),
    );

    await toggle(tester);
    expect(
      tester.getSemantics(header.first),
      isSemantics(isButton: true, hasExpandedState: true, isExpanded: true),
    );
    semantics.dispose();
  });

  testWidgets('l’en-tête fait au moins la cible tactile d’atelier', (
    tester,
  ) async {
    for (final summary in const [null, '3 mm']) {
      await pumpDisclosure(tester, summary: summary);
      final header = find.byType(InkWell);
      expect(
        tester.getSize(header).height,
        greaterThanOrEqualTo(kFieldHeight),
        reason: 'résumé : $summary',
      );
    }
  });

  testWidgets('le panneau reste ouvert quand la mise en page change', (
    tester,
  ) async {
    await pumpDisclosure(tester);
    await toggle(tester);

    await pumpDisclosure(tester, isWide: true);
    await tester.pumpAndSettle();
    expect(find.text('Contenu'), findsOneWidget);
  });

  testWidgets('dans un groupe, ouvrir un panneau referme les autres', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const Scaffold(
          body: AppDisclosureGroup(
            child: Column(
              children: [
                AppDisclosure(
                  title: 'Surface',
                  initiallyExpanded: true,
                  child: Text('Contenu surface'),
                ),
                AppDisclosure(title: 'Jeux', child: Text('Contenu jeux')),
              ],
            ),
          ),
        ),
      ),
    );
    expect(find.text('Contenu surface'), findsOneWidget);

    await tester.tap(find.text('Jeux'));
    await tester.pumpAndSettle();
    expect(find.text('Contenu jeux'), findsOneWidget);
    expect(find.text('Contenu surface'), findsNothing);

    await tester.tap(find.text('Jeux'));
    await tester.pumpAndSettle();
    expect(find.text('Contenu jeux'), findsNothing);
    expect(find.text('Contenu surface'), findsNothing);
  });
}
