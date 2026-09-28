import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'calc_exception.dart';

part 'tilt.freezed.dart';
part 'tilt.g.dart';

/// Lecture brute d'accéléromètre, en m/s², repère Android.
///
/// À plat écran au ciel, `z = +g`. Lever le bord droit rend `x` positif, lever
/// le haut de l'écran rend `y` positif.
@freezed
abstract class AccelReading with _$AccelReading {
  const factory AccelReading(double x, double y, double z) = _AccelReading;

  factory AccelReading.fromJson(Map<String, dynamic> json) =>
      _$AccelReadingFromJson(json);
}

/// Inclinaison sous laquelle la pièce est déclarée de niveau, en degrés.
const double kLevelThresholdDeg = 0.5;

/// Angle placé à mi-course de la bulle, en degrés.
const double kVialHalfCourseDeg = 2;

/// Calibrage propre au téléphone : un biais par tranche, soustrait de chaque
/// lecture.
///
/// Une tranche sans entrée dans [edgesDeg] n'est pas calibrée.
@freezed
abstract class DeviceCalibration with _$DeviceCalibration {
  const factory DeviceCalibration({
    /// Biais de chaque tranche, en degrés, par quart de tour
    /// ([EdgeTilt.quarterTurns]).
    @Default(<int, double>{}) Map<int, double> edgesDeg,
  }) = _DeviceCalibration;

  factory DeviceCalibration.fromJson(Map<String, dynamic> json) =>
      _$DeviceCalibrationFromJson(json);
}

/// L'inclinaison du téléphone, mesurée sur une tranche seulement.
@freezed
sealed class TiltResult with _$TiltResult {
  /// Posé sur le dos : rien à mesurer. La surépaisseur de l'appareil photo
  /// fausserait la lecture.
  const factory TiltResult.flat() = FlatTilt;

  /// Sur une tranche : un axe, dans le plan de l'écran redressé de
  /// [quarterTurns] quarts de tour horaires. [angleDeg] est positif quand
  /// l'extrémité droite de la tranche du bas monte.
  const factory TiltResult.edge({
    required double angleDeg,
    required int quarterTurns,
    required bool isLevel,
    required bool isCalibrated,
  }) = EdgeTilt;
}

/// Dérive l'inclinaison d'un vecteur accéléromètre.
///
/// Sur la tranche dès que la gravité est à plus de 45° de l'axe de l'écran.
/// Le biais de [calibration] pour cette tranche est soustrait.
///
/// Lève [CalcException] :
/// - [InvalidLevelThreshold] si [levelThresholdDeg] est négatif ou non fini ;
/// - [InvalidSensorReading] si la lecture est non finie ou nulle.
TiltResult computeTilt(
  AccelReading r, {
  DeviceCalibration calibration = const DeviceCalibration(),
  double levelThresholdDeg = kLevelThresholdDeg,
}) {
  if (!levelThresholdDeg.isFinite || levelThresholdDeg < 0) {
    throw const CalcException(InvalidLevelThreshold());
  }
  if (!r.x.isFinite || !r.y.isFinite || !r.z.isFinite) {
    throw const CalcException(InvalidSensorReading());
  }
  final inPlane = math.sqrt(r.x * r.x + r.y * r.y);
  if (math.sqrt(inPlane * inPlane + r.z * r.z) < _minMagnitude) {
    throw const CalcException(InvalidSensorReading());
  }

  if (r.z.abs() >= inPlane) return const TiltResult.flat();

  // Direction du ciel dans le plan de l'écran : 0° vers son haut, positive
  // vers sa droite. Le quart de tour le plus proche redresse l'écran.
  final up = math.atan2(r.x, r.y) * _radToDeg;
  final turns = (up / 90).round();
  final quarterTurns = turns % 4;
  final bias = calibration.edgesDeg[quarterTurns];
  final angle = up - turns * 90 - (bias ?? 0);
  return TiltResult.edge(
    angleDeg: angle,
    quarterTurns: quarterTurns,
    isLevel: angle.abs() < levelThresholdDeg,
    isCalibrated: bias != null,
  );
}

/// Pente d'un angle, en millimètres par mètre, signe conservé.
double slopeMmPerM(double angleDeg) => math.tan(angleDeg * _degToRad) * 1000;

/// Place [angleDeg] sur la course de la bulle : 0 au centre, vers ±1 au bord
/// du côté haut.
///
/// Presque linéaire sous [kVialHalfCourseDeg], resserrée au-delà.
double vialCourse(double angleDeg) =>
    angleDeg / (angleDeg.abs() + kVialHalfCourseDeg);

const double _radToDeg = 180 / math.pi;
const double _degToRad = math.pi / 180;

/// Norme minimale d'un vecteur exploitable, en m/s² : en dessous,
/// l'orientation n'a pas de sens.
const double _minMagnitude = 1e-6;
