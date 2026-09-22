import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Un en-tête de section du playground.
class ShowcaseSection extends StatelessWidget {
  const ShowcaseSection({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          Text(subtitle, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// Une entrée du playground : nom du widget, où il sert dans l'app, et une
/// démo vivante manipulable.
class WidgetShowcase extends StatelessWidget {
  const WidgetShowcase({
    required this.name,
    required this.usage,
    required this.child,
    this.candidate = false,
    super.key,
  });

  final String name;

  /// Où le widget sert — ou servirait, pour un candidat.
  final String usage;

  final Widget child;

  /// `true` = pas encore utilisé dans l'app, retenu comme option.
  final bool candidate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                if (candidate)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cut.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'candidat',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.cut,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(usage, style: theme.textTheme.bodySmall),
            const Divider(height: AppSpacing.lg),
            Align(alignment: Alignment.centerLeft, child: child),
          ],
        ),
      ),
    );
  }
}
