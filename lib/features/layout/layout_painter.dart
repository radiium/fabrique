import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/layout.dart';
import '../../core/format.dart';
import '../../core/painting.dart';

/// Marges autour de la surface : de la place pour les cotes, à gauche et en
/// haut, et un filet ailleurs.
const double _leftMargin = 46;
const double _topMargin = 32;
const double _rightMargin = 14;

/// Le bas porte la note d'unité, sous le dessin.
const double _bottomMargin = 28;

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
    _paintPerimeter(canvas, origin, drawnWidth, drawnHeight, scale);
    _paintElements(canvas, r, origin, scale);
    _paintSurfaceOutline(canvas, origin, drawnWidth, drawnHeight);
    if (!compact) {
      _paintDimensions(canvas, origin, drawnWidth, drawnHeight);
      _paintNote(canvas, size);
    }
  }

  /// Le fond de la surface — ce qui reste visible là où aucun élément ne
  /// tombe, donc un vide : il prend la couleur de la feuille.
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

  /// Le jeu périphérique, hachuré : réservé, jamais garni.
  ///
  /// Même hachure que les marges de la Répartition, et pour la même raison —
  /// c'est de la surface qu'on a décidé de ne pas couvrir, pas de la matière.
  void _paintPerimeter(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
    double scale,
  ) {
    final band = input.perimeterGap * scale;
    if (band <= 0) return;

    final outer = origin & Size(width, height);
    final inner = outer.deflate(band);
    if (inner.isEmpty) return;

    final paint = Paint()
      ..color = kExtensionLine
      ..strokeWidth = kDimStroke;

    canvas
      ..save()
      ..clipPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(outer),
          Path()..addRect(inner),
        ),
      );
    // Hachures à 45°, posées large puis détourées par le clip.
    for (var x = outer.left - outer.height; x < outer.right; x += 6) {
      canvas.drawLine(
        Offset(x, outer.bottom),
        Offset(x + outer.height, outer.top),
        paint,
      );
    }
    canvas.restore();
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
      ..color = kExtensionLine
      ..style = PaintingStyle.stroke
      ..strokeWidth = kDimStroke;

    final rects = [
      for (final element in r.elements)
        Rect.fromLTWH(
          origin.dx + element.x * scale,
          origin.dy + element.y * scale,
          element.w * scale,
          element.h * scale,
        ),
    ];

    // Deux passes : un joint est centré sur l'arête, et l'aplat de l'élément
    // voisin, posé après lui, en mangerait la moitié.
    for (final (i, element) in r.elements.indexed) {
      canvas.drawRect(rects[i], element.isCut ? cutFill : fullFill);
    }
    if (!stroked) return;
    for (final rect in rects) {
      canvas.drawRect(rect, seam);
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
        ..color = kSchemaInk
        ..style = PaintingStyle.stroke
        ..strokeWidth = kOutlineStroke,
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
    for (final x in [origin.dx, origin.dx + width]) {
      drawExtensionLine(
        canvas,
        Offset(x, origin.dy - kExtensionGap),
        Offset(x, dimY - kExtensionOvershoot),
      );
    }
    drawHDimension(
      canvas,
      x1: origin.dx,
      x2: origin.dx + width,
      y: dimY,
      label: formatNumber(input.surfaceX),
      ticks: false,
    );

    final dimX = origin.dx - 12;
    for (final y in [origin.dy, origin.dy + height]) {
      drawExtensionLine(
        canvas,
        Offset(origin.dx - kExtensionGap, y),
        Offset(dimX - kExtensionOvershoot, y),
      );
    }
    drawVDimension(
      canvas,
      y1: origin.dy,
      y2: origin.dy + height,
      x: dimX,
      label: formatNumber(input.surfaceY),
      labelSide: -1,
      ticks: false,
    );
  }

  /// L'unité du dessin, une fois, sous la surface.
  void _paintNote(Canvas canvas, Size size) {
    final text = schemaText(kUnitNote, size: 9);
    text.paint(
      canvas,
      Offset((size.width - text.width) / 2, size.height - text.height - 4),
    );
  }

  @override
  bool shouldRepaint(LayoutPainter old) =>
      old.result != result || old.input != input || old.compact != compact;
}
