import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/calc/layout.dart';
import '../../core/export/plan.dart';
import '../../core/export/plan_export_action.dart';
import '../../core/models/tool.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/labels.dart';
import '../../l10n/numbers.dart';
import 'layout_controller.dart';
import 'layout_painter.dart';
import 'layout_schema.dart';

/// Millimètres carrés dans un mètre carré.
const double _mm2PerM2 = 1000 * 1000;

/// Point de construction unique du plan du Calepinage, pour la page plein
/// écran et l'export. `null` quand la saisie est refusée.
PlanPainter? buildLayoutPlan({
  required AppLocalizations l10n,
  required LayoutInput input,
  required LayoutOutcome outcome,
  required DateTime date,
}) {
  if (outcome is! LayoutReady) return null;
  final result = outcome.result;
  final cuts = summarizeCuts(result);

  return PlanPainter(
    plan: Plan(
      title: Tool.layout.label(l10n),
      // Seulement ce que le dessin ne cote pas : l'élément et les jeux.
      fields: [
        (l10n.planDate.toUpperCase(), formatPlanDate(date, l10n)),
        (
          l10n.layoutPlanElement.toUpperCase(),
          '${l10n.number(input.elementX)} × ${l10n.number(input.elementY)} mm',
        ),
        (l10n.layoutPlanOffset.toUpperCase(), input.offset.label(l10n)),
        if (input.gapX > 0 || input.gapY > 0)
          (
            l10n.layoutPlanGap.toUpperCase(),
            '${l10n.number(input.gapX)} × ${l10n.number(input.gapY)} mm',
          ),
        if (input.perimeterGap > 0)
          (
            l10n.layoutPlanPerimeterGap.toUpperCase(),
            '${l10n.number(input.perimeterGap)} mm',
          ),
        (l10n.layoutPlanFull.toUpperCase(), '${result.fullCount}'),
        (l10n.layoutPlanCut.toUpperCase(), '${result.cutCount}'),
        (l10n.layoutPlanTotal.toUpperCase(), '${result.totalCount}'),
        (
          l10n.layoutSurface.toUpperCase(),
          '${l10n.number(result.coveredArea / _mm2PerM2)} m²',
        ),
        (
          l10n.layoutPlanWaste.toUpperCase(),
          '${l10n.number(result.wastePercent)} %',
        ),
      ],
      // La liste de débit, qui porte aussi les rangées de bord équilibrées.
      tables: [
        PlanTable(
          title: l10n.layoutPlanCuts.toUpperCase(),
          // La première colonne, étroite, est celle des numéros.
          headers: [
            l10n.planIndex,
            '${l10n.layoutPlanWidthColumn.toUpperCase()} (mm)',
            '${l10n.layoutPlanLengthColumn.toUpperCase()} (mm)',
            l10n.layoutPlanCountColumn.toUpperCase(),
          ],
          rows: [
            for (final (i, cut) in cuts.indexed)
              [
                '${i + 1}',
                l10n.number(cut.w),
                l10n.number(cut.h),
                '${cut.count}',
              ],
          ],
          fallback: cuts.isEmpty
              ? l10n.layoutPlanNoCut
              : l10n.layoutPlanCutsFallback(cuts.length),
        ),
      ],
      note: l10n.layoutPlanNote,
    ),
    drawing: LayoutPainter(result: result, input: input, l10n: l10n),
  );
}

/// Le plan du Calepinage, branché sur les providers : schéma et cartouche.
/// Saisie refusée : le schéma seul.
class LayoutPlanView extends ConsumerWidget {
  const LayoutPlanView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final painter = buildLayoutPlan(
      l10n: l10n,
      input: ref.watch(layoutFormProvider),
      outcome: ref.watch(layoutResultProvider),
      date: DateTime.now(),
    );
    if (painter == null) return const LayoutSchema();

    return CustomPaint(painter: painter, size: Size.infinite);
  }
}

/// Les gestes d'export du plan du Calepinage, branchés sur ses providers.
class LayoutExportAction extends ConsumerWidget {
  const LayoutExportAction({this.compact = false, super.key});

  /// `true` = l'icône de l'`AppBar`, `false` = la rangée en pied de carte.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PlanExportAction(
      tool: Tool.layout,
      compact: compact,
      ready: ref.watch(layoutResultProvider) is LayoutReady,
      buildPlan: (date) => buildLayoutPlan(
        l10n: l10n,
        input: ref.read(layoutFormProvider),
        outcome: ref.read(layoutResultProvider),
        date: date,
      ),
    );
  }
}
