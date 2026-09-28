/// Conversions entre unités d'une même grandeur, par une unité pivot.
///
/// Pivots : mm, mm², mm³, g, Pa. Le mm³ et le mm² ne s'affichent pas.
library;

import '../../models/measure_unit.dart';
import '../calc_exception.dart';

/// Combien de pivots vaut une unité.
///
/// Facteurs impériaux exacts : le pouce vaut 25,4 mm par définition.
double baseFactor(MeasureUnit unit) => switch (unit) {
  // Longueur → mm
  MeasureUnit.mm => 1,
  MeasureUnit.cm => 10,
  MeasureUnit.m => 1000,
  MeasureUnit.inch => 25.4,
  MeasureUnit.foot => 304.8,

  // Surface → mm² (25,4² et 304,8²)
  MeasureUnit.mm2 => 1,
  MeasureUnit.cm2 => 100,
  MeasureUnit.m2 => 1000000,
  MeasureUnit.inch2 => 645.16,
  MeasureUnit.foot2 => 92903.04,

  // Volume → mm³ (25,4³ pour le pouce cube, 144 po³ pour le pied-planche)
  MeasureUnit.cm3 => 1000,
  MeasureUnit.liter => 1000000,
  MeasureUnit.m3 => 1000000000,
  MeasureUnit.inch3 => 16387.064,
  MeasureUnit.boardFoot => 2359737.216,

  // Masse → g (once et livre avoirdupois)
  MeasureUnit.gram => 1,
  MeasureUnit.kilogram => 1000,
  MeasureUnit.tonne => 1000000,
  MeasureUnit.ounce => 28.349523125,
  MeasureUnit.pound => 453.59237,

  // Pression → Pa
  MeasureUnit.bar => 100000,
  MeasureUnit.kilopascal => 1000,
  MeasureUnit.megapascal => 1000000,
  MeasureUnit.psi => 6894.757293168,
};

/// Convertit [value] exprimée en [unit] vers le pivot de sa grandeur.
double toBase(double value, MeasureUnit unit) {
  if (!value.isFinite) {
    throw const CalcException(NonFiniteValue());
  }
  return value * baseFactor(unit);
}

/// Convertit une valeur exprimée dans le pivot de la grandeur de [unit] vers
/// [unit].
double fromBase(double base, MeasureUnit unit) {
  if (!base.isFinite) {
    throw const CalcException(NonFiniteValue());
  }
  return base / baseFactor(unit);
}

/// Convertit [value] de [from] vers [to].
///
/// Lève [CalcException] entre deux grandeurs différentes.
double convert(double value, MeasureUnit from, MeasureUnit to) {
  if (from.quantity != to.quantity) {
    throw CalcException(IncompatibleUnits(from, to));
  }
  return fromBase(toBase(value, from), to);
}

/// [value], exprimée en [unit], rendue dans toutes les unités de sa grandeur.
Map<MeasureUnit, double> convertAll(double value, MeasureUnit unit) {
  final base = toBase(value, unit);
  return {
    for (final target in unit.quantity.units) target: fromBase(base, target),
  };
}
