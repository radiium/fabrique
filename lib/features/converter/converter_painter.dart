import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/units/imperial.dart';
import '../../core/models/measure_unit.dart';
import '../../core/painting.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/numbers.dart';
import 'converter_controller.dart';

const double _sideMargin = 24;

/// Longueur d'une graduation principale et d'une secondaire.
const double _majorTick = 13;
const double _minorTick = 7;

/// Millimètres dans un pouce — les deux règles partagent la même échelle
/// physique, c'est ce qui rend la conversion visible.
const double _mmPerInch = 25.4;

/// Échelons « ronds » pour la règle métrique, en mm.
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

/// Échelons usuels pour la règle impériale, en pouces : fractions binaires,
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

/// Nombre visé de graduations principales sur la largeur du canvas.
const int _targetTicks = 7;

/// Double règle graduée (métrique en haut, impérial en bas) avec curseur sur
/// la valeur courante.
///
/// Les deux règles couvrent **la même longueur physique** : le curseur les
/// traverse d'un seul trait, et c'est ce trait qui montre la conversion — une
/// même position, deux lectures.
///
/// Réservé aux longueurs : une règle graduée ne veut rien dire pour une masse
/// ou une pression. Les autres grandeurs passent par `ComparisonPainter`.
class RulerPainter extends CustomPainter {
  const RulerPainter({required this.result, required this.l10n});

  final ConverterResult? result;

  final AppLocalizations l10n;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final r = result;
    final imperial = r?.imperial;
    if (r == null ||
        r.quantity != Quantity.length ||
        imperial == null ||
        !r.base.isFinite) {
      drawSchemaPlaceholder(canvas, size);
      return;
    }

    final usable = size.width - 2 * _sideMargin;
    if (usable <= 0) return;

    // La plage affichée : un cran rond au-dessus de la valeur, pour que le
    // curseur ne colle jamais au bord droit.
    final span = _niceCeil(math.max(r.base, 1) * 1.25);
    double dx(double mm) => _sideMargin + usable * (mm / span);

    final centerY = size.height / 2;
    final metricBaseline = centerY - 26;
    final imperialBaseline = centerY + 26;

    _paintMetric(canvas, dx, metricBaseline, span, usable);
    _paintImperial(canvas, dx, imperialBaseline, span, usable);
    _paintCursor(canvas, r, imperial, dx, metricBaseline, imperialBaseline);
  }

  /// Règle métrique : graduations vers le haut, libellés au-dessus.
  void _paintMetric(
    Canvas canvas,
    double Function(double) dx,
    double baseline,
    double span,
    double usable,
  ) {
    final step = _pickStep(_metricSteps, span, usable);
    _paintRuler(
      canvas,
      dx: dx,
      baseline: baseline,
      span: span,
      step: step,
      direction: -1,
      unit: 'mm',
      label: l10n.number,
    );
  }

  /// Règle impériale : graduations vers le bas, libellés en dessous, écrits en
  /// impérial composé par `core/calc` — pas de formatage maison ici.
  void _paintImperial(
    Canvas canvas,
    double Function(double) dx,
    double baseline,
    double span,
    double usable,
  ) {
    final stepInches = _pickStep(_imperialSteps, span / _mmPerInch, usable);
    _paintRuler(
      canvas,
      dx: dx,
      baseline: baseline,
      span: span,
      step: stepInches * _mmPerInch,
      direction: 1,
      unit: l10n.unitInchSymbol,
      label: (mm) => formatImperial(mmToImperial(mm, denominator: 64)),
    );
  }

  /// Tracé commun aux deux règles. [direction] vaut −1 pour des graduations
  /// vers le haut, +1 vers le bas.
  void _paintRuler(
    Canvas canvas, {
    required double Function(double) dx,
    required double baseline,
    required double span,
    required double step,
    required double direction,
    required String unit,
    required String Function(double) label,
  }) {
    final paint = Paint()
      ..color = AppColors.label
      ..strokeWidth = 1.2;

    canvas.drawLine(Offset(dx(0), baseline), Offset(dx(span), baseline), paint);

    // Graduations secondaires : seulement si elles restent lisibles.
    final minorStep = step / 4;
    if (dx(minorStep) - dx(0) >= 5) {
      final minorPaint = Paint()
        ..color = AppColors.label.withValues(alpha: 0.45)
        ..strokeWidth = 1;
      for (var mm = 0.0; mm <= span + 1e-9; mm += minorStep) {
        canvas.drawLine(
          Offset(dx(mm), baseline),
          Offset(dx(mm), baseline + direction * _minorTick),
          minorPaint,
        );
      }
    }

    var previousLabelEnd = double.negativeInfinity;
    for (var mm = 0.0; mm <= span + 1e-9; mm += step) {
      final x = dx(mm);
      canvas.drawLine(
        Offset(x, baseline),
        Offset(x, baseline + direction * _majorTick),
        paint,
      );

      final text = schemaText(label(mm), size: 10);
      final start = x - text.width / 2;
      // Un libellé qui chevaucherait le précédent est sauté : la graduation
      // reste, seul le chiffre disparaît.
      if (start < previousLabelEnd + 6) continue;
      previousLabelEnd = start + text.width;

      final y = direction < 0
          ? baseline - _majorTick - 2 - text.height
          : baseline + _majorTick + 2;
      text.paint(canvas, Offset(start, y));
    }

    final unitLabel = schemaText(unit, size: 10);
    unitLabel.paint(
      canvas,
      Offset(dx(0) - unitLabel.width - 8, baseline - unitLabel.height / 2),
    );
  }

  /// Le curseur : un seul trait qui relie les deux lectures de la même
  /// position.
  void _paintCursor(
    Canvas canvas,
    ConverterResult r,
    ImperialParts imperial,
    double Function(double) dx,
    double metricBaseline,
    double imperialBaseline,
  ) {
    final x = dx(r.base);
    final paint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas
      ..drawLine(Offset(x, metricBaseline), Offset(x, imperialBaseline), paint)
      ..drawCircle(Offset(x, metricBaseline), 4, paint)
      ..drawCircle(Offset(x, imperialBaseline), 4, paint);

    final metric = schemaText(
      '${l10n.number(r.base)} mm',
      size: 13,
      color: AppColors.accentDeep,
      weight: FontWeight.w700,
    );
    final imperialText = schemaText(
      formatImperial(imperial),
      size: 13,
      color: AppColors.accentDeep,
      weight: FontWeight.w700,
    );

    // Les deux valeurs se posent entre les règles, de part et d'autre du trait,
    // en restant dans le canvas quand le curseur approche d'un bord.
    drawSchemaLabel(canvas, metric, Offset(x, metricBaseline + 14));
    drawSchemaLabel(canvas, imperialText, Offset(x, imperialBaseline - 14));
  }

  /// Le plus petit échelon de [ladder] qui tient le compte de graduations sous
  /// [_targetTicks] — et qui laisse au moins 24 px entre deux traits.
  ///
  /// Si aucun échelon rond ne convient — une valeur démesurée sort de
  /// l'échelle — on retombe sur une division brute. Les chiffres sont moins
  /// jolis, mais le nombre de graduations reste borné : sans ça, une saisie en
  /// pieds à six chiffres ferait tracer des milliers de traits.
  double _pickStep(List<double> ladder, double span, double usable) {
    for (final step in ladder) {
      if (span / step <= _targetTicks && usable * step / span >= 24) {
        return step;
      }
    }
    return span / _targetTicks;
  }

  /// Arrondit vers le haut sur l'échelle 1 / 2 / 2.5 / 5 / 10.
  double _niceCeil(double value) {
    if (value <= 0 || !value.isFinite) return 1;
    final magnitude = math.pow(10, (math.log(value) / math.ln10).floor());
    final base = magnitude.toDouble();
    for (final multiple in [1.0, 2.0, 2.5, 5.0, 10.0]) {
      if (value <= multiple * base + 1e-9) return multiple * base;
    }
    return 10 * base;
  }

  @override
  bool shouldRepaint(RulerPainter old) =>
      old.result != result || old.l10n.localeName != l10n.localeName;
}
