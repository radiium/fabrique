import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'labeled_field.dart';
import 'number_field.dart';

/// Deux cotes du même objet, lues ensemble : largeur × longueur, jeu X × jeu Y,
/// marge de début × marge de fin.
///
/// Jamais pour gagner de la place, jamais avec un `CountField`. Si l'un porte
/// un ⓘ, [PairedLabelScope] aligne l'autre.
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
