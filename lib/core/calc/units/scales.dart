/// Échelles des schémas du Convertisseur : la double règle des longueurs, et
/// la comparaison à un repère des autres grandeurs.
library;

import 'dart:math' as math;

import '../../models/measure_unit.dart';

/// Millimètres dans un pouce.
const double _mmPerInch = 25.4;

/// Marge de la règle au-delà de la valeur, pour que le curseur quitte le bord.
const double _rulerHeadroom = 1.25;

/// Échelons ronds de la règle métrique, en mm.
const List<double> _metricSteps = [
  1,
  2,
  5,
  10,
  20,
  25,
  50,
  100,
  200,
  250,
  500,
  1000,
  2000,
  2500,
  5000,
  10000,
  20000,
  50000,
  100000,
];

/// Échelons usuels de la règle impériale, en pouces : fractions binaires,
/// puis pouces, puis pieds.
const List<double> _imperialSteps = [
  1 / 16,
  1 / 8,
  1 / 4,
  1 / 2,
  1,
  2,
  3,
  6,
  12,
  24,
  36,
  72,
  144,
  288,
  720,
];

/// Longueur couverte par la règle pour une valeur de [mm], en mm.
///
/// Un cran rond au-dessus de la valeur, sur l'échelle 1 / 2 / 2,5 / 5 / 10.
double rulerSpan(double mm) => _niceCeil(math.max(mm, 1) * _rulerHeadroom);

/// Pas des graduations principales de la règle métrique, en mm.
///
/// Le plus petit échelon rond qui donne au plus [maxTicks] graduations sur
/// [spanMm], chacune d'au moins [minStepMm]. Sinon une division brute, pour
/// borner le nombre de traits.
double metricRulerStep(
  double spanMm, {
  required int maxTicks,
  required double minStepMm,
}) => _pickStep(_metricSteps, spanMm, maxTicks, minStepMm);

/// Pas des graduations principales de la règle impériale, en mm.
///
/// Mêmes critères que [metricRulerStep], sur les échelons impériaux.
double imperialRulerStep(
  double spanMm, {
  required int maxTicks,
  required double minStepMm,
}) =>
    _pickStep(
      _imperialSteps,
      spanMm / _mmPerInch,
      maxTicks,
      minStepMm / _mmPerInch,
    ) *
    _mmPerInch;

double _pickStep(
  List<double> ladder,
  double span,
  int maxTicks,
  double minStep,
) {
  for (final step in ladder) {
    if (span / step <= maxTicks && step >= minStep) return step;
  }
  return span / maxTicks;
}

double _niceCeil(double value) {
  if (value <= 0 || !value.isFinite) return 1;
  final magnitude = math.pow(10, (math.log(value) / math.ln10).floor());
  final base = magnitude.toDouble();
  for (final multiple in [1.0, 2.0, 2.5, 5.0, 10.0]) {
    if (value <= multiple * base + 1e-9) return multiple * base;
  }
  return 10 * base;
}

/// Le repère rond auquel se compare une valeur de [quantity], ou `null` pour
/// une longueur, qui se lit sur la double règle.
MeasureUnit? comparisonReference(Quantity quantity) => switch (quantity) {
  Quantity.length => null,
  Quantity.area => MeasureUnit.m2,
  Quantity.volume => MeasureUnit.liter,
  Quantity.mass => MeasureUnit.kilogram,
  Quantity.pressure => MeasureUnit.bar,
};

/// Rapport des dimensions dessinées pour [ratio] repères de [quantity].
///
/// Racine carrée pour une surface (côté d'un carré), cubique pour un volume
/// (arête d'un cube), le rapport tel quel sinon.
double linearRatio(double ratio, Quantity quantity) => switch (quantity) {
  Quantity.area => math.sqrt(ratio),
  Quantity.volume => math.pow(ratio, 1 / 3).toDouble(),
  Quantity.length || Quantity.mass || Quantity.pressure => ratio,
};

/// Tailles dessinées de la valeur et du repère, dans l'unité de [maxExtent].
///
/// La plus grande des deux vaut [maxExtent], l'autre suit [linear]. Une taille
/// sous [minExtent] y est relevée, et [isOutOfScale] le signale. Un rapport
/// nul, négatif ou non fini ne dessine que le repère.
({double value, double reference, bool isOutOfScale}) comparisonExtents(
  double linear, {
  required double maxExtent,
  required double minExtent,
}) {
  if (!linear.isFinite || linear <= 0) {
    return (value: 0, reference: maxExtent, isOutOfScale: false);
  }

  final (value, reference) = linear >= 1
      ? (maxExtent, maxExtent / linear)
      : (maxExtent * linear, maxExtent);

  if (math.min(value, reference) >= minExtent) {
    return (value: value, reference: reference, isOutOfScale: false);
  }
  return (
    value: math.max(value, minExtent),
    reference: math.max(reference, minExtent),
    isOutOfScale: true,
  );
}
