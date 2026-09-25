import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/calc/drawers.dart';
import '../../core/export/plan.dart';
import '../../core/export/plan_export_action.dart';
import '../../core/format.dart';
import '../../core/models/tool.dart';
import 'drawers_controller.dart';
import 'drawers_painter.dart';
import 'drawers_schema.dart';

/// Point de construction unique du plan des Tiroirs, pour l'aperçu comme pour
/// l'export.
///
/// `null` quand la saisie est refusée : l'écran de l'outil dit déjà pourquoi.
PlanPainter? buildDrawersPlan({
  required DrawersInput input,
  required DrawersOutcome outcome,
  required DateTime date,
}) {
  if (outcome case DrawersReady(:final result)) {
    return PlanPainter(
      plan: Plan(
        title: Tool.drawers.label,
        // Ce que le dessin ne cote pas : l'ouverture, les épaisseurs, la
        // glissière. Les façades et la caisse sont cotées sur les deux vues.
        // Bois sur bois, la glissière reste seule sur sa rangée, en pleine
        // largeur.
        fields: [
          ('DATE', formatPlanDate(date)),
          (
            'FAÇADES',
            '${input.frontMount.label}, jeu ${formatNumber(input.frontGap)}',
          ),
          (
            'OUVERTURE',
            '${formatNumber(input.openingWidth)} × '
                '${formatNumber(input.openingHeight)} mm',
          ),
          ('PROFONDEUR', '${formatNumber(input.openingDepth)} mm'),
          (
            'ÉP. CÔTÉS / FOND',
            '${formatNumber(input.sideThickness)} / '
                '${formatNumber(input.bottomThickness)} mm',
          ),
          ('ÉP. FAÇADE', '${formatNumber(input.frontThickness)} mm'),
          ('GLISSIÈRE', input.slide.label),
          if (result.slideLength case final length?)
            ('LONGUEUR', '${formatNumber(length)} mm'),
        ],
        // La fiche de débit d'abord : c'est ce qu'on emporte à la scie. Les
        // axes ensuite, pour le traçage au montage.
        tables: [
          PlanTable(
            title: 'FICHE DE DÉBIT',
            // La première colonne est celle des numéros, étroite et fixe.
            // L'épaisseur est dans les cases : une cinquième colonne ne
            // laisserait plus la place d'écrire `203.67`.
            headers: const ['N°', 'PIÈCE', 'NB', 'L (mm)', 'l (mm)'],
            rows: [
              for (final (i, piece) in result.cutList.indexed)
                [
                  '${i + 1}',
                  piece.part.label,
                  '${piece.quantity}',
                  formatNumber(piece.length),
                  formatNumber(piece.width),
                ],
            ],
            fallback:
                '${result.cutList.length} lignes de débit — à lire dans '
                'l’app',
          ),
          PlanTable(
            title: 'AXES DE GLISSIÈRE, TIROIR 1 EN HAUT',
            headers: const ['N°', 'DEPUIS LE BAS DE L’OUVERTURE (mm)'],
            rows: [
              for (final (i, axis) in result.slideAxes.indexed)
                ['${i + 1}', formatNumber(axis)],
            ],
            fallback: '${result.slideAxes.length} axes — à lire dans l’app',
          ),
        ],
        note: switch (input.slide) {
          SlideKind.undermount =>
            'Cotes de glissière sous tiroir indicatives. Vérifier sur la '
                'fiche du fabricant.',
          SlideKind.ballBearing ||
          SlideKind.woodOnWood ||
          SlideKind.custom => null,
        },
      ),
      drawing: DrawersPainter(result: result, input: input),
    );
  }
  return null;
}

/// Le plan des Tiroirs, branché sur les providers : ce que montre la page
/// plein écran, cartouche compris.
///
/// Saisie refusée : on retombe sur le schéma seul, qui pose son tiret.
class DrawersPlanView extends ConsumerWidget {
  const DrawersPlanView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final painter = buildDrawersPlan(
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
    return PlanExportAction(
      tool: Tool.drawers,
      compact: compact,
      ready: ref.watch(drawersResultProvider) is DrawersReady,
      buildPlan: (date) => buildDrawersPlan(
        input: ref.read(drawersFormProvider),
        outcome: ref.read(drawersResultProvider),
        date: date,
      ),
    );
  }
}
