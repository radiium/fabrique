import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'haptics.dart';

/// Une option d'une grille de tuiles : sa valeur, son nom, son pictogramme.
class ChoiceTile<T> {
  const ChoiceTile({
    required this.value,
    required this.label,
    required this.preview,
  });

  final T value;
  final String label;

  /// Le pictogramme, dessiné dans la teinte de l'état sélectionné ou non.
  final CustomPainter Function({required bool selected}) preview;
}

/// Un choix exclusif en tuiles pictogramme + texte, sur [columns] colonnes.
///
/// Pour les choix que des segments tronqueraient et qu'un dessin explique.
class ChoiceTiles<T> extends StatelessWidget {
  const ChoiceTiles({
    required this.tiles,
    required this.value,
    required this.onChanged,
    this.columns = 2,
    super.key,
  }) : assert(columns > 0, 'Il faut au moins une colonne.');

  final List<ChoiceTile<T>> tiles;
  final T value;
  final ValueChanged<T> onChanged;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final rows = (tiles.length / columns).ceil();
    return Column(
      children: [
        for (var row = 0; row < rows; row++) ...[
          if (row > 0) const SizedBox(height: AppSpacing.sm),
          // `IntrinsicHeight` : des tuiles voisines de même hauteur.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var col = 0; col < columns; col++) ...[
                  if (col > 0) const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: switch (tiles.elementAtOrNull(row * columns + col)) {
                      final tile? => _Tile(
                        tile: tile,
                        selected: tile.value == value,
                        onTap: () => _select(context, tile.value),
                      ),
                      // Dernière rangée incomplète : la case vide garde sa largeur.
                      null => const SizedBox.shrink(),
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _select(BuildContext context, T next) {
    if (next == value) return;
    hapticSelection(context);
    onChanged(next);
  }
}

class _Tile<T> extends StatelessWidget {
  const _Tile({
    required this.tile,
    required this.selected,
    required this.onTap,
  });

  final ChoiceTile<T> tile;
  final bool selected;
  final VoidCallback onTap;

  static const double _previewHeight = 30;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.field),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? AppColors.accentWash : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.field),
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              children: [
                SizedBox(
                  height: _previewHeight,
                  child: CustomPaint(
                    painter: tile.preview(selected: selected),
                    size: Size.infinite,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  tile.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: selected ? AppColors.accentDeep : AppColors.label,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                  // Deux lignes plutôt qu'une troncature.
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
