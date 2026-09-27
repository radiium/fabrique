import 'package:fabrique/app/theme.dart';
import 'package:fabrique/core/widgets/field_help.dart';
import 'package:fabrique/core/widgets/labeled_field.dart';
import 'package:fabrique/core/widgets/number_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';
import '../../support/phone.dart';

/// L'aide de champ ne se vérifie qu'au rendu : qu'elle s'ouvre, qu'elle se
/// referme, et surtout qu'elle ne coûte rien au champ qui n'en a pas — c'est
/// la seule raison pour laquelle elle tient dans une carte déjà pleine.
void main() {
  const about = FieldHelp(
    title: 'Longueur totale',
    body: 'La longueur de l’espace à garnir.',
    bullets: ['Un point détaché'],
  );

  Future<void> pump(WidgetTester tester, Widget child) async {
    usePhone(tester);
    await tester.pumpWidget(testApp(home: Scaffold(body: child)));
  }

  testWidgets('un tap sur la ligne de libellé ouvre la feuille', (
    tester,
  ) async {
    await pump(
      tester,
      const LabeledField(
        label: 'Longueur totale',
        about: about,
        child: SizedBox(height: kFieldHeight),
      ),
    );

    expect(find.text('La longueur de l’espace à garnir.'), findsNothing);

    // C'est le libellé qu'on tape, pas l'icône : la cible est la ligne.
    await tester.tap(find.text('Longueur totale'));
    await tester.pumpAndSettle();

    expect(find.text('La longueur de l’espace à garnir.'), findsOneWidget);
    expect(find.text('Un point détaché'), findsOneWidget);
    // Le titre reprend le libellé : on doit reconnaître d'où ça s'est ouvert.
    expect(find.text('Longueur totale'), findsNWidgets(2));
  });

  testWidgets('la feuille se referme sur le voile', (tester) async {
    await pump(
      tester,
      const LabeledField(
        label: 'Longueur totale',
        about: about,
        child: SizedBox(height: kFieldHeight),
      ),
    );

    await tester.tap(find.text('Longueur totale'));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(200, 40));
    await tester.pumpAndSettle();
    expect(find.text('La longueur de l’espace à garnir.'), findsNothing);
  });

  testWidgets('un champ sans aide garde exactement sa hauteur', (tester) async {
    await pump(
      tester,
      Column(
        children: [
          NumberField(label: 'Sans', value: 1, onChanged: (_) {}),
          NumberField(label: 'Avec', about: about, value: 1, onChanged: (_) {}),
        ],
      ),
    );

    final sans = tester.getSize(find.byType(NumberField).at(0)).height;
    final avec = tester.getSize(find.byType(NumberField).at(1)).height;

    // 20 px de libellé nu contre 32 de ligne tappable : le surcoût est de 12,
    // et il ne frappe que les champs qui portent une explication.
    expect(sans, 76);
    expect(avec, sans + 12);
  });

  testWidgets('deux champs appariés restent alignés', (tester) async {
    // La feuille a été retenue contre le dépliant en place pour ce cas
    // précis : deux champs sur une ligne. Encore faut-il que le ⓘ ne
    // désaligne pas la paire à lui seul.
    await pump(
      tester,
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: NumberField(
              label: 'Gauche',
              about: about,
              value: 1,
              onChanged: (_) {},
            ),
          ),
          Expanded(
            child: NumberField(
              label: 'Droite',
              about: about,
              value: 1,
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );

    final left = tester.getRect(find.byType(TextField).at(0));
    final right = tester.getRect(find.byType(TextField).at(1));
    expect(left.top, right.top);
  });
}
