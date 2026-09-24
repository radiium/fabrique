import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/calc/tilt.dart';
import '../../core/format.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/result_tile.dart';
import '../../core/widgets/schema_card.dart';
import '../../core/widgets/tool_scaffold.dart';
import 'level_controller.dart';
import 'level_schema.dart';

/// Aucune saisie : lecture capteur, plus un bouton de calibrage.
class LevelScreen extends ConsumerWidget {
  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reading = ref.watch(accelStreamProvider);
    final zero = ref.watch(tiltZeroProvider);
    final result = ref.watch(tiltResultProvider);

    return ToolScaffold(
      title: Tool.level.label,
      input: reading.hasError
          ? const _SensorUnavailable()
          : _Calibration(reading: reading.value, zero: zero),
      visualization: const SchemaCard(child: LevelSchema()),
      results: [
        ResultTile(
          label: 'Inclinaison latérale',
          value: formatDegrees(result?.rollDeg),
          unit: '°',
          note: 'Gauche ⇄ droite',
        ),
        ResultTile(
          label: 'Inclinaison longitudinale',
          value: formatDegrees(result?.pitchDeg),
          unit: '°',
          note: 'Avant ⇄ arrière',
        ),
        ResultTile(
          label: 'État',
          value: result == null
              ? kNoValue
              : (result.isLevel ? 'À plat' : 'Hors niveau'),
          note: zero == null
              ? 'Par rapport à l’horizontale'
              : 'Par rapport au zéro posé',
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
                  label: const Text('Mettre à zéro'),
                ),
              ),
            ),
            if (zero != null) ...[
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                height: kFieldHeight,
                child: OutlinedButton(
                  onPressed: controller.reset,
                  child: const Text('Annuler'),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          zero == null
              ? 'Les angles sont donnés par rapport à l’horizontale.'
              : 'Zéro posé : les angles sont relatifs à la surface calibrée.',
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
                'Accéléromètre indisponible',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Cet outil demande un appareil équipé d’un accéléromètre.',
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
