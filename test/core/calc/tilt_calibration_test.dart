import 'dart:convert';
import 'dart:math' as math;

import 'package:fabrique/core/calc/calc_exception.dart';
import 'package:fabrique/core/calc/tilt.dart';
import 'package:fabrique/core/calc/tilt_calibration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const g = 9.81;
  double rad(double deg) => deg * math.pi / 180;

  AccelReading flatBy({double pitchDeg = 0, double rollDeg = 0}) {
    final y = g * math.sin(rad(pitchDeg));
    final x = g * math.sin(rad(rollDeg));
    return AccelReading(x, y, math.sqrt(g * g - x * x - y * y));
  }

  AccelReading uprightBy(double deg) =>
      AccelReading(g * math.sin(rad(deg)), g * math.cos(rad(deg)), 0);

  Matcher refusedWith<T extends CalcError>() =>
      throwsA(isA<CalcException>().having((e) => e.reason, 'reason', isA<T>()));

  group('steadyReading', () {
    test('rend la moyenne des lectures', () {
      final mean = steadyReading(const [
        AccelReading(0.01, 0, 9.8),
        AccelReading(-0.01, 0.02, 9.8),
      ]);

      expect(mean.x, closeTo(0, 1e-12));
      expect(mean.y, closeTo(0.01, 1e-12));
      expect(mean.z, closeTo(9.8, 1e-12));
    });

    test('une série vide est refusée', () {
      expect(
        () => steadyReading(const []),
        refusedWith<InvalidSensorReading>(),
      );
    });

    test('un téléphone qui bouge de plus de 0,3° est refusé', () {
      expect(
        () => steadyReading([flatBy(), flatBy(pitchDeg: 0.8)]),
        refusedWith<UnsteadyReading>(),
      );
      expect(steadyReading([flatBy(), flatBy(pitchDeg: 0.2)]), isNotNull);
    });

    test('un changement de tranche en cours de mesure est refusé', () {
      expect(
        () => steadyReading([uprightBy(0), uprightBy(90)]),
        refusedWith<UnsteadyReading>(),
      );
    });

    test('une lecture non finie est refusée', () {
      expect(
        () =>
            steadyReading([uprightBy(0), const AccelReading(0, double.nan, 0)]),
        refusedWith<InvalidSensorReading>(),
      );
    });
  });

  group('calibrateByReversal', () {
    // Sur une surface qui penche, un capteur biaisé lit pente + biais, puis,
    // retourné, biais − pente.
    const slope = 1.2;
    const bias = 0.3;

    test('rend le biais malgré la pente de la surface', () {
      final outcome = calibrateByReversal(
        const DeviceCalibration(),
        computeTilt(uprightBy(slope + bias)),
        computeTilt(uprightBy(-slope + bias)),
      );

      expect(outcome.calibration.edgesDeg[0], closeTo(bias, 1e-6));
      expect(outcome.biasDeg, closeTo(bias, 1e-6));
    });

    test('sur une tranche, ne touche qu’à celle-là', () {
      const current = DeviceCalibration(edgesDeg: {1: 0.5});
      final outcome = calibrateByReversal(
        current,
        computeTilt(uprightBy(slope + bias)),
        computeTilt(uprightBy(-slope + bias)),
      );

      expect(outcome.calibration.edgesDeg[0], closeTo(bias, 1e-6));
      expect(outcome.calibration.edgesDeg[1], 0.5);
    });

    test('corrigée, la lecture retrouve la pente de la surface', () {
      final first = computeTilt(uprightBy(slope + bias));
      final outcome = calibrateByReversal(
        const DeviceCalibration(),
        first,
        computeTilt(uprightBy(-slope + bias)),
      );

      final corrected = computeTilt(
        uprightBy(slope + bias),
        calibration: outcome.calibration,
      );
      expect((corrected as EdgeTilt).angleDeg, closeTo(slope, 1e-6));
    });

    test('une mesure prise à plat est refusée', () {
      for (final (first, second) in [
        (flatBy(), uprightBy(0)),
        (uprightBy(0), flatBy()),
        (flatBy(), flatBy()),
      ]) {
        expect(
          () => calibrateByReversal(
            const DeviceCalibration(),
            computeTilt(first),
            computeTilt(second),
          ),
          refusedWith<NotOnEdge>(),
        );
      }
    });

    test('deux tranches différentes sont refusées', () {
      expect(
        () => calibrateByReversal(
          const DeviceCalibration(),
          computeTilt(uprightBy(0)),
          computeTilt(uprightBy(90)),
        ),
        refusedWith<PoseChanged>(),
      );
    });

    test('un biais de plus de 3° est refusé', () {
      expect(
        () => calibrateByReversal(
          const DeviceCalibration(),
          computeTilt(uprightBy(4)),
          computeTilt(uprightBy(4)),
        ),
        refusedWith<BiasTooLarge>(),
      );
    });
  });

  test('le calibrage survit à un aller-retour en JSON', () {
    const calibration = DeviceCalibration(edgesDeg: {0: 0.4, 3: -0.1});
    final json =
        jsonDecode(jsonEncode(calibration.toJson())) as Map<String, dynamic>;

    expect(DeviceCalibration.fromJson(json), calibration);
  });
}
