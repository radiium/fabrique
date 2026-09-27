import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/calc/tilt.dart';
import '../../core/format.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/result_tile.dart';
import '../../core/widgets/schema_card.dart';
import '../../core/widgets/tool_scaffold.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/labels.dart';
import '../../l10n/numbers.dart';
import 'level_controller.dart';
import 'level_schema.dart';

/// Aucune saisie : lecture capteur, plus un bouton de calibrage.
class LevelScreen extends ConsumerWidget {
  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reading = ref.watch(accelStreamProvider);
    final zero = ref.watch(tiltZeroProvider);
    final result = ref.watch(tiltResultProvider);

    return ToolScaffold(
      title: Tool.level.label(l10n),
      input: reading.hasError
          ? const _SensorUnavailable()
          : _Calibration(reading: reading.value, zero: zero),
      visualization: const SchemaCard(child: LevelSchema()),
      results: [
        ResultTile(
          label: l10n.levelRoll,
          value: l10n.degrees(result?.rollDeg),
          unit: '°',
          note: l10n.levelRollNote,
        ),
        ResultTile(
          label: l10n.levelPitch,
          value: l10n.degrees(result?.pitchDeg),
          unit: '°',
          note: l10n.levelPitchNote,
        ),
        ResultTile(
          label: l10n.levelState,
          value: result == null
              ? kNoValue
              : (result.isLevel ? l10n.levelFlat : l10n.levelOff),
          note: zero == null ? l10n.levelFromHorizontal : l10n.levelFromZero,
        ),
      ],
    );
  }
}

/// Le calibrage : poser un zéro sur une surface de référence, et pouvoir le
/// reprendre. Sans le retour au zéro absolu, un calibrage malheureux ne se
/// rattrape qu'en redémarrant l'app.
class _Calibration extends ConsumerWidget {
  const _Calibration({required this.reading, required this.zero});

  /// `null` tant que le capteur n'a rien livré — le bouton reste inerte
  /// plutôt que de poser un zéro sur du vide.
  final AccelReading? reading;
  final AccelReading? zero;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final current = reading;
    final controller = ref.read(tiltZeroProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: kFieldHeight,
                child: FilledButton.icon(
                  onPressed: current == null
                      ? null
                      : () => controller.calibrate(current),
                  icon: const Icon(Icons.adjust_outlined),
                  label: Text(l10n.levelSetZero),
                ),
              ),
            ),
            if (zero != null) ...[
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                height: kFieldHeight,
                child: OutlinedButton(
                  onPressed: controller.reset,
                  child: Text(l10n.levelCancelZero),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          zero == null ? l10n.levelHorizontalHelp : l10n.levelZeroHelp,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AppColors.label),
        ),
      ],
    );
  }
}

/// Pas d'accéléromètre — un navigateur de bureau, un émulateur, un appareil qui
/// refuse la permission. On le dit, plutôt que de laisser une bulle figée au
/// centre passer pour un niveau parfait.
class _SensorUnavailable extends StatelessWidget {
  const _SensorUnavailable();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.sensors_off_outlined, color: AppColors.cut),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.levelSensorUnavailable,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.levelSensorUnavailableHelp,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.label,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
