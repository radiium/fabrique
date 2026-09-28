/// Mesure immobile et calibrage par retournement du Niveau.
library;

import 'dart:math' as math;

import 'calc_exception.dart';
import 'tilt.dart';

/// Écart maximal d'une lecture à la moyenne, en degrés, pour une mesure
/// déclarée immobile.
const double kMaxSampleSpreadDeg = 0.3;

/// Biais maximal accepté, en degrés.
///
/// Un accéléromètre de téléphone dérive de quelques dixièmes. Au-delà, le
/// téléphone n'a pas été retourné sur la même marque.
const double kMaxBiasDeg = 3;

/// Moyenne d'une série de lectures prises téléphone immobile.
///
/// Lève [CalcException] :
/// - [InvalidSensorReading] si [samples] est vide, ou si une lecture est non
///   finie ou nulle ;
/// - [UnsteadyReading] si une lecture s'écarte de plus de
///   [kMaxSampleSpreadDeg] de la moyenne.
AccelReading steadyReading(List<AccelReading> samples) {
  if (samples.isEmpty) throw const CalcException(InvalidSensorReading());

  var x = 0.0;
  var y = 0.0;
  var z = 0.0;
  for (final s in samples) {
    x += s.x;
    y += s.y;
    z += s.z;
  }
  final mean = AccelReading(
    x / samples.length,
    y / samples.length,
    z / samples.length,
  );

  for (final s in samples) {
    if (_angleBetweenDeg(s, mean) > kMaxSampleSpreadDeg) {
      throw const CalcException(UnsteadyReading());
    }
  }
  return mean;
}

/// Ajoute à [current] le biais d'une tranche, et rend son ampleur en degrés.
///
/// [second] suit un demi-tour sur place : la pente de la surface change de
/// signe, le biais non. Les deux mesures sont prises sans calibrage.
///
/// Lève [CalcException] :
/// - [NotOnEdge] si une mesure a été prise à plat ;
/// - [PoseChanged] si les deux mesures ne portent pas sur la même tranche ;
/// - [BiasTooLarge] si le biais dépasse [kMaxBiasDeg].
({DeviceCalibration calibration, double biasDeg}) calibrateByReversal(
  DeviceCalibration current,
  TiltResult first,
  TiltResult second,
) {
  switch ((first, second)) {
    case (final EdgeTilt a, final EdgeTilt b):
      if (a.quarterTurns != b.quarterTurns) {
        throw const CalcException(PoseChanged());
      }
      final bias = (a.angleDeg + b.angleDeg) / 2;
      if (bias.abs() > kMaxBiasDeg) {
        throw const CalcException(BiasTooLarge(kMaxBiasDeg));
      }
      return (
        calibration: current.copyWith(
          edgesDeg: {...current.edgesDeg, a.quarterTurns: bias},
        ),
        biasDeg: bias.abs(),
      );
    case (FlatTilt(), EdgeTilt() || FlatTilt()) || (EdgeTilt(), FlatTilt()):
      throw const CalcException(NotOnEdge());
  }
}

/// Angle entre deux lectures, en degrés.
///
/// Indifférent à la pose : un changement de tranche dépasse de loin le seuil.
double _angleBetweenDeg(AccelReading a, AccelReading b) {
  final dot = a.x * b.x + a.y * b.y + a.z * b.z;
  final norms =
      math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z) *
      math.sqrt(b.x * b.x + b.y * b.y + b.z * b.z);
  if (!(norms > 0)) throw const CalcException(InvalidSensorReading());
  // `clamp` : l'arrondi peut pousser le cosinus au-delà de 1.
  return math.acos((dot / norms).clamp(-1.0, 1.0)) * 180 / math.pi;
}
