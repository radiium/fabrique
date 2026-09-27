import 'package:fabrique/core/calc/calc_exception.dart';
import 'package:fabrique/core/calc/units/measures.dart';
import 'package:fabrique/core/calc/units/units.dart';
import 'package:fabrique/core/models/length_unit.dart';
import 'package:fabrique/core/models/measure_unit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('table des unités', () {
    test('au plus 5 unités par grandeur', () {
      // Contrainte d'UI, pas de calcul : au-delà, l'AppSegmentedButton ne tient
      // plus sur un téléphone. Elle se vérifie ici parce que c'est ici qu'on
      // ajoute une unité, et que rien à l'écran ne préviendrait.
      for (final q in Quantity.values) {
        expect(
          q.units.length,
          inInclusiveRange(2, 5),
          reason: '${q.name} : ${q.units.length} unités',
        );
      }
    });

    test('l’unité par défaut appartient à sa grandeur', () {
      for (final q in Quantity.values) {
        expect(q.defaultUnit.quantity, q, reason: q.name);
      }
    });

    test('facteurs strictement positifs', () {
      for (final unit in MeasureUnit.values) {
        expect(baseFactor(unit), greaterThan(0), reason: unit.name);
      }
    });
  });

  group('cohérence avec la table des longueurs', () {
    // `units.dart` garde sa propre table pour les outils, qui sont tous en
    // longueur. Deux tables, donc un risque de dérive : ce test est le seul
    // garde-fou.
    test('mêmes facteurs que mmPerUnit', () {
      const pairs = {
        LengthUnit.mm: MeasureUnit.mm,
        LengthUnit.cm: MeasureUnit.cm,
        LengthUnit.m: MeasureUnit.m,
        LengthUnit.inch: MeasureUnit.inch,
        LengthUnit.foot: MeasureUnit.foot,
      };
      pairs.forEach((length, measure) {
        expect(baseFactor(measure), mmPerUnit(length), reason: length.name);
      });
    });

    test('les deux tables couvrent les mêmes longueurs', () {
      expect(Quantity.length.units.length, LengthUnit.values.length);
    });
  });

  group('toBase / fromBase', () {
    test('round-trip sur chaque unité', () {
      const values = [0.0, 1.0, 12.5, 1234.567];
      for (final unit in MeasureUnit.values) {
        for (final v in values) {
          expect(
            fromBase(toBase(v, unit), unit),
            closeTo(v, 1e-9),
            reason: '$v ${unit.name}',
          );
        }
      }
    });

    test('valeur non finie → CalcException', () {
      expect(
        () => toBase(double.nan, MeasureUnit.mm),
        throwsA(isA<CalcException>()),
      );
      expect(
        () => fromBase(double.infinity, MeasureUnit.mm),
        throwsA(isA<CalcException>()),
      );
    });
  });

  group('convert', () {
    test('longueur', () {
      expect(convert(1, MeasureUnit.m, MeasureUnit.mm), closeTo(1000, 1e-9));
      expect(convert(1, MeasureUnit.foot, MeasureUnit.inch), closeTo(12, 1e-9));
    });

    test('surface — le pied carré fait 144 pouces carrés', () {
      expect(
        convert(1, MeasureUnit.foot2, MeasureUnit.inch2),
        closeTo(144, 1e-9),
      );
      expect(
        convert(1, MeasureUnit.m2, MeasureUnit.foot2),
        closeTo(10.7639104167, 1e-9),
      );
    });

    test('volume — le pied-planche fait 144 pouces cubes', () {
      expect(
        convert(1, MeasureUnit.boardFoot, MeasureUnit.inch3),
        closeTo(144, 1e-9),
      );
      expect(
        convert(1, MeasureUnit.liter, MeasureUnit.cm3),
        closeTo(1000, 1e-9),
      );
      expect(
        convert(1, MeasureUnit.m3, MeasureUnit.boardFoot),
        closeTo(423.776, 1e-3),
      );
    });

    test('masse', () {
      expect(
        convert(1, MeasureUnit.pound, MeasureUnit.gram),
        closeTo(453.59237, 1e-9),
      );
      expect(
        convert(1, MeasureUnit.kilogram, MeasureUnit.pound),
        closeTo(2.2046226218, 1e-9),
      );
    });

    test('pression', () {
      expect(
        convert(1, MeasureUnit.bar, MeasureUnit.kilopascal),
        closeTo(100, 1e-9),
      );
      expect(
        convert(1, MeasureUnit.bar, MeasureUnit.psi),
        closeTo(14.5037737730, 1e-9),
      );
      expect(
        convert(1, MeasureUnit.megapascal, MeasureUnit.bar),
        closeTo(10, 1e-9),
      );
    });

    test('changer de grandeur → CalcException', () {
      expect(
        () => convert(1, MeasureUnit.m, MeasureUnit.kilogram),
        throwsA(isA<CalcException>()),
      );
      expect(
        () => convert(1, MeasureUnit.m2, MeasureUnit.m3),
        throwsA(isA<CalcException>()),
      );
    });
  });

  group('convertAll', () {
    test('rend exactement les unités de la grandeur', () {
      for (final unit in MeasureUnit.values) {
        expect(
          convertAll(1, unit).keys,
          orderedEquals(unit.quantity.units),
          reason: unit.name,
        );
      }
    });

    test('l’unité source se retrouve inchangée', () {
      final all = convertAll(2.5, MeasureUnit.liter);
      expect(all[MeasureUnit.liter], closeTo(2.5, 1e-9));
      expect(all[MeasureUnit.cm3], closeTo(2500, 1e-9));
    });
  });
}
