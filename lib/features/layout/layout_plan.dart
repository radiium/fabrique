import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/calc/layout.dart';
import '../../core/export/plan.dart';
import '../../core/export/plan_export.dart';
import '../../core/format.dart';
import '../../core/models/enums.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/app_card_actions.dart';
import '../../core/widgets/haptics.dart';
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
      table: PlanTable(
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

/// Les deux gestes du plan : l'enregistrer, ou l'envoyer.
///
/// En pied de la carte de résultats, et en icône dans l'`AppBar` de la page
/// plein écran, qui n'a pas de carte de résultats. Là-bas une seule action,
/// l'enregistrement : « ajuster » et « pivoter » occupent déjà la barre.
///
/// Les deux s'éteignent tant que la saisie est refusée, jamais ne
/// disparaissent — même règle que « réinitialiser ».
class LayoutExportAction extends ConsumerStatefulWidget {
  const LayoutExportAction({this.compact = false, super.key});

  /// `true` = l'icône de l'`AppBar`, `false` = la rangée en pied de carte.
  final bool compact;

  @override
  ConsumerState<LayoutExportAction> createState() => _LayoutExportActionState();
}

/// Ce qui tourne, pour n'éteindre que le bouton concerné.
enum _Running { none, save, share }

class _LayoutExportActionState extends ConsumerState<LayoutExportAction> {
  _Running _running = _Running.none;

  /// Le plan à l'instant du tap.
  ///
  /// La saisie est relue, jamais observée : construire le plan à chaque frappe
  /// grouperait la liste de débit — jusqu'à 5000 éléments parcourus — pour des
  /// boutons qui n'ont besoin que de savoir s'il y a un résultat.
  (PlanPainter, DateTime)? _snapshot() {
    final date = DateTime.now();
    final painter = buildLayoutPlan(
      input: ref.read(layoutFormProvider),
      outcome: ref.read(layoutResultProvider),
      date: date,
    );
    return painter == null ? null : (painter, date);
  }

  Future<void> _run(
    _Running which,
    Future<bool> Function(
      BuildContext context, {
      required PlanPainter painter,
      required Tool tool,
      required DateTime date,
    })
    action,
  ) async {
    final snapshot = _snapshot();
    if (snapshot == null) return;
    final (painter, date) = snapshot;

    setState(() => _running = which);
    try {
      await action(context, painter: painter, tool: Tool.layout, date: date);
    } finally {
      if (mounted) setState(() => _running = _Running.none);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ready = ref.watch(layoutResultProvider) is LayoutReady;
    final idle = ready && _running == _Running.none;

    if (widget.compact) {
      return IconButton(
        icon: _running == _Running.save
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.download),
        tooltip: 'Exporter le plan',
        onPressed: idle
            ? () {
                hapticSelection(context);
                unawaited(_run(_Running.save, savePlan));
              }
            : null,
      );
    }

    return AppCardActions(
      actions: [
        CardAction(
          icon: Icons.download,
          label: 'Exporter',
          busy: _running == _Running.save,
          onTap: idle ? () => _run(_Running.save, savePlan) : null,
        ),
        CardAction(
          icon: Icons.share,
          label: 'Partager',
          busy: _running == _Running.share,
          onTap: idle ? () => _run(_Running.share, sharePlan) : null,
        ),
      ],
    );
  }
}
