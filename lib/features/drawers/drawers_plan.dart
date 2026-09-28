import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/calc/drawers.dart';
import '../../core/export/plan.dart';
import '../../core/export/plan_export_action.dart';
import '../../core/models/tool.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/labels.dart';
import '../../l10n/numbers.dart';
import 'drawers_controller.dart';
import 'drawers_labels.dart';
import 'drawers_painter.dart';
import 'drawers_schema.dart';

/// Point de construction unique du plan des Tiroirs, pour la page plein
/// écran et l'export. `null` quand la saisie est refusée.
PlanPainter? buildDrawersPlan({
  required AppLocalizations l10n,
  required DrawersInput input,
  required DrawersOutcome outcome,
  required DateTime date,
}) {
  if (outcome case DrawersReady(:final result)) {
    return PlanPainter(
      plan: Plan(
        title: Tool.drawers.label(l10n),
        // Ce que le dessin ne cote pas : l'ouverture, les épaisseurs, la
        // glissière.
        fields: [
          (l10n.planDate.toUpperCase(), formatPlanDate(date, l10n)),
          (
            l10n.drawersPlanFronts.toUpperCase(),
            l10n.drawersPlanFrontsValue(
              input.frontMount.label(l10n),
              l10n.number(input.frontGap),
            ),
          ),
          (
            l10n.drawersOpening.toUpperCase(),
            '${l10n.number(input.openingWidth)} × '
                '${l10n.number(input.openingHeight)} mm',
          ),
          (
            l10n.drawersPlanDepth.toUpperCase(),
            '${l10n.number(input.openingDepth)} mm',
          ),
          (
            l10n.drawersPlanThicknesses.toUpperCase(),
            '${l10n.number(input.sideThickness)} / '
                '${l10n.number(input.bottomThickness)} mm',
          ),
          (
            l10n.drawersPlanFrontThickness.toUpperCase(),
            '${l10n.number(input.frontThickness)} mm',
          ),
          (l10n.drawersSlide.toUpperCase(), input.slide.label(l10n)),
          if (result.slideLength case final length?)
            (l10n.drawersPlanLength.toUpperCase(), '${l10n.number(length)} mm'),
        ],
        // La fiche de débit, puis les axes pour le traçage.
        tables: [
          PlanTable(
            title: l10n.drawersCutList.toUpperCase(),
            // Numéros d'abord. L'épaisseur reste dans les cases : une cinquième
            // colonne ne laisserait pas la place d'écrire `203.67`.
            headers: [
              l10n.planIndex,
              l10n.drawersCutListPart.toUpperCase(),
              l10n.drawersPlanCount.toUpperCase(),
              l10n.drawersPlanLengthColumn,
              l10n.drawersPlanWidthColumn,
            ],
            rows: [
              for (final (i, piece) in result.cutList.indexed)
                [
                  '${i + 1}',
                  piece.part.label(l10n),
                  '${piece.quantity}',
                  l10n.number(piece.length),
                  l10n.number(piece.width),
                ],
            ],
            fallback: l10n.drawersPlanCutListFallback(result.cutList.length),
          ),
          PlanTable(
            title: l10n.drawersPlanAxes.toUpperCase(),
            headers: [
              l10n.planIndex,
              '${l10n.drawersPlanAxesColumn.toUpperCase()} (mm)',
            ],
            rows: [
              for (final (i, axis) in result.slideAxes.indexed)
                ['${i + 1}', l10n.number(axis)],
            ],
            fallback: l10n.drawersPlanAxesFallback(result.slideAxes.length),
          ),
        ],
        note: switch (input.slide) {
          SlideKind.undermount => l10n.drawersPlanUndermountNote,
          SlideKind.ballBearing ||
          SlideKind.woodOnWood ||
          SlideKind.custom => null,
        },
      ),
      drawing: DrawersPainter(result: result, input: input, l10n: l10n),
    );
  }
  return null;
}

/// Le plan des Tiroirs, branché sur les providers : schéma et cartouche.
/// Saisie refusée : le schéma seul.
class DrawersPlanView extends ConsumerWidget {
  const DrawersPlanView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final painter = buildDrawersPlan(
      l10n: l10n,
      input: ref.watch(drawersFormProvider),
      outcome: ref.watch(drawersResultProvider),
      date: DateTime.now(),
    );
    if (painter == null) return const DrawersSchema();

    return CustomPaint(painter: painter, size: Size.infinite);
  }
}

/// Les gestes d'export du plan des Tiroirs, branchés sur ses providers.
class DrawersExportAction extends ConsumerWidget {
  const DrawersExportAction({this.compact = false, super.key});

  /// `true` = l'icône de l'`AppBar`, `false` = la rangée en pied de carte.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PlanExportAction(
      tool: Tool.drawers,
      compact: compact,
      ready: ref.watch(drawersResultProvider) is DrawersReady,
      buildPlan: (date) => buildDrawersPlan(
        l10n: l10n,
        input: ref.read(drawersFormProvider),
        outcome: ref.read(drawersResultProvider),
        date: date,
      ),
    );
  }
}
