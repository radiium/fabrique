import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'haptics.dart';

/// Réglage booléen d'un formulaire : libellé à gauche, interrupteur à droite.
///
/// Contrairement à [LabeledField], le libellé ne surplombe pas le contrôle — il
/// en fait partie. **Toute la ligne bascule l'interrupteur**, libellé et aide
/// compris : en atelier, viser une pastille de 32 px avec un gant est perdu
/// d'avance, alors que la ligne entière fait [kFieldHeight] de haut sur toute
/// la largeur de la carte.
///
/// Le `Switch` reste un enfant interactif à part entière : il garde son propre
/// focus clavier et son animation. Un tap dessus lui revient (l'arène des
/// gestes donne la main au plus profond), un tap ailleurs sur la ligne passe
/// par l'[InkWell] — dans les deux cas un seul aller-retour vers [onChanged].
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

    // Le libellé et l'interrupteur ne forment qu'un seul nœud d'accessibilité :
    // un lecteur d'écran annonce « Impérial composé, activé », pas deux
    // éléments sans rapport.
    return MergeSemantics(
      child: InkWell(
        onTap: () => _toggle(context),
        borderRadius: BorderRadius.circular(AppRadii.field),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kFieldHeight),
          child: Padding(
            // 4 px, pas 8 : le `Switch` mesure 40 de haut une fois sa cible
            // tactile dégonflée, et la colonne libellé + aide tombe sur les
            // mêmes 40. Les deux variantes retombent donc sur [kFieldHeight].
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Même style que le libellé d'un [LabeledField] : dans la
                      // carte de saisie, tous les libellés se lisent pareil.
                      Text(
                        label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.label,
                        ),
                      ),
                      if (help != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          help!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.label,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // `shrinkWrap` : sans lui, Material ajoute au `Switch` sa
                // propre cible tactile de 48 px, qui s'empile sur la marge de
                // la ligne et la pousse à 64 — le contrôle déborderait de
                // [kFieldHeight] sans que rien ne le dise. La cible, ici,
                // c'est la ligne entière.
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
