import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/widgets/haptics.dart';
import '../../core/widgets/number_field.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/numbers.dart';
import 'drawers_controller.dart';

/// Le bouton qui ouvre l'édition des hauteurs, à côté du nombre de tiroirs.
///
/// Il affiche l'état (« Égales » ou « Ajustées »), pour que des hauteurs
/// fixées ne restent pas cachées.
class FrontHeightsButton extends ConsumerWidget {
  const FrontHeightsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final input = ref.watch(drawersFormProvider);
    final isAdjusted = input.fixedFrontHeights.any((h) => h != null);

    return Semantics(
      button: true,
      label: l10n.drawersEditHeights,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.field),
        onTap: () {
          hapticSelection(context);
          unawaited(showFrontHeightsSheet(context));
        },
        child: Container(
          height: kFieldHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.field,
            borderRadius: BorderRadius.circular(AppRadii.field),
            border: Border.all(
              color: isAdjusted ? AppColors.accent : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  isAdjusted
                      ? l10n.drawersHeightsAdjusted
                      : l10n.drawersHeightsEqual,
                  style: controlTextStyle(context),
                ),
              ),
              const Icon(Icons.edit_outlined, color: AppColors.accent),
            ],
          ),
        ),
      ),
    );
  }
}

/// Le résumé des hauteurs, sous la ligne du nombre de tiroirs, quand elles ne
/// sont plus égales.
class FrontHeightsSummary extends ConsumerWidget {
  const FrontHeightsSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(drawersFormProvider);
    final result = ref.watch(drawersResultProvider).result;
    if (result == null || !input.fixedFrontHeights.any((h) => h != null)) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Text(
        l10n.drawersHeightsTopToBottom(
          result.fronts.map((f) => l10n.number(f.height)).join(' · '),
        ),
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: AppColors.label),
      ),
    );
  }
}

/// Ouvre l'édition des hauteurs dans une feuille basse.
///
/// Une feuille : la saisie reste derrière.
Future<void> showFrontHeightsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: AppColors.cardSurface,
    isScrollControlled: true,
    builder: (context) => const _FrontHeightsSheet(),
  );
}

class _FrontHeightsSheet extends ConsumerWidget {
  const _FrontHeightsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(drawersFormProvider);
    final result = ref.watch(drawersResultProvider).result;
    final form = ref.read(drawersFormProvider.notifier);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    double? fixedAt(int i) =>
        i < input.fixedFrontHeights.length ? input.fixedFrontHeights[i] : null;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.drawersFrontHeights, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.drawersFrontHeightsHelp,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.label,
              ),
            ),
            for (var i = 0; i < input.drawerCount; i++) ...[
              const SizedBox(height: AppSpacing.md),
              NumberField(
                label: _drawerLabel(i, input.drawerCount, l10n),
                suffix: 'mm',
                help: fixedAt(i) == null
                    ? l10n.drawersHeightShared
                    : l10n.drawersHeightFixed,
                value:
                    fixedAt(i) ??
                    result?.fronts.elementAtOrNull(i)?.height ??
                    0,
                onChanged: (mm) => form.setFrontHeight(i, mm),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: kFieldHeight,
              child: OutlinedButton(
                onPressed: input.fixedFrontHeights.any((h) => h != null)
                    ? () {
                        hapticSelection(context);
                        form.resetFrontHeights();
                      }
                    : null,
                child: Text(l10n.drawersResetHeights),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// « Tiroir 1 (haut) » : le rang seul ne dit pas dans quel sens on compte.
  static String _drawerLabel(int index, int count, AppLocalizations l10n) =>
      switch (index) {
        0 when count > 1 => l10n.drawersDrawerTop(index + 1),
        _ when index == count - 1 && count > 1 => l10n.drawersDrawerBottom(
          index + 1,
        ),
        _ => l10n.drawersDrawer(index + 1),
      };
}
