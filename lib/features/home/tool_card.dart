import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/app_card.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/labels.dart';

/// L'icône d'un outil, en trait.
IconData iconFor(Tool tool) => switch (tool) {
  Tool.converter => Icons.straighten_outlined,
  Tool.distribution => Icons.more_horiz_outlined,
  Tool.drawers => Icons.inbox_outlined,
  Tool.layout => Icons.grid_on_outlined,
  Tool.level => Icons.architecture_outlined,
};

/// Une ligne de la liste d'accueil : icône, titre et sous-titre, chevron.
class ToolCard extends StatelessWidget {
  const ToolCard({required this.tool, super.key});

  final Tool tool;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return AppCard(
      onTap: () => context.go(AppRoutes.tool(tool)),
      child: Row(
        children: [
          Icon(iconFor(tool), size: 32, color: AppColors.accent),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tool.label(l10n),
                  // En `titleLarge`, au-dessus des contrôles : on le lit téléphone posé.
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  tool.subtitle(l10n),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.label,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.chevron_right, color: AppColors.label),
        ],
      ),
    );
  }
}
