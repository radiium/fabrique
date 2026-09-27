/// Le plan : le schéma d'un outil posé sur une feuille A4, avec son cartouche.
///
/// C'est ce que l'app exporte, et c'est aussi ce que montre la page plein
/// écran. Les deux traversent le même painter, donc l'aperçu et le fichier
/// sont le même dessin au pixel près — un aperçu qui montrerait autre chose
/// que ce qui sort ne serait pas un aperçu.
///
/// Le cartouche est un **tableau réglé**, pas une liste de valeurs : encre
/// noire, une case par champ, cadre gras et refends fins. C'est la forme qu'a
/// le cartouche de n'importe quel plan, donc elle se lit sans qu'on l'explique
/// — là où un panneau typographique se lit comme une capture d'app.
///
/// Il ne porte **que ce que le dessin ne dit pas**. Les cotes de la pièce sont
/// sur le schéma, aux mêmes chiffres exacts : les répéter en texte remplirait
/// le cartouche de redites, et chaque ligne gagnée est une position de plus
/// dans la table.
///
/// Rien ici ne calcule : le plan reçoit des chaînes déjà formatées.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';

/// Une case du cartouche : son intitulé en petites capitales, sa valeur.
typedef PlanField = (String label, String value);

/// La table du cartouche — les cotes de pose, une par ligne.
///
/// **Tout ou rien** : [fallback] remplace la table entière dès qu'elle ne tient
/// pas dans la place restante. Une liste de positions tronquée sur un plan
/// d'atelier, c'est une pièce percée en moins, et rien sur la feuille ne dirait
/// qu'il en manque.
class PlanTable {
  const PlanTable({
    required this.title,
    required this.headers,
    required this.rows,
    required this.fallback,
  });

  final String title;

  /// L'unité va ici et non dans chaque cellule : elle qualifie la colonne.
  final List<String> headers;

  /// Une ligne par entrée, de la longueur de [headers].
  final List<List<String>> rows;

  /// Ce qui s'écrit à la place de la table quand elle déborde.
  final String fallback;
}

/// Le contenu d'un plan : ce que porte son cartouche.
class Plan {
  const Plan({
    required this.title,
    required this.fields,
    this.tables = const [],
    this.note,
  });

  /// Le nom de l'outil, seul en tête du cartouche.
  final String title;

  /// Les cases, deux par rangée, dans l'ordre de lecture. Une case seule en
  /// fin de liste prend toute la largeur.
  final List<PlanField> fields;

  /// Les tables, l'une sous l'autre, la plus importante d'abord : chacune
  /// cède sa place à son repli si elle ne tient plus, sans toucher aux
  /// précédentes.
  final List<PlanTable> tables;

  /// L'avertissement de l'outil, en pleine largeur au bas du cartouche — le
  /// `%` de perte pessimiste du Calepinage.
  final String? note;
}

/// `23/09/2026` — la date telle qu'on l'écrit sur un plan, dans l'ordre de la
/// langue (`09/23/2026` en anglais).
String formatPlanDate(DateTime date, AppLocalizations l10n) {
  String two(int v) => v.toString().padLeft(2, '0');
  return l10n.planDateValue(two(date.day), two(date.month), '${date.year}');
}

/// Les proportions d'une A4 à l'italienne, et la boîte dans laquelle le plan
/// est coté.
///
/// **Le plan ne se recompose pas avec le canvas, il s'y pose en entier** — même
/// règle que les schémas : tout est coté dans cette boîte, qu'une seule mise à
/// l'échelle uniforme amène à la taille disponible. Sans ça, le cartouche
/// s'étirerait d'un appareil à l'autre et l'aperçu cesserait de valoir pour le
/// fichier.
///
/// À l'italienne parce que les cinq schémas sont tous plus larges que hauts, et
/// parce qu'une image large se regarde mieux dans une conversation.
const double kPlanWidth = 594;
const double kPlanHeight = 420;
const double kPlanAspectRatio = kPlanWidth / kPlanHeight;

/// Marge de la feuille, jusqu'au cadre.
const double _sheetMargin = 14;

/// Largeur du cartouche, en colonne le long du bord droit.
///
/// En colonne et non en bandeau bas : une table de positions veut de la
/// hauteur, et la zone de tracé y garde des proportions proches de celles des
/// schémas, qui s'y posent donc en occupant vraiment la place. En bandeau, un
/// schéma en 5/4 se retrouvait cerné de blanc sur ses deux flancs.
const double _cartoucheWidth = 196;

/// Retrait de la zone de tracé par rapport au cadre — sans lui, un schéma qui
/// remplit sa boîte vient toucher le trait.
const double _drawingInset = 8;

/// Marge intérieure d'une case.
const double _cellPad = 4;

/// Interligne de tout le cartouche.
///
/// Figé, et c'est ce qui rend les hauteurs de case calculables : la boîte de
/// ligne vaut exactement `taille × ce facteur`, donc un intitulé et sa valeur
/// tiennent dans une case dont la hauteur se déduit, au lieu de se chevaucher
/// dès qu'une police un peu large passe par là.
const double _lineHeight = 1.15;

const double _titleSize = 14;
const double _labelSize = 6;
const double _valueSize = 10;
const double _tableHeaderSize = 6.5;
const double _tableSize = 8;
const double _noteSize = 7;

/// Hauteur des cases, par nature — dérivées de [_lineHeight] et [_cellPad],
/// jamais posées à l'œil : une case trop basse fait passer la valeur sous son
/// intitulé, et ça ne se voit qu'au rendu.
const double _titleCellHeight = 2 * _cellPad + _titleSize * _lineHeight;
const double _fieldCellHeight =
    2 * _cellPad + _labelSize * _lineHeight + _valueSize * _lineHeight + 2;
const double _tableTitleHeight = 2 * _cellPad + _tableHeaderSize * _lineHeight;
const double _tableHeaderHeight = _tableHeaderSize * _lineHeight + 5;
const double _tableRowHeight = _tableSize * _lineHeight + 2;

/// Interlettrage des intitulés — c'est lui qui fait lire une petite capitale
/// comme une étiquette de cartouche et non comme un mot tassé.
const double _labelTracking = 0.8;

/// Écart entre deux colonnes d'une table.
const double _columnGap = 4;

/// Largeur de la colonne des numéros.
///
/// Fixée et non mesurée : une largeur mesurée ferait danser les colonnes d'un
/// plan à l'autre. Mais assez large pour le plus grand numéro possible
/// ([kMaxDistributionCount] en donne trois chiffres) — sous-dimensionnée, la
/// cellule ne tronque pas, elle **n'écrit rien**, et la colonne se vide en
/// silence à partir de 10.
const double _indexWidth = 26;

/// L'encre du plan.
///
/// Du noir franc : le cartouche est un tableau réglé, et c'est le contraste
/// maximal qui le fait tenir comme de l'encre une fois la feuille imprimée.
const Color _planInk = Color(0xFF000000);

/// Les intitulés de case — le même gris pour tous, pour que les valeurs
/// ressortent seules.
const Color _planLabel = Color(0xFF6E6E6E);

/// Les refends du cartouche. Le cadre de la feuille, lui, fait le double :
/// c'est la convention des deux épaisseurs du dessin technique.
const double _ruleWidth = 0.5;
const double _frameWidth = 1;

Rect get _frame => const Rect.fromLTRB(
  _sheetMargin,
  _sheetMargin,
  kPlanWidth - _sheetMargin,
  kPlanHeight - _sheetMargin,
);

Rect get _cartouche => Rect.fromLTRB(
  _frame.right - _cartoucheWidth,
  _frame.top,
  _frame.right,
  _frame.bottom,
);

/// La place du schéma sur la feuille.
Rect get _drawing => Rect.fromLTRB(
  _frame.left,
  _frame.top,
  _frame.right - _cartoucheWidth,
  _frame.bottom,
).deflate(_drawingInset);

/// Un plan complet : la feuille, le schéma, le cartouche.
///
/// [drawing] est le painter de l'outil, pris tel quel — le plan ne lui impose
/// que sa place. Il se fixe lui-même à sa boîte de référence, comme il le fait
/// dans sa vignette, donc rien ici n'a à savoir ce qu'il dessine.
class PlanPainter extends CustomPainter {
  const PlanPainter({required this.plan, required this.drawing});

  final Plan plan;
  final CustomPainter drawing;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final scale = math.min(size.width / kPlanWidth, size.height / kPlanHeight);
    canvas
      ..save()
      ..translate(
        (size.width - kPlanWidth * scale) / 2,
        (size.height - kPlanHeight * scale) / 2,
      )
      ..scale(scale);
    _paintSheet(canvas);
    canvas.restore();
  }

  void _paintSheet(Canvas canvas) {
    // La feuille peint son propre blanc : c'est la couleur sur laquelle les
    // libellés de cote se détourent ([drawSchemaLabel]), et un PNG au fond
    // transparent les laisserait traîner un pavé blanc dans le vide.
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, kPlanWidth, kPlanHeight),
      Paint()..color = AppColors.cardSurface,
    );

    final area = _drawing;
    canvas
      ..save()
      ..clipRect(area)
      ..translate(area.left, area.top);
    drawing.paint(canvas, area.size);
    canvas.restore();

    _paintCartouche(canvas);

    // Le cadre en dernier, donc jamais mordu. Ce qui l'en tient à distance,
    // c'est [_drawingInset] d'un côté et les cases du cartouche de l'autre :
    // un schéma qui remplit sa boîte s'arrête net avant le trait.
    final frame = Paint()
      ..color = _planInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = _frameWidth;
    canvas
      ..drawRect(_frame, frame)
      ..drawLine(
        Offset(_cartouche.left, _frame.top),
        Offset(_cartouche.left, _frame.bottom),
        frame,
      );
  }

  void _paintCartouche(Canvas canvas) {
    final column = _cartouche;
    var y = _paintTitleCell(canvas, column);

    final note = plan.note;
    // Le pied est réservé avant le reste : c'est lui qui borne la table, et une
    // table qui déborderait dessus recouvrirait l'avertissement de l'outil — la
    // seule ligne du cartouche qu'on n'a pas le droit de perdre.
    final noteText = note == null
        ? null
        : _text(
            note,
            size: _noteSize,
            color: _planLabel,
            maxWidth: column.width - 2 * _cellPad,
            maxLines: 3,
          );
    final limit = noteText == null
        ? column.bottom
        : column.bottom - noteText.height - 2 * _cellPad;

    y = _paintFields(canvas, column, y);

    for (final table in plan.tables) {
      y = _paintTable(canvas, column, y, limit, table);
    }

    if (noteText != null) {
      _rect(
        canvas,
        Rect.fromLTRB(column.left, limit, column.right, column.bottom),
      );
      noteText.paint(canvas, Offset(column.left + _cellPad, limit + _cellPad));
    }
  }

  /// Le bandeau du cartouche : le nom du dessin, et rien d'autre.
  double _paintTitleCell(Canvas canvas, Rect column) {
    final rect = Rect.fromLTWH(
      column.left,
      column.top,
      column.width,
      _titleCellHeight,
    );
    _rect(canvas, rect);

    _text(
      plan.title,
      size: _titleSize,
      weight: FontWeight.w700,
      maxWidth: rect.width - 2 * _cellPad,
    ).paint(canvas, Offset(rect.left + _cellPad, rect.top + _cellPad));
    return rect.bottom;
  }

  /// Les cases, deux par rangée. Une case seule en fin de liste prend la
  /// largeur entière plutôt que de laisser un trou dans la grille.
  double _paintFields(Canvas canvas, Rect column, double top) {
    var y = top;
    for (var i = 0; i < plan.fields.length; i += 2) {
      final last = i + 1 >= plan.fields.length;
      final width = last ? column.width : column.width / 2;

      _paintFieldCell(
        canvas,
        Rect.fromLTWH(column.left, y, width, _fieldCellHeight),
        plan.fields[i],
      );
      if (!last) {
        _paintFieldCell(
          canvas,
          Rect.fromLTWH(column.left + width, y, width, _fieldCellHeight),
          plan.fields[i + 1],
        );
      }
      y += _fieldCellHeight;
    }
    return y;
  }

  /// Une case : intitulé en petites capitales en haut, valeur en bas.
  ///
  /// La valeur ne se tronque jamais — c'est l'intitulé qui cède la place. Un
  /// intitulé raccourci se devine encore, un nombre amputé se lit faux.
  void _paintFieldCell(Canvas canvas, Rect rect, PlanField field) {
    _rect(canvas, rect);
    final inner = rect.width - 2 * _cellPad;

    final label = _text(
      field.$1,
      size: _labelSize,
      color: _planLabel,
      letterSpacing: _labelTracking,
      maxWidth: inner,
    );
    label.paint(canvas, Offset(rect.left + _cellPad, rect.top + _cellPad));

    final value = _text(
      field.$2,
      size: _valueSize,
      weight: FontWeight.w700,
      maxWidth: inner,
    );
    value.paint(
      canvas,
      Offset(rect.left + _cellPad, rect.bottom - _cellPad - value.height),
    );
  }

  /// La table des positions, ou son repli si elle ne tient pas jusqu'à [limit].
  double _paintTable(
    Canvas canvas,
    Rect column,
    double top,
    double limit,
    PlanTable table,
  ) {
    var y = top;
    final titleRect = Rect.fromLTWH(
      column.left,
      y,
      column.width,
      _tableTitleHeight,
    );
    _rect(canvas, titleRect);
    _text(
      table.title,
      size: _tableHeaderSize,
      color: _planLabel,
      letterSpacing: _labelTracking,
      maxWidth: column.width - 2 * _cellPad,
    ).paint(canvas, Offset(column.left + _cellPad, y + _cellPad));
    y = titleRect.bottom;

    final widths = _columnWidths(column.width, table.headers.length);
    final capacity = ((limit - y - _tableHeaderHeight) / _tableRowHeight)
        .floor();

    if (table.rows.isEmpty || table.rows.length > capacity) {
      final note = _text(
        table.fallback,
        size: _noteSize,
        color: _planLabel,
        maxWidth: column.width - 2 * _cellPad,
        maxLines: 3,
      );
      final rect = Rect.fromLTRB(
        column.left,
        y,
        column.right,
        y + note.height + 2 * _cellPad,
      );
      _rect(canvas, rect);
      note.paint(canvas, Offset(column.left + _cellPad, y + _cellPad));
      return rect.bottom;
    }

    _paintCells(
      canvas,
      Rect.fromLTWH(column.left, y, column.width, _tableHeaderHeight),
      widths,
      table.headers,
      size: _tableHeaderSize,
      color: _planLabel,
    );
    y += _tableHeaderHeight;

    for (final row in table.rows) {
      _paintCells(
        canvas,
        Rect.fromLTWH(column.left, y, column.width, _tableRowHeight),
        widths,
        row,
        size: _tableSize,
      );
      y += _tableRowHeight;
    }
    return y;
  }

  /// Une ligne de table : sa case de bord à bord, ses refends verticaux, et
  /// chaque cellule cadrée à droite — unités sous unités, centaines sous
  /// centaines.
  void _paintCells(
    Canvas canvas,
    Rect rect,
    List<double> widths,
    List<String> cells, {
    required double size,
    Color color = _planInk,
  }) {
    _rect(canvas, rect);

    var x = rect.left;
    for (final (i, cell) in cells.indexed) {
      final width = widths[i];
      if (i > 0) {
        canvas.drawLine(Offset(x, rect.top), Offset(x, rect.bottom), _rule);
      }
      final text = _text(
        cell,
        size: size,
        color: color,
        maxWidth: width - 2 * _columnGap,
      );
      text.paint(
        canvas,
        Offset(
          x + width - _columnGap - text.width,
          rect.center.dy - text.height / 2,
        ),
      );
      x += width;
    }
  }

  /// Les numéros à l'étroit, le reste à parts égales.
  List<double> _columnWidths(double total, int count) {
    if (count <= 1) return [total];
    final rest = (total - _indexWidth) / (count - 1);
    return [_indexWidth, for (var i = 1; i < count; i++) rest];
  }

  /// Le contour d'une case. Les cases voisines partagent leurs bords, donc le
  /// trait se pose deux fois — sans conséquence, l'encre étant opaque.
  void _rect(Canvas canvas, Rect rect) => canvas.drawRect(rect, _rule);

  static final Paint _rule = Paint()
    ..color = _planInk
    ..style = PaintingStyle.stroke
    ..strokeWidth = _ruleWidth;

  /// Un plan se redessine dès que son widget se reconstruit, c'est-à-dire quand
  /// une saisie change — et alors tout change à la fois, le schéma comme le
  /// cartouche. Comparer case à case coûterait plus cher que de redessiner une
  /// feuille de quelques centaines de traits.
  @override
  bool shouldRepaint(PlanPainter old) => true;
}

/// Texte de cartouche : chiffres tabulaires, et jamais de débord.
///
/// [maxWidth] est obligatoire par construction — toute chaîne posée ici vient
/// d'une saisie, donc rien ne borne sa longueur, et une ligne qui déborde de sa
/// case va se poser sur la voisine.
TextPainter _text(
  String value, {
  required double size,
  required double maxWidth,
  Color color = _planInk,
  FontWeight weight = FontWeight.w400,
  double letterSpacing = 0,
  int maxLines = 1,
}) => TextPainter(
  text: TextSpan(
    text: value,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: _lineHeight,
      letterSpacing: letterSpacing,
      fontFeatures: const [FontFeature.tabularFigures()],
    ),
  ),
  textDirection: TextDirection.ltr,
  maxLines: maxLines,
  ellipsis: '…',
)..layout(maxWidth: maxWidth);
