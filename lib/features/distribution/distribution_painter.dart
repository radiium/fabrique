import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/distribution.dart';
import '../../core/format.dart';
import '../../core/painting.dart';

/// Marge latérale, pour que les cotes d'extrémité ne butent pas sur le bord.
const double _sideMargin = 20;

/// Épaisseur de la barre représentant la pièce.
const double _barThickness = 26;

/// Débord d'un tiret d'extrémité de part et d'autre de la barre.
const double _endTickOverhang = 9;

/// Écart barre ↔ ligne de cote, au-dessus et en dessous.
const double _totalGap = 34;
const double _chainGap = 28;

/// Un élément plus fin que ça deviendrait invisible : on le dessine quand même
/// à cette largeur, quitte à mentir d'un pixel. C'est aussi ce qui donne sa
/// forme au cas `largeur = 0` — un trait, pas un disque.
const double _minElementPixels = 2;

/// Tolérance de comparaison en mm : sert à ne pas coter un jeu nul.
const double _epsilon = 1e-6;

/// La rangée, cotée : largeur totale au-dessus, chaîne des jeux en dessous.
///
/// **Une seule grammaire, quelle que soit la largeur** : des rectangles à
/// l'échelle, qu'une largeur nulle réduit à un trait. Le dessin reste alors
/// continu quand on fait varier l'épaisseur — un basculement vers des disques
/// laisserait croire à un autre modèle là où il n'y en a qu'un, et ferait
/// sauter le schéma sous le doigt à chaque passage par zéro.
///
/// On voit directement ce que les bords changent : un élément collé au tiret
/// d'extrémité, ou un jeu avant lui. Les marges sont hachurées — la zone
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
  });

  final DistributionResult? result;
  final double length;
  final double elementWidth;
  final double startOffset;
  final double endOffset;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final r = result;
    if (r == null || length <= 0) {
      drawSchemaPlaceholder(canvas, size);
      return;
    }

    final usable = size.width - 2 * _sideMargin;
    if (usable <= 0) return;

    // mm → px. C'est la seule « math » du painter : une mise à l'échelle.
    double dx(double mm) => _sideMargin + usable * (mm / length);

    final centerY = size.height / 2;
    final barTop = centerY - _barThickness / 2;
    final barBottom = centerY + _barThickness / 2;

    _paintBar(canvas, dx(0), dx(length), barTop, barBottom);
    _paintOffsets(canvas, dx, barTop, barBottom);
    _paintTotal(canvas, dx, barTop - _totalGap);
    _paintElements(canvas, r, dx, barTop, barBottom, usable);
    _paintEndTicks(canvas, dx, barTop, barBottom);
    _paintChain(canvas, r, dx, barBottom + _chainGap);
  }

  /// La pièce : un rectangle clair posé sur la carte teintée.
  void _paintBar(
    Canvas canvas,
    double left,
    double right,
    double top,
    double bottom,
  ) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTRB(left, top, right, bottom),
      const Radius.circular(3),
    );
    canvas
      ..drawRRect(rect, Paint()..color = AppColors.surface)
      ..drawRRect(
        rect,
        Paint()
          ..color = AppColors.border
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
  }

  /// Les marges, hachurées : réservées, jamais garnies.
  void _paintOffsets(
    Canvas canvas,
    double Function(double) dx,
    double top,
    double bottom,
  ) {
    final zones = <(double, double)>[
      if (startOffset > 0) (0, startOffset),
      if (endOffset > 0) (length - endOffset, length),
    ];
    if (zones.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.label.withValues(alpha: 0.35)
      ..strokeWidth = 1;

    for (final (from, to) in zones) {
      final rect = Rect.fromLTRB(dx(from), top, dx(to), bottom);
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

  /// Les extrémités — un tiret, jamais un élément. C'est ce contraste qui
  /// porte la règle « les extrémités ne sont pas des points ».
  void _paintEndTicks(
    Canvas canvas,
    double Function(double) dx,
    double barTop,
    double barBottom,
  ) {
    final paint = Paint()
      ..color = AppColors.label
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (final mm in [0.0, length]) {
      canvas.drawLine(
        Offset(dx(mm), barTop - _endTickOverhang),
        Offset(dx(mm), barBottom + _endTickOverhang),
        paint,
      );
    }
  }

  /// Cote d'ensemble au-dessus de la barre.
  void _paintTotal(Canvas canvas, double Function(double) dx, double y) {
    drawHDimension(
      canvas,
      x1: dx(0),
      x2: dx(length),
      y: y,
      label: '${formatNumber(length)} mm',
    );
  }

  /// Les éléments à l'échelle, numérotés quand la place le permet. Une largeur
  /// nulle passe ici comme les autres : le `clamp` en fait un trait.
  void _paintElements(
    Canvas canvas,
    DistributionResult r,
    double Function(double) dx,
    double barTop,
    double barBottom,
    double usable,
  ) {
    if (r.positions.isEmpty) return;

    final fill = Paint()..color = AppColors.accent;
    final stroke = Paint()
      ..color = AppColors.accentDeep
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final top = barTop + 3;
    final bottom = barBottom - 3;

    for (final position in r.positions) {
      final left = dx(position);
      final right = dx(position + elementWidth);
      final rect = Rect.fromLTRB(
        left,
        top,
        // Un bardage serré ne doit pas se résoudre en une trame vide.
        left + (right - left).clamp(_minElementPixels, double.infinity),
        bottom,
      );
      canvas
        ..drawRect(rect, fill)
        ..drawRect(rect, stroke);
    }

    _paintIndices(canvas, r, dx, barTop, usable * r.pitch / length);
  }

  /// Le numéro d'ordre au-dessus de chaque élément — c'est ce qui relie le
  /// schéma à la table de positions des résultats.
  void _paintIndices(
    Canvas canvas,
    DistributionResult r,
    double Function(double) dx,
    double barTop,
    double pitchPixels,
  ) {
    // Mesuré sur le plus long des numéros : si le dernier tient, tous tiennent.
    final widest = schemaText('${r.count}', size: 10);
    if (widest.width + 6 > pitchPixels) return;

    for (final (i, position) in r.positions.indexed) {
      final label = schemaText('${i + 1}', size: 10);
      label.paint(
        canvas,
        Offset(
          dx(position + elementWidth / 2) - label.width / 2,
          barTop - 15 - label.height / 2,
        ),
      );
    }
  }

  /// La chaîne de cotes : marges, jeux, dans l'ordre où on les lit.
  ///
  /// Les segments se déduisent des positions, sans rejouer le choix des bords :
  /// entre deux éléments voisins il y a un jeu, et s'il reste de la place avant
  /// le premier ou après le dernier, c'en est un aussi.
  void _paintChain(
    Canvas canvas,
    DistributionResult r,
    double Function(double) dx,
    double y,
  ) {
    // Le booléen dit « ceci est un jeu » : seuls les jeux appellent la légende
    // de repli, une marge trop étroite pour son chiffre n'a rien à voir avec
    // la règle qu'elle énonce.
    final segments = <(double, double, bool)>[];
    if (startOffset > _epsilon) segments.add((0, startOffset, false));

    var cursor = startOffset;
    for (final position in r.positions) {
      if (position - cursor > _epsilon) segments.add((cursor, position, true));
      cursor = position + elementWidth;
    }

    final lastGapEnd = length - endOffset;
    if (lastGapEnd - cursor > _epsilon) {
      segments.add((cursor, lastGapEnd, true));
    }
    if (endOffset > _epsilon) segments.add((lastGapEnd, length, false));

    if (segments.isEmpty) return;

    var allLabelled = true;
    for (final (from, to, isGap) in segments) {
      final placed = drawHDimension(
        canvas,
        x1: dx(from),
        x2: dx(to),
        y: y,
        label: formatNumber(to - from),
      );
      allLabelled = allLabelled && (placed || !isGap);
    }

    // Quand les cotes ne tiennent plus une par une, une seule légende dit la
    // même chose — et énonce la règle en toutes lettres.
    if (!allLabelled) {
      final caption = schemaText(
        '${r.gapCount} × ${formatNumber(r.spacing)} mm',
      );
      caption.paint(
        canvas,
        Offset((dx(0) + dx(length) - caption.width) / 2, y + kDimTick + 6),
      );
    }
  }

  @override
  bool shouldRepaint(DistributionPainter old) =>
      old.result != result ||
      old.length != length ||
      old.elementWidth != elementWidth ||
      old.startOffset != startOffset ||
      old.endOffset != endOffset;
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

    final left = 2.0;
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
