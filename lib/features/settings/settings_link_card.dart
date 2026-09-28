import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/widgets/app_card.dart';

/// Une carte qui ouvre une page : libellé et chevron, à [kFieldHeight] au moins.
class SettingsLinkCard extends StatelessWidget {
  const SettingsLinkCard({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.chevron_right, color: AppColors.label),
          ],
        ),
      ),
    );
  }
}
