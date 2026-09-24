import 'package:fabrique/app/theme.dart';
import 'package:fabrique/core/models/measure_unit.dart';
import 'package:fabrique/core/widgets/result_tile.dart';
import 'package:fabrique/features/converter/converter_controller.dart';
import 'package:fabrique/features/converter/converter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/phone.dart';

/// Le seul écran dont la forme change avec la saisie : les unités, le schéma
/// et les tuiles dépendent tous de la grandeur choisie. Un painter qui lève
/// sur une grandeur ne se verrait nulle part ailleurs — ni `flutter analyze`
/// ni les tests du cœur ne peuvent l'attraper.
void main() {
  Future<ProviderContainer> pumpConverter(WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const ConverterScreen(),
        ),
      ),
    );
    return container;
  }

  testWidgets('chaque grandeur se rend sans lever', (tester) async {
    final container = await pumpConverter(tester);
    final form = container.read(converterFormProvider.notifier);

    for (final quantity in Quantity.values) {
      form.setQuantity(quantity);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: quantity.label);

      // Une tuile par unité de la grandeur, plus l'impérial composé en
      // longueur (actif par défaut).
      final expected =
          quantity.units.length + (quantity == Quantity.length ? 1 : 0);
      expect(
        find.byType(ResultTile),
        findsNWidgets(expected),
        reason: quantity.label,
      );
    }
  });

  testWidgets('chaque unité de chaque grandeur se rend sans lever', (
    tester,
  ) async {
    final container = await pumpConverter(tester);
    final form = container.read(converterFormProvider.notifier);

    for (final unit in MeasureUnit.values) {
      form.setUnit(unit);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: unit.name);
    }
  });

  testWidgets('une valeur nulle ne fait pas planter le schéma', (tester) async {
    final container = await pumpConverter(tester);
    final form = container.read(converterFormProvider.notifier);

    for (final quantity in Quantity.values) {
      form.setQuantity(quantity);
      form.setValue(0);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: quantity.label);
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

  testWidgets('aucun symbole d’unité n’est tronqué sur un téléphone', (
    tester,
  ) async {
    // Le segmented tronque en silence (`overflow: ellipsis`) : un symbole trop
    // large donnerait « mba… » sans que rien ne lève, et c'est la seule façon
    // de s'en apercevoir sans regarder.
    usePhone(tester);

    final container = await pumpConverter(tester);
    final form = container.read(converterFormProvider.notifier);

    for (final quantity in Quantity.values) {
      form.setQuantity(quantity);
      await tester.pumpAndSettle();

      for (final unit in quantity.units) {
        final label = find.text(unit.symbol);
        if (label.evaluate().isEmpty) continue;
        expect(
          tester.renderObject<RenderParagraph>(label.first).didExceedMaxLines,
          isFalse,
          reason:
              '${unit.symbol} (${quantity.label}) tronqué dans le segmented',
        );
      }
    }
  });
}
