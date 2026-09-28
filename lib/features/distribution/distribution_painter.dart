import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/distribution.dart';
import '../../core/painting.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/numbers.dart';

/// Marge latérale, pour que les cotes d'extrémité ne butent pas sur le bord.
const double _sideMargin = 20;

/// Gouttière entre les traits de rupture des deux panneaux de détail.
const double _paneGutter = 28;

/// Retrait des panneaux sous la vue d'ensemble, de chaque côté.
///
/// Les panneaux couvrent ainsi 83 % de la barre du haut : plus larges, ils se
/// liraient comme deux bouts aussi longs que la pièce.
const double _paneInset = 12;

/// Épaisseur de la barre, vue d'ensemble puis panneaux.
///
/// Le panneau double l'épaisseur, sinon un détail agrandi en largeur seule se
/// lit comme un étirement.
const double _overviewBarThickness = 30;
const double _detailBarThickness = 2 * _overviewBarThickness;

/// Débord d'un trait de rupture, de part et d'autre de la barre.
const double _breakOverhang = 12;

/// Les étages du dessin, en pixels depuis le haut du bloc.
///
/// Absolus : le texte a une taille fixe, des proportions finiraient par le
/// faire se chevaucher.
const double _totalDimY = 16;
const double _overviewBarTop = 24;
const double _titleTop = 74;
const double _detailBarTop = 94;
const double _firstLevelY = 178;
const double _legendTop = 242;

/// Boîte de référence du schéma, mise à l'échelle uniformément dans le canvas.
///
/// Largeur de la vignette du téléphone de référence, hauteur des trois bandes :
/// le rapport de `visualizationAspectRatio`, donc une échelle de 1 en vignette.
const double _designWidth = 336;
const double _designHeight = 255;

/// Écart entre deux étages de cote, égal à la distance du premier à la barre.
///
/// Les étages tombent ainsi à un, deux et trois pas sous la pièce.
const double _levelStep = 24;

/// Largeur minimale d'un élément dessiné, pour qu'il reste visible.
///
/// Un élément de largeur nulle devient ainsi un trait.
const double _minElementPixels = 2;

/// Tolérance de comparaison en mm, pour ne pas coter un jeu nul.
const double _epsilon = 1e-6;

/// Les agrandissements ronds admis pour les panneaux de détail.
///
/// L'échelle se prend au rang inférieur. Les demis jusqu'à 3 évitent qu'une
/// rangée de cinq (vers 1,8) retombe à 1, qui n'agrandit rien.
const List<double> _zoomLadder = [
  1,
  1.5,
  2,
  2.5,
  3,
  4,
  5,
  6,
  8,
  10,
  15,
  20,
  30,
  50,
  75,
  100,
];

/// Le plus grand agrandissement de [_zoomLadder] qui tienne dans [ratio].
double _zoomFor(double ratio) {
  var chosen = _zoomLadder.first;
  for (final zoom in _zoomLadder) {
    if (zoom <= ratio) chosen = zoom;
  }
  return chosen;
}

/// Une cote de panneau : son segment en millimètres, et son étage.
///
/// L'étage est fixe par nature de cote (marge, élément, écart), pour qu'une
/// marge remise à zéro ne fasse pas remonter les autres.
typedef _Dim = (double from, double to, int level);

/// La rangée en plan : la pièce entière avec sa cote totale, puis ses deux
/// bouts agrandis, qui portent les autres cotes.
///
/// Les marges sont hachurées. Un élément de largeur nulle se dessine en trait.
class DistributionPainter extends CustomPainter {
  const DistributionPainter({
    required this.result,
    required this.length,
    required this.elementWidth,
    required this.startOffset,
    required this.endOffset,
    required this.l10n,
  });

  final DistributionResult? result;
  final double length;
  final double elementWidth;
  final double startOffset;
  final double endOffset;
  final AppLocalizations l10n;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final r = result;
    if (r == null || length <= 0 || r.positions.isEmpty) {
      drawSchemaPlaceholder(canvas, size);
      return;
    }

    // Une échelle unique pour les deux axes : la vignette ne s'étire pas.
    final scale = math.min(
      size.width / _designWidth,
      size.height / _designHeight,
    );
    canvas
      ..save()
      ..translate(
        (size.width - _designWidth * scale) / 2,
        (size.height - _designHeight * scale) / 2,
      )
      ..scale(scale);
    _paintDesign(canvas, r);
    canvas.restore();
  }

  /// Le schéma dans la boîte de référence, en coordonnées de [_designWidth]
  /// par [_designHeight].
  void _paintDesign(Canvas canvas, DistributionResult r) {
    const usable = _designWidth - 2 * _sideMargin;
    const paneWidth = (usable - 2 * _paneInset - _paneGutter) / 2;

    final overview = SchemaViewport.fit(
      rect: const Rect.fromLTWH(
        _sideMargin,
        _overviewBarTop,
        usable,
        _overviewBarThickness,
      ),
      spanMm: length,
    );
    _paintPiece(
      canvas,
      r,
      overview,
      clip: Path()..addRect(overview.rect.inflate(kOutlineStroke)),
    );
    for (final x in [overview.x(0), overview.x(length)]) {
      drawExtensionLine(
        canvas,
        Offset(x, overview.rect.top - kExtensionGap),
        Offset(x, _totalDimY - kExtensionOvershoot),
      );
    }
    drawHDimension(
      canvas,
      x1: overview.x(0),
      x2: overview.x(length),
      y: _totalDimY,
      label: l10n.number(length),
      ticks: false,
    );

    final starts = _startDimensions(r);
    final ends = _endDimensions(r);
    final reach = math.max(
      starts.fold(0.0, (m, d) => math.max(m, d.$2)),
      length - ends.fold(length, (m, d) => math.min(m, d.$1)),
    );

    final zoom = _zoomFor(
      reach <= _epsilon ? 1 : (paneWidth / reach) / overview.scale,
    );
    final scale = zoom * overview.scale;
    final window = paneWidth / scale;

    const paneRect = Rect.fromLTWH(
      _sideMargin + _paneInset,
      _detailBarTop,
      paneWidth,
      _detailBarThickness,
    );
    final start = SchemaViewport(rect: paneRect, originMm: 0, scale: scale);
    final end = SchemaViewport(
      rect: paneRect.translate(paneWidth + _paneGutter, 0),
      originMm: length - window,
      scale: scale,
    );

    _paintTitle(canvas, l10n.distributionSchemaStart, start);
    _paintTitle(canvas, l10n.distributionSchemaEnd, end);

    _paintPiece(canvas, r, start, clip: _brokenPane(start, breakRight: true));
    _paintPiece(canvas, r, end, clip: _brokenPane(end, breakRight: false));
    for (final x in [start.rect.right, end.rect.left]) {
      drawBreakLine(
        canvas,
        x: x,
        y1: paneRect.top - _breakOverhang,
        y2: paneRect.bottom + _breakOverhang,
      );
    }

    _paintDimensions(canvas, starts, start, labelSide: -1);
    _paintDimensions(canvas, ends, end, labelSide: 1);
    _paintLegend(canvas, zoom);
  }

  /// La zone de matière d'un panneau, fermée par la ligne brisée du côté coupé.
  ///
  /// Détourée sur le zigzag, pour que la matière ne déborde pas des dents.
  Path _brokenPane(SchemaViewport view, {required bool breakRight}) {
    final top = view.rect.top - _breakOverhang;
    final bottom = view.rect.bottom + _breakOverhang;
    final points = schemaBreakPoints(
      x: breakRight ? view.rect.right : view.rect.left,
      y1: top,
      y2: bottom,
    );
    // Élargi d'un filet : découpé sur l'arête, le filet perdrait sa moitié.
    final far = breakRight
        ? view.rect.left - kOutlineStroke
        : view.rect.right + kOutlineStroke;

    final path = Path()..moveTo(far, top);
    for (final point in points) {
      path.lineTo(point.dx, point.dy);
    }
    return path
      ..lineTo(far, bottom)
      ..close();
  }

  /// Les cotes du panneau de début : marge, premier élément, premier écart.
  ///
  /// L'écart coté est le premier rencontré, avant ou après le premier élément.
  List<_Dim> _startDimensions(DistributionResult r) {
    final first = r.positions.first;
    return [
      if (startOffset > _epsilon) (0.0, startOffset, 0),
      if (elementWidth > _epsilon) (first, first + elementWidth, 1),
      if (first - startOffset > _epsilon)
        (startOffset, first, 2)
      else if (r.positions.length > 1)
        (first + elementWidth, r.positions[1], 2),
    ];
  }

  /// Les cotes du panneau de fin, en miroir de [_startDimensions].
  List<_Dim> _endDimensions(DistributionResult r) {
    final lastStart = r.positions.last;
    final lastEnd = lastStart + elementWidth;
    final inner = length - endOffset;
    return [
      if (endOffset > _epsilon) (inner, length, 0),
      if (elementWidth > _epsilon) (lastStart, lastEnd, 1),
      if (inner - lastEnd > _epsilon)
        (lastEnd, inner, 2)
      else if (r.positions.length > 1)
        (r.positions[r.positions.length - 2] + elementWidth, lastStart, 2),
    ];
  }

  /// La pièce dans une bande : matière, marges hachurées, éléments.
  ///
  /// Fond beige : en blanc, la pièce se confondrait avec la feuille. Le contour
  /// court sur toute la pièce, [clip] n'en montre que la part du panneau.
  void _paintPiece(
    Canvas canvas,
    DistributionResult r,
    SchemaViewport view, {
    required Path clip,
  }) {
    canvas
      ..save()
      ..clipPath(clip);

    final rect = Rect.fromLTRB(
      view.x(0),
      view.rect.top,
      view.x(length),
      view.rect.bottom,
    );
    final elements = _elementRects(r, view);

    // Aplats d'abord, traits ensuite : un aplat posé après un trait le rogne.
    canvas.drawRect(rect, Paint()..color = AppColors.field);
    _paintOffsets(canvas, view);
    final fill = Paint()..color = AppColors.accent;
    for (final element in elements) {
      canvas.drawRect(element, fill);
    }

    // Seulement les deux chants d'un élément : les arêtes horizontales
    // appartiennent à la pièce.
    final chant = Paint()
      ..color = AppColors.accentDeep
      ..strokeWidth = kDimStroke;
    for (final element in elements) {
      for (final x in [element.left, element.right]) {
        canvas.drawLine(
          Offset(x, element.top),
          Offset(x, element.bottom),
          chant,
        );
      }
    }

    // Le filet de la pièce en dernier, pour que les chants ne le coupent pas.
    canvas
      ..drawRect(
        rect,
        Paint()
          ..color = kSchemaInk
          ..style = PaintingStyle.stroke
          ..strokeWidth = kOutlineStroke,
      )
      ..restore();
  }

  /// Les marges, hachurées : réservées, jamais garnies.
  void _paintOffsets(Canvas canvas, SchemaViewport view) {
    final zones = <(double, double)>[
      if (startOffset > 0) (0.0, startOffset),
      if (endOffset > 0) (length - endOffset, length),
    ];
    if (zones.isEmpty) return;

    final paint = Paint()
      ..color = kExtensionLine
      ..strokeWidth = kDimStroke;

    for (final (from, to) in zones) {
      // Détouré à la fenêtre : au zoom, une marge hors champ ferait des
      // milliers de traits invisibles.
      final rect = Rect.fromLTRB(
        view.x(from),
        view.rect.top,
        view.x(to),
        view.rect.bottom,
      ).intersect(view.rect);
      if (rect.isEmpty) continue;

      canvas
        ..save()
        ..clipRect(rect);
      // Hachures à 45°, posées large puis détourées par le clip.
      for (var x = rect.left - rect.height; x < rect.right; x += 6) {
        canvas.drawLine(
          Offset(x, rect.bottom),
          Offset(x + rect.height, rect.top),
          paint,
        );
      }
      canvas.restore();
    }
  }

  /// Les éléments à l'échelle, limités à ceux que la fenêtre montre.
  List<Rect> _elementRects(DistributionResult r, SchemaViewport view) {
    final rects = <Rect>[];
    for (final position in r.positions) {
      final left = view.x(position);
      // Les positions sont croissantes : passé le bord droit, c'est fini.
      if (left > view.rect.right) break;
      final right = view.x(position + elementWidth);
      if (right < view.rect.left) continue;

      // Toute la hauteur de la bande : un élément traverse la pièce.
      rects.add(
        Rect.fromLTRB(
          left,
          view.rect.top,
          left + (right - left).clamp(_minElementPixels, double.infinity),
          view.rect.bottom,
        ),
      );
    }
    return rects;
  }

  /// Le titre d'un panneau, centré au-dessus de lui.
  void _paintTitle(Canvas canvas, String label, SchemaViewport view) {
    final text = schemaText(label, size: 9);
    text.paint(canvas, Offset(view.rect.center.dx - text.width / 2, _titleTop));
  }

  /// Les cotes d'un panneau, chacune à son étage, rattachées à la pièce.
  ///
  /// [labelSide] envoie les chiffres serrés hors de la pièce : dedans, ils
  /// croiseraient les attaches de l'étage voisin.
  void _paintDimensions(
    Canvas canvas,
    List<_Dim> dims,
    SchemaViewport view, {
    required double labelSide,
  }) {
    // Une attache par abscisse, jusqu'à son étage le plus bas : deux traits
    // superposés se voient, par leurs bords adoucis.
    final reaches = <double, double>{};
    for (final (from, to, level) in dims) {
      final lineY = _firstLevelY + level * _levelStep;
      for (final x in [view.x(from), view.x(to)]) {
        reaches[x] = math.max(reaches[x] ?? lineY, lineY);
      }
    }
    reaches.forEach(
      (x, lineY) => drawExtensionLine(
        canvas,
        Offset(x, view.rect.bottom + kExtensionGap),
        Offset(x, lineY + kExtensionOvershoot),
      ),
    );

    for (final (from, to, level) in dims) {
      final lineY = _firstLevelY + level * _levelStep;
      final x1 = view.x(from);
      final x2 = view.x(to);
      drawHDimension(
        canvas,
        x1: x1,
        x2: x2,
        y: lineY,
        label: l10n.number(to - from),
        tight: true,
        labelSide: labelSide,
        ticks: false,
        bounds: const Rect.fromLTWH(0, 0, _designWidth, _designHeight),
      );
    }
  }

  /// L'unité du dessin et le rapport d'agrandissement des panneaux, écrits
  /// sous le dessin.
  void _paintLegend(Canvas canvas, double zoom) {
    final text = schemaText(
      l10n.distributionSchemaLegend(l10n.number(zoom)),
      size: 9,
    );
    text.paint(canvas, Offset((_designWidth - text.width) / 2, _legendTop));
  }

  @override
  bool shouldRepaint(DistributionPainter old) =>
      old.result != result ||
      old.length != length ||
      old.elementWidth != elementWidth ||
      old.startOffset != startOffset ||
      old.endOffset != endOffset ||
      old.l10n.localeName != l10n.localeName;
}

/// Le pictogramme d'un couple de bords, pour les tuiles de choix.
///
/// Dessiné : « Écart – Élément » et « Élément – Écart » se distinguent mal
/// écrits, et seraient tronqués dans le sélecteur segmenté.
class EdgePreviewPainter extends CustomPainter {
  const EdgePreviewPainter({
    required this.startEdge,
    required this.endEdge,
    required this.selected,
  });

  final DistributionEdge startEdge;
  final DistributionEdge endEdge;
  final bool selected;

  /// Un début, un milieu et une fin.
  static const int _count = 3;

  static const double _elementWidth = 9;
  static const double _elementHeight = 18;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final centerY = size.height / 2;
    final edges =
        (startEdge == DistributionEdge.element ? 1 : 0) +
        (endEdge == DistributionEdge.element ? 1 : 0);
    final gaps = _count + 1 - edges;

    const left = 2.0;
    final right = size.width - 2;
    final span = right - left;
    final spacing = (span - _count * _elementWidth) / gaps;
    if (spacing < 0) return;

    final tone = selected ? AppColors.accentDeep : AppColors.label;

    final fill = Paint()
      ..color = selected ? AppColors.accent : AppColors.label
      ..style = selected ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final first = left + (startEdge == DistributionEdge.element ? 0 : spacing);
    for (var i = 0; i < _count; i++) {
      final x = first + i * (_elementWidth + spacing);
      canvas.drawRect(
        Rect.fromLTWH(
          x,
          centerY - _elementHeight / 2,
          _elementWidth,
          _elementHeight,
        ),
        fill,
      );
    }

    // Les jeux en pointillé : égaux, sans valeur.
    final dash = Paint()
      ..color = tone.withValues(alpha: 0.7)
      ..strokeWidth = 1;
    var cursor = left;
    for (var i = 0; i <= _count; i++) {
      final next = i < _count ? first + i * (_elementWidth + spacing) : right;
      if (next - cursor > 1) {
        for (var x = cursor + 1; x < next - 1; x += 3) {
          canvas.drawLine(
            Offset(x, centerY),
            Offset((x + 1.5).clamp(x, next - 1), centerY),
            dash,
          );
        }
      }
      cursor = next + _elementWidth;
    }

    // Les montants en dernier : un élément collé au bord les recouvrirait.
    final edgePaint = Paint()
      ..color = tone
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (final x in [left, right]) {
      canvas.drawLine(
        Offset(x, centerY - _elementHeight / 2 - 3),
        Offset(x, centerY + _elementHeight / 2 + 3),
        edgePaint,
      );
    }
  }

  @override
  bool shouldRepaint(EdgePreviewPainter old) =>
      old.startEdge != startEdge ||
      old.endEdge != endEdge ||
      old.selected != selected;
}
