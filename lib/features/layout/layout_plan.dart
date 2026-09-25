import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/calc/layout.dart';
import '../../core/export/plan.dart';
import '../../core/export/plan_export_action.dart';
import '../../core/format.dart';
import '../../core/models/enums.dart';
import '../../core/models/tool.dart';
import 'layout_controller.dart';
import 'layout_painter.dart';
import 'layout_schema.dart';

/// Millimètres carrés dans un mètre carré.
const double _mm2PerM2 = 1000 * 1000;

/// Point de construction unique du plan du Calepinage.
///
/// La page plein écran et l'export le traversent tous les deux, comme la
/// vignette et le plein écran traversent [LayoutSchema] : c'est ce qui garantit
/// que le fichier exporté est exactement ce que l'aperçu montre.
///
/// `null` quand la saisie est refusée. Il n'y a alors pas de plan à faire — le
/// cartouche n'aurait que des tirets, et l'écran de l'outil dit déjà pourquoi.
PlanPainter? buildLayoutPlan({
  required LayoutInput input,
  required LayoutOutcome outcome,
  required DateTime date,
}) {
  if (outcome is! LayoutReady) return null;
  final result = outcome.result;
  final cuts = summarizeCuts(result);

  return PlanPainter(
    plan: Plan(
      title: Tool.layout.label,
      // Le cartouche ne porte **que ce que le dessin ne cote pas**. Les deux
      // cotes de la surface sont sur le schéma, aux mêmes chiffres exacts.
      // L'élément, lui, est dessiné sans être coté, et les jeux ne se mesurent
      // pas à l'œil sur une trame.
      fields: [
        ('DATE', formatPlanDate(date)),
        (
          'ÉLÉMENT',
          '${formatNumber(input.elementX)} × ${formatNumber(input.elementY)} mm',
        ),
        ('DÉCALAGE', input.offset.label),
        if (input.gapX > 0 || input.gapY > 0)
          (
            'JEU',
            '${formatNumber(input.gapX)} × ${formatNumber(input.gapY)} mm',
          ),
        if (input.perimeterGap > 0)
          ('JEU PÉRIPH.', '${formatNumber(input.perimeterGap)} mm'),
        ('ENTIERS', '${result.fullCount}'),
        ('À COUPER', '${result.cutCount}'),
        ('TOTAL', '${result.totalCount}'),
        ('SURFACE', '${formatNumber(result.coveredArea / _mm2PerM2)} m²'),
        ('PERTE', '${formatNumber(result.wastePercent)} %'),
      ],
      // La liste de débit : ce qu'on emporte à la scie. Elle remplace la table
      // des positions de la Répartition, et elle rend inutile une case pour
      // les rangées de bord équilibrées — leur cote est déjà une ligne ici.
      tables: [
        PlanTable(
          title: 'PIÈCES À COUPER',
          // La première colonne est celle des numéros, étroite et fixe : les
          // nombres vont donc dans les colonnes larges qui suivent.
          headers: const ['N°', 'LARG. (mm)', 'LONG. (mm)', 'NB'],
          rows: [
            for (final (i, cut) in cuts.indexed)
              [
                '${i + 1}',
                formatNumber(cut.w),
                formatNumber(cut.h),
                '${cut.count}',
              ],
          ],
          fallback: cuts.isEmpty
              ? 'Aucune coupe, tout tombe juste'
              : '${cuts.length} cotes de coupe — à lire dans l’app',
        ),
      ],
      // L'avertissement de l'outil, réservé avant tout le reste : c'est la
      // ligne qu'on n'a pas le droit de perdre sous un débordement.
      note:
          'Perte estimée sans réemploi des chutes. Chaque coupe consomme un '
          'élément entier.',
    ),
    drawing: LayoutPainter(result: result, input: input),
  );
}

/// Le plan du Calepinage, branché sur les providers.
///
/// C'est ce que montre la page plein écran : le schéma **et** son cartouche,
/// c'est-à-dire l'image qui sortira. Un aperçu qui ne montrerait que le dessin
/// laisserait découvrir le cartouche après coup, dans le fichier.
///
/// Saisie refusée : on retombe sur le schéma seul, qui pose son tiret.
class LayoutPlanView extends ConsumerWidget {
  const LayoutPlanView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final painter = buildLayoutPlan(
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
    return PlanExportAction(
      tool: Tool.layout,
      compact: compact,
      ready: ref.watch(layoutResultProvider) is LayoutReady,
      buildPlan: (date) => buildLayoutPlan(
        input: ref.read(layoutFormProvider),
        outcome: ref.read(layoutResultProvider),
        date: date,
      ),
    );
  }
}
