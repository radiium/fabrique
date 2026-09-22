/// Primitives de cotation partagées par les painters.
///
/// Les cinq schémas dessinent tous les mêmes choses — du texte tabulaire, des
/// flèches, des lignes de cote détourées. Sans ce fichier, chaque painter
/// recopierait sa propre version et les schémas finiraient par ne plus se
/// ressembler.
///
/// Rien ici ne calcule : ce sont des primitives de rendu, elles reçoivent des
/// pixels déjà mis à l'échelle.
library;

import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'format.dart';

/// Longueur des branches d'une flèche de cote.
const double kArrowArm = 5;

/// Demi-longueur d'un tiret d'extrémité de cote.
const double kDimTick = 4;

/// Épaisseur d'un trait de cote.
const double kDimStroke = 1;

/// Texte de schéma : chiffres tabulaires, comme partout ailleurs dans l'app.
TextPainter schemaText(
  String value, {
  double size = 11,
  Color color = AppColors.label,
  FontWeight weight = FontWeight.w600,
}) => TextPainter(
  text: TextSpan(
    text: value,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontWeight: weight,
      fontFeatures: const [FontFeature.tabularFigures()],
    ),
  ),
  textDirection: TextDirection.ltr,
)..layout();

/// Pose [text] centré sur [center], sur un fond plein qui « coupe » ce qu'il y
/// a dessous — sinon le libellé se lit par-dessus sa propre ligne de cote.
void drawSchemaLabel(
  Canvas canvas,
  TextPainter text,
  Offset center, {
  Color knockout = AppColors.cardTinted,
  double padding = 4,
}) {
  canvas.drawRect(
    Rect.fromCenter(
      center: center,
      width: text.width + padding * 2,
      height: text.height,
    ),
    Paint()..color = knockout,
  );
  text.paint(
    canvas,
    Offset(center.dx - text.width / 2, center.dy - text.height / 2),
  );
}

/// Flèche de cote. [along] est le vecteur unitaire qui va de la pointe vers
/// l'intérieur du segment ; les branches s'ouvrent perpendiculairement.
void drawSchemaArrow(Canvas canvas, Offset tip, Offset along, Paint paint) {
  final perpendicular = Offset(-along.dy, along.dx);
  final base = tip + along * kArrowArm;
  canvas
    ..drawLine(tip, base + perpendicular * 3, paint)
    ..drawLine(tip, base - perpendicular * 3, paint);
}

/// Cote horizontale : ligne de [x1] à [x2] à la hauteur [y], tirets aux bouts,
/// flèches vers l'intérieur, libellé détouré au milieu.
///
/// Le libellé est omis s'il ne tient pas dans la cote — mieux vaut une cote
/// muette qu'un chiffre qui déborde sur le voisin. Rend `true` s'il a été posé.
bool drawHDimension(
  Canvas canvas, {
  required double x1,
  required double x2,
  required double y,
  String? label,
  Color color = AppColors.label,
  Color knockout = AppColors.cardTinted,
  double labelSize = 11,
}) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = kDimStroke;
  final width = (x2 - x1).abs();

  canvas.drawLine(Offset(x1, y), Offset(x2, y), paint);
  for (final x in [x1, x2]) {
    canvas.drawLine(Offset(x, y - kDimTick), Offset(x, y + kDimTick), paint);
  }
  if (width > 2 * kArrowArm + 4) {
    drawSchemaArrow(canvas, Offset(x1, y), const Offset(1, 0), paint);
    drawSchemaArrow(canvas, Offset(x2, y), const Offset(-1, 0), paint);
  }

  if (label == null) return false;
  final text = schemaText(label, size: labelSize, color: color);
  if (text.width + 10 > width) return false;
  drawSchemaLabel(canvas, text, Offset((x1 + x2) / 2, y), knockout: knockout);
  return true;
}

/// Cote verticale : ligne de [y1] à [y2] à l'abscisse [x], libellé posé **à
/// côté** et non pivoté — un chiffre tourné à 90° ne se lit pas d'un coup
/// d'œil, et c'est un schéma d'atelier.
///
/// [labelSide] vaut +1 pour poser le libellé à droite du trait, −1 à gauche.
void drawVDimension(
  Canvas canvas, {
  required double y1,
  required double y2,
  required double x,
  String? label,
  double labelSide = 1,
  Color color = AppColors.label,
}) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = kDimStroke;
  final height = (y2 - y1).abs();

  canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);
  for (final y in [y1, y2]) {
    canvas.drawLine(Offset(x - kDimTick, y), Offset(x + kDimTick, y), paint);
  }
  if (height > 2 * kArrowArm + 4) {
    drawSchemaArrow(canvas, Offset(x, y1), const Offset(0, 1), paint);
    drawSchemaArrow(canvas, Offset(x, y2), const Offset(0, -1), paint);
  }

  if (label == null) return;
  final text = schemaText(label, color: color);
  final cy = (y1 + y2) / 2;
  final dx = labelSide >= 0 ? x + kDimTick + 3 : x - kDimTick - 3 - text.width;
  text.paint(canvas, Offset(dx, cy - text.height / 2));
}

/// Ligne d'attache : le trait fin qui relie une pièce à sa ligne de cote.
void drawExtensionLine(Canvas canvas, Offset from, Offset to, {Color? color}) {
  canvas.drawLine(
    from,
    to,
    Paint()
      ..color = (color ?? AppColors.label).withValues(alpha: 0.45)
      ..strokeWidth = kDimStroke,
  );
}

/// Le tiret des tuiles de résultat, au centre du canvas — une carte vide
/// passerait pour un bug.
void drawSchemaPlaceholder(Canvas canvas, Size size) {
  final text = schemaText(kNoValue, size: 22);
  text.paint(
    canvas,
    Offset((size.width - text.width) / 2, (size.height - text.height) / 2),
  );
}
