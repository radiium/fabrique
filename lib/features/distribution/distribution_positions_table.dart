import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import '../../core/calc/distribution.dart';
import '../../core/format.dart';

/// Les cotes de pose en table numérotée plutôt qu'en ruban `250 · 500 · 750`.
///
/// Le geste réel, c'est lire une position, tracer, lire la suivante, tracer —
/// sur un ruban qui passe à la ligne, on perd sa place et on recompte à chaque
/// trait. Numérotées, les positions se retrouvent : « l'élément 7 ».
///
/// Deux colonnes dès qu'il y a une épaisseur : on trace au bord quand on pose
/// à la règle, au centre quand on perce. La colonne centre disparaît pour des
/// points purs, où les deux se confondent.
///
/// Chiffres tabulaires **alignés à droite** : unités sous unités, centaines
/// sous centaines, donc un entraxe irrégulier se verrait à l'œil. En
/// `titleMedium` et non en [controlTextStyle] — ici on a le nez sur l'écran avec
/// un crayon, c'est le repérage qui compte, pas la lecture à bout de bras, et
/// quinze lignes à 22 px ne tiendraient nulle part.
class PositionsTable extends StatelessWidget {
  const PositionsTable({
    required this.result,
    required this.hasWidth,
    super.key,
  });

  /// `null` = saisie refusée, distinct d'une liste vide (zéro élément demandé).
  final DistributionResult? result;

  final bool hasWidth;

  /// Largeur de la colonne N°, **mesurée** sur le plus large de ses contenus
  /// (l'en-tête ou le dernier numéro) plutôt que fixée. Une largeur ronde y
  /// laisserait du mou : les numéros sont cadrés à droite, donc ce mou tombe
  /// entièrement à gauche du chiffre et s'ajoute à [_cellPadding] — la première
  /// cellule aurait alors trois fois le blanc de la dernière. Collée au
  /// contenu, la colonne rend le rembourrage de la ligne visible tel quel des
  /// deux côtés.
  static double _indexColumnWidth(
    String widestIndex,
    TextStyle? headerStyle,
    TextStyle? cellStyle,
  ) {
    double widthOf(String text, TextStyle? style) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      return painter.width;
    }

    return math.max(
      widthOf(_indexHeader, headerStyle),
      widthOf(widestIndex, cellStyle),
    );
  }

  static const String _indexHeader = 'N°';

  /// Le tableau tient la gouttière de [AppSpacing.md] de la carte, comme tout
  /// le reste — c'est la rayure qui commence et finit sur cette ligne. Les
  /// cellules, elles, rentrent de [AppSpacing.sm] : sans ça le dernier chiffre,
  /// cadré à droite, toucherait le bord de la rayure. Porté par les lignes et
  /// par l'en-tête, jamais par le titre, sinon les colonnes décrocheraient.
  static const EdgeInsets _cellPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.sm,
  );

  Future<void> _copy(BuildContext context, DistributionResult r) async {
    final messenger = ScaffoldMessenger.of(context);
    // Une position par ligne, colonnes séparées par une tabulation : ça tombe
    // dans un tableur, là où le point médian de l'affichage ne se colle nulle
    // part.
    final lines = [
      for (final (i, position) in r.positions.indexed)
        hasWidth
            ? '${formatNumber(position)}\t${formatNumber(r.centers[i])}'
            : formatNumber(position),
    ];
    await Clipboard.setData(ClipboardData(text: lines.join('\n')));
    messenger.showSnackBar(const SnackBar(content: Text('Copié')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = result;
    final hasRows = r != null && r.positions.isNotEmpty;

    final headerStyle = theme.textTheme.bodySmall?.copyWith(
      color: AppColors.label,
    );
    final cellStyle = theme.textTheme.titleMedium?.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final indexWidth = _indexColumnWidth(
      '${hasRows ? r.positions.length : 0}',
      headerStyle,
      cellStyle,
    );

    return InkWell(
      // Même geste que sur une ResultTile : un tap copie tout.
      onTap: hasRows ? () => _copy(context, r) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Positions depuis l’origine',
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                if (hasRows) const Icon(Icons.copy_outlined),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (!hasRows)
              Text(
                r == null ? kNoValue : 'Aucun élément',
                style: theme.textTheme.titleLarge,
              )
            else ...[
              // L'unité va dans l'en-tête : elle qualifie la colonne entière,
              // pas chaque ligne — la répéter quinze fois serait du bruit.
              Padding(
                padding: _cellPadding,
                child: Row(
                  children: [
                    SizedBox(
                      width: indexWidth,
                      child: Text(
                        _indexHeader,
                        style: headerStyle,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        hasWidth ? 'Bord (mm)' : 'Position (mm)',
                        style: headerStyle,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    if (hasWidth) ...[
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'Centre (mm)',
                          style: headerStyle,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              for (final (i, position) in r.positions.indexed)
                DecoratedBox(
                  decoration: BoxDecoration(
                    // Rayures discrètes : de l'accroche pour l'œil qui
                    // redescend la colonne entre deux traits de crayon.
                    color: i.isOdd ? AppColors.field : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadii.field),
                  ),
                  child: Padding(
                    padding: _cellPadding.add(
                      const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: indexWidth,
                          child: Text(
                            '${i + 1}',
                            style: cellStyle?.copyWith(color: AppColors.label),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            formatNumber(position),
                            style: cellStyle,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        if (hasWidth) ...[
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              formatNumber(r.centers[i]),
                              style: cellStyle,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
