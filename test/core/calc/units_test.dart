import 'package:fabrique/core/calc/calc_exception.dart';
import 'package:fabrique/core/calc/units/imperial.dart';
import 'package:fabrique/core/calc/units/units.dart';
import 'package:fabrique/core/models/length_unit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('toMm / fromMm', () {
    test('facteurs de référence', () {
      expect(toMm(1, LengthUnit.mm), 1);
      expect(toMm(1, LengthUnit.cm), 10);
      expect(toMm(1, LengthUnit.m), 1000);
      expect(toMm(1, LengthUnit.inch), 25.4);
      expect(toMm(1, LengthUnit.foot), 304.8);
    });

    test('fromMm inverse toMm', () {
      expect(fromMm(25.4, LengthUnit.inch), closeTo(1, 1e-9));
      expect(fromMm(304.8, LengthUnit.foot), closeTo(1, 1e-9));
      expect(fromMm(1000, LengthUnit.m), closeTo(1, 1e-9));
    });

    test('round-trip sur chaque unité', () {
      const values = [0.0, 1.0, 12.5, 1234.567];
      for (final unit in LengthUnit.values) {
        for (final v in values) {
          expect(
            fromMm(toMm(v, unit), unit),
            closeTo(v, 1e-9),
            reason: '$v ${unit.name}',
          );
        }
      }
    });

    test('valeur non finie → CalcException', () {
      expect(
        () => toMm(double.nan, LengthUnit.mm),
        throwsA(isA<CalcException>()),
      );
      expect(
        () => fromMm(double.infinity, LengthUnit.mm),
        throwsA(isA<CalcException>()),
      );
    });
  });

  group('mmToImperial', () {
    test('304.8 mm → 1 pied pile', () {
      final p = mmToImperial(304.8);
      expect(p.feet, 1);
      expect(p.inches, 0);
      expect(p.num, 0);
    });

    test('15.875 mm → 5/8 de pouce (fraction réduite)', () {
      final p = mmToImperial(15.875);
      expect(p.feet, 0);
      expect(p.inches, 0);
      expect(p.num, 5);
      expect(p.den, 8);
    });

    test('réduction de fraction : 6/16 → 3/8, 8/16 → 1/2', () {
      final sixteenths = mmToImperial(0.375 * 25.4);
      expect(sixteenths.num, 3);
      expect(sixteenths.den, 8);

      final half = mmToImperial(0.5 * 25.4);
      expect(half.num, 1);
      expect(half.den, 2);
    });

    test('valeur entière → num 0, den 1', () {
      final p = mmToImperial(2 * 25.4);
      expect(p.inches, 2);
      expect(p.num, 0);
      expect(p.den, 1);
    });

    test('retenue : juste sous 25.4 mm → 1 pouce pile, pas 16/16', () {
      final p = mmToImperial(25.39);
      expect(p.inches, 1);
      expect(p.num, 0);
    });

    test('retenue : 12 pouces → 1 pied', () {
      final p = mmToImperial(11.999 * 25.4);
      expect(p.feet, 1);
      expect(p.inches, 0);
      expect(p.num, 0);
    });

    test('composé : 2 pi 6 3/8 po', () {
      final p = mmToImperial(30.375 * 25.4);
      expect(p.feet, 2);
      expect(p.inches, 6);
      expect(p.num, 3);
      expect(p.den, 8);
    });

    test('dénominateur plus fin', () {
      final p = mmToImperial(25.4 / 32, denominator: 32);
      expect(p.num, 1);
      expect(p.den, 32);
    });

    test('entrées invalides → CalcException', () {
      expect(() => mmToImperial(-1), throwsA(isA<CalcException>()));
      expect(
        () => mmToImperial(100, denominator: 0),
        throwsA(isA<CalcException>()),
      );
      expect(() => mmToImperial(double.nan), throwsA(isA<CalcException>()));
    });
  });

  group('imperialToMm', () {
    test('recompose une longueur composée', () {
      const p = ImperialParts(feet: 2, inches: 6, num: 3, den: 8);
      expect(imperialToMm(p), closeTo(30.375 * 25.4, 1e-9));
    });

    test('round-trip mm → impérial → mm au 1/16 près', () {
      const values = [0.0, 25.4, 304.8, 771.525, 1000.0];
      for (final mm in values) {
        final back = imperialToMm(mmToImperial(mm));
        // Tolérance = un demi-cran de 1/16 de pouce.
        expect(back, closeTo(mm, 25.4 / 32), reason: '$mm mm');
      }
    });

    test('dénominateur nul → CalcException', () {
      const p = ImperialParts(feet: 0, inches: 1, num: 1, den: 0);
      expect(() => imperialToMm(p), throwsA(isA<CalcException>()));
    });
  });

  group('formatImperial', () {
    test('composé', () {
      expect(
        formatImperial(const ImperialParts(feet: 2, inches: 6, num: 3, den: 8)),
        "2' 6 3/8\"",
      );
    });

    test('pied entier : garde le zéro pouce', () {
      expect(
        formatImperial(const ImperialParts(feet: 1, inches: 0, num: 0, den: 1)),
        "1' 0\"",
      );
    });

    test('fraction seule : n’invente pas de zéro pouce', () {
      expect(
        formatImperial(const ImperialParts(feet: 0, inches: 0, num: 5, den: 8)),
        '5/8"',
      );
    });

    test('pouces entiers', () {
      expect(
        formatImperial(const ImperialParts(feet: 0, inches: 5, num: 0, den: 1)),
        '5"',
      );
    });

    test('pouces et fraction', () {
      expect(
        formatImperial(const ImperialParts(feet: 0, inches: 2, num: 1, den: 2)),
        '2 1/2"',
      );
    });

    test('zéro', () {
      expect(
        formatImperial(const ImperialParts(feet: 0, inches: 0, num: 0, den: 1)),
        '0"',
      );
    });
  });
}
