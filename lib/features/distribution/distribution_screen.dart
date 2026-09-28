import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/error_banner.dart';
import '../../core/widgets/result_tile.dart';
import '../../core/widgets/schema_card.dart';
import '../../core/widgets/tool_scaffold.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/calc_errors.dart';
import '../../l10n/labels.dart';
import '../../l10n/numbers.dart';
import 'distribution_controller.dart';
import 'distribution_form.dart';
import 'distribution_input_groups.dart';
import 'distribution_plan.dart';
import 'distribution_positions_table.dart';
import 'distribution_schema.dart';

class DistributionScreen extends ConsumerWidget {
  const DistributionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final input = ref.watch(distributionFormProvider);
    final outcome = ref.watch(distributionResultProvider);
    final form = ref.read(distributionFormProvider.notifier);

    final ready = outcome is DistributionReady ? outcome : null;
    final result = ready?.best;

    return ToolScaffold(
      title: Tool.distribution.label(l10n),
      onReset: form.reset,
      canReset: input != kDistributionDefaults,
      inputGroups: [
        DistributionGeometryGroup(input: input, ready: ready, form: form),
        DistributionEdgesGroup(input: input, form: form),
        // Le refus dans la carte de saisie, près du champ fautif.
        if (outcome case DistributionFailure(:final reason))
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ErrorBanner(message: l10n.calcError(reason)),
          ),
      ],
      // Plus haute que 16/10, pour que la boîte de référence du painter tienne
      // à l'échelle 1 sur un téléphone.
      visualizationAspectRatio: 5 / 4,
      visualization: const SchemaCard(
        expandFor: Tool.distribution,
        child: DistributionSchema(),
      ),
      results: [
        if (input.mode == DistributionMode.count)
          ResultTile(
            label: l10n.distributionCount,
            value: result == null ? kNoValue : '${result.count}',
            note: l10n.distributionCountNote(l10n.number(input.targetSpacing)),
          ),
        ResultTile(
          label: input.mode == DistributionMode.count
              ? l10n.distributionGapObtained
              : l10n.distributionGap,
          value: l10n.number(result?.spacing),
          unit: 'mm',
          note: result == null
              ? null
              : l10n.distributionGapRule(result.count, result.gapCount),
        ),
        // Sans épaisseur, l'entraxe est l'écart.
        if (input.elementWidth > 0)
          ResultTile(
            label: l10n.distributionPitch,
            value: l10n.number(result?.pitch),
            unit: 'mm',
            note: l10n.distributionPitchNote,
          ),
        PositionsTable(result: result, hasWidth: input.elementWidth > 0),
      ],
      resultsFooter: const DistributionExportAction(),
    );
  }
}
