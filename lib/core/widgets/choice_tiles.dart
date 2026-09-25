import 'package:flutter/material.dart';

import '../../app/theme.dart';

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
/// Pour les choix que des segments tronqueraient (« Élément – Élément »,
/// « Devant et dos recouvrants »), et que le dessin explique mieux que la
/// phrase.
class ChoiceTiles<T> extends StatelessWidget {
  const ChoiceTiles({
    required this.tiles,
    required this.value,
    required this.onChanged,
    this.columns = 2,
    super.key,
  });

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
          // `IntrinsicHeight` : une tuile dont le libellé passe à la ligne ne
          // doit pas laisser sa voisine plus courte.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var col = 0; col < columns; col++) ...[
                  if (col > 0) const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: row * columns + col < tiles.length
                        ? _Tile(
                            tile: tiles[row * columns + col],
                            selected: tiles[row * columns + col].value == value,
                            onTap: onChanged,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
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
  final ValueChanged<T> onTap;

  static const double _previewHeight = 30;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: () => onTap(tile.value),
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
                  // Deux lignes : mieux vaut voir un libellé passer à la ligne
                  // que se faire couper.
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
