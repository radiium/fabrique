import 'dart:ui';

import 'package:fabrique/core/calc/units/imperial.dart';
import 'package:fabrique/core/calc/units/measures.dart';
import 'package:fabrique/core/models/measure_unit.dart';
import 'package:fabrique/features/converter/comparison_painter.dart';
import 'package:fabrique/features/converter/converter_controller.dart';
import 'package:fabrique/features/converter/converter_painter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/l10n.dart';

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

  /// Zéro, l'unité, une valeur courante, et deux extrêmes hors échelles.
  const values = [0.0, 1.0, 100.0, 0.001, 1e6];

  // Les deux langues : un libellé plus long peut déborder autrement.
  for (final l10n in allLocales) {
    group(l10n.localeName, () {
      test('la double règle se rend sans lever', () {
        for (final unit in Quantity.length.units) {
          for (final value in values) {
            final painter = RulerPainter(
              result: _resultFor(value, unit),
              l10n: l10n,
            );
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
                l10n: l10n,
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
          RulerPainter(
            result: null,
            l10n: l10n,
          ).paint(Canvas(PictureRecorder()), size);
          ComparisonPainter(
            result: null,
            unit: MeasureUnit.kilogram,
            l10n: l10n,
          ).paint(Canvas(PictureRecorder()), size);
        }
      });
    });
  }
}
