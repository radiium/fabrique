import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'calc_exception.dart';

part 'tilt.freezed.dart';
part 'tilt.g.dart';

/// Lecture brute d'accéléromètre.
@freezed
abstract class AccelReading with _$AccelReading {
  const factory AccelReading(double x, double y, double z) = _AccelReading;

  factory AccelReading.fromJson(Map<String, dynamic> json) =>
      _$AccelReadingFromJson(json);
}

@freezed
abstract class TiltResult with _$TiltResult {
  const factory TiltResult({
    required double pitchDeg,
    required double rollDeg,
    required bool isLevel,
  }) = _TiltResult;
}

/// Dérive les angles d'un vecteur accéléromètre.
///
/// `pitch = atan2(y, sqrt(x² + z²))`, `roll = atan2(x, sqrt(y² + z²))`.
/// [zero] est l'offset de calibrage : ses propres angles sont soustraits.
TiltResult computeTilt(
  AccelReading r, {
  AccelReading? zero,
  double levelThresholdDeg = 0.5,
}) {
  if (!levelThresholdDeg.isFinite || levelThresholdDeg < 0) {
    throw const CalcException(InvalidLevelThreshold());
  }

  final pitch = _pitchDeg(r) - (zero == null ? 0 : _pitchDeg(zero));
  final roll = _rollDeg(r) - (zero == null ? 0 : _rollDeg(zero));

  return TiltResult(
    pitchDeg: pitch,
    rollDeg: roll,
    isLevel: pitch.abs() < levelThresholdDeg && roll.abs() < levelThresholdDeg,
  );
}

const double _radToDeg = 180 / math.pi;

/// Norme minimale d'un vecteur exploitable, en m/s² : en dessous,
/// `atan2(0, 0)` rendrait un faux « à plat ».
const double _minMagnitude = 1e-6;

double _pitchDeg(AccelReading r) {
  _guard(r);
  return math.atan2(r.y, math.sqrt(r.x * r.x + r.z * r.z)) * _radToDeg;
}

double _rollDeg(AccelReading r) {
  _guard(r);
  return math.atan2(r.x, math.sqrt(r.y * r.y + r.z * r.z)) * _radToDeg;
}

void _guard(AccelReading r) {
  if (!r.x.isFinite || !r.y.isFinite || !r.z.isFinite) {
    throw const CalcException(InvalidSensorReading());
  }
  if (math.sqrt(r.x * r.x + r.y * r.y + r.z * r.z) < _minMagnitude) {
    throw const CalcException(InvalidSensorReading());
  }
}
