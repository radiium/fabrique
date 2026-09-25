import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/widgets/haptics.dart';
import '../../core/widgets/number_field.dart';
import 'drawers_controller.dart';

/// Le bouton qui ouvre l'édition des hauteurs, à côté du nombre de tiroirs.
///
/// Il dit l'état en un mot (« Égales » ou « Ajustées ») : sans lui, des
/// hauteurs fixées resteraient cachées derrière la feuille.
class FrontHeightsButton extends ConsumerWidget {
  const FrontHeightsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(drawersFormProvider);
    final isAdjusted = input.fixedFrontHeights.any((h) => h != null);

    return Semantics(
      button: true,
      label: 'Modifier les hauteurs des façades',
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
                  isAdjusted ? 'Ajustées' : 'Égales',
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

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Text(
        'De haut en bas : '
        '${result.fronts.map((f) => formatNumber(f.height)).join(' · ')} mm',
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: AppColors.label),
      ),
    );
  }
}

/// Ouvre l'édition des hauteurs dans une feuille basse.
///
/// Une feuille plutôt qu'une page : la saisie reste derrière, et on revient
/// d'un glissement.
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
            Text('Hauteurs des façades', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Une hauteur saisie reste fixe. Les autres façades se partagent '
              'le reste.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.label,
              ),
            ),
            for (var i = 0; i < input.drawerCount; i++) ...[
              const SizedBox(height: AppSpacing.md),
              NumberField(
                label: _drawerLabel(i, input.drawerCount),
                suffix: 'mm',
                help: fixedAt(i) == null ? 'Partagée' : 'Fixée',
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
                child: const Text('Remettre à égales'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// « Tiroir 1 (haut) » : le rang seul ne dit pas dans quel sens on compte.
  static String _drawerLabel(int index, int count) {
    final position = switch (index) {
      0 when count > 1 => ' (haut)',
      _ when index == count - 1 && count > 1 => ' (bas)',
      _ => '',
    };
    return 'Tiroir ${index + 1}$position';
  }
}
