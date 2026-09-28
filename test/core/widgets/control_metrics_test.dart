import 'package:fabrique/app/theme.dart';
import 'package:fabrique/core/widgets/app_dropdown.dart';
import 'package:fabrique/core/widgets/app_segmented_button.dart';
import 'package:fabrique/core/widgets/app_switch_field.dart';
import 'package:fabrique/core/widgets/count_field.dart';
import 'package:fabrique/core/widgets/number_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';
import '../../support/phone.dart';

/// Chaque contrôle atteint [kFieldHeight] et [kControlFontSize] par un chemin
/// différent : ce test garde leur alignement.
void main() {
  Future<void> pumpControls(WidgetTester tester) async {
    usePhone(tester);

    await tester.pumpWidget(
      testApp(
        home: Scaffold(
          body: Column(
            children: [
              NumberField(label: 'Nu', value: 12, onChanged: (_) {}),
              CountField(
                label: 'Compteur',
                value: 3,
                min: 1,
                max: 10,
                onChanged: (_) {},
              ),
              AppSegmentedButton<int>(
                segments: const [
                  AppSegment(value: 0, label: 'Un'),
                  AppSegment(value: 1, label: 'Deux'),
                ],
                value: 0,
                onChanged: (_) {},
              ),
              AppDropdown<int>(
                value: 0,
                onSelected: (_) {},
                entries: const {0: 'Alpha', 1: 'Beta'},
              ),
              AppSwitchField(label: 'Nu', value: true, onChanged: (_) {}),
              AppSwitchField(
                label: 'Avec aide',
                help: 'Une ligne d’explication',
                value: true,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('tous les contrôles font kFieldHeight de haut', (tester) async {
    await pumpControls(tester);

    void expectFieldHeight(String what, Finder finder) {
      final found = finder.evaluate().length;
      expect(found, greaterThan(0), reason: '$what : introuvable');
      for (var i = 0; i < found; i++) {
        expect(
          tester.getSize(finder.at(i)).height,
          kFieldHeight,
          reason: '$what[$i]',
        );
      }
    }

    // Trois `TextField`, dont celui du `DropdownMenu`, réglé par le thème.
    expectFieldHeight('champ', find.byType(TextField));
    expectFieldHeight('sélecteur', find.byType(AppSegmentedButton<int>));
    expectFieldHeight('dropdown', find.byType(DropdownMenu<int>));
    expectFieldHeight('switch', find.byType(AppSwitchField));

    // Les boutons − / + sont carrés, à la hauteur du champ qu'ils encadrent.
    for (final icon in [Icons.remove, Icons.add]) {
      final button = find.ancestor(
        of: find.byIcon(icon),
        matching: find.byType(AnimatedContainer),
      );
      expect(
        tester.getSize(button.first),
        const Size(kFieldHeight, kFieldHeight),
      );
    }
  });

  testWidgets('tous les contrôles écrivent en kControlFontSize', (
    tester,
  ) async {
    await pumpControls(tester);

    // Champs numériques et valeur fermée du dropdown.
    for (final editable in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(editable.style.fontSize, kControlFontSize);
    }

    // Posés par un `AnimatedDefaultTextStyle`, invisible depuis le `Text`.
    for (final label in ['Un', 'Deux']) {
      final style = tester
          .widget<DefaultTextStyle>(
            find
                .ancestor(
                  of: find.text(label),
                  matching: find.byType(DefaultTextStyle),
                )
                .first,
          )
          .style;
      expect(style.fontSize, kControlFontSize, reason: label);
    }
  });
}
