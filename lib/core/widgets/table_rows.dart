import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Retrait des cellules dans la rayure, pour que le dernier chiffre ne touche
/// pas le bord. Lignes et en-tête seulement, jamais le titre.
const EdgeInsets kTableCellPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.sm,
);

/// Style des en-têtes de colonne, qui portent l'unité.
TextStyle? tableHeaderStyle(ThemeData theme) =>
    theme.textTheme.bodySmall?.copyWith(color: AppColors.label);

/// Style des cellules : chiffres tabulaires.
TextStyle? tableCellStyle(ThemeData theme) => theme.textTheme.titleMedium
    ?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

/// L'en-tête d'une table, aligné sur les cellules de [TableStripeRow].
class TableHeaderRow extends StatelessWidget {
  const TableHeaderRow({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: kTableCellPadding.add(
      const EdgeInsets.only(bottom: AppSpacing.xs),
    ),
    child: child,
  );
}

/// Une ligne de table, rayée une fois sur deux.
///
/// La première ligne reste nue, pour se détacher de l'en-tête.
class TableStripeRow extends StatelessWidget {
  const TableStripeRow({required this.index, required this.child, super.key});

  /// Rang de la ligne, à partir de 0.
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: index.isOdd ? AppColors.field : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadii.field),
    ),
    child: Padding(
      padding: kTableCellPadding.add(
        const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      ),
      child: child,
    ),
  );
}
