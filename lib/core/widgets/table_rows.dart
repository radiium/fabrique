import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Retrait des cellules dans la rayure.
///
/// La table tient la gouttière de [AppSpacing.md] de la carte, et c'est la
/// rayure qui commence et finit sur cette ligne. Les cellules rentrent de
/// [AppSpacing.sm] : sans ça le dernier chiffre, cadré à droite, toucherait le
/// bord de la rayure. Porté par les lignes et par l'en-tête, jamais par le
/// titre, sinon les colonnes décrocheraient.
const EdgeInsets kTableCellPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.sm,
);

/// Style des en-têtes de colonne : discret, l'unité y vit une fois pour
/// toute la colonne.
TextStyle? tableHeaderStyle(ThemeData theme) =>
    theme.textTheme.bodySmall?.copyWith(color: AppColors.label);

/// Style des cellules : chiffres tabulaires, pour que les unités tombent sous
/// les unités.
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
/// Rayures discrètes : de l'accroche pour l'œil qui redescend la colonne entre
/// deux traits de crayon. La première ligne reste nue, pour ne pas se coller à
/// l'en-tête.
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
