import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/models/measure_unit.dart';
import '../../core/painting.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/labels.dart';
import '../../l10n/numbers.dart';
import 'converter_controller.dart';

/// Marge intérieure du canvas.
const double _margin = 22;

/// Taille minimale d'une forme : en dessous, elle disparaîtrait purement et
/// simplement. On la maintient visible et on le signale plutôt que de laisser
/// croire à un bug d'affichage.
const double _minExtent = 3;

/// Profondeur du cube, en fraction du côté (projection oblique).
const double _cubeDepth = 0.34;

/// La valeur courante comparée à un repère rond de sa famille.
///
/// Hors longueur, aucune règle graduée n'a de sens : une masse ne se pose pas
/// sur un ruban. Le seul visuel honnête est un rapport de grandeur — « ta
/// valeur, à côté de 1 m² » — et c'est ce que dessine ce painter, sous la
/// forme qui convient à la grandeur : carrés pour une surface, cubes pour un
/// volume, barres pour ce qui n'a pas de géométrie.
///
/// Assumé : c'est plus pauvre que la double règle des longueurs. Une pression
/// n'a pas de forme, et lui en inventer une mentirait.
class ComparisonPainter extends CustomPainter {
  const ComparisonPainter({
    required this.result,
    required this.unit,
    required this.l10n,
  });

  final ConverterResult? result;

  /// L'unité saisie : la forme est cotée dans l'unité que l'utilisateur a
  /// sous les yeux, pas dans le repère.
  final MeasureUnit unit;

  final AppLocalizations l10n;

  /// Le repère de chaque famille : une quantité que tout le monde se figure.
  static const Map<Quantity, MeasureUnit> _reference = {
    Quantity.area: MeasureUnit.m2,
    Quantity.volume: MeasureUnit.liter,
    Quantity.mass: MeasureUnit.kilogram,
    Quantity.pressure: MeasureUnit.bar,
  };

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final r = result;
    final reference = r == null ? null : _reference[r.quantity];
    final value = r == null || reference == null ? null : r.perUnit[reference];
    if (r == null || reference == null || value == null || !value.isFinite) {
      drawSchemaPlaceholder(canvas, size);
      return;
    }

    // Le rapport d'échelle linéaire : une surface double a un côté √2 fois
    // plus grand, un volume double une arête ∛2 fois plus grande. C'est tout
    // l'intérêt du dessin — montrer que 10 m² n'est pas « 10 fois plus long ».
    final k = switch (r.quantity) {
      Quantity.area => math.sqrt(value),
      Quantity.volume => math.pow(value, 1 / 3).toDouble(),
      Quantity.length || Quantity.mass || Quantity.pressure => value,
    };

    final box = Rect.fromLTWH(
      _margin,
      _margin,
      size.width - 2 * _margin,
      size.height - 2 * _margin,
    );
    if (box.width <= 0 || box.height <= 0) return;

    final isShape =
        r.quantity == Quantity.area || r.quantity == Quantity.volume;
    final maxExtent = isShape
        ? math.min(box.width / 2.3, box.height - 26)
        : box.width;

    final (valueExtent, refExtent, outOfScale) = _extents(k, maxExtent);

    final valueLabel = '${l10n.number(r.perUnit[unit])} ${unit.symbol(l10n)}';
    final refLabel = '1 ${reference.symbol(l10n)}';

    switch (r.quantity) {
      case Quantity.area:
        _paintSquares(
          canvas,
          box,
          valueExtent,
          refExtent,
          valueLabel,
          refLabel,
        );
      case Quantity.volume:
        _paintCubes(canvas, box, valueExtent, refExtent, valueLabel, refLabel);
      case Quantity.mass || Quantity.pressure:
        _paintBars(canvas, box, valueExtent, refExtent, valueLabel, refLabel);
      case Quantity.length:
        drawSchemaPlaceholder(canvas, size);
        return;
    }

    if (outOfScale) {
      _paintCaption(canvas, box, l10n.converterOutOfScale);
    }
  }

  /// Répartit [maxExtent] entre la valeur et le repère : la plus grande des
  /// deux remplit la place, l'autre suit le rapport [k].
  ///
  /// Sous [_minExtent] la petite forme serait invisible : on la relève et on
  /// rend `true` pour que l'écran le dise.
  (double, double, bool) _extents(double k, double maxExtent) {
    if (!k.isFinite || k <= 0) return (0, maxExtent, false);

    final (value, reference) = k >= 1
        ? (maxExtent, maxExtent / k)
        : (maxExtent * k, maxExtent);

    final smallest = math.min(value, reference);
    if (smallest >= _minExtent) return (value, reference, false);

    return (math.max(value, _minExtent), math.max(reference, _minExtent), true);
  }

  /// Surfaces : deux carrés posés sur la même ligne de sol, côte à côte plutôt
  /// qu'imbriqués — imbriqués, le petit se perdrait dans le grand.
  void _paintSquares(
    Canvas canvas,
    Rect box,
    double value,
    double reference,
    String valueLabel,
    String refLabel,
  ) {
    final ground = box.bottom - 16;
    final gap = box.width * 0.08;
    final totalWidth = value + reference + gap;
    var x = box.center.dx - totalWidth / 2;

    _square(
      canvas,
      Rect.fromLTWH(x, ground - value, value, value),
      filled: true,
    );
    _legend(canvas, valueLabel, x + value / 2, ground + 4, accent: true);

    x += value + gap;
    _square(
      canvas,
      Rect.fromLTWH(x, ground - reference, reference, reference),
      filled: false,
    );
    _legend(canvas, refLabel, x + reference / 2, ground + 4, accent: false);
  }

  /// Volumes : même principe, en projection oblique. Le cube dit ce que le
  /// carré ne dit pas — qu'un facteur 1000 sur le volume ne fait que 10 sur
  /// l'arête.
  void _paintCubes(
    Canvas canvas,
    Rect box,
    double value,
    double reference,
    String valueLabel,
    String refLabel,
  ) {
    final ground = box.bottom - 16;
    final gap = box.width * 0.08;
    final totalWidth = value + reference + gap;
    var x = box.center.dx - totalWidth / 2;

    _cube(canvas, x, ground, value, filled: true);
    _legend(canvas, valueLabel, x + value / 2, ground + 4, accent: true);

    x += value + gap;
    _cube(canvas, x, ground, reference, filled: false);
    _legend(canvas, refLabel, x + reference / 2, ground + 4, accent: false);
  }

  /// Masses et pressions : pas de géométrie, donc deux barres. La longueur est
  /// proportionnelle à la valeur, sans artifice.
  void _paintBars(
    Canvas canvas,
    Rect box,
    double value,
    double reference,
    String valueLabel,
    String refLabel,
  ) {
    const height = 26.0;
    final centerY = box.center.dy;

    _bar(canvas, box.left, centerY - height - 8, value, height, filled: true);
    _legend(
      canvas,
      valueLabel,
      box.left + math.max(value, 1) + 8,
      centerY - height - 8 + height / 2,
      accent: true,
      centered: false,
    );

    _bar(canvas, box.left, centerY + 8, reference, height, filled: false);
    _legend(
      canvas,
      refLabel,
      box.left + math.max(reference, 1) + 8,
      centerY + 8 + height / 2,
      accent: false,
      centered: false,
    );
  }

  void _square(Canvas canvas, Rect rect, {required bool filled}) {
    if (filled) {
      canvas.drawRect(
        rect,
        Paint()..color = AppColors.accent.withValues(alpha: 0.18),
      );
    }
    canvas.drawRect(rect, _stroke(filled));
  }

  void _cube(
    Canvas canvas,
    double left,
    double ground,
    double side, {
    required bool filled,
  }) {
    final depth = side * _cubeDepth;
    final front = Rect.fromLTWH(left, ground - side, side, side);

    // Les deux faces vues se dessinent avant la face avant : elles passent
    // derrière, et l'ordre de tracé suffit à le dire.
    final top = Path()
      ..moveTo(front.left, front.top)
      ..lineTo(front.left + depth, front.top - depth)
      ..lineTo(front.right + depth, front.top - depth)
      ..lineTo(front.right, front.top)
      ..close();
    final side_ = Path()
      ..moveTo(front.right, front.top)
      ..lineTo(front.right + depth, front.top - depth)
      ..lineTo(front.right + depth, front.bottom - depth)
      ..lineTo(front.right, front.bottom)
      ..close();

    if (filled) {
      canvas
        ..drawPath(
          top,
          Paint()..color = AppColors.accent.withValues(alpha: 0.10),
        )
        ..drawPath(
          side_,
          Paint()..color = AppColors.accent.withValues(alpha: 0.24),
        )
        ..drawRect(
          front,
          Paint()..color = AppColors.accent.withValues(alpha: 0.18),
        );
    }
    canvas
      ..drawPath(top, _stroke(filled))
      ..drawPath(side_, _stroke(filled))
      ..drawRect(front, _stroke(filled));
  }

  void _bar(
    Canvas canvas,
    double left,
    double top,
    double width,
    double height, {
    required bool filled,
  }) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, math.max(width, 1), height),
      const Radius.circular(3),
    );
    if (filled) {
      canvas.drawRRect(
        rect,
        Paint()..color = AppColors.accent.withValues(alpha: 0.18),
      );
    }
    canvas.drawRRect(rect, _stroke(filled));
  }

  /// La valeur est à l'accent, le repère au gris des libellés : lequel des
  /// deux on regarde doit se voir sans lire.
  Paint _stroke(bool isValue) => Paint()
    ..color = isValue ? AppColors.accent : AppColors.label
    ..style = PaintingStyle.stroke
    ..strokeWidth = isValue ? 1.6 : 1.2;

  void _legend(
    Canvas canvas,
    String text,
    double x,
    double y, {
    required bool accent,
    bool centered = true,
  }) {
    final painter = schemaText(
      text,
      size: 12,
      color: accent ? AppColors.accentDeep : AppColors.label,
      weight: accent ? FontWeight.w700 : FontWeight.w600,
    );
    painter.paint(
      canvas,
      Offset(centered ? x - painter.width / 2 : x, y - painter.height / 2),
    );
  }

  void _paintCaption(Canvas canvas, Rect box, String text) {
    final painter = schemaText(text, size: 10);
    painter.paint(canvas, Offset(box.left, box.top - painter.height - 2));
  }

  @override
  bool shouldRepaint(ComparisonPainter old) =>
      old.result != result ||
      old.unit != unit ||
      old.l10n.localeName != l10n.localeName;
}
