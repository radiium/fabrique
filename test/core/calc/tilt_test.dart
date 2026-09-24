import 'dart:math' as math;

import 'package:fabrique/core/calc/calc_exception.dart';
import 'package:fabrique/core/calc/tilt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Lecture inclinée de [pitchDeg] autour de l'axe X, à 1 g.
  AccelReading pitchedBy(double pitchDeg) {
    const g = 9.81;
    final rad = pitchDeg * math.pi / 180;
    return AccelReading(0, g * math.sin(rad), g * math.cos(rad));
  }

  group('computeTilt — orientations de référence', () {
    test('à plat → 0 / 0, niveau atteint', () {
      final r = computeTilt(const AccelReading(0, 0, 9.81));

      expect(r.pitchDeg, closeTo(0, 1e-9));
      expect(r.rollDeg, closeTo(0, 1e-9));
      expect(r.isLevel, isTrue);
    });

    test('sur le côté → roll ≈ 90°', () {
      final r = computeTilt(const AccelReading(9.81, 0, 0));

      expect(r.rollDeg, closeTo(90, 1e-6));
      expect(r.pitchDeg, closeTo(0, 1e-9));
      expect(r.isLevel, isFalse);
    });

    test('vers l’avant → pitch ≈ 90°', () {
      final r = computeTilt(const AccelReading(0, 9.81, 0));

      expect(r.pitchDeg, closeTo(90, 1e-6));
      expect(r.rollDeg, closeTo(0, 1e-9));
      expect(r.isLevel, isFalse);
    });

    test('inclinaison négative → angle négatif', () {
      final r = computeTilt(pitchedBy(-30));

      expect(r.pitchDeg, closeTo(-30, 1e-6));
      expect(r.isLevel, isFalse);
    });
  });

  group('computeTilt — calibrage', () {
    test('lecture identique au zéro → 0 / 0 après correction', () {
      const reading = AccelReading(1.2, 2.4, 9.3);
      final r = computeTilt(reading, zero: reading);

      expect(r.pitchDeg, closeTo(0, 1e-9));
      expect(r.rollDeg, closeTo(0, 1e-9));
      expect(r.isLevel, isTrue);
    });

    test('le zéro décale l’angle rendu', () {
      final r = computeTilt(pitchedBy(10), zero: pitchedBy(4));

      expect(r.pitchDeg, closeTo(6, 1e-6));
      expect(r.isLevel, isFalse);
    });
  });

  group('computeTilt — seuil de niveau', () {
    test('0.4° sous le seuil par défaut → niveau', () {
      expect(computeTilt(pitchedBy(0.4)).isLevel, isTrue);
    });

    test('0.6° au-dessus du seuil par défaut → hors niveau', () {
      expect(computeTilt(pitchedBy(0.6)).isLevel, isFalse);
    });

    test('seuil personnalisé', () {
      expect(computeTilt(pitchedBy(0.6), levelThresholdDeg: 1).isLevel, isTrue);
      expect(
        computeTilt(pitchedBy(0.4), levelThresholdDeg: 0.2).isLevel,
        isFalse,
      );
    });

    test('le roll compte autant que le pitch', () {
      const g = 9.81;
      const rad = 5 * math.pi / 180;
      final r = computeTilt(
        AccelReading(g * math.sin(rad), 0, g * math.cos(rad)),
      );

      expect(r.rollDeg, closeTo(5, 1e-6));
      expect(r.isLevel, isFalse);
    });
  });

  group('computeTilt — entrées invalides', () {
    test('lecture non finie → CalcException', () {
      expect(
        () => computeTilt(const AccelReading(double.nan, 0, 9.81)),
        throwsA(isA<CalcException>()),
      );
    });

    test('vecteur nul → CalcException (pas de faux « à plat »)', () {
      expect(
        () => computeTilt(const AccelReading(0, 0, 0)),
        throwsA(isA<CalcException>()),
      );
    });

    test('seuil négatif → CalcException', () {
      expect(
        () =>
            computeTilt(const AccelReading(0, 0, 9.81), levelThresholdDeg: -1),
        throwsA(isA<CalcException>()),
      );
    });
  });
}
