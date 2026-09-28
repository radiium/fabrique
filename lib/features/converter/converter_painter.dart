import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/units/imperial.dart';
import '../../core/calc/units/scales.dart';
import '../../core/models/measure_unit.dart';
import '../../core/painting.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/numbers.dart';
import 'converter_controller.dart';

const double _sideMargin = 24;

/// Longueur d'une graduation principale et d'une secondaire.
const double _majorTick = 13;
const double _minorTick = 7;

/// Nombre visé de graduations principales sur la largeur du canvas.
const int _targetTicks = 7;

/// Écart minimal entre deux graduations principales, en pixels.
const double _minTickGap = 24;

/// Double règle graduée (métrique en haut, impérial en bas) avec curseur sur
/// la valeur courante.
///
/// Les deux règles couvrent la même longueur : le curseur relie les deux
/// lectures d'une même position. Longueurs seulement.
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

    final span = rulerSpan(r.base);
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
    final step = metricRulerStep(
      span,
      maxTicks: _targetTicks,
      minStepMm: _minTickGap * span / usable,
    );
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

  /// Règle impériale : graduations vers le bas, libellés en dessous, en
  /// impérial composé.
  void _paintImperial(
    Canvas canvas,
    double Function(double) dx,
    double baseline,
    double span,
    double usable,
  ) {
    final step = imperialRulerStep(
      span,
      maxTicks: _targetTicks,
      minStepMm: _minTickGap * span / usable,
    );
    _paintRuler(
      canvas,
      dx: dx,
      baseline: baseline,
      span: span,
      step: step,
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
      // Un libellé qui chevaucherait le précédent est sauté, pas la graduation.
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

    // Les deux valeurs entre les règles, de part et d'autre du trait.
    drawSchemaLabel(canvas, metric, Offset(x, metricBaseline + 14));
    drawSchemaLabel(canvas, imperialText, Offset(x, imperialBaseline - 14));
  }

  @override
  bool shouldRepaint(RulerPainter old) =>
      old.result != result || old.l10n.localeName != l10n.localeName;
}
