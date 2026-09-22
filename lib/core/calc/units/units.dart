import '../../models/length_unit.dart';
import '../calc_exception.dart';

/// Facteurs de conversion vers le millimètre.
const Map<LengthUnit, double> mmPerUnit = {
  LengthUnit.mm: 1,
  LengthUnit.cm: 10,
  LengthUnit.m: 1000,
  LengthUnit.inch: 25.4,
  LengthUnit.foot: 304.8,
};

/// Convertit [value] exprimée en [unit] vers des millimètres.
double toMm(double value, LengthUnit unit) {
  if (!value.isFinite) {
    throw const CalcException('Valeur non finie');
  }
  return value * mmPerUnit[unit]!;
}

/// Convertit [mm] vers [unit].
double fromMm(double mm, LengthUnit unit) {
  if (!mm.isFinite) {
    throw const CalcException('Valeur non finie');
  }
  return mm / mmPerUnit[unit]!;
}
