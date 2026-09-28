import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/calc/tilt.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/result_tile.dart';
import '../../core/widgets/schema_card.dart';
import '../../core/widgets/tool_scaffold.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/labels.dart';
import '../../l10n/numbers.dart';
import 'level_calibration.dart';
import 'level_controller.dart';
import 'level_schema.dart';

/// Lecture sur la tranche, et calibrage.
///
/// Verrouillé en portrait : posé sur la tranche, le téléphone ferait sinon
/// pivoter l'écran au moment de la mesure. Le dessin se redresse seul.
class LevelScreen extends ConsumerStatefulWidget {
  const LevelScreen({super.key});

  @override
  ConsumerState<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends ConsumerState<LevelScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    );
  }

  @override
  void dispose() {
    // Liste vide : l'orientation revient au choix du système.
    unawaited(SystemChrome.setPreferredOrientations(const []));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reading = ref.watch(accelStreamProvider);
    final isSilent = ref.watch(sensorSilenceProvider);
    final result = ref.watch(tiltResultProvider);
    final tilt = result is EdgeTilt ? result : null;

    final isUnavailable = reading.hasError || (isSilent && !reading.hasValue);

    return ToolScaffold(
      title: Tool.level.label(l10n),
      input: isUnavailable
          ? const _SensorUnavailable()
          : LevelCalibrationControls(result: result),
      // Carré : le tube tourne d'un quart de tour avec le téléphone.
      visualizationAspectRatio: 1,
      visualization: const SchemaCard(child: LevelSchema()),
      results: [
        _AngleTile(tilt: tilt),
        _SlopeTile(tilt: tilt),
      ],
    );
  }
}

/// L'inclinaison, ou l'écart d'aplomb téléphone debout. Un tiret à plat : le
/// dessin dit quoi faire.
class _AngleTile extends StatelessWidget {
  const _AngleTile({required this.tilt});

  final EdgeTilt? tilt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final angle = tilt?.angleDeg;
    return ResultTile(
      label: (tilt?.quarterTurns.isEven ?? false)
          ? l10n.levelPlumbGap
          : l10n.levelEdgeTilt,
      value: l10n.degrees(angle),
      unit: '°',
    );
  }
}

/// La pente en mm/m, et de quel côté corriger : la cale sous l'extrémité
/// basse, ou le côté vers lequel penche le haut d'un montant.
class _SlopeTile extends StatelessWidget {
  const _SlopeTile({required this.tilt});

  final EdgeTilt? tilt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isUpright = tilt?.quarterTurns.isEven ?? false;
    final angle = tilt?.angleDeg;
    return ResultTile(
      label: isUpright ? l10n.levelPlumbOffset : l10n.levelSlope,
      // Sans signe : la note dit le côté.
      value: l10n.tenths(angle == null ? null : slopeMmPerM(angle).abs()),
      unit: 'mm/m',
      // Positif : l'extrémité droite monte, donc le haut d'un montant part à
      // gauche.
      note: switch (angle) {
        null => null,
        final angle => switch ((isUpright, angle > 0)) {
          (true, true) => l10n.levelTopLeansLeft,
          (true, false) => l10n.levelTopLeansRight,
          (false, true) => l10n.levelUnderLeftEnd,
          (false, false) => l10n.levelUnderRightEnd,
        },
      },
    );
  }
}

/// Pas d'accéléromètre (navigateur, émulateur, permission refusée) : une
/// bulle figée passerait pour un niveau parfait.
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
