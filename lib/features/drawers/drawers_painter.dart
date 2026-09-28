import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/drawers.dart';
import '../../core/painting.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/numbers.dart';

/// Marges de la feuille. La droite de chaque vue porte ses cotes verticales,
/// le haut ses cotes de largeur, le bas la note d'unité.
const double _sideMargin = 12;
const double _topMargin = 26;
const double _bottomMargin = 22;
const double _vDimSpace = 44;

/// Place sous la vue de face pour la largeur hors tout du caisson : son
/// chiffre se pose entre le caisson et la ligne de cote.
const double _hDimSpace = 30;

/// Blanc entre les deux vues, cotes verticales de la vue de face comprises.
const double _viewGap = 20;

/// Recul de la cote de largeur au-dessus de ce qu'elle cote.
const double _hDimOffset = 10;

/// Coupe de face de la colonne, et coupe de dessus d'un tiroir, côte à côte.
///
/// Une seule échelle pour les deux vues, pour comparer profondeur et hauteur.
///
/// Ordre de tracé : ce qui est derrière le plan de coupe d'abord, puis la
/// coupe en deux passes ([_Section]), les cotes en dernier.
class DrawersPainter extends CustomPainter {
  const DrawersPainter({
    required this.result,
    required this.input,
    required this.l10n,
  });

  final DrawersResult? result;
  final DrawersInput input;
  final AppLocalizations l10n;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final r = result;
    if (r == null || r.fronts.isEmpty) {
      drawSchemaPlaceholder(canvas, size);
      return;
    }

    final face = _faceBounds(r);
    final top = _topBounds(r);

    // Trois colonnes de cotes verticales : le hors tout à gauche de la face,
    // les façades à sa droite, la longueur de caisse à droite du dessus.
    final availableWidth =
        size.width - 2 * _sideMargin - 3 * _vDimSpace - _viewGap;
    final availableHeight =
        size.height - _topMargin - _hDimSpace - _bottomMargin;
    if (availableWidth <= 0 || availableHeight <= 0) return;

    final scale = math.min(
      availableWidth / (face.width + top.width),
      availableHeight / math.max(face.height, top.height),
    );
    if (!scale.isFinite || scale <= 0) return;

    final drawnWidth =
        (face.width + top.width) * scale + 3 * _vDimSpace + _viewGap;
    final left = (size.width - drawnWidth) / 2 + _vDimSpace;
    final sheet = Offset.zero & size;

    _paintFace(
      canvas,
      r,
      bounds: face,
      topLeft: Offset(left, _topMargin),
      scale: scale,
      sheet: sheet,
    );
    _paintTop(
      canvas,
      r,
      bounds: top,
      topLeft: Offset(
        left + face.width * scale + _vDimSpace + _viewGap,
        _topMargin,
      ),
      scale: scale,
      sheet: sheet,
    );
    _paintNote(canvas, size);
  }

  /// L'étendue de la coupe de face en mm, y vers le haut : le caisson et la
  /// colonne de façades.
  Rect _faceBounds(DrawersResult r) {
    final carcass = input.carcassThickness;
    return Rect.fromLTRB(
      math.min(-carcass, r.frontLeft),
      math.min(-carcass, r.fronts.last.bottom),
      math.max(input.openingWidth + carcass, r.frontLeft + r.frontWidth),
      math.max(
        input.openingHeight + carcass,
        r.fronts.first.bottom + r.fronts.first.height,
      ),
    );
  }

  /// L'étendue de la coupe de dessus en mm, y vers le fond : les flancs et la
  /// façade.
  Rect _topBounds(DrawersResult r) {
    final t = r.topSection;
    final pieces = [...t.flanks, t.front];
    return Rect.fromLTRB(
      pieces.map((p) => p.x0).reduce(math.min),
      pieces.map((p) => p.y0).reduce(math.min),
      pieces.map((p) => p.x1).reduce(math.max),
      pieces.map((p) => p.y1).reduce(math.max),
    );
  }

  /// Coupe de face : un plan vertical au milieu de la profondeur, vu vers
  /// l'avant.
  ///
  /// En coupe, le caisson, les côtés, les fonds et les glissières. Derrière le
  /// plan, les façades, en contour seul : elles se tracent d'abord, et la coupe
  /// les recouvre là où elle passe devant.
  void _paintFace(
    Canvas canvas,
    DrawersResult r, {
    required Rect bounds,
    required Offset topLeft,
    required double scale,
    required Rect sheet,
  }) {
    double x(double mm) => topLeft.dx + (mm - bounds.left) * scale;
    double y(double mm) => topLeft.dy + (bounds.bottom - mm) * scale;
    Rect rect(double x0, double y0, double x1, double y1) =>
        Rect.fromLTRB(x(x0), y(y1), x(x1), y(y0));
    Path section(SectionRect p) =>
        Path()..addRect(rect(p.x0, p.y0, p.x1, p.y1));
    Path polygon(SectionPolygon p) => Path()
      ..addPolygon([for (final v in p.points) Offset(x(v.x), y(v.y))], true);

    final beyond = Paint()
      ..color = kSchemaInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = kDimStroke;

    for (final front in r.fronts) {
      canvas.drawRect(
        rect(
          r.frontLeft,
          front.bottom,
          r.frontLeft + r.frontWidth,
          front.bottom + front.height,
        ),
        beyond,
      );
    }

    final carcass = input.carcassThickness;
    final width = input.openingWidth;
    final height = input.openingHeight;
    final opening = rect(0, 0, width, height);
    final carcassRect = rect(
      -carcass,
      -carcass,
      width + carcass,
      height + carcass,
    );
    final cut = _Section()
      ..cut(
        Path()
          ..fillType = PathFillType.evenOdd
          ..addRect(carcassRect)
          ..addRect(opening),
      );
    for (final drawer in r.faceSections) {
      drawer.slides.map(polygon).forEach(cut.hardware);
      drawer.sides.map(polygon).forEach(cut.cut);
      cut.cut(section(drawer.bottom));
    }
    cut.paint(canvas);

    final frontsTop = r.fronts.first.bottom + r.fronts.first.height;
    drawHDimension(
      canvas,
      x1: x(r.frontLeft),
      x2: x(r.frontLeft + r.frontWidth),
      y: math.min(carcassRect.top, y(frontsTop)) - _hDimOffset,
      label: l10n.number(r.frontWidth),
      bounds: sheet,
    );

    // Le caisson hors tout, sous la vue et à gauche : le haut et la droite
    // sont aux façades.
    drawHDimension(
      canvas,
      x1: carcassRect.left,
      x2: carcassRect.right,
      y: y(bounds.top) + _hDimSpace - _hDimOffset,
      label: l10n.number(r.carcassWidth),
      bounds: sheet,
    );
    drawVDimension(
      canvas,
      y1: carcassRect.top,
      y2: carcassRect.bottom,
      x: x(bounds.left) - _hDimOffset,
      label: l10n.number(r.carcassHeight),
      labelSide: -1,
    );

    final dimX = x(bounds.right) + _hDimOffset;
    for (final front in r.fronts) {
      drawVDimension(
        canvas,
        y1: y(front.bottom + front.height),
        y2: y(front.bottom),
        x: dimX,
        label: l10n.number(front.height),
      );
    }
  }

  /// Coupe de dessus d'un tiroir dans le caisson : flancs, glissières, caisse,
  /// façade. Le fond du caisson est en haut, la façade en bas, côté
  /// utilisateur.
  void _paintTop(
    Canvas canvas,
    DrawersResult r, {
    required Rect bounds,
    required Offset topLeft,
    required double scale,
    required Rect sheet,
  }) {
    double x(double mm) => topLeft.dx + (mm - bounds.left) * scale;
    double y(double mm) => topLeft.dy + (bounds.bottom - mm) * scale;
    Path section(SectionRect p) =>
        Path()..addRect(Rect.fromLTRB(x(p.x0), y(p.y1), x(p.x1), y(p.y0)));

    final t = r.topSection;
    final cut = _Section();
    t.slides.map(section).forEach(cut.hardware);
    [...t.flanks, ...t.walls, t.front].map(section).forEach(cut.cut);
    cut.paint(canvas);

    final boxLeft = r.sideClearance;
    final near = r.boxSetback;
    drawHDimension(
      canvas,
      x1: x(boxLeft),
      x2: x(boxLeft + r.boxWidth),
      y: y(bounds.bottom) - _hDimOffset,
      label: l10n.number(r.boxWidth),
      bounds: sheet,
    );
    drawVDimension(
      canvas,
      y1: y(near + r.boxLength),
      y2: y(near),
      x: x(bounds.right) + _hDimOffset,
      label: l10n.number(r.boxLength),
    );
  }

  /// L'unité du dessin, une fois, sous les deux vues.
  void _paintNote(Canvas canvas, Size size) {
    final text = schemaText(l10n.commonUnitNote, size: 9);
    text.paint(
      canvas,
      Offset((size.width - text.width) / 2, size.height - text.height - 4),
    );
  }

  @override
  bool shouldRepaint(DrawersPainter oldDelegate) =>
      oldDelegate.result != result ||
      oldDelegate.input != input ||
      oldDelegate.l10n.localeName != l10n.localeName;
}

/// Une coupe, en deux passes : aplats, puis contours.
///
/// Pièce par pièce, un aplat rognerait le contour de la voisine. Suppose des
/// pièces qui ne se chevauchent pas.
class _Section {
  final _cuts = <Path>[];
  final _hardware = <Path>[];

  /// Une pièce coupée : matière et contour.
  void cut(Path piece) => _cuts.add(piece);

  /// Une glissière : aplat gris, contour comme la matière.
  void hardware(Path piece) => _hardware.add(piece);

  void paint(Canvas canvas) {
    final fill = Paint()..color = AppColors.field;
    final slide = Paint()..color = kExtensionLine;
    final outline = Paint()
      ..color = kSchemaInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = kOutlineStroke;
    for (final piece in _hardware) {
      canvas.drawPath(piece, slide);
    }
    for (final piece in _cuts) {
      canvas.drawPath(piece, fill);
    }
    for (final piece in [..._hardware, ..._cuts]) {
      canvas.drawPath(piece, outline);
    }
  }
}

/// Le remplissage et le contour d'une pièce de pictogramme.
///
/// Pièces blanches, pour que les jonctions se lisent. La sélection se voit au
/// contour plus foncé et plus épais.
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
