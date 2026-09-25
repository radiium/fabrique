import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/drawers.dart';
import '../../core/format.dart';

/// La fiche de débit : une ligne par groupe de pièces identiques.
///
/// Deux colonnes et non cinq : sur un téléphone, pièce, quantité, longueur,
/// largeur et épaisseur côte à côte tomberaient à 60 px chacune. Les trois
/// cotes se lisent d'un bloc (`500 × 180 × 15`), dans l'ordre de l'en-tête.
class CutListTable extends StatelessWidget {
  const CutListTable({required this.pieces, super.key});

  /// `null` = saisie refusée.
  final List<CutPiece>? pieces;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.labelMedium?.copyWith(
      color: AppColors.label,
    );
    final cellStyle = theme.textTheme.titleMedium?.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final pieces = this.pieces;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Fiche de débit', style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          if (pieces == null)
            Text(kNoValue, style: theme.textTheme.titleLarge)
          else ...[
            Row(
              children: [
                Expanded(child: Text('Pièce', style: headerStyle)),
                Text('L × l × ép (mm)', style: headerStyle),
              ],
            ),
            for (final (i, piece) in pieces.indexed)
              Container(
                color: i.isEven ? AppColors.field : null,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${piece.part.label} ×${piece.quantity}',
                        style: cellStyle,
                      ),
                    ),
                    Text(
                      '${formatNumber(piece.length)} × '
                      '${formatNumber(piece.width)} × '
                      '${formatNumber(piece.thickness)}',
                      style: cellStyle,
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
