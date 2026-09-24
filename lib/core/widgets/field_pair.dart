import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Deux champs de même famille côte à côte : largeur × longueur, jeu X × jeu Y,
/// marge de début × marge de fin.
///
/// Aucun des deux ne porte de boutons − / + : à cette largeur ils tiennent, là
/// où une paire de champs à pas serait illisible sur un téléphone.
class FieldPair extends StatelessWidget {
  const FieldPair({required this.first, required this.second, super.key});

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: second),
      ],
    );
  }
}
