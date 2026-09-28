import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/calc/tilt.dart';
import '../../core/widgets/error_banner.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/calc_errors.dart';
import '../../l10n/numbers.dart';
import 'level_controller.dart';

/// Le calibrage, dans la carte de saisie : le bouton de l'assistant et l'état
/// de la tranche en cours.
class LevelCalibrationControls extends StatelessWidget {
  const LevelCalibrationControls({required this.result, super.key});

  /// `null` tant que le capteur n'a rien livré : le bouton reste inerte.
  final TiltResult? result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: kFieldHeight,
          child: OutlinedButton.icon(
            onPressed: result == null
                ? null
                : () => unawaited(showCalibrationSheet(context)),
            icon: const Icon(Icons.tune),
            label: Text(l10n.levelCalibrate),
          ),
        ),
        if (result case EdgeTilt(:final isCalibrated)) ...[
          const SizedBox(height: AppSpacing.sm),
          _CalibrationStatus(isCalibrated: isCalibrated),
        ],
      ],
    );
  }
}

/// Dit si le dixième affiché mérite d'être cru, sur la tranche en cours.
class _CalibrationStatus extends StatelessWidget {
  const _CalibrationStatus({required this.isCalibrated});

  final bool isCalibrated;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = isCalibrated ? AppColors.accent : AppColors.label;
    return Row(
      children: [
        Icon(
          isCalibrated ? Icons.verified_outlined : Icons.info_outline,
          size: 18,
          color: color,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            isCalibrated ? l10n.levelCalibrated : l10n.levelNotCalibrated,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

/// Avance sur l'attente puis la moyenne d'une mesure immobile.
///
/// Purement visuelle : la fin de la mesure vient du contrôleur.
class MeasureProgress extends StatelessWidget {
  const MeasureProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: kSettleDelay + kSampleWindow,
      builder: (context, value, _) => LinearProgressIndicator(value: value),
    );
  }
}

/// Ouvre l'assistant de calibrage par-dessus le Niveau, qui garde son
/// verrou d'orientation.
Future<void> showCalibrationSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.cardSurface,
      isScrollControlled: true,
      builder: (_) => const _CalibrationSheet(),
    );

class _CalibrationSheet extends ConsumerWidget {
  const _CalibrationSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final step = ref.watch(calibrationWizardProvider);
    final wizard = ref.read(calibrationWizardProvider.notifier);
    final calibration = ref.watch(tiltCalibrationProvider);
    final hasCalibration = calibration != const DeviceCalibration();

    // `SafeArea` : la feuille descend sous la barre de navigation d'Android,
    // son contenu non.
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.levelCalibrationTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.levelCalibrationIntro,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.label,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _WizardStep(step: step),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: kFieldHeight,
              child: switch (step) {
                CalibrationWaiting() => FilledButton(
                  onPressed: wizard.measure,
                  child: Text(l10n.levelMeasure),
                ),
                CalibrationMeasuring() => FilledButton(
                  onPressed: null,
                  child: Text(l10n.levelMeasure),
                ),
                CalibrationDone() => FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.levelCalibrationFinish),
                ),
                CalibrationFailed() => FilledButton(
                  onPressed: wizard.restart,
                  child: Text(l10n.levelCalibrationRestart),
                ),
              },
            ),
            if (hasCalibration && step is! CalibrationMeasuring) ...[
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: kFieldHeight,
                child: TextButton(
                  onPressed: () {
                    ref.read(tiltCalibrationProvider.notifier).clear();
                    wizard.restart();
                  },
                  child: Text(l10n.levelCalibrationClear),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// La consigne de l'étape en cours, ou son issue.
class _WizardStep extends StatelessWidget {
  const _WizardStep({required this.step});

  final CalibrationStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final stepLabel = theme.textTheme.labelLarge?.copyWith(
      color: AppColors.accentDeep,
    );

    return switch (step) {
      CalibrationWaiting(:final step) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.levelCalibrationStep(step), style: stepLabel),
          const SizedBox(height: AppSpacing.xs),
          Text(
            step == 1
                ? l10n.levelCalibrationFirst
                : l10n.levelCalibrationSecond,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
      CalibrationMeasuring(:final step) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.levelCalibrationStep(step), style: stepLabel),
          const SizedBox(height: AppSpacing.sm),
          // Une clé par mesure : la barre repart de zéro à la seconde.
          MeasureProgress(key: ValueKey(step)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.levelCalibrationMeasuring,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
      CalibrationDone(:final biasDeg) => Text(
        l10n.levelCalibrationDone(l10n.degrees(biasDeg)),
        style: theme.textTheme.bodyLarge,
      ),
      CalibrationFailed(:final reason) => ErrorBanner(
        message: l10n.calcError(reason),
      ),
    };
  }
}
