import 'dart:ui';

import 'package:fabrique/core/calc/units/imperial.dart';
import 'package:fabrique/core/calc/units/measures.dart';
import 'package:fabrique/core/models/measure_unit.dart';
import 'package:fabrique/features/converter/comparison_painter.dart';
import 'package:fabrique/features/converter/converter_controller.dart';
import 'package:fabrique/features/converter/converter_painter.dart';
import 'package:flutter_test/flutter_test.dart';

/// Le résultat tel que le provider le construit.
ConverterResult _resultFor(double value, MeasureUnit unit) {
  final base = toBase(value, unit);
  return ConverterResult(
    quantity: unit.quantity,
    base: base,
    perUnit: convertAll(value, unit),
    imperial: unit.quantity == Quantity.length ? mmToImperial(base) : null,
  );
}

void main() {
  /// Vignette d'un téléphone, plein écran, et une taille dégénérée.
  const sizes = [Size(336, 210), Size(800, 600), Size(40, 30)];

  /// Zéro, l'unité, une valeur courante, et deux extrêmes qui sortent des
  /// échelles rondes.
  const values = [0.0, 1.0, 100.0, 0.001, 1e6];

  test('la double règle se rend sans lever', () {
    for (final unit in Quantity.length.units) {
      for (final value in values) {
        final painter = RulerPainter(result: _resultFor(value, unit));
        for (final size in sizes) {
          painter.paint(Canvas(PictureRecorder()), size);
        }
      }
    }
  });

  test('la comparaison se rend sans lever, pour chaque grandeur', () {
    for (final quantity in Quantity.values) {
      if (quantity == Quantity.length) continue;
      for (final unit in quantity.units) {
        for (final value in values) {
          final painter = ComparisonPainter(
            result: _resultFor(value, unit),
            unit: unit,
          );
          for (final size in sizes) {
            painter.paint(Canvas(PictureRecorder()), size);
          }
        }
      }
    }
  });

  test('une saisie refusée se rend sans lever', () {
    for (final size in sizes) {
      const RulerPainter(result: null).paint(Canvas(PictureRecorder()), size);
      const ComparisonPainter(
        result: null,
        unit: MeasureUnit.kilogram,
      ).paint(Canvas(PictureRecorder()), size);
    }
  });
}
