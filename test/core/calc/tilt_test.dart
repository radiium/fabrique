import 'dart:math' as math;

import 'package:fabrique/core/calc/calc_exception.dart';
import 'package:fabrique/core/calc/tilt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const g = 9.81;
  double rad(double deg) => deg * math.pi / 180;

  /// À plat, haut de l'écran levé de [pitchDeg].
  AccelReading flatBy(double pitchDeg) {
    final y = g * math.sin(rad(pitchDeg));
    return AccelReading(0, y, math.sqrt(g * g - y * y));
  }

  /// Debout, tourné de [deg] dans le sens antihoraire vu de face.
  AccelReading uprightBy(double deg) =>
      AccelReading(g * math.sin(rad(deg)), g * math.cos(rad(deg)), 0);

  EdgeTilt edge(
    AccelReading r, {
    DeviceCalibration calibration = const DeviceCalibration(),
  }) => computeTilt(r, calibration: calibration) as EdgeTilt;

  group('computeTilt — pose', () {
    test('posé sur le dos ou sur l’écran, rien à mesurer', () {
      expect(computeTilt(const AccelReading(0, 0, g)), const FlatTilt());
      expect(computeTilt(const AccelReading(0, 0, -g)), const FlatTilt());
    });

    test('au-delà de 45° d’inclinaison, le téléphone est sur la tranche', () {
      expect(computeTilt(flatBy(44)), isA<FlatTilt>());
      expect(computeTilt(flatBy(46)), isA<EdgeTilt>());
    });
  });

  group('computeTilt — sur la tranche', () {
    test('debout → aucun quart de tour, 0°, de niveau', () {
      final r = edge(const AccelReading(0, g, 0));

      expect(r.quarterTurns, 0);
      expect(r.angleDeg, closeTo(0, 1e-9));
      expect(r.isLevel, isTrue);
      expect(r.isCalibrated, isFalse);
    });

    test('chaque tranche du bas donne son quart de tour', () {
      expect(edge(const AccelReading(g, 0, 0)).quarterTurns, 1);
      expect(edge(const AccelReading(0, -g, 0)).quarterTurns, 2);
      expect(edge(const AccelReading(-g, 0, 0)).quarterTurns, 3);
    });

    test('tourné dans le sens antihoraire, l’extrémité droite monte', () {
      final r = edge(uprightBy(1.5));

      expect(r.angleDeg, closeTo(1.5, 1e-6));
      expect(r.isLevel, isFalse);
    });

    test('couché sur un bord, l’angle se lit dans l’écran redressé', () {
      // Couché sur le bord gauche : un quart de tour, puis 2° de plus.
      final r = edge(uprightBy(92));

      expect(r.quarterTurns, 1);
      expect(r.angleDeg, closeTo(2, 1e-6));
    });
  });

  group('computeTilt — calibrage de l’appareil', () {
    const calibration = DeviceCalibration(edgesDeg: {0: 0.4});

    test('le biais de la tranche est soustrait', () {
      final r = edge(uprightBy(1.4), calibration: calibration);

      expect(r.angleDeg, closeTo(1, 1e-6));
      expect(r.isCalibrated, isTrue);
    });

    test('une autre tranche reste non calibrée, et intacte', () {
      final r = edge(uprightBy(91), calibration: calibration);

      expect(r.angleDeg, closeTo(1, 1e-6));
      expect(r.isCalibrated, isFalse);
    });
  });

  group('computeTilt — seuil de niveau', () {
    test('seuil par défaut : 0,4° de niveau, 0,6° hors niveau', () {
      expect(edge(uprightBy(0.4)).isLevel, isTrue);
      expect(edge(uprightBy(-0.6)).isLevel, isFalse);
    });

    test('seuil personnalisé', () {
      final r = computeTilt(uprightBy(0.6), levelThresholdDeg: 1);

      expect((r as EdgeTilt).isLevel, isTrue);
    });
  });

  group('computeTilt — entrées invalides', () {
    test('lecture non finie → CalcException', () {
      expect(
        () => computeTilt(const AccelReading(double.nan, 0, g)),
        throwsA(isA<CalcException>()),
      );
    });

    test('vecteur nul → CalcException', () {
      expect(
        () => computeTilt(const AccelReading(0, 0, 0)),
        throwsA(isA<CalcException>()),
      );
    });

    test('seuil négatif → CalcException', () {
      expect(
        () => computeTilt(const AccelReading(0, g, 0), levelThresholdDeg: -1),
        throwsA(isA<CalcException>()),
      );
    });
  });

  test('45° font 1000 mm/m, et le signe suit l’angle', () {
    expect(slopeMmPerM(45), closeTo(1000, 1e-9));
    expect(slopeMmPerM(-0.5), closeTo(-8.727, 1e-3));
  });

  group('course de la bulle', () {
    test('mi-course à kVialHalfCourseDeg, jamais hors du tube', () {
      expect(vialCourse(0), 0);
      expect(vialCourse(kVialHalfCourseDeg), closeTo(0.5, 1e-9));
      expect(vialCourse(-kVialHalfCourseDeg), closeTo(-0.5, 1e-9));
      expect(vialCourse(45), lessThan(1));
    });

    test('la bulle monte du côté haut', () {
      expect(vialCourse(edge(uprightBy(2)).angleDeg), greaterThan(0));
    });

    test('bulle entre les repères si et seulement si de niveau', () {
      final target = vialCourse(kLevelThresholdDeg);
      for (final angle in [0.3, 0.49, 0.51, -0.7]) {
        final r = edge(uprightBy(angle));
        expect(
          vialCourse(r.angleDeg).abs() < target,
          r.isLevel,
          reason: '$angle',
        );
      }
    });
  });
}
