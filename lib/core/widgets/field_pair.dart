import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'labeled_field.dart';
import 'number_field.dart';

/// Deux champs de même famille côte à côte : largeur × longueur, jeu X × jeu Y,
/// marge de début × marge de fin.
///
/// Aucun des deux ne porte de boutons − / + : à cette largeur ils tiennent, là
/// où une paire de champs à pas serait illisible sur un téléphone.
///
/// Si l'un des deux porte un ⓘ, sa ligne de libellé est plus haute : la paire
/// le dit à l'autre ([PairedLabelScope]), sinon les deux champs démarreraient
/// à des hauteurs différentes.
class FieldPair extends StatelessWidget {
  const FieldPair({required this.first, required this.second, super.key});

  final Widget first;
  final Widget second;

  static bool _hasAbout(Widget field) => switch (field) {
    NumberField(:final about) => about != null,
    LabeledField(:final about) => about != null,
    _ => false,
  };

  @override
  Widget build(BuildContext context) {
    return PairedLabelScope(
      tallLabelRow: _hasAbout(first) || _hasAbout(second),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: first),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: second),
        ],
      ),
    );
  }
}
