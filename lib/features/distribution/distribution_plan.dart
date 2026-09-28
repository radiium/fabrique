import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/export/plan.dart';
import '../../core/export/plan_export_action.dart';
import '../../core/models/tool.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/labels.dart';
import '../../l10n/numbers.dart';
import 'distribution_controller.dart';
import 'distribution_form.dart';
import 'distribution_painter.dart';
import 'distribution_schema.dart';

/// Point de construction unique du plan de la Répartition, pour la page plein
/// écran et l'export. `null` quand la saisie est refusée.
PlanPainter? buildDistributionPlan({
  required AppLocalizations l10n,
  required DistributionFormState input,
  required DistributionOutcome outcome,
  required DateTime date,
}) {
  if (outcome is! DistributionReady) return null;
  final result = outcome.best;
  final hasWidth = input.elementWidth > 0;
  final byCount = input.mode == DistributionMode.count;
  final positionHeader = hasWidth
      ? l10n.distributionEdgeColumn
      : l10n.distributionPositionColumn;

  return PlanPainter(
    plan: Plan(
      title: Tool.distribution.label(l10n),
      // Seulement ce que le dessin ne cote pas.
      fields: [
        (l10n.planDate.toUpperCase(), formatPlanDate(date, l10n)),
        (l10n.distributionPlanElements.toUpperCase(), '${result.count}'),
        // L'écart visé, que le dessin ne montre pas, juste avant sa réponse.
        if (byCount)
          (
            l10n.distributionTargetSpacing.toUpperCase(),
            '${l10n.number(input.targetSpacing)} mm',
          ),
        (
          (byCount ? l10n.distributionGapObtained : l10n.distributionGap)
              .toUpperCase(),
          '${l10n.number(result.spacing)} mm',
        ),
        // Sans épaisseur, l'entraxe est l'écart.
        if (hasWidth)
          (
            l10n.distributionPitch.toUpperCase(),
            '${l10n.number(result.pitch)} mm',
          ),
        (l10n.distributionPlanGaps.toUpperCase(), '${result.gapCount}'),
      ],
      tables: [
        PlanTable(
          title: l10n.distributionPositions.toUpperCase(),
          headers: [
            l10n.planIndex,
            '${positionHeader.toUpperCase()} (mm)',
            if (hasWidth) '${l10n.distributionCenterColumn.toUpperCase()} (mm)',
          ],
          rows: [
            for (final (i, position) in result.positions.indexed)
              [
                '${i + 1}',
                l10n.number(position),
                if (hasWidth) l10n.number(result.centers[i]),
              ],
          ],
          fallback: l10n.distributionPlanFallback(result.positions.length),
        ),
      ],
    ),
    drawing: DistributionPainter(
      result: result,
      length: input.length,
      elementWidth: input.elementWidth,
      startOffset: input.startOffset,
      endOffset: input.endOffset,
      l10n: l10n,
    ),
  );
}

/// Le plan de la Répartition, branché sur les providers : schéma et
/// cartouche. Saisie refusée : le schéma seul.
class DistributionPlanView extends ConsumerWidget {
  const DistributionPlanView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final painter = buildDistributionPlan(
      l10n: l10n,
      input: ref.watch(distributionFormProvider),
      outcome: ref.watch(distributionResultProvider),
      date: DateTime.now(),
    );
    if (painter == null) return const DistributionSchema();

    return CustomPaint(painter: painter, size: Size.infinite);
  }
}

/// Les gestes d'export du plan de la Répartition, branchés sur ses providers.
class DistributionExportAction extends ConsumerWidget {
  const DistributionExportAction({this.compact = false, super.key});

  /// `true` = l'icône de l'`AppBar`, `false` = la rangée en pied de carte.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PlanExportAction(
      tool: Tool.distribution,
      compact: compact,
      ready: ref.watch(distributionResultProvider) is DistributionReady,
      buildPlan: (date) => buildDistributionPlan(
        l10n: l10n,
        input: ref.read(distributionFormProvider),
        outcome: ref.read(distributionResultProvider),
        date: date,
      ),
    );
  }
}
