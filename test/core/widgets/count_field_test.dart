import 'package:fabrique/core/widgets/count_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';
import '../../support/phone.dart';

void main() {
  Future<List<int>> pumpCount(WidgetTester tester, {required int value}) async {
    usePhone(tester);
    final changes = <int>[];
    await tester.pumpWidget(
      testApp(
        home: Scaffold(
          body: CountField(
            label: 'Nombre',
            value: value,
            min: 1,
            max: 10,
            onChanged: changes.add,
          ),
        ),
      ),
    );
    return changes;
  }

  testWidgets('un appui sur + ou − avance d’une unité', (tester) async {
    final changes = await pumpCount(tester, value: 5);

    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byIcon(Icons.remove));

    expect(changes, [6, 4]);
  });

  testWidgets('une borne atteinte désactive le bouton qui en sortirait', (
    tester,
  ) async {
    final atMin = await pumpCount(tester, value: 1);
    await tester.tap(find.byIcon(Icons.remove));
    expect(atMin, isEmpty);

    final atMax = await pumpCount(tester, value: 10);
    await tester.tap(find.byIcon(Icons.add));
    expect(atMax, isEmpty);
  });

  testWidgets('une frappe au clavier arrive en entier', (tester) async {
    final changes = await pumpCount(tester, value: 5);

    await tester.enterText(find.byType(TextField), '7');

    expect(changes, [7]);
  });

  testWidgets('les boutons − / + se prennent au clavier', (tester) async {
    final changes = await pumpCount(tester, value: 5);

    Focus.of(tester.element(find.byIcon(Icons.add))).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);

    expect(changes, [6]);
  });

  testWidgets('le champ porte son libellé pour un lecteur d’écran', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpCount(tester, value: 5);

    expect(
      tester.getSemantics(find.byType(EditableText)),
      isSemantics(label: 'Nombre', isTextField: true),
    );
    semantics.dispose();
  });
}
