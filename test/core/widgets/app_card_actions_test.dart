import 'package:fabrique/core/widgets/app_card_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';
import '../../support/phone.dart';

void main() {
  Future<void> pumpActions(
    WidgetTester tester, {
    bool isBusy = false,
    double textScale = 1,
  }) async {
    usePhone(tester);
    await tester.pumpWidget(
      testApp(
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: Scaffold(
              body: AppCardActions(
                actions: [
                  CardAction(
                    icon: Icons.save_alt,
                    label: 'Envoyer',
                    onTap: () {},
                  ),
                  CardAction(
                    icon: Icons.share,
                    label: 'Partager',
                    onTap: () {},
                    busy: isBusy,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('une action en cours garde son nom pour un lecteur d’écran', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpActions(tester, isBusy: true);

    expect(find.text('Partager'), findsNothing);
    expect(find.bySemanticsLabel('Partager'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('un texte système agrandi fait tomber l’icône, pas le libellé', (
    tester,
  ) async {
    await pumpActions(tester);
    expect(find.byIcon(Icons.save_alt), findsOneWidget);

    // La police de test fait 18 px par caractère : « Envoyer » et son icône
    // tiennent juste dans les 180 px d'une demi-largeur, plus au double.
    await pumpActions(tester, textScale: 2);
    expect(find.byIcon(Icons.save_alt), findsNothing);
    expect(find.text('Envoyer'), findsOneWidget);
  });
}
