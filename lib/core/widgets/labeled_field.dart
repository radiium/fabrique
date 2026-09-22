import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import 'app_segmented_button.dart';
import 'field_help.dart';

/// Libellé statique au-dessus du contrôle, façon formulaire web.
///
/// Remplace le label flottant de Material : en atelier, le libellé doit rester
/// lisible une fois la saisie commencée, et à bout de bras un label réduit à
/// 12 px collé à la bordure ne l'est pas.
///
/// S'applique à n'importe quel contrôle, pas seulement aux champs texte :
/// `DropdownMenu`, [AppSegmentedButton], groupe de boutons…
class LabeledField extends StatelessWidget {
  const LabeledField({
    required this.label,
    required this.child,
    this.help,
    this.about,
    this.haptics = true,
    super.key,
  });

  final String label;
  final Widget child;

  /// Précision courte sous le contrôle (unité attendue, règle appliquée).
  ///
  /// Reste affiché en permanence : c'est une contrainte de saisie, elle se lit
  /// d'un coup d'œil. À distinguer d'[about], qui explique.
  final String? help;

  /// Explication ouverte à la demande, derrière un ⓘ posé après le libellé.
  ///
  /// `null` = pas d'icône, et le libellé retrouve exactement sa hauteur d'avant
  /// — un champ sans explication ne doit rien payer.
  final FieldHelp? about;

  /// TODO(ui): câbler sur le réglage global « retour haptique ».
  final bool haptics;

  /// Hauteur de la ligne de libellé quand elle porte un ⓘ.
  ///
  /// Le libellé seul en fait 20. Les 12 de plus achètent la cible tactile :
  /// c'est la **ligne entière** qui ouvre l'explication, pas la pastille de
  /// 18 px — même raisonnement que pour [AppSwitchField]. En deçà de
  /// [kFieldHeight], et c'est assumé : la cible fait la largeur de la carte, et
  /// rater un ⓘ n'abîme rien, là où rater un champ change une cote.
  static const double _labelRowHeight = 32;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.titleSmall?.copyWith(
      color: AppColors.label,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (about case final about?)
          _AboutRow(
            label: label,
            style: labelStyle,
            about: about,
            haptics: haptics,
          )
        else
          Text(label, style: labelStyle),
        const SizedBox(height: AppSpacing.sm),
        child,
        if (help != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            help!,
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.label),
          ),
        ],
      ],
    );
  }
}

/// Ligne de libellé qui ouvre une explication.
///
/// Le ⓘ se pose **après** le texte et non avant : une icône en tête décalerait
/// le libellé de la colonne que forment tous les autres libellés de la carte —
/// et c'est cette colonne que l'œil descend. Collé au texte plutôt que rejeté
/// à droite, il reste lisible comme appartenant à *ce* libellé, y compris
/// quand deux champs se partagent une ligne.
class _AboutRow extends StatelessWidget {
  const _AboutRow({
    required this.label,
    required this.style,
    required this.about,
    required this.haptics,
  });

  final String label;
  final TextStyle? style;
  final FieldHelp about;
  final bool haptics;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Aide : $label',
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.field),
        onTap: () {
          if (haptics) unawaited(HapticFeedback.selectionClick());
          unawaited(showFieldHelp(context, about));
        },
        child: SizedBox(
          height: LabeledField._labelRowHeight,
          child: Row(
            children: [
              // `Flexible` et non `Expanded` : le ⓘ doit rester collé au texte,
              // pas être poussé au bord de la carte.
              Flexible(child: Text(label, style: style)),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.info_outline, size: 18, color: AppColors.accent),
            ],
          ),
        ),
      ),
    );
  }
}
