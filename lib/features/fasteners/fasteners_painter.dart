import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/fasteners.dart';
import '../../core/format.dart';
import '../../core/painting.dart';

/// Marges. La droite est large : c'est là que s'empilent les cotes verticales.
const double _leftMargin = 16;
const double _rightMargin = 128;
const double _topMargin = 58;
const double _bottomMargin = 18;

/// Marge de la vignette, où plus aucune cote n'est posée autour du dessin.
const double _compactMargin = 12;

/// Largeur des pièces dessinées, en multiples du Ø de lamage — assez de matière
/// autour du perçage pour que la coupe se lise comme une coupe.
const double _pieceWidthFactor = 7;

/// Épaisseur de support dessinée sous la pointe de la vis, en multiples de la
/// pénétration : il doit rester de la matière visible sous le trou.
const double _supportFactor = 1.45;

/// Coupe des deux pièces vissées : trou de passage, guidage, lamage,
/// pénétration.
///
/// Les trois perçages sont concentriques et de diamètres croissants vers le
/// haut ; les trois cotes de Ø s'empilent donc au-dessus du dessin, où leurs
/// largeurs respectives rendent l'emboîtement lisible sans ligne d'attache.
///
/// L'invariant `pilotHole < clearanceHole < counterboreDia` garanti par
/// `core/calc` est ce qui rend ce dessin toujours cohérent.
class FastenersPainter extends CustomPainter {
  const FastenersPainter({
    required this.result,
    required this.input,
    this.compact = false,
  });

  final FastenerResult? result;
  final FastenerInput input;

  /// Vignette : la coupe seule. Les cotes prennent 128 px à droite et 58 en
  /// haut, soit plus de la moitié de la largeur d'une vignette — et les trois
  /// Ø sont déjà dans les tuiles de résultat, sous le schéma.
  final bool compact;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final r = result;
    if (r == null) {
      drawSchemaPlaceholder(canvas, size);
      return;
    }

    final thickness = input.fixedThickness;
    final support = r.penetration * _supportFactor;
    final pieceWidth = r.counterboreDia * _pieceWidthFactor;
    final totalHeight = thickness + support;

    final leftMargin = compact ? _compactMargin : _leftMargin;
    final rightMargin = compact ? _compactMargin : _rightMargin;
    final topMargin = compact ? _compactMargin : _topMargin;
    final bottomMargin = compact ? _compactMargin : _bottomMargin;

    final availableWidth = size.width - leftMargin - rightMargin;
    final availableHeight = size.height - topMargin - bottomMargin;
    if (availableWidth <= 0 || availableHeight <= 0) return;

    // Échelle uniforme : une coupe dont les Ø et les épaisseurs ne sont pas au
    // même rapport induirait en erreur sur la profondeur de pénétration.
    final scale = math.min(
      availableWidth / pieceWidth,
      availableHeight / totalHeight,
    );
    if (!scale.isFinite || scale <= 0) return;

    final drawnWidth = pieceWidth * scale;
    final drawnHeight = totalHeight * scale;
    final left = leftMargin + (availableWidth - drawnWidth) / 2;
    final top = topMargin + (availableHeight - drawnHeight) / 2;
    final centerX = left + drawnWidth / 2;
    final joint = top + thickness * scale;

    double halfOf(double diameter) => diameter * scale / 2;

    _paintPieces(canvas, left, drawnWidth, top, joint, drawnHeight);
    _paintHoles(canvas, r, centerX, top, joint, scale, halfOf);
    _paintScrew(canvas, r, centerX, top, scale, halfOf);
    _paintJoint(canvas, left, drawnWidth, joint);
    if (compact) return;
    _paintDiameters(canvas, r, centerX, top, halfOf);
    _paintHeights(canvas, r, left + drawnWidth, top, joint, scale);
  }

  /// Les deux pièces en coupe : celle à fixer au-dessus, le support en dessous.
  void _paintPieces(
    Canvas canvas,
    double left,
    double width,
    double top,
    double joint,
    double height,
  ) {
    // Le beige des champs, et non le blanc : la feuille du schéma est blanche,
    // une pièce blanche dessus ne se distinguerait que par son filet.
    final fill = Paint()..color = AppColors.field;
    final stroke = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final rect in [
      Rect.fromLTRB(left, top, left + width, joint),
      Rect.fromLTRB(left, joint, left + width, top + height),
    ]) {
      canvas
        ..drawRect(rect, fill)
        ..drawRect(rect, stroke);
    }
  }

  /// Les perçages, évidés à la couleur de la feuille : ce sont des vides, pas
  /// des pièces. Lamage et passage traversent la pièce du haut, le guidage s'arrête
  /// à la pénétration.
  void _paintHoles(
    Canvas canvas,
    FastenerResult r,
    double centerX,
    double top,
    double joint,
    double scale,
    double Function(double) halfOf,
  ) {
    final void_ = Paint()..color = AppColors.cardSurface;
    final edge = Paint()
      ..color = AppColors.label.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final holes = [
      // Lamage : du dessus jusqu'à la profondeur de tête.
      Rect.fromLTRB(
        centerX - halfOf(r.counterboreDia),
        top,
        centerX + halfOf(r.counterboreDia),
        top + r.counterboreDepth * scale,
      ),
      // Passage : du fond du lamage jusqu'au joint.
      Rect.fromLTRB(
        centerX - halfOf(r.clearanceHole),
        top + r.counterboreDepth * scale,
        centerX + halfOf(r.clearanceHole),
        joint,
      ),
      // Guidage : dans le support, sur la pénétration.
      Rect.fromLTRB(
        centerX - halfOf(r.pilotHole),
        joint,
        centerX + halfOf(r.pilotHole),
        joint + r.penetration * scale,
      ),
    ];

    for (final hole in holes) {
      canvas
        ..drawRect(hole, void_)
        ..drawRect(hole, edge);
    }
  }

  /// La vis, en trait d'accent et remplissage léger : on doit voir *à travers*
  /// le jeu entre le fût et le trou de passage — c'est tout l'intérêt d'un trou
  /// de passage, et ça ne se lit que si la vis ne bouche pas le dessin.
  void _paintScrew(
    Canvas canvas,
    FastenerResult r,
    double centerX,
    double top,
    double scale,
    double Function(double) halfOf,
  ) {
    final headBottom = top + r.counterboreDepth * scale;
    final tip = top + r.screwLength * scale;
    final shank = halfOf(input.screwDiameter);

    final path = Path()
      ..moveTo(centerX - halfOf(r.counterboreDia), top)
      ..lineTo(centerX + halfOf(r.counterboreDia), top)
      ..lineTo(centerX + halfOf(r.counterboreDia), headBottom)
      ..lineTo(centerX + shank, headBottom)
      // Pointe : les deux derniers diamètres de la vis.
      ..lineTo(centerX + shank, tip - shank * 2)
      ..lineTo(centerX, tip)
      ..lineTo(centerX - shank, tip - shank * 2)
      ..lineTo(centerX - shank, headBottom)
      ..lineTo(centerX - halfOf(r.counterboreDia), headBottom)
      ..close();

    canvas
      ..drawPath(path, Paint()..color = AppColors.accent.withValues(alpha: 0.2))
      ..drawPath(
        path,
        Paint()
          ..color = AppColors.accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4,
      );
  }

  /// Le plan de joint entre les deux pièces.
  void _paintJoint(Canvas canvas, double left, double width, double joint) {
    canvas.drawLine(
      Offset(left, joint),
      Offset(left + width, joint),
      Paint()
        ..color = AppColors.label
        ..strokeWidth = 1.5,
    );
  }

  /// Les trois Ø, empilés au-dessus du dessin. Du plus large en haut au plus
  /// étroit en bas : l'emboîtement se lit dans les largeurs elles-mêmes.
  void _paintDiameters(
    Canvas canvas,
    FastenerResult r,
    double centerX,
    double top,
    double Function(double) halfOf,
  ) {
    final rows = [
      (r.counterboreDia, 'Ø ${formatNumber(r.counterboreDia)}'),
      (r.clearanceHole, 'Ø ${formatNumber(r.clearanceHole)}'),
      (r.pilotHole, 'Ø ${formatNumber(r.pilotHole)}'),
    ];

    for (final (i, (diameter, label)) in rows.indexed) {
      final y = top - 44 + i * 15;
      final half = halfOf(diameter);
      final placed = drawHDimension(
        canvas,
        x1: centerX - half,
        x2: centerX + half,
        y: y,
        label: label,
      );
      // Cote trop étroite pour son chiffre : on le pose à droite plutôt que de
      // le perdre — c'est la valeur que l'utilisateur vient chercher.
      if (!placed) {
        schemaText(label).paint(canvas, Offset(centerX + half + 6, y - 6));
      }
    }
  }

  /// Épaisseur, pénétration et longueur de vis, en colonnes à droite.
  void _paintHeights(
    Canvas canvas,
    FastenerResult r,
    double right,
    double top,
    double joint,
    double scale,
  ) {
    final first = right + 14;
    final second = first + 62;

    drawVDimension(
      canvas,
      y1: top,
      y2: joint,
      x: first,
      label: formatNumber(input.fixedThickness),
    );
    drawVDimension(
      canvas,
      y1: joint,
      y2: joint + r.penetration * scale,
      x: first,
      label: formatNumber(r.penetration),
    );
    drawVDimension(
      canvas,
      y1: top,
      y2: top + r.screwLength * scale,
      x: second,
      label: formatNumber(r.screwLength),
      color: AppColors.accent,
    );
  }

  @override
  bool shouldRepaint(FastenersPainter old) =>
      old.result != result || old.input != input || old.compact != compact;
}
