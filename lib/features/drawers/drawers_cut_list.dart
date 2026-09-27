import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import '../../core/calc/drawers.dart';
import '../../core/format.dart';
import '../../core/widgets/haptics.dart';
import '../../core/widgets/table_rows.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/numbers.dart';
import 'drawers_labels.dart';

/// La fiche de débit : une ligne par groupe de pièces identiques.
///
/// Deux colonnes et non cinq : sur un téléphone, pièce, quantité, longueur,
/// largeur et épaisseur côte à côte tomberaient à 60 px chacune. Les trois
/// cotes se lisent d'un bloc (`500 × 180 × 15`), dans l'ordre de l'en-tête.
class CutListTable extends StatelessWidget {
  const CutListTable({required this.pieces, super.key});

  /// `null` = saisie refusée.
  final List<CutPiece>? pieces;

  /// Une pièce par ligne, colonnes séparées par une tabulation : ça tombe dans
  /// un tableur, avec la quantité dans sa propre colonne pour qu'on puisse la
  /// multiplier.
  Future<void> _copy(BuildContext context, List<CutPiece> pieces) async {
    hapticSelection(context);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    final lines = [
      for (final piece in pieces)
        [
          piece.part.label(l10n),
          '${piece.quantity}',
          l10n.number(piece.length),
          l10n.number(piece.width),
          l10n.number(piece.thickness),
        ].join('\t'),
    ];
    await Clipboard.setData(ClipboardData(text: lines.join('\n')));
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.commonCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final headerStyle = tableHeaderStyle(theme);
    final cellStyle = tableCellStyle(theme);
    final pieces = this.pieces;

    return InkWell(
      // Même geste que sur une ResultTile : un tap copie tout.
      onTap: pieces == null ? null : () => _copy(context, pieces),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.drawersCutList,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                if (pieces != null) const Icon(Icons.copy_outlined),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (pieces == null)
              Text(kNoValue, style: theme.textTheme.titleLarge)
            else ...[
              TableHeaderRow(
                child: Row(
                  children: [
                    Text(l10n.drawersCutListPart, style: headerStyle),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        l10n.drawersCutListSizes,
                        style: headerStyle,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              for (final (i, piece) in pieces.indexed)
                TableStripeRow(
                  index: i,
                  child: Row(
                    children: [
                      Text(
                        '${piece.part.label(l10n)} ×${piece.quantity}',
                        style: cellStyle,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Les cotes cèdent la place, pas la pièce : trop longues,
                      // elles passent à la ligne plutôt que de pousser le nom
                      // hors de la carte.
                      Expanded(
                        child: Text(
                          '${l10n.number(piece.length)} × '
                          '${l10n.number(piece.width)} × '
                          '${l10n.number(piece.thickness)}',
                          style: cellStyle,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
