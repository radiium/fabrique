import 'package:fabrique/core/models/measure_unit.dart';
import 'package:fabrique/core/widgets/result_tile.dart';
import 'package:fabrique/features/converter/converter_controller.dart';
import 'package:fabrique/features/converter/converter_screen.dart';
import 'package:fabrique/l10n/labels.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';
import '../../support/l10n.dart';
import '../../support/phone.dart';

void main() {
  Future<ProviderContainer> pumpConverter(
    WidgetTester tester, {
    Locale locale = const Locale('fr'),
  }) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: testApp(home: const ConverterScreen(), locale: locale),
      ),
    );
    return container;
  }

  testWidgets('chaque grandeur a une tuile par unité', (tester) async {
    final container = await pumpConverter(tester);
    final form = container.read(converterFormProvider.notifier);

    for (final quantity in Quantity.values) {
      form.setQuantity(quantity);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: quantity.name);

      // Une tuile par unité de la grandeur, plus l'impérial composé en
      // longueur (actif par défaut).
      final expected =
          quantity.units.length + (quantity == Quantity.length ? 1 : 0);
      expect(
        find.byType(ResultTile),
        findsNWidgets(expected),
        reason: quantity.name,
      );
    }
  });

  testWidgets('l’impérial composé ne s’affiche qu’en longueur', (tester) async {
    final container = await pumpConverter(tester);
    final form = container.read(converterFormProvider.notifier);

    expect(find.text('Impérial composé'), findsOneWidget);

    form.setQuantity(Quantity.pressure);
    await tester.pumpAndSettle();
    expect(find.text('Impérial composé'), findsNothing);

    form.setQuantity(Quantity.length);
    await tester.pumpAndSettle();
    expect(find.text('Impérial composé'), findsOneWidget);
  });

  testWidgets('changer de grandeur garde la valeur saisie', (tester) async {
    final container = await pumpConverter(tester);
    final form = container.read(converterFormProvider.notifier);

    form.setValue(2400);
    form.setQuantity(Quantity.mass);
    await tester.pumpAndSettle();

    final input = container.read(converterFormProvider);
    expect(input.value, 2400);
    expect(input.unit, Quantity.mass.defaultUnit);
  });

  for (final l10n in allLocales) {
    testWidgets('aucun symbole d’unité n’est tronqué sur un téléphone '
        '(${l10n.localeName})', (tester) async {
      // Le segmented tronque en silence (`overflow: ellipsis`).
      usePhone(tester);

      final container = await pumpConverter(
        tester,
        locale: Locale(l10n.localeName),
      );
      final form = container.read(converterFormProvider.notifier);

      for (final quantity in Quantity.values) {
        form.setQuantity(quantity);
        await tester.pumpAndSettle();

        for (final unit in quantity.units) {
          final symbol = unit.symbol(l10n);
          final label = find.text(symbol);
          if (label.evaluate().isEmpty) continue;
          expect(
            tester.renderObject<RenderParagraph>(label.first).didExceedMaxLines,
            isFalse,
            reason:
                '$symbol (${quantity.label(l10n)}) tronqué dans le segmented',
          );
        }
      }
    });
  }
}
