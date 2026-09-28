import 'package:fabrique/core/calc/units/scales.dart';
import 'package:fabrique/core/models/measure_unit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('rulerSpan', () {
    test('prend un cran rond au-dessus de la valeur', () {
      expect(rulerSpan(100), 200);
      expect(rulerSpan(160), 200);
      expect(rulerSpan(1000), 2000);
    });

    test('couvre au moins 1 mm pour une valeur nulle ou négative', () {
      expect(rulerSpan(0), 2);
      expect(rulerSpan(-50), 2);
    });
  });

  group('metricRulerStep', () {
    test('rend le plus petit échelon rond sous le nombre de graduations', () {
      // 200 / 7 = 28,6 : 50 est le premier échelon au-dessus.
      expect(metricRulerStep(200, maxTicks: 7, minStepMm: 0), 50);
    });

    test('respecte l’écart minimal entre graduations', () {
      expect(metricRulerStep(200, maxTicks: 7, minStepMm: 60), 100);
    });

    test('divise la règle à plat au-delà des échelons ronds', () {
      expect(metricRulerStep(1e7, maxTicks: 7, minStepMm: 0), 1e7 / 7);
    });
  });

  group('imperialRulerStep', () {
    test('choisit en pouces et rend des millimètres', () {
      // 12 po / 7 = 1,7 po : l'échelon de 2 po.
      expect(
        imperialRulerStep(12 * 25.4, maxTicks: 7, minStepMm: 0),
        closeTo(2 * 25.4, 1e-9),
      );
    });

    test('descend aux fractions binaires sur une règle courte', () {
      expect(
        imperialRulerStep(25.4, maxTicks: 7, minStepMm: 0),
        closeTo(25.4 / 4, 1e-9),
      );
    });
  });

  test('chaque grandeur hors longueur a un repère', () {
    for (final quantity in Quantity.values) {
      final reference = comparisonReference(quantity);
      if (quantity == Quantity.length) {
        expect(reference, isNull);
      } else {
        expect(reference?.quantity, quantity);
      }
    }
  });

  test('le rapport dessiné suit la dimension de la grandeur', () {
    expect(linearRatio(100, Quantity.area), closeTo(10, 1e-9));
    expect(linearRatio(1000, Quantity.volume), closeTo(10, 1e-9));
    expect(linearRatio(5, Quantity.mass), 5);
    expect(linearRatio(5, Quantity.pressure), 5);
  });

  group('comparisonExtents', () {
    test('la plus grande forme remplit la place', () {
      final big = comparisonExtents(4, maxExtent: 100, minExtent: 3);
      expect((big.value, big.reference, big.isOutOfScale), (100, 25, false));

      final small = comparisonExtents(0.25, maxExtent: 100, minExtent: 3);
      expect(
        (small.value, small.reference, small.isOutOfScale),
        (25, 100, false),
      );
    });

    test('relève une forme trop petite et le signale', () {
      final r = comparisonExtents(1000, maxExtent: 100, minExtent: 3);
      expect((r.value, r.reference, r.isOutOfScale), (100, 3, true));
    });

    test('ne dessine que le repère sur un rapport nul ou invalide', () {
      for (final linear in [0.0, -1.0, double.nan, double.infinity]) {
        final r = comparisonExtents(linear, maxExtent: 100, minExtent: 3);
        expect((r.value, r.reference, r.isOutOfScale), (0, 100, false));
      }
    });
  });
}
