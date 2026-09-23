import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/layout.dart';
import '../../core/format.dart';
import '../../core/painting.dart';

/// Marges autour de la surface : de la place pour les cotes, à gauche et en
/// haut, et un filet ailleurs.
const double _leftMargin = 46;
const double _topMargin = 26;
const double _rightMargin = 14;
const double _bottomMargin = 14;

/// Marge de la vignette, où il n'y a plus de cote à loger : juste de quoi ne
/// pas coller le contour de la surface au bord de la feuille.
const double _compactMargin = 8;

/// Au-delà, on cesse de cerner chaque élément : à cette densité les filets se
/// touchent et forment un aplat, et le dessin coûte cher pour rien.
const int _strokeBudget = 1500;

/// Vue de dessus : grille d'éléments, décalage de joints visible d'une rangée
/// à l'autre, éléments de bord dessinés comme des coupes (orange).
///
/// Toute la géométrie vient de [LayoutResult.elements] — aucun calcul ici.
/// Le painter ne fait que mettre la surface à l'échelle du canvas et recopier
/// les rectangles que le cœur a posés, `isCut` compris.
class LayoutPainter extends CustomPainter {
  const LayoutPainter({
    required this.result,
    required this.input,
    this.compact = false,
  });

  final LayoutResult? result;

  /// Vignette : sans les deux cotes, la surface récupère les 46 px de marge
  /// gauche et les 26 du haut. À 200 px de haut, c'est un quart du dessin —
  /// et les cotes sont déjà dans les champs, juste au-dessus.
  final bool compact;

  /// Les cotes de la surface : [LayoutResult] n'expose que son aire, dont X et
  /// Y ne se déduisent pas.
  final LayoutInput input;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final r = result;
    if (r == null) {
      drawSchemaPlaceholder(canvas, size);
      return;
    }

    final leftMargin = compact ? _compactMargin : _leftMargin;
    final topMargin = compact ? _compactMargin : _topMargin;
    final rightMargin = compact ? _compactMargin : _rightMargin;
    final bottomMargin = compact ? _compactMargin : _bottomMargin;

    final availableWidth = size.width - leftMargin - rightMargin;
    final availableHeight = size.height - topMargin - bottomMargin;
    if (availableWidth <= 0 || availableHeight <= 0) return;

    // Échelle uniforme : un calepinage déformé ne veut rien dire, on doit
    // pouvoir juger la proportion des lames à l'œil.
    final scale = math.min(
      availableWidth / input.surfaceX,
      availableHeight / input.surfaceY,
    );
    if (!scale.isFinite || scale <= 0) return;

    final drawnWidth = input.surfaceX * scale;
    final drawnHeight = input.surfaceY * scale;
    final origin = Offset(
      leftMargin + (availableWidth - drawnWidth) / 2,
      topMargin + (availableHeight - drawnHeight) / 2,
    );

    _paintSurface(canvas, origin, drawnWidth, drawnHeight);
    _paintElements(canvas, r, origin, scale);
    _paintSurfaceOutline(canvas, origin, drawnWidth, drawnHeight);
    if (!compact) _paintDimensions(canvas, origin, drawnWidth, drawnHeight);
  }

  /// Le fond de la surface — ce qui reste visible là où aucun élément ne
  /// tombe, donc un vide : il prend la couleur de la feuille, comme les
  /// perçages des Avant-trous.
  void _paintSurface(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    canvas.drawRect(
      origin & Size(width, height),
      Paint()..color = AppColors.cardSurface,
    );
  }

  void _paintElements(
    Canvas canvas,
    LayoutResult r,
    Offset origin,
    double scale,
  ) {
    final stroked = r.elements.length <= _strokeBudget;

    // Beige et non blanc : c'est de la matière posée sur la surface, et sur
    // une feuille blanche un élément blanc ne se lirait plus que par ses
    // joints — le découvert et le couvert se confondraient.
    final fullFill = Paint()..color = AppColors.field;
    final cutFill = Paint()..color = AppColors.cut.withValues(alpha: 0.3);

    // **Un seul trait de joint, quel que soit le remplissage.** Cerner les
    // coupes en orange sur un fond orange revenait à les effacer : sur une
    // rangée entièrement rabotée — donc entièrement en coupe — la trame des
    // joints disparaissait, et avec elle le décalage d'une rangée à l'autre.
    // C'est le remplissage qui dit « à couper », pas le trait.
    final seam = Paint()
      ..color = AppColors.label.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final element in r.elements) {
      final rect = Rect.fromLTWH(
        origin.dx + element.x * scale,
        origin.dy + element.y * scale,
        element.w * scale,
        element.h * scale,
      );
      canvas.drawRect(rect, element.isCut ? cutFill : fullFill);
      if (stroked) canvas.drawRect(rect, seam);
    }
  }

  /// Tracé après les éléments : le contour de la surface doit rester net même
  /// là où une pièce de bord affleure.
  void _paintSurfaceOutline(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    canvas.drawRect(
      origin & Size(width, height),
      Paint()
        ..color = AppColors.label
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  /// Les deux cotes de la surface : largeur au-dessus, longueur à gauche.
  void _paintDimensions(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
  ) {
    final dimY = origin.dy - 14;
    drawExtensionLine(
      canvas,
      Offset(origin.dx, origin.dy),
      Offset(origin.dx, dimY),
    );
    drawExtensionLine(
      canvas,
      Offset(origin.dx + width, origin.dy),
      Offset(origin.dx + width, dimY),
    );
    drawHDimension(
      canvas,
      x1: origin.dx,
      x2: origin.dx + width,
      y: dimY,
      label: '${formatNumber(input.surfaceX)} mm',
    );

    final dimX = origin.dx - 12;
    drawExtensionLine(
      canvas,
      Offset(origin.dx, origin.dy),
      Offset(dimX, origin.dy),
    );
    drawExtensionLine(
      canvas,
      Offset(origin.dx, origin.dy + height),
      Offset(dimX, origin.dy + height),
    );
    drawVDimension(
      canvas,
      y1: origin.dy,
      y2: origin.dy + height,
      x: dimX,
      label: '${formatNumber(input.surfaceY)} mm',
      labelSide: -1,
    );
  }

  @override
  bool shouldRepaint(LayoutPainter old) =>
      old.result != result || old.input != input || old.compact != compact;
}
