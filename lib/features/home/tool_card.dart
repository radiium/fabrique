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

const double _kIconSize = 32;

/// Une carte d'outil de l'accueil : icône, titre et sous-titre.
///
/// En ligne avec un chevron dans la liste, en tuile verticale dans la grille
/// ([isTile]), où le sous-titre passe à la ligne au lieu d'être tronqué.
class ToolCard extends StatelessWidget {
  const ToolCard({required this.tool, this.isTile = false, super.key});

  final Tool tool;
  final bool isTile;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(iconFor(tool), size: _kIconSize, color: AppColors.accent);
    return AppCard(
      onTap: () => context.go(AppRoutes.tool(tool)),
      child: isTile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                icon,
                const SizedBox(height: AppSpacing.sm),
                _ToolTexts(tool: tool, subtitleMaxLines: null),
              ],
            )
          : Row(
              children: [
                icon,
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _ToolTexts(tool: tool, subtitleMaxLines: 1)),
                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.chevron_right, color: AppColors.label),
              ],
            ),
    );
  }
}

class _ToolTexts extends StatelessWidget {
  const _ToolTexts({required this.tool, required this.subtitleMaxLines});

  final Tool tool;

  /// `null` : le sous-titre passe à la ligne autant qu'il le faut.
  final int? subtitleMaxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(
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
          maxLines: subtitleMaxLines,
          overflow: subtitleMaxLines == null ? null : TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.label),
        ),
      ],
    );
  }
}
