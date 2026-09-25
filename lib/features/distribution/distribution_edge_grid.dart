import 'package:flutter/material.dart';

import '../../core/calc/distribution.dart';
import '../../core/widgets/choice_tiles.dart';
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
    return ChoiceTiles<EdgeChoice>(
      tiles: [
        for (final choice in kEdgeChoices)
          ChoiceTile(
            value: choice,
            label: choice.label,
            preview: ({required selected}) => EdgePreviewPainter(
              startEdge: choice.start,
              endEdge: choice.end,
              selected: selected,
            ),
          ),
      ],
      // Les instances de [kEdgeChoices] sont constantes : l'égalité par
      // identité suffit à retrouver la tuile sélectionnée.
      value: kEdgeChoices.firstWhere(
        (c) => c.start == startEdge && c.end == endEdge,
      ),
      onChanged: (choice) => onChanged(choice.start, choice.end),
    );
  }
}
