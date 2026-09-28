import 'package:flutter/material.dart';

import '../../core/calc/distribution.dart';
import '../../core/widgets/choice_tiles.dart';
import '../../l10n/app_localizations.dart';
import 'distribution_form.dart';
import 'distribution_painter.dart';

/// Les quatre dispositions, en grille 2 × 2.
///
/// En segments, « Élément – Élément » serait tronqué.
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
    final l10n = AppLocalizations.of(context);
    return ChoiceTiles<EdgeChoice>(
      tiles: [
        for (final choice in kEdgeChoices)
          ChoiceTile(
            value: choice,
            label: choice.label(l10n),
            preview: ({required selected}) => EdgePreviewPainter(
              startEdge: choice.start,
              endEdge: choice.end,
              selected: selected,
            ),
          ),
      ],
      // Instances constantes : l'identité suffit.
      value: kEdgeChoices.firstWhere(
        (c) => c.start == startEdge && c.end == endEdge,
      ),
      onChanged: (choice) => onChanged(choice.start, choice.end),
    );
  }
}
