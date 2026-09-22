import 'package:fabrique/core/calc/calc_exception.dart';
import 'package:fabrique/core/calc/fasteners.dart';
import 'package:fabrique/core/models/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FastenerResult compute(
    MaterialKind material,
    double diameter,
    double thickness,
  ) => computeFastener(
    FastenerInput(
      material: material,
      screwDiameter: diameter,
      fixedThickness: thickness,
    ),
  );

  group('computeFastener — cas de référence', () {
    test('résineux Ø4 sur 18 mm', () {
      final r = compute(MaterialKind.softwood, 4, 18);

      expect(r.pilotHole, closeTo(2.2, 1e-9));
      expect(r.clearanceHole, closeTo(4.5, 1e-9));
      expect(r.penetration, closeTo(36, 1e-9));
      expect(r.screwLength, closeTo(54, 1e-9));
      expect(r.counterboreDia, closeTo(8, 1e-9));
      expect(r.counterboreDepth, closeTo(2.4, 1e-9));
    });

    test('feuillu : avant-trou plus gros que résineux', () {
      final softwood = compute(MaterialKind.softwood, 4, 18);
      final hardwood = compute(MaterialKind.hardwood, 4, 18);

      expect(hardwood.pilotHole, greaterThan(softwood.pilotHole));
      expect(hardwood.pilotHole, closeTo(2.8, 1e-9));
      // Seul l'avant-trou dépend du matériau.
      expect(hardwood.clearanceHole, closeTo(softwood.clearanceHole, 1e-9));
    });

    test('pénétration écrêtée au plafond', () {
      final r = compute(MaterialKind.softwood, 5, 40);

      expect(r.penetration, closeTo(maxPenetration, 1e-9));
      expect(r.screwLength, closeTo(40 + maxPenetration, 1e-9));
    });
  });

  group('computeFastener — invariants', () {
    const diameters = [3.0, 3.5, 4.0, 4.5, 5.0, 6.0];

    test('pilotHole < clearanceHole < counterboreDia, toujours', () {
      for (final material in MaterialKind.values) {
        for (final d in diameters) {
          final r = compute(material, d, 18);
          expect(
            r.pilotHole,
            lessThan(r.clearanceHole),
            reason: '${material.name} Ø$d',
          );
          expect(
            r.clearanceHole,
            lessThan(r.counterboreDia),
            reason: '${material.name} Ø$d',
          );
        }
      }
    });

    test('l’avant-trou croît avec le Ø de vis', () {
      for (final material in MaterialKind.values) {
        var previous = 0.0;
        for (final d in diameters) {
          final pilot = compute(material, d, 18).pilotHole;
          expect(pilot, greaterThan(previous), reason: '${material.name} Ø$d');
          previous = pilot;
        }
      }
    });

    test('la vis traverse la pièce et pénètre le support', () {
      for (final d in diameters) {
        final r = compute(MaterialKind.plywood, d, 22);
        expect(r.screwLength, greaterThan(22));
        expect(r.screwLength, closeTo(22 + r.penetration, 1e-9));
        expect(r.penetration, greaterThan(0));
      }
    });
  });

  group('computeFastener — entrées invalides', () {
    test('Ø nul ou négatif → CalcException', () {
      expect(
        () => compute(MaterialKind.softwood, 0, 18),
        throwsA(isA<CalcException>()),
      );
      expect(
        () => compute(MaterialKind.softwood, -4, 18),
        throwsA(isA<CalcException>()),
      );
    });

    test('Ø sous le minimum → CalcException (invariant intenable)', () {
      expect(
        () => compute(MaterialKind.softwood, minScrewDiameter / 2, 18),
        throwsA(isA<CalcException>()),
      );
    });

    test('épaisseur nulle ou négative → CalcException', () {
      expect(
        () => compute(MaterialKind.softwood, 4, 0),
        throwsA(isA<CalcException>()),
      );
      expect(
        () => compute(MaterialKind.softwood, 4, -18),
        throwsA(isA<CalcException>()),
      );
    });

    test('cote non finie → CalcException', () {
      expect(
        () => compute(MaterialKind.softwood, double.nan, 18),
        throwsA(isA<CalcException>()),
      );
    });
  });
}
