import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/distribution.dart';
import '../../core/widgets/haptics.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/numbers.dart';

/// Ce que l'écart demandé donne vraiment, et l'autre borne s'il y en a une.
///
/// Toujours présent en mode « Calcul nombre » : teinté quand il propose la
/// borne écartée, vide quand il confirme. Toute sa surface est la cible.
class TargetCallout extends StatelessWidget {
  const TargetCallout({
    required this.best,
    required this.other,
    required this.onAdopt,
    super.key,
  });

  final DistributionResult best;

  /// L'autre solution entière, ou `null` quand la cible tombe juste.
  final DistributionResult? other;

  final void Function(int count) onAdopt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shown = other ?? best;
    final exact = other == null;
    final spacing = l10n.number(shown.spacing);
    final label = exact
        ? l10n.distributionCalloutExact(shown.count, spacing)
        : l10n.distributionCalloutOther(shown.count, spacing);

    // Teinté seulement quand il y a une action, pour que l'offre se remarque.
    final tint = exact ? Colors.transparent : AppColors.callout;
    final ink = exact ? AppColors.label : AppColors.accentDeep;

    final content = Container(
      constraints: const BoxConstraints(minHeight: kFieldHeight),
      decoration: BoxDecoration(
        color: tint,
        border: Border.all(color: AppColors.calloutBorder),
        borderRadius: BorderRadius.circular(AppRadii.field),
      ),
      // Même rembourrage dans les deux états : la carte ne saute pas.
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          Icon(
            exact ? Icons.check_rounded : Icons.swap_horiz,
            size: 20,
            color: ink,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ink,
                fontWeight: exact ? FontWeight.w500 : FontWeight.w600,
              ),
            ),
          ),
          if (!exact) ...[
            const SizedBox(width: AppSpacing.sm),
            const _AdoptButton(),
          ],
        ],
      ),
    );

    if (exact) return Semantics(container: true, child: content);

    return Semantics(
      button: true,
      label: l10n.distributionCalloutAdoptLabel(shown.count, spacing),
      child: InkWell(
        onTap: () {
          hapticSelection(context);
          onAdopt(shown.count);
        },
        borderRadius: BorderRadius.circular(AppRadii.field),
        child: content,
      ),
    );
  }
}

/// Le repère d'action de [TargetCallout], sans geste propre : l'encart
/// entier reçoit le tap.
class _AdoptButton extends StatelessWidget {
  const _AdoptButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accentDeep,
        borderRadius: BorderRadius.circular(AppRadii.field),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        AppLocalizations.of(context).distributionCalloutAdopt,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: AppColors.onAccent, fontWeight: FontWeight.w600),
      ),
    );
  }
}
