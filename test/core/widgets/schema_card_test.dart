import 'package:fabrique/core/models/tool.dart';
import 'package:fabrique/core/widgets/schema_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';

void main() {
  Future<void> pumpCard(WidgetTester tester, {Tool? expandFor}) async {
    await tester.pumpWidget(
      testApp(
        home: Scaffold(
          body: SizedBox(
            height: 200,
            child: SchemaCard(
              expandFor: expandFor,
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('une vignette qui s’agrandit s’annonce comme un bouton', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpCard(tester, expandFor: Tool.layout);

    expect(
      tester.getSemantics(find.bySemanticsLabel('Agrandir le schéma')),
      isSemantics(isButton: true, hasTapAction: true),
    );
    semantics.dispose();
  });

  testWidgets('une vignette figée ne promet rien', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpCard(tester);

    expect(find.bySemanticsLabel('Agrandir le schéma'), findsNothing);
    semantics.dispose();
  });
}
