/// Le plan : le schéma d'un outil posé sur une feuille A4, avec son cartouche.
///
/// Même painter pour l'export et la page plein écran. Le cartouche ne porte
/// que ce que le dessin ne dit pas, et reçoit des chaînes déjà formatées.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';

/// Une case du cartouche : son intitulé en petites capitales, sa valeur.
typedef PlanField = (String label, String value);

/// La table du cartouche : les cotes de pose, une par ligne.
///
/// Tout ou rien : [fallback] remplace la table entière si elle ne tient pas,
/// car une liste tronquée ferait oublier une pièce.
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

  /// Les tables, la plus importante d'abord. Chacune cède la place à son repli
  /// si elle ne tient plus, sans toucher aux précédentes.
  final List<PlanTable> tables;

  /// L'avertissement de l'outil, en pleine largeur au bas du cartouche.
  final String? note;
}

/// La date d'un plan, dans l'ordre de la langue : `23/09/2026`, `09/23/2026`.
String formatPlanDate(DateTime date, AppLocalizations l10n) {
  String two(int v) => v.toString().padLeft(2, '0');
  return l10n.planDateValue(two(date.day), two(date.month), '${date.year}');
}

/// Boîte de référence du plan, aux proportions d'une A4 à l'italienne.
///
/// Mise à l'échelle uniformément dans le canvas, comme les schémas, pour que
/// l'aperçu vaille pour le fichier.
const double kPlanWidth = 594;
const double kPlanHeight = 420;
const double kPlanAspectRatio = kPlanWidth / kPlanHeight;

/// Marge de la feuille, jusqu'au cadre.
const double _sheetMargin = 14;

/// Largeur du cartouche, en colonne le long du bord droit.
///
/// En colonne : une table de positions veut de la hauteur, et la zone de
/// tracé garde les proportions des schémas.
const double _cartoucheWidth = 196;

/// Retrait de la zone de tracé par rapport au cadre.
const double _drawingInset = 8;

/// Marge intérieure d'une case.
const double _cellPad = 4;

/// Interligne de tout le cartouche.
///
/// Figé, pour que la hauteur d'une case se calcule : `taille × facteur`.
const double _lineHeight = 1.15;

const double _titleSize = 14;
const double _labelSize = 6;
const double _valueSize = 10;
const double _tableHeaderSize = 6.5;
const double _tableSize = 8;
const double _noteSize = 7;

/// Hauteur des cases, dérivée de [_lineHeight] et [_cellPad] : trop basse,
/// la valeur passe sous l'intitulé.
const double _titleCellHeight = 2 * _cellPad + _titleSize * _lineHeight;
const double _fieldCellHeight =
    2 * _cellPad + _labelSize * _lineHeight + _valueSize * _lineHeight + 2;
const double _tableTitleHeight = 2 * _cellPad + _tableHeaderSize * _lineHeight;
const double _tableHeaderHeight = _tableHeaderSize * _lineHeight + 5;
const double _tableRowHeight = _tableSize * _lineHeight + 2;

/// Interlettrage des intitulés en petites capitales.
const double _labelTracking = 0.8;

/// Écart entre deux colonnes d'une table.
const double _columnGap = 4;

/// Largeur de la colonne des numéros, fixe d'un plan à l'autre.
///
/// Prévue pour trois chiffres ([kMaxDistributionCount]) : trop étroite, la
/// cellule n'écrit rien.
const double _indexWidth = 26;

/// L'encre du plan : noir franc, pour l'impression.
const Color _planInk = Color(0xFF000000);

/// Les intitulés de case, en gris pour que les valeurs ressortent.
const Color _planLabel = Color(0xFF6E6E6E);

/// Les refends du cartouche, et le cadre au double (les deux épaisseurs du
/// dessin technique).
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
/// [drawing] est le painter de l'outil, pris tel quel : il se fixe lui-même à
/// sa boîte de référence.
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
    // La feuille peint son blanc : les libellés de cote s'y détourent, et un
    // PNG transparent laisserait des pavés blancs.
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

    // Le cadre en dernier, pour qu'il ne soit jamais recouvert.
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
    // Le pied est réservé d'abord : il borne la table, qui ne doit jamais
    // recouvrir l'avertissement.
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

  /// Les cases, deux par rangée. Une case seule en fin de liste prend toute la
  /// largeur.
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
  /// Seul l'intitulé se tronque : un nombre amputé se lit faux.
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

  /// Une ligne de table, chaque cellule cadrée à droite pour aligner les
  /// chiffres.
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

  /// Le contour d'une case. Les cases voisines partagent leurs bords.
  void _rect(Canvas canvas, Rect rect) => canvas.drawRect(rect, _rule);

  static final Paint _rule = Paint()
    ..color = _planInk
    ..style = PaintingStyle.stroke
    ..strokeWidth = _ruleWidth;

  /// Toujours : une saisie change le schéma et le cartouche à la fois, et
  /// comparer coûterait plus que redessiner.
  @override
  bool shouldRepaint(PlanPainter old) => true;
}

/// Texte de cartouche : chiffres tabulaires, et jamais de débord.
///
/// [maxWidth] est obligatoire : les chaînes viennent d'une saisie, sans
/// longueur bornée.
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
