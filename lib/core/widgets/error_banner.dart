import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Le motif d'un refus de calcul, affiché tel quel.
///
/// **Écart assumé à la convention `CalcException` → `null`.** Le tiret suffit
/// tant qu'une saisie invalide n'est qu'une frappe en cours. Mais sur un outil
/// à huit contrôles, un refus métier — « l'élément fait 1200 mm pour une zone
/// de 980 » — est l'information la plus utile que l'outil puisse rendre : la
/// taire laisserait chercher lequel des huit champs est fautif.
///
/// Se pose **dans la carte de saisie**, en bas, et non près des résultats : sur
/// mobile les résultats sont sous le schéma, donc un message posé là se lirait
/// deux écrans plus bas que le champ à corriger.
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({required this.message, super.key});

  final String message;

  /// Un lavis de la couleur d'erreur : le message se détache de la carte sans
  /// crier plus fort que le champ à corriger.
  static const double _washOpacity = 0.08;
  static const double _borderOpacity = 0.4;

  /// La taille de l'icône d'une ligne de `bodyMedium`.
  static const double _iconSize = 20;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.error;

    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: _washOpacity),
          borderRadius: BorderRadius.circular(AppRadii.field),
          border: Border.all(color: color.withValues(alpha: _borderOpacity)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline, size: _iconSize, color: color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
