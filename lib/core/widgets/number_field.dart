import 'package:flutter/material.dart';

import 'field_help.dart';
import 'labeled_field.dart';
import 'numeric_input.dart';

/// Champ de cote, en millimètres : clavier numérique, gros texte, hauteur fixe
/// [kFieldHeight] — au-dessus de la cible tactile minimale.
///
/// Jamais de boutons − / + : une cote se mesure au mètre puis se tape, la
/// faire défiler millimètre par millimètre n'apporte rien. Un nombre
/// d'éléments, lui, s'ajuste au pouce : c'est `CountField`.
class NumberField extends StatelessWidget {
  const NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.suffix,
    this.help,
    this.about,
    super.key,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final String? suffix;

  /// Précision courte affichée sous le champ.
  final String? help;

  /// Explication ouverte à la demande — cf. [LabeledField.about].
  final FieldHelp? about;

  @override
  Widget build(BuildContext context) {
    return LabeledField(
      label: label,
      help: help,
      about: about,
      child: NumericInput(
        value: value,
        onChanged: onChanged,
        suffix: suffix,
        semanticLabel: label,
      ),
    );
  }
}
