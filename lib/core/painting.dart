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

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'format.dart';

/// Une fenêtre : une portion de l'objet coté, posée à une échelle sur la
/// feuille.
///
/// C'est la séparation espace objet / espace papier du dessin technique. Les
/// millimètres de la pièce vivent d'un côté, la feuille de l'autre, et une
/// fenêtre est le seul point de passage — avec **son** échelle, qui n'est pas
/// forcément celle de la fenêtre d'à côté. Un schéma peut ainsi porter une vue
/// d'ensemble et un détail agrandi sans que l'un impose sa réduction à l'autre.
///
/// Ce qui se lit (chiffres, flèches, épaisseurs de trait) reste en unités de
/// feuille et ne traverse jamais une fenêtre : un chiffre garde sa taille quelle
/// que soit l'échelle de la vue qu'il cote, exactement comme sur un plan.
///
/// Seul l'axe des X porte aujourd'hui des millimètres, faute d'un schéma qui en
/// ait deux — [rect] donne la hauteur, en unités de feuille.
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
/// Une pointe pleine, et courte : c'est ce que trace un plan. Une flèche
/// ouverte et longue mange la cote qu'elle borne, et sur une cote serrée elle
/// couvre le chiffre voisin.
const double kArrowArm = 4;
const double _arrowHalfWidth = 0.9;

/// Demi-longueur d'un tiret d'extrémité de cote.
const double kDimTick = 4;

/// Épaisseur d'un trait de cote.
const double kDimStroke = 1;

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

/// Pose [text] centré sur [center], sur un fond plein qui « coupe » ce qu'il y
/// a dessous — sinon le libellé se lit par-dessus sa propre ligne de cote.
///
/// [knockout] doit valoir la couleur du fond sur lequel le schéma est dessiné,
/// sinon le détourage laisse un pavé visible. Les schémas vivent tous sur la
/// feuille blanche de `SchemaSheet`, d'où ce défaut.
void drawSchemaLabel(
  Canvas canvas,
  TextPainter text,
  Offset center, {
  Color knockout = AppColors.cardSurface,
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

/// Flèche de cote, pleine. [along] est le vecteur unitaire qui va de la pointe
/// vers l'intérieur du segment ; la base s'ouvre perpendiculairement.
///
/// Un trapèze et non un triangle : une pointe qui s'affine jusqu'à zéro n'a
/// plus d'encre sur son dernier tiers, et la cote semble alors ne pas partir du
/// trait qu'elle vise. Son extrémité fait donc l'épaisseur d'un trait, ce qui
/// la raccorde franchement au tiret — sans rien arrondir.
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

/// Cote horizontale : ligne de [x1] à [x2] à la hauteur [y], tirets aux bouts,
/// flèches vers l'intérieur, libellé détouré au milieu.
///
/// Le libellé est omis s'il ne tient pas dans la cote — mieux vaut une cote
/// muette qu'un chiffre qui déborde sur le voisin. Rend `true` s'il a été posé.
///
/// [tight] renverse ce choix, selon la convention du dessin technique pour les
/// petites cotes : les flèches se retournent vers l'extérieur et le chiffre va
/// se poser **hors** de l'espace mesuré, au-delà du trait de rappel, du côté
/// que dit [labelSide] (+1 à droite, −1 à gauche). [bounds] est la feuille : un
/// chiffre sorti s'y recale plutôt que de déborder, quand le côté demandé n'a
/// pas la place de le prendre. C'est le seul moyen de coter
/// une marge de 40 mm et un élément de 18 mm côte à côte, et une cote ainsi
/// posée rend toujours `true`.
///
/// Dehors et non au-dessus du trait : un chiffre posé sur une cote de 6 px en
/// détoure la ligne, ses flèches et parfois le trait de rappel voisin. Sorti,
/// il ne recouvre plus rien.
bool drawHDimension(
  Canvas canvas, {
  required double x1,
  required double x2,
  required double y,
  String? label,
  Color color = AppColors.label,
  Color knockout = AppColors.cardSurface,
  double labelSize = 10,
  bool tight = false,
  double labelSide = 1,
  Rect? bounds,
}) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = kDimStroke;
  final width = (x2 - x1).abs();

  canvas.drawLine(Offset(x1, y), Offset(x2, y), paint);
  for (final x in [x1, x2]) {
    canvas.drawLine(Offset(x, y - kDimTick), Offset(x, y + kDimTick), paint);
  }
  final left = x1 < x2 ? x1 : x2;
  final right = x1 < x2 ? x2 : x1;
  if (width > 2 * kArrowArm + 4) {
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
  if (text.width + 10 <= width) {
    drawSchemaLabel(canvas, text, Offset((x1 + x2) / 2, y), knockout: knockout);
    return true;
  }
  if (!tight) return false;

  final reach = _outsideArm + 3 + text.width / 2;
  var cx = labelSide >= 0 ? right + reach : left - reach;
  if (bounds != null) {
    final margin = text.width / 2 + 2;
    cx = cx.clamp(bounds.left + margin, bounds.right - margin);
  }
  drawSchemaLabel(canvas, text, Offset(cx, y), knockout: knockout);
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

/// Les sommets d'un trait de rupture, de `(x, y1)` à `(x, y2)`.
///
/// Rendus plutôt que dessinés directement : la matière doit être **détourée**
/// par la même ligne brisée qui la barre, sinon elle déborde de part et
/// d'autre des dents et le trait ne coupe rien. L'appelant en fait un chemin
/// de découpe, [drawBreakLine] en fait un trait.
List<Offset> schemaBreakPoints({
  required double x,
  required double y1,
  required double y2,
}) {
  const double amplitude = 3;
  const double targetStep = 14;

  // Le pas se déduit d'un nombre entier de dents plutôt que l'inverse : à pas
  // fixe, la dernière dent prend ce qui reste et le zigzag boite.
  final count = math.max(2, ((y2 - y1).abs() / targetStep).round());
  final step = (y2 - y1) / count;

  // Les deux dents des bouts ne font qu'une demi-hauteur. Les extrémités sont
  // sur l'axe et les dents intérieures vont d'un bord à l'autre : à hauteur
  // égale, elles parcourraient la moitié du chemin, et la première et la
  // dernière pencheraient deux fois moins que les autres.
  return [
    Offset(x, y1),
    for (var i = 0; i < count; i++)
      Offset(x + (i.isEven ? amplitude : -amplitude), y1 + (i + 0.5) * step),
    Offset(x, y2),
  ];
}

/// Trait de rupture : le zigzag qui dit « la pièce continue, on a coupé ».
///
/// C'est la convention qui autorise un panneau de détail à ne montrer qu'un
/// bout de la pièce sans laisser croire qu'elle s'arrête là. Le zigzag court
/// sur toute la hauteur : un trait droit se lirait comme une arête.
void drawBreakLine(
  Canvas canvas, {
  required double x,
  required double y1,
  required double y2,
  Color color = AppColors.label,
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
/// **opaque**.
///
/// Le même gris obtenu par transparence noircirait à chaque recouvrement, et
/// deux cotes voisines partagent presque toujours un bord — la fin d'une marge
/// est le début d'un élément. Une teinte fixe se superpose à elle-même sans
/// rien changer.
const Color kExtensionLine = Color(0xFFBCB8B5);

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

/// Le tiret des tuiles de résultat, au centre du canvas — une carte vide
/// passerait pour un bug.
void drawSchemaPlaceholder(Canvas canvas, Size size) {
  final text = schemaText(kNoValue, size: 22);
  text.paint(
    canvas,
    Offset((size.width - text.width) / 2, (size.height - text.height) / 2),
  );
}
