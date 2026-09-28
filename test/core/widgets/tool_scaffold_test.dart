import 'package:fabrique/core/widgets/app_disclosure.dart';
import 'package:fabrique/core/widgets/tool_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';
import '../../support/phone.dart';

void main() {
  final resetButton = find.widgetWithIcon(IconButton, Icons.restart_alt);

  Future<void> pumpScaffold(
    WidgetTester tester, {
    Widget? input,
    List<Widget>? inputGroups,
    VoidCallback? onReset,
  }) async {
    usePhone(tester);
    await tester.pumpWidget(
      testApp(
        home: ToolScaffold(
          title: 'Outil',
          input: input,
          inputGroups: inputGroups,
          visualization: const SizedBox.shrink(),
          results: const [],
          onReset: onReset,
        ),
      ),
    );
  }

  testWidgets('les groupes de saisie vont de bord à bord de la carte', (
    tester,
  ) async {
    // Une marge de carte revenue ne se verrait qu'au rendu.
    await pumpScaffold(
      tester,
      inputGroups: const [
        AppDisclosure(title: 'Premier', summary: 'a', child: Text('1')),
        AppDisclosure(title: 'Dernier', summary: 'b', child: Text('2')),
      ],
    );

    final card = tester.getRect(
      find.ancestor(of: find.text('Premier'), matching: find.byType(Card)),
    );
    Rect header(String title) => tester.getRect(
      find.ancestor(of: find.text(title), matching: find.byType(InkWell)),
    );

    expect(header('Premier').top, card.top);
    expect(header('Premier').left, card.left);
    expect(header('Dernier').right, card.right);
    expect(header('Dernier').bottom, card.bottom);
  });

  testWidgets('un outil sans saisie n’affiche pas l’action de reset', (
    tester,
  ) async {
    await pumpScaffold(tester, input: const SizedBox.shrink());

    expect(resetButton, findsNothing);
  });
}
