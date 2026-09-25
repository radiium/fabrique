import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/drawers.dart';
import '../../core/format.dart';
import '../../core/painting.dart';

/// Marges de la feuille. La droite de chaque vue porte ses cotes verticales,
/// le haut ses cotes de largeur, le bas la note d'unité.
const double _sideMargin = 12;
const double _topMargin = 26;
const double _bottomMargin = 22;
const double _vDimSpace = 44;

/// Blanc entre les deux vues, cotes verticales de la vue de face comprises.
const double _viewGap = 20;

/// Recul de la cote de largeur au-dessus de ce qu'elle cote.
const double _hDimOffset = 10;

/// Hauteur de profil dessinée d'une glissière latérale, en mm : un ordre de
/// grandeur pour la reconnaître, pas une cote.
const double _slideProfileMm = 35;

/// Largeur dessinée d'une glissière sous tiroir, depuis le flanc, en mm.
const double _undermountReachMm = 30;

/// Coupe de face de la colonne, et coupe de dessus d'un tiroir, côte à côte.
///
/// Une seule échelle pour les deux vues : la coupe se lit à côté de la face,
/// et une profondeur tracée plus grande qu'une hauteur mentirait.
///
/// Ordre de tracé : l'ouverture en gris d'abord (la référence), les pièces
/// par-dessus, les cotes en dernier.
class DrawersPainter extends CustomPainter {
  const DrawersPainter({required this.result, required this.input});

  final DrawersResult? result;
  final DrawersInput input;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final r = result;
    if (r == null || r.fronts.isEmpty) {
      drawSchemaPlaceholder(canvas, size);
      return;
    }

    final carcass = input.carcassThickness;
    final faceLow = math.min(
      -carcass,
      r.fronts.map((f) => f.bottom).reduce(math.min),
    );
    final faceHigh = math.max(
      input.openingHeight + carcass,
      r.fronts.map((f) => f.bottom + f.height).reduce(math.max),
    );
    final faceWidthMm = math.max(
      input.openingWidth + 2 * carcass,
      r.frontWidth,
    );
    final faceHeightMm = faceHigh - faceLow;

    final frontDepth = input.frontMount == FrontMount.overlay
        ? input.frontThickness
        : 0.0;
    final topWidthMm = input.openingWidth + 2 * input.carcassThickness;
    final topHeightMm = input.openingDepth + frontDepth;

    final availableWidth =
        size.width - 2 * _sideMargin - 2 * _vDimSpace - _viewGap;
    final availableHeight = size.height - _topMargin - _bottomMargin;
    if (availableWidth <= 0 || availableHeight <= 0) return;

    final scale = math.min(
      availableWidth / (faceWidthMm + topWidthMm),
      availableHeight / math.max(faceHeightMm, topHeightMm),
    );
    if (!scale.isFinite || scale <= 0) return;

    final drawnWidth =
        (faceWidthMm + topWidthMm) * scale + 2 * _vDimSpace + _viewGap;
    final left = (size.width - drawnWidth) / 2;
    const top = _topMargin;
    final sheet = Offset.zero & size;

    _paintFace(
      canvas,
      r,
      origin: Offset(left, top + (faceHigh - faceLow) * scale),
      faceLow: faceLow,
      faceWidthMm: faceWidthMm,
      scale: scale,
      sheet: sheet,
    );
    _paintTop(
      canvas,
      r,
      origin: Offset(left + faceWidthMm * scale + _vDimSpace + _viewGap, top),
      frontDepth: frontDepth,
      scale: scale,
      sheet: sheet,
    );
    _paintNote(canvas, size);
  }

  /// Coupe de face : un plan vertical au milieu de la profondeur, vu vers
  /// l'avant.
  ///
  /// En coupe, le caisson, les côtés, les fonds et les glissières. Derrière le
  /// plan, les façades, en contour seul : elles se tracent d'abord, et la coupe
  /// les recouvre là où elle passe devant.
  ///
  /// [origin] est le coin bas gauche de la vue, au plus bas du dessin.
  void _paintFace(
    Canvas canvas,
    DrawersResult r, {
    required Offset origin,
    required double faceLow,
    required double faceWidthMm,
    required double scale,
    required Rect sheet,
  }) {
    // L'origine des millimètres est le coin bas gauche de l'ouverture.
    final openingLeft = (faceWidthMm - input.openingWidth) / 2;
    double x(double mm) => origin.dx + (openingLeft + mm) * scale;
    double y(double mm) => origin.dy - (mm - faceLow) * scale;
    Rect rect(double left, double bottom, double right, double top) =>
        Rect.fromLTRB(x(left), y(top), x(right), y(bottom));

    final carcass = input.carcassThickness;
    final width = input.openingWidth;
    final frontLeft = (width - r.frontWidth) / 2;

    final fill = Paint()..color = AppColors.field;
    final outline = Paint()
      ..color = kSchemaInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = kOutlineStroke;
    final beyond = Paint()
      ..color = kSchemaInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = kDimStroke;
    void cut(Rect piece) => canvas
      ..drawRect(piece, fill)
      ..drawRect(piece, outline);

    for (final front in r.fronts) {
      canvas.drawRect(
        rect(
          frontLeft,
          front.bottom,
          frontLeft + r.frontWidth,
          front.bottom + front.height,
        ),
        beyond,
      );
    }

    final opening = rect(0, 0, width, input.openingHeight);
    final carcassRect = rect(
      -carcass,
      -carcass,
      width + carcass,
      input.openingHeight + carcass,
    );
    canvas
      ..drawPath(
        Path()
          ..fillType = PathFillType.evenOdd
          ..addRect(carcassRect)
          ..addRect(opening),
        fill,
      )
      ..drawRect(carcassRect, outline)
      ..drawRect(opening, outline);

    final side = input.sideThickness;
    final bottom = input.bottomThickness;
    final boxLeft = r.sideClearance;
    final boxRight = boxLeft + r.boxWidth;
    final recess = slideSpecFor(input).bottomRecess;
    final mount = recess == null ? input.bottomMount : BottomMount.between;
    final slidePaint = Paint()..color = kExtensionLine;

    for (var i = 0; i < r.boxBottoms.length; i++) {
      final low = r.boxBottoms[i];
      final high = low + r.boxHeights[i];
      final floor = low + r.bottomLift;

      // Les glissières d'abord : la caisse passe devant celles qui la
      // débordent.
      if (r.slideLength != null && i < r.slideAxes.length) {
        final axis = r.slideAxes[i];
        for (final (from, to)
            in recess == null
                ? [(0.0, boxLeft), (boxRight, width)]
                : [
                    (0.0, boxLeft + side + _undermountReachMm),
                    (boxRight - side - _undermountReachMm, width),
                  ]) {
          canvas.drawRect(
            recess == null
                ? rect(
                    from,
                    axis - _slideProfileMm / 2,
                    to,
                    axis + _slideProfileMm / 2,
                  )
                : rect(from, low, to, floor),
            slidePaint,
          );
        }
      }

      final sidesFrom = mount == BottomMount.underneath ? low + bottom : low;
      cut(rect(boxLeft, sidesFrom, boxLeft + side, high));
      cut(rect(boxRight - side, sidesFrom, boxRight, high));

      // Le fond après les côtés : en rainure, il passe par-dessus eux.
      cut(switch (mount) {
        BottomMount.groove => rect(
          boxLeft + side - input.grooveDepth,
          floor,
          boxRight - side + input.grooveDepth,
          floor + bottom,
        ),
        BottomMount.between => rect(
          boxLeft + side,
          floor,
          boxRight - side,
          floor + bottom,
        ),
        BottomMount.underneath => rect(boxLeft, low, boxRight, low + bottom),
      });
    }

    final top = math.min(carcassRect.top, y(_frontsTop(r)));
    drawHDimension(
      canvas,
      x1: x(frontLeft),
      x2: x(frontLeft + r.frontWidth),
      y: top - _hDimOffset,
      label: formatNumber(r.frontWidth),
      bounds: sheet,
    );

    final dimX = origin.dx + faceWidthMm * scale + _hDimOffset;
    for (final front in r.fronts) {
      drawVDimension(
        canvas,
        y1: y(front.bottom + front.height),
        y2: y(front.bottom),
        x: dimX,
        label: formatNumber(front.height),
      );
    }
  }

  static double _frontsTop(DrawersResult r) =>
      r.fronts.map((f) => f.bottom + f.height).reduce(math.max);

  /// Coupe de dessus d'un tiroir dans le caisson : flancs, glissières, caisse,
  /// façade.
  ///
  /// [origin] est le coin haut gauche de la vue, au fond du caisson ; la
  /// façade est en bas, côté utilisateur.
  void _paintTop(
    Canvas canvas,
    DrawersResult r, {
    required Offset origin,
    required double frontDepth,
    required double scale,
    required Rect sheet,
  }) {
    final carcass = input.carcassThickness;
    final depth = input.openingDepth;
    double x(double mm) => origin.dx + mm * scale;
    double y(double mm) => origin.dy + mm * scale;

    final outline = Paint()
      ..color = kSchemaInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = kOutlineStroke;
    final fill = Paint()..color = AppColors.field;

    // Les flancs du caisson, coupés.
    for (final flankLeft in [0.0, carcass + input.openingWidth]) {
      final rect = Rect.fromLTRB(
        x(flankLeft),
        y(0),
        x(flankLeft + carcass),
        y(depth),
      );
      canvas
        ..drawRect(rect, fill)
        ..drawRect(rect, outline);
    }

    // La caisse, parois comprises, posée depuis le chant.
    final boxLeft = carcass + r.sideClearance;
    final boxFront = depth - r.boxSetback;
    final boxRect = Rect.fromLTRB(
      x(boxLeft),
      y(boxFront - r.boxLength),
      x(boxLeft + r.boxWidth),
      y(boxFront),
    );
    final wall = input.sideThickness * scale;
    canvas
      ..drawRect(boxRect, fill)
      ..drawRect(boxRect.deflate(wall), Paint()..color = AppColors.cardSurface)
      ..drawRect(boxRect, outline)
      ..drawRect(boxRect.deflate(wall), outline);

    // Les glissières, dans le jeu entre flanc et caisse.
    if (r.slideLength case final slide?) {
      final slidePaint = Paint()..color = kExtensionLine;
      for (final slideLeft in [carcass, boxLeft + r.boxWidth]) {
        canvas.drawRect(
          Rect.fromLTRB(
            x(slideLeft),
            y(boxFront - slide),
            x(slideLeft + r.sideClearance),
            y(boxFront),
          ),
          slidePaint,
        );
      }
    }

    // La façade, devant la caisse.
    final frontLeft = carcass + (input.openingWidth - r.frontWidth) / 2;
    final frontRect = Rect.fromLTRB(
      x(frontLeft),
      y(boxFront),
      x(frontLeft + r.frontWidth),
      y(boxFront + (frontDepth > 0 ? frontDepth : r.boxSetback)),
    );
    canvas
      ..drawRect(frontRect, fill)
      ..drawRect(frontRect, outline);

    drawHDimension(
      canvas,
      x1: x(boxLeft),
      x2: x(boxLeft + r.boxWidth),
      y: y(0) - _hDimOffset,
      label: formatNumber(r.boxWidth),
      bounds: sheet,
    );
    drawVDimension(
      canvas,
      y1: y(boxFront - r.boxLength),
      y2: y(boxFront),
      x: x(2 * carcass + input.openingWidth) + _hDimOffset,
      label: formatNumber(r.boxLength),
    );
  }

  /// L'unité du dessin, une fois, sous les deux vues.
  void _paintNote(Canvas canvas, Size size) {
    final text = schemaText(kUnitNote, size: 9);
    text.paint(
      canvas,
      Offset((size.width - text.width) / 2, size.height - text.height - 4),
    );
  }

  @override
  bool shouldRepaint(DrawersPainter oldDelegate) =>
      oldDelegate.result != result || oldDelegate.input != input;
}

/// Le remplissage et le contour d'une pièce de pictogramme.
///
/// Pièces blanches dans les deux états : ce que le dessin montre, ce sont les
/// jonctions, et un aplat teinté les noyait sous le contour. La sélection se
/// lit par la tuile (fond et bordure) et par un contour plus foncé et plus
/// épais.
(Paint, Paint) _pictogramPaints({required bool selected}) => (
  Paint()..color = AppColors.cardSurface,
  Paint()
    ..color = selected ? AppColors.accentDeep : AppColors.label
    ..style = PaintingStyle.stroke
    ..strokeWidth = selected ? 1.5 : 1,
);

/// Pose les pièces d'un pictogramme centré de [width] × [height].
void _paintPictogram(
  Canvas canvas,
  Size size, {
  required double width,
  required double height,
  required List<Rect> pieces,
  required bool selected,
}) {
  if (size.width < width || size.height < height) return;
  final (fill, outline) = _pictogramPaints(selected: selected);
  final origin = Offset((size.width - width) / 2, (size.height - height) / 2);
  for (final piece in pieces) {
    final rect = piece.shift(origin);
    canvas
      ..drawRect(rect, fill)
      ..drawRect(rect, outline);
  }
}

/// La caisse vue de dessus, chaque pièce détachée : on voit laquelle court
/// d'un bout à l'autre.
class BoxJointPreviewPainter extends CustomPainter {
  const BoxJointPreviewPainter({required this.joint, required this.selected});

  final BoxJoint joint;
  final bool selected;

  static const double _width = 48;
  static const double _height = 26;
  static const double _wall = 5;

  @override
  void paint(Canvas canvas, Size size) {
    const w = _width;
    const h = _height;
    const t = _wall;
    final pieces = switch (joint) {
      BoxJoint.sidesOverlap => const [
        Rect.fromLTWH(0, 0, t, h),
        Rect.fromLTWH(w - t, 0, t, h),
        Rect.fromLTWH(t, 0, w - 2 * t, t),
        Rect.fromLTWH(t, h - t, w - 2 * t, t),
      ],
      BoxJoint.frontBackOverlap => const [
        Rect.fromLTWH(0, 0, w, t),
        Rect.fromLTWH(0, h - t, w, t),
        Rect.fromLTWH(0, t, t, h - 2 * t),
        Rect.fromLTWH(w - t, t, t, h - 2 * t),
      ],
    };
    _paintPictogram(
      canvas,
      size,
      width: w,
      height: h,
      pieces: pieces,
      selected: selected,
    );
  }

  @override
  bool shouldRepaint(BoxJointPreviewPainter old) =>
      old.joint != joint || old.selected != selected;
}

/// La caisse en coupe : deux côtés, et le fond pris dans leur rainure, posé
/// entre eux ou dessous.
class BottomMountPreviewPainter extends CustomPainter {
  const BottomMountPreviewPainter({
    required this.mount,
    required this.selected,
  });

  final BottomMount mount;
  final bool selected;

  static const double _width = 48;
  static const double _height = 24;
  static const double _wall = 5;
  static const double _bottom = 3;

  /// Ce que le fond entre dans chaque côté, et sa hauteur au-dessus de l'arête.
  static const double _groove = 2;
  static const double _grooveLift = 3;

  @override
  void paint(Canvas canvas, Size size) {
    const w = _width;
    const h = _height;
    const t = _wall;
    const b = _bottom;
    final pieces = switch (mount) {
      // Le fond après les côtés : il passe par-dessus, dans la rainure.
      BottomMount.groove => const [
        Rect.fromLTWH(0, 0, t, h),
        Rect.fromLTWH(w - t, 0, t, h),
        Rect.fromLTWH(
          t - _groove,
          h - _grooveLift - b,
          w - 2 * t + 2 * _groove,
          b,
        ),
      ],
      BottomMount.between => const [
        Rect.fromLTWH(0, 0, t, h),
        Rect.fromLTWH(w - t, 0, t, h),
        Rect.fromLTWH(t, h - b, w - 2 * t, b),
      ],
      BottomMount.underneath => const [
        Rect.fromLTWH(0, 0, t, h - b),
        Rect.fromLTWH(w - t, 0, t, h - b),
        Rect.fromLTWH(0, h - b, w, b),
      ],
    };
    _paintPictogram(
      canvas,
      size,
      width: w,
      height: h,
      pieces: pieces,
      selected: selected,
    );
  }

  @override
  bool shouldRepaint(BottomMountPreviewPainter old) =>
      old.mount != mount || old.selected != selected;
}
