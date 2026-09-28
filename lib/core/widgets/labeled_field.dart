import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'app_segmented_button.dart';
import 'field_help.dart';
import 'haptics.dart';

/// Libellé statique au-dessus du contrôle, lisible pendant la saisie.
///
/// Pour tout contrôle : champ, `DropdownMenu`, [AppSegmentedButton].
class LabeledField extends StatelessWidget {
  const LabeledField({
    required this.label,
    required this.child,
    this.help,
    this.about,
    super.key,
  });

  final String label;
  final Widget child;

  /// Précision courte sous le contrôle, toujours affichée. [about] explique.
  final String? help;

  /// Explication ouverte à la demande, derrière un ⓘ après le libellé.
  /// `null` : ni icône, ni hauteur en plus.
  final FieldHelp? about;

  /// Hauteur de la ligne de libellé quand elle porte un ⓘ.
  ///
  /// Toute la ligne ouvre l'explication. Sous [kFieldHeight], car rater un ⓘ
  /// ne change aucune cote.
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
          _AboutRow(label: label, style: labelStyle, about: about)
        else if (PairedLabelScope.isTall(context))
          // Aligné sur le libellé à ⓘ de son voisin de paire.
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _labelRowHeight),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(label, style: labelStyle),
            ),
          )
        else
          Text(label, style: labelStyle),
        const SizedBox(height: AppSpacing.sm),
        child,
        if (help case final help?) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            help,
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.label),
          ),
        ],
      ],
    );
  }
}

/// Ligne de libellé qui ouvre une explication.
///
/// Le ⓘ se pose après le texte, collé, pour garder l'alignement des libellés.
class _AboutRow extends StatelessWidget {
  const _AboutRow({
    required this.label,
    required this.style,
    required this.about,
  });

  final String label;
  final TextStyle? style;
  final FieldHelp about;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: AppLocalizations.of(context).commonHelpFor(label),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.field),
        onTap: () {
          hapticSelection(context);
          unawaited(showFieldHelp(context, about));
        },
        child: SizedBox(
          height: LabeledField._labelRowHeight,
          child: Row(
            children: [
              // `Flexible` : le ⓘ reste collé au texte.
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

/// Dit aux libellés d'une paire de champs qu'un voisin porte un ⓘ, et qu'ils
/// doivent prendre la hauteur de sa ligne.
///
/// Une portée : la paire reçoit des champs déjà construits.
class PairedLabelScope extends InheritedWidget {
  const PairedLabelScope({
    required this.tallLabelRow,
    required super.child,
    super.key,
  });

  final bool tallLabelRow;

  static bool isTall(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<PairedLabelScope>()
          ?.tallLabelRow ??
      false;

  @override
  bool updateShouldNotify(PairedLabelScope oldWidget) =>
      tallLabelRow != oldWidget.tallLabelRow;
}
