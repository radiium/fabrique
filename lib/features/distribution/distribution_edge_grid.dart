import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/distribution.dart';
import 'distribution_form.dart';
import 'distribution_painter.dart';

/// Les quatre dispositions, en grille 2 × 2.
///
/// Quatre segments sur une ligne donneraient 90 px par libellé : « Élément –
/// Élément » y serait tronqué en silence. La grille laisse la place au
/// pictogramme, qui est de toute façon plus lisible que la phrase.
class EdgeChoiceGrid extends StatelessWidget {
  const EdgeChoiceGrid({
    required this.startEdge,
    required this.endEdge,
    required this.onChanged,
    super.key,
  });

  final DistributionEdge startEdge;
  final DistributionEdge endEdge;
  final void Function(DistributionEdge start, DistributionEdge end) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row = 0; row < 2; row++) ...[
          if (row > 0) const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (var col = 0; col < 2; col++) ...[
                if (col > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _EdgeTile(
                    choice: kEdgeChoices[row * 2 + col],
                    selected:
                        kEdgeChoices[row * 2 + col].start == startEdge &&
                        kEdgeChoices[row * 2 + col].end == endEdge,
                    onTap: onChanged,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _EdgeTile extends StatelessWidget {
  const _EdgeTile({
    required this.choice,
    required this.selected,
    required this.onTap,
  });

  final EdgeChoice choice;
  final bool selected;
  final void Function(DistributionEdge start, DistributionEdge end) onTap;

  static const double _previewHeight = 30;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: () => onTap(choice.start, choice.end),
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: _previewHeight,
                  child: CustomPaint(
                    painter: EdgePreviewPainter(
                      startEdge: choice.start,
                      endEdge: choice.end,
                      selected: selected,
                    ),
                    size: Size.infinite,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  choice.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: selected ? AppColors.accentDeep : AppColors.label,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                  // Deux lignes : « Élément – Élément » ne tient pas sur une
                  // seule à cette largeur, et il vaut mieux le voir passer à
                  // la ligne que se faire couper.
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
