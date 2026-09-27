import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/app_card.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/labels.dart';

/// Icône ligne + nom + sous-titre une ligne.
IconData iconFor(Tool tool) => switch (tool) {
  Tool.converter => Icons.straighten_outlined,
  Tool.distribution => Icons.more_horiz_outlined,
  Tool.drawers => Icons.inbox_outlined,
  Tool.layout => Icons.grid_on_outlined,
  Tool.level => Icons.architecture_outlined,
};

/// Une ligne de la liste d'accueil : icône à gauche, titre + sous-titre au
/// centre, chevron de navigation à droite. Carte claire, sans élévation.
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
                  // Le nom de l'outil est le texte qu'on vise depuis l'établi,
                  // téléphone posé : il se lit en `titleLarge`, un cran
                  // au-dessus des contrôles (18 px), pas en dessous.
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
