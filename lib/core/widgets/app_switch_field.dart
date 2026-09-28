import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'haptics.dart';

/// Réglage booléen d'un formulaire : libellé à gauche, interrupteur à droite.
///
/// Toute la ligne bascule l'interrupteur. Le `Switch` garde son focus et son
/// tap ; ailleurs, l'[InkWell] prend le relais.
class AppSwitchField extends StatelessWidget {
  const AppSwitchField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.help,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  /// Précision courte sous le libellé, dans la zone tappable.
  final String? help;

  void _toggle(BuildContext context) {
    hapticSelection(context);
    onChanged(!value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Un seul nœud d'accessibilité pour le libellé et l'interrupteur.
    return MergeSemantics(
      child: InkWell(
        onTap: () => _toggle(context),
        // Le focus clavier au seul `Switch` : un seul arrêt Tab.
        canRequestFocus: false,
        borderRadius: BorderRadius.circular(AppRadii.field),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kFieldHeight),
          child: Padding(
            // 4 px : `Switch` et colonne libellé + aide font 40, soit [kFieldHeight]
            // avec la marge.
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Même style que le libellé d'un [LabeledField].
                      Text(
                        label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.label,
                        ),
                      ),
                      if (help case final help?) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          help,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.label,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // `shrinkWrap` : sinon la cible de 48 px du `Switch` pousse la ligne à 64.
                Switch(
                  value: value,
                  onChanged: (_) => _toggle(context),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
