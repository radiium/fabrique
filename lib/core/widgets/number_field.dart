import 'package:flutter/material.dart';

import 'field_help.dart';
import 'labeled_field.dart';
import 'numeric_input.dart';

/// Champ de cote, en millimètres : clavier numérique, hauteur [kFieldHeight].
///
/// Sans boutons − / + : une cote se mesure puis se tape.
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

  /// Explication ouverte à la demande, comme [LabeledField.about].
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
