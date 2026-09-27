import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/distribution.dart';
import '../../core/painting.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/numbers.dart';

/// Marge latérale, pour que les cotes d'extrémité ne butent pas sur le bord.
const double _sideMargin = 20;

/// Gouttière entre les deux panneaux de détail, soit entre leurs deux traits
/// de rupture.
const double _paneGutter = 28;

/// Retrait du bloc des panneaux par rapport à la vue d'ensemble, de chaque
/// côté.
///
/// Avec le retrait et la gouttière, les deux panneaux couvrent 83 % de la
/// largeur de la barre du haut. Sans, ils l'atteignaient à 6 % près et
/// donnaient à lire deux bouts aussi longs que la pièce entière.
const double _paneInset = 12;

/// Épaisseur de la barre, vue d'ensemble puis panneaux.
///
/// Le panneau fait exactement le double de la vue d'ensemble : la matière
/// grossit avec le dessin, sinon un détail agrandi en largeur seulement se lit
/// comme un étirement.
const double _overviewBarThickness = 30;
const double _detailBarThickness = 2 * _overviewBarThickness;

/// Débord d'un trait de rupture, de part et d'autre de la barre.
const double _breakOverhang = 12;

/// Les étages du dessin, en pixels depuis le haut du bloc.
///
/// Des positions absolues et non des proportions : tout ce qui se lit ici est
/// du texte de taille fixe, donc les interlignes ne peuvent pas suivre la
/// hauteur du canvas sans finir par se toucher.
const double _totalDimY = 16;
const double _overviewBarTop = 24;
const double _titleTop = 74;
const double _detailBarTop = 94;
const double _firstLevelY = 178;
const double _legendTop = 242;

/// La boîte dans laquelle le schéma est dessiné, toujours la même.
///
/// **Le dessin ne se recompose pas avec le canvas, il s'y pose en entier.** Un
/// schéma dont la largeur suivrait le canvas et la hauteur ses chiffres se
/// déformerait à chaque redimensionnement — c'est d'ailleurs invisible sur un
/// téléphone et flagrant sur le web. Ici tout est coté dans cette boîte, puis
/// une seule mise à l'échelle uniforme l'amène à la taille disponible.
///
/// Sa largeur est celle de la vignette d'un téléphone de référence, sa hauteur
/// celle qu'il faut à ses trois bandes : le rapport ainsi obtenu est celui que
/// `visualizationAspectRatio` donne à la carte, pour que le facteur y vaille 1
/// et que rien ne soit ni agrandi ni réduit là où l'outil se lit d'abord.
const double _designWidth = 336;
const double _designHeight = 255;

/// Écart entre deux étages de cote, et distance du premier au bas de la barre.
///
/// Les deux valent la même chose, c'est voulu : les trois étages tombent alors
/// à une, deux et trois fois cette distance sous la pièce. Un peigne régulier
/// se lit comme une seule chose, là où trois écarts inégaux donnent à croire
/// qu'ils veulent dire quelque chose.
const double _levelStep = 24;

/// Un élément plus fin que ça deviendrait invisible : on le dessine quand même
/// à cette largeur, quitte à mentir d'un pixel. C'est aussi ce qui donne sa
/// forme au cas `largeur = 0` — un trait, pas un disque.
const double _minElementPixels = 2;

/// Tolérance de comparaison en mm : sert à ne pas coter un jeu nul.
const double _epsilon = 1e-6;

/// Les agrandissements admis pour les panneaux de détail.
///
/// Un rapport rond et écrit sous le dessin plutôt qu'un agrandissement
/// quelconque : le détail reste mesurable, ce qu'un « hors échelle » ne
/// promet pas.
///
/// L'échelle se prend au rang inférieur, pour que le contenu tienne — donc un
/// rang manquant se paie en agrandissement perdu. D'où des demis jusqu'à 3 :
/// le cas courant d'une rangée de cinq tombe vers 1,8, et sans le rang 1,5 il
/// s'arrondirait à 1, c'est-à-dire à des panneaux qui n'agrandissent rien.
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
/// L'étage est fixe par nature de cote (marge, élément, écart) et non attribué
/// au fil des cotes présentes : une marge remise à zéro ferait autrement
/// remonter l'élément et l'écart d'un cran sous les doigts.
typedef _Dim = (double from, double to, int level);

/// La rangée en plan : la pièce entière cotée, puis ses deux bouts agrandis.
///
/// **Une vue d'ensemble ne peut pas coter ce qu'elle montre.** Une marge de
/// 40 mm sur une pièce de 1800 fait deux pixels : le chiffre ne tient pas, et
/// l'élément qu'elle borde encore moins. D'où les deux panneaux, qui reprennent
/// le début et la fin à un agrandissement rond — écrit sous le dessin, pour
/// que le détail reste mesurable. La barre du haut ne porte donc plus que la
/// cote totale, et toutes les autres vivent dans les panneaux.
///
/// **Une seule grammaire, quelle que soit la largeur** : des rectangles à
/// l'échelle, qu'une largeur nulle réduit à un trait. Le dessin reste alors
/// continu quand on fait varier l'épaisseur — un basculement vers des disques
/// laisserait croire à un autre modèle là où il n'y en a qu'un, et ferait
/// sauter le schéma sous le doigt à chaque passage par zéro.
///
/// On voit directement ce que les bords changent : un élément collé au bord de
/// la pièce, ou un jeu avant lui. Les marges sont hachurées — la zone
/// existe, mais rien n'y est réparti.
///
/// Le painter peint, il ne calcule rien : il consomme [result] tel quel et ne
/// fait que passer des millimètres en pixels.
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

    // Une échelle unique pour les deux axes, et le dessin centré dans ce qui
    // reste : c'est ce qui interdit à la vignette de s'étirer.
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

  /// La zone de matière d'un panneau : fermée par la ligne brisée du côté où
  /// elle est coupée, par le bord du panneau des trois autres.
  ///
  /// Détourer sur le zigzag lui-même et non sur une verticale : sinon la
  /// matière déborde des dents et le trait de rupture se pose dessus sans rien
  /// couper.
  Path _brokenPane(SchemaViewport view, {required bool breakRight}) {
    final top = view.rect.top - _breakOverhang;
    final bottom = view.rect.bottom + _breakOverhang;
    final points = schemaBreakPoints(
      x: breakRight ? view.rect.right : view.rect.left,
      y1: top,
      y2: bottom,
    );
    // Le bord opposé porte le filet de la pièce, centré sur l'arête. Découpé
    // pile dessus, il n'en reste que la moitié intérieure, et le coin se lit
    // comme deux rectangles décalés d'une demi-épaisseur.
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
  /// L'écart coté est celui qui se présente en premier — avant le premier
  /// élément quand un bord est un écart, après lui sinon. Les positions
  /// suffisent à le dire, sans rejouer le choix des bords.
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
  /// Le beige des champs et non le blanc : une pièce blanche sur la feuille ne
  /// se distinguerait que par son filet, et les marges hachurées perdraient le
  /// fond sur lequel elles se lisent.
  ///
  /// Le contour dit à lui seul où la pièce s'arrête : il court sur toute la
  /// pièce, et [clip] n'en laisse voir que la part du panneau. Là où le panneau
  /// coupe, c'est la ligne brisée du clip qui ferme la matière, et le trait de
  /// rupture qui se pose dessus.
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

    // Deux passes : tous les aplats, puis tous les traits. Un trait est centré
    // sur l'arête, et un aplat posé après lui en mangerait la moitié.
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

    // Le filet de la pièce en dernier : un élément la traverse de part en
    // part, et son chant ne doit pas trouer le contour.
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
      // Détouré à la fenêtre avant de hachurer : au zoom, une marge hors champ
      // lancerait une boucle sur des milliers de traits invisibles.
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

  /// Les éléments à l'échelle, limités à ceux que la fenêtre montre. Une
  /// largeur nulle passe ici comme les autres : le `clamp` en fait un trait.
  List<Rect> _elementRects(DistributionResult r, SchemaViewport view) {
    final rects = <Rect>[];
    for (final position in r.positions) {
      final left = view.x(position);
      // Les positions sont croissantes : passé le bord droit, c'est fini.
      if (left > view.rect.right) break;
      final right = view.x(position + elementWidth);
      if (right < view.rect.left) continue;

      // Toute la hauteur de la bande : un élément traverse la pièce de part en
      // part, et un jeu au-dessus et en dessous le ferait flotter dedans.
      rects.add(
        Rect.fromLTRB(
          left,
          view.rect.top,
          // Un bardage serré ne doit pas se résoudre en une trame vide.
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
  /// [labelSide] envoie les chiffres serrés **hors** de la pièce, vers la marge
  /// de la feuille. Vers l'intérieur ils tomberaient au-delà des traits
  /// d'attache de l'étage voisin, qui descendent plus bas qu'eux : le chiffre
  /// d'une marge se retrouverait de l'autre côté des attaches de l'élément
  /// qu'elle borde. Dehors, il n'y a rien à traverser.
  void _paintDimensions(
    Canvas canvas,
    List<_Dim> dims,
    SchemaViewport view, {
    required double labelSide,
  }) {
    // Une attache par abscisse, tirée jusqu'à son étage le plus bas : la fin
    // d'une marge est le début d'un élément, et deux traits superposés se
    // voient même opaques, par leurs bords adoucis.
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
  ///
  /// Sans le rapport, rien ne dit qu'un élément est plus gros dans un panneau
  /// que sur la vue d'ensemble. Chiffré plutôt qu'un « hors échelle » : il rend
  /// le détail mesurable au lieu de seulement avertir qu'il ne l'est pas.
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
/// Dessiné plutôt qu'écrit : « Écart – Élément » et « Élément – Écart » se
/// distinguent d'un coup d'œil sur un schéma, presque pas dans une phrase — et
/// un libellé de cette longueur serait de toute façon tronqué en silence par
/// le sélecteur segmenté. Trois éléments suffisent à montrer la règle.
class EdgePreviewPainter extends CustomPainter {
  const EdgePreviewPainter({
    required this.startEdge,
    required this.endEdge,
    required this.selected,
  });

  final DistributionEdge startEdge;
  final DistributionEdge endEdge;
  final bool selected;

  /// Assez pour montrer un début, un milieu et une fin.
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

    // Les jeux, en pointillé : on montre qu'ils sont égaux, pas ce qu'ils
    // valent.
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

    // Les montants en dernier : un élément qui borde les recouvrirait, et la
    // disposition « collée au bord » perdrait justement son bord.
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
