/// Primitives de cotation partagées par les painters.
///
/// Elles reçoivent des pixels déjà mis à l'échelle et ne calculent rien.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'format.dart';

/// Une fenêtre : une portion de l'objet coté, posée à son échelle sur la
/// feuille.
///
/// Les chiffres, flèches et traits restent en unités de feuille. Seul l'axe X
/// porte des millimètres : [rect] donne la hauteur.
class SchemaViewport {
  const SchemaViewport({
    required this.rect,
    required this.originMm,
    required this.scale,
  });

  /// Fenêtre dans laquelle [spanMm] millimètres occupent toute la largeur.
  factory SchemaViewport.fit({
    required Rect rect,
    required double spanMm,
    double originMm = 0,
  }) => SchemaViewport(
    rect: rect,
    originMm: originMm,
    scale: spanMm <= 0 ? 0 : rect.width / spanMm,
  );

  /// La place de la fenêtre sur la feuille.
  final Rect rect;

  /// Le millimètre de l'objet qui tombe sur le bord gauche de [rect].
  final double originMm;

  /// Unités de feuille par millimètre. Le rapport entre deux fenêtres d'un même
  /// schéma est ce qu'un plan écrit sous une vue de détail.
  final double scale;

  /// Les millimètres visibles dans la fenêtre.
  double get spanMm => scale <= 0 ? 0 : rect.width / scale;

  /// L'abscisse, sur la feuille, du millimètre [mm].
  double x(double mm) => rect.left + (mm - originMm) * scale;
}

/// Longueur d'une pointe de flèche de cote, et sa demi-largeur à la base.
///
/// Courte et pleine : longue, elle couvre le chiffre d'une cote serrée.
const double kArrowArm = 4;
const double _arrowHalfWidth = 1.5;

/// Demi-longueur d'un tiret d'extrémité de cote.
const double kDimTick = 4;

/// Les deux épaisseurs du dessin technique, dans le rapport normé 1:2.
///
/// [kOutlineStroke] pour un contour vu, [kDimStroke] pour toute la cotation.
/// Les deux se déplacent ensemble, sinon le rapport se perd.
const double kDimStroke = 0.5;
const double kOutlineStroke = 1;

/// L'encre d'un schéma : contours vus et cotation.
///
/// Noir franc : c'est l'encre qui porte le contraste, ce qui permet un trait
/// fin. Le gris reste aux lignes de construction ([kExtensionLine]).
const Color kSchemaInk = Color(0xFF000000);

/// Texte de schéma : chiffres tabulaires, comme partout ailleurs dans l'app.
TextPainter schemaText(
  String value, {
  double size = 10,
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

/// Pose [text] centré sur [center], sur un fond plein qui masque le trait
/// dessous.
///
/// [knockout] doit valoir la couleur du fond du schéma, blanc par défaut.
void drawSchemaLabel(
  Canvas canvas,
  TextPainter text,
  Offset center, {
  Color knockout = AppColors.cardSurface,
  double padding = kLabelPadding,
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

/// Flèche de cote, pleine. [along] est le vecteur unitaire qui va de la pointe
/// vers l'intérieur du segment.
///
/// Un trapèze : sa pointe garde l'épaisseur d'un trait et se raccorde au tiret.
void drawSchemaArrow(Canvas canvas, Offset tip, Offset along, Paint paint) {
  final perpendicular = Offset(-along.dy, along.dx);
  final nib = perpendicular * (kDimStroke / 2);
  final flare = perpendicular * _arrowHalfWidth;
  final base = tip + along * kArrowArm;

  canvas.drawPath(
    Path()
      ..moveTo(tip.dx + nib.dx, tip.dy + nib.dy)
      ..lineTo(base.dx + flare.dx, base.dy + flare.dy)
      ..lineTo(base.dx - flare.dx, base.dy - flare.dy)
      ..lineTo(tip.dx - nib.dx, tip.dy - nib.dy)
      ..close(),
    Paint()..color = paint.color,
  );
}

/// Longueur du trait qui prolonge une cote trop étroite, de part et d'autre.
const double _outsideArm = 13;

/// Ce qu'un libellé garde de dégagé de chaque côté du texte.
const double kLabelPadding = 4;

/// Ce qui sépare un chiffre de cote de la ligne qu'il cote.
const double kLabelLift = 2;

/// Pose un chiffre de cote au-dessus de la ligne qui passe par [y], centré
/// sur [cx].
///
/// Au-dessus et non détouré dedans : la ligne de cote reste continue.
void drawDimensionLabel(Canvas canvas, TextPainter text, double cx, double y) {
  text.paint(
    canvas,
    Offset(cx - text.width / 2, y - kDimStroke / 2 - kLabelLift - text.height),
  );
}

/// Cote horizontale : ligne de [x1] à [x2] à la hauteur [y], flèches vers
/// l'intérieur, libellé au-dessus. Rend `true` si le libellé a été posé.
///
/// Le libellé est omis s'il ne tient pas dans la cote. [tight] applique la
/// convention des petites cotes : flèches retournées, chiffre posé hors de la
/// cote du côté de [labelSide] (+1 à droite, −1 à gauche), recalé dans
/// [bounds]. [ticks] se coupe quand une ligne d'attache arrive au même point.
bool drawHDimension(
  Canvas canvas, {
  required double x1,
  required double x2,
  required double y,
  String? label,
  Color color = kSchemaInk,
  double labelSize = 10,
  bool tight = false,
  double labelSide = 1,
  bool ticks = true,
  Rect? bounds,
}) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = kDimStroke;
  final width = (x2 - x1).abs();

  canvas.drawLine(Offset(x1, y), Offset(x2, y), paint);
  if (ticks) {
    for (final x in [x1, x2]) {
      canvas.drawLine(Offset(x, y - kDimTick), Offset(x, y + kDimTick), paint);
    }
  }
  final left = x1 < x2 ? x1 : x2;
  final right = x1 < x2 ? x2 : x1;
  final inward = width > 2 * kArrowArm + 4;
  if (inward) {
    drawSchemaArrow(canvas, Offset(left, y), const Offset(1, 0), paint);
    drawSchemaArrow(canvas, Offset(right, y), const Offset(-1, 0), paint);
  } else if (tight) {
    canvas
      ..drawLine(Offset(left - _outsideArm, y), Offset(left, y), paint)
      ..drawLine(Offset(right, y), Offset(right + _outsideArm, y), paint);
    drawSchemaArrow(canvas, Offset(left, y), const Offset(-1, 0), paint);
    drawSchemaArrow(canvas, Offset(right, y), const Offset(1, 0), paint);
  }

  if (label == null) return false;
  final text = schemaText(label, size: labelSize, color: color);

  if (text.width + 2 * kLabelPadding <= width) {
    drawDimensionLabel(canvas, text, (x1 + x2) / 2, y);
    return true;
  }
  if (!tight) return false;

  // Sorti, le chiffre se pose après le bras de prolongement ou le bout de la
  // cote, détourage compris.
  final reach =
      (inward ? 0.0 : _outsideArm) + kLabelPadding + 2 + text.width / 2;
  var cx = labelSide >= 0 ? right + reach : left - reach;
  if (bounds != null) {
    final margin = text.width / 2 + 2;
    cx = cx.clamp(bounds.left + margin, bounds.right - margin);
  }
  drawDimensionLabel(canvas, text, cx, y);
  return true;
}

/// Cote verticale : ligne de [y1] à [y2] à l'abscisse [x], libellé posé à
/// côté, non pivoté.
///
/// [labelSide] vaut +1 pour la droite, −1 pour la gauche. [ticks] comme dans
/// [drawHDimension].
void drawVDimension(
  Canvas canvas, {
  required double y1,
  required double y2,
  required double x,
  String? label,
  double labelSide = 1,
  bool ticks = true,
  Color color = kSchemaInk,
}) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = kDimStroke;
  final height = (y2 - y1).abs();

  canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);
  if (ticks) {
    for (final y in [y1, y2]) {
      canvas.drawLine(Offset(x - kDimTick, y), Offset(x + kDimTick, y), paint);
    }
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

/// Les sommets d'un trait de rupture, de `(x, y1)` à `(x, y2)`.
///
/// L'appelant en fait un chemin de découpe, [drawBreakLine] en fait un trait :
/// la matière est détourée par la ligne qui la barre.
List<Offset> schemaBreakPoints({
  required double x,
  required double y1,
  required double y2,
}) {
  const double amplitude = 3;
  const double targetStep = 14;

  // Un nombre entier de dents, sinon la dernière prend le reste.
  final count = math.max(2, ((y2 - y1).abs() / targetStep).round());
  final step = (y2 - y1) / count;

  // Les dents des bouts font une demi-hauteur : elles partent de l'axe, et
  // penchent ainsi comme les autres.
  return [
    Offset(x, y1),
    for (var i = 0; i < count; i++)
      Offset(x + (i.isEven ? amplitude : -amplitude), y1 + (i + 0.5) * step),
    Offset(x, y2),
  ];
}

/// Trait de rupture : le zigzag qui indique que la pièce continue.
void drawBreakLine(
  Canvas canvas, {
  required double x,
  required double y1,
  required double y2,
  Color color = kSchemaInk,
}) {
  final points = schemaBreakPoints(x: x, y1: y1, y2: y2);
  final path = Path()..moveTo(points.first.dx, points.first.dy);
  for (final point in points.skip(1)) {
    path.lineTo(point.dx, point.dy);
  }

  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = kDimStroke
      ..strokeJoin = StrokeJoin.round,
  );
}

/// Gris d'un trait d'attache : [AppColors.label] à 45 % sur la feuille, mais
/// opaque.
///
/// Par transparence, il foncerait là où deux cotes partagent un bord.
const Color kExtensionLine = Color(0xFFBCB8B5);

/// Ce qu'une ligne d'attache laisse à la pièce, et ce qu'elle dépasse de la
/// ligne de cote.
///
/// Le dépassement marque le point coté, en l'absence de tiret.
const double kExtensionGap = 2;
const double kExtensionOvershoot = 3;

/// Ligne d'attache : le trait fin qui relie une pièce à sa ligne de cote.
void drawExtensionLine(Canvas canvas, Offset from, Offset to, {Color? color}) {
  canvas.drawLine(
    from,
    to,
    Paint()
      ..color = color ?? kExtensionLine
      ..strokeWidth = kDimStroke,
  );
}

/// Le tiret des tuiles de résultat, au centre du canvas.
void drawSchemaPlaceholder(Canvas canvas, Size size) {
  final text = schemaText(kNoValue, size: 22);
  text.paint(
    canvas,
    Offset((size.width - text.width) / 2, (size.height - text.height) / 2),
  );
}
