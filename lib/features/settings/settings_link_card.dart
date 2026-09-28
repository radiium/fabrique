import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/widgets/app_card.dart';

/// Une carte qui ouvre une page ou un lien, à [kFieldHeight] au moins.
///
/// Chevron pour une page de l'app, [Icons.open_in_new] pour un lien externe.
class SettingsLinkCard extends StatelessWidget {
  const SettingsLinkCard({
    required this.label,
    required this.onTap,
    this.subtitle,
    this.value,
    this.isExternal = false,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final String? subtitle;

  /// Valeur courte en gris avant l'icône, comme la version.
  final String? value;
  final bool isExternal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: kFieldHeight),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.titleMedium),
                  if (subtitle case final subtitle?)
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.label,
                      ),
                    ),
                ],
              ),
            ),
            if (value case final value?) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.label,
                ),
              ),
            ],
            const SizedBox(width: AppSpacing.sm),
            Icon(
              isExternal ? Icons.open_in_new : Icons.chevron_right,
              color: AppColors.label,
            ),
          ],
        ),
      ),
    );
  }
}
