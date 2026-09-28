import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Le motif d'un refus de calcul.
///
/// Dans la carte de saisie, en bas, près des champs : sur mobile, les
/// résultats sont sous le schéma.
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({required this.message, super.key});

  final String message;

  /// Lavis de la couleur d'erreur, discret.
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
