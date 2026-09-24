import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/export/plan.dart';
import '../../core/export/plan_export.dart';
import '../../core/format.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/app_card_actions.dart';
import '../../core/widgets/haptics.dart';
import 'distribution_controller.dart';
import 'distribution_form.dart';
import 'distribution_painter.dart';
import 'distribution_schema.dart';

/// Point de construction unique du plan de la Répartition.
///
/// La page plein écran et l'export le traversent tous les deux, comme la
/// vignette et le plein écran traversent [DistributionSchema] : c'est ce qui
/// garantit que le fichier exporté est exactement ce que l'aperçu montre.
///
/// `null` quand la saisie est refusée. Il n'y a alors pas de plan à faire — le
/// cartouche n'aurait que des tirets, et l'écran de l'outil dit déjà pourquoi.
PlanPainter? buildDistributionPlan({
  required DistributionFormState input,
  required DistributionOutcome outcome,
  required DateTime date,
}) {
  if (outcome is! DistributionReady) return null;
  final result = outcome.best;
  final hasWidth = input.elementWidth > 0;
  final byCount = input.mode == DistributionMode.count;

  return PlanPainter(
    plan: Plan(
      title: Tool.distribution.label,
      // Le cartouche ne porte **que ce que le dessin ne cote pas**. La largeur
      // totale, la largeur d'élément et les marges sont sur le schéma, aux
      // mêmes chiffres exacts : les réécrire ici serait une redite, et chaque
      // case gagnée est une position de plus dans la table.
      fields: [
        ('DATE', formatPlanDate(date)),
        ('ÉLÉMENTS', '${result.count}'),
        // L'écart visé est la seule saisie que le dessin ne montre pas — il ne
        // porte que l'écart obtenu. Sans elle, rien n'explique le nombre
        // trouvé, d'où sa place juste avant sa réponse.
        if (byCount)
          ('ÉCART SOUHAITÉ', '${formatNumber(input.targetSpacing)} mm'),
        (
          byCount ? 'ÉCART OBTENU' : 'ÉCART',
          '${formatNumber(result.spacing)} mm',
        ),
        // Sans épaisseur, l'entraxe *est* l'écart : deux cases identiques ne
        // diraient rien de plus, ici comme sur l'écran.
        if (hasWidth) ('ENTRAXE', '${formatNumber(result.pitch)} mm'),
        ('ÉCARTS', '${result.gapCount}'),
      ],
      table: PlanTable(
        title: 'POSITIONS DEPUIS L’ORIGINE',
        headers: [
          'N°',
          hasWidth ? 'BORD (mm)' : 'POSITION (mm)',
          if (hasWidth) 'CENTRE (mm)',
        ],
        rows: [
          for (final (i, position) in result.positions.indexed)
            [
              '${i + 1}',
              formatNumber(position),
              if (hasWidth) formatNumber(result.centers[i]),
            ],
        ],
        fallback:
            '${result.positions.length} positions — à copier depuis l’app',
      ),
    ),
    drawing: DistributionPainter(
      result: result,
      length: input.length,
      elementWidth: input.elementWidth,
      startOffset: input.startOffset,
      endOffset: input.endOffset,
    ),
  );
}

/// Le plan de la Répartition, branché sur les providers.
///
/// C'est ce que montre la page plein écran : le schéma **et** son cartouche,
/// c'est-à-dire l'image qui sortira. Un aperçu qui ne montrerait que le dessin
/// laisserait découvrir le cartouche après coup, dans le fichier.
///
/// Saisie refusée : on retombe sur le schéma seul, qui pose son tiret. Il n'y a
/// pas de plan à montrer, et un cartouche vide en serait un mauvais.
class DistributionPlanView extends ConsumerWidget {
  const DistributionPlanView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final painter = buildDistributionPlan(
      input: ref.watch(distributionFormProvider),
      outcome: ref.watch(distributionResultProvider),
      date: DateTime.now(),
    );
    if (painter == null) return const DistributionSchema();

    return CustomPaint(painter: painter, size: Size.infinite);
  }
}

/// Les deux gestes du plan : l'enregistrer, ou l'envoyer.
///
/// **Enregistrer d'abord.** Le sélecteur de partage d'Android ne liste que des
/// applications — il n'y a pas d'action « enregistrer » dedans, contrairement à
/// iOS. Sans ce premier bouton, on ne pourrait pas simplement garder son plan.
///
/// En pied de la carte de résultats, et en icône dans l'`AppBar` de la page
/// plein écran, qui n'a pas de carte de résultats. Là-bas une seule action,
/// l'enregistrement : « ajuster » et « pivoter » occupent déjà la barre, et
/// partager reste à un écran de distance.
///
/// Les deux s'éteignent tant que la saisie est refusée, jamais ne
/// disparaissent — même règle que « réinitialiser ».
class DistributionExportAction extends ConsumerStatefulWidget {
  const DistributionExportAction({this.compact = false, super.key});

  /// `true` = l'icône de l'`AppBar`, `false` = la rangée en pied de carte.
  final bool compact;

  @override
  ConsumerState<DistributionExportAction> createState() =>
      _DistributionExportActionState();
}

/// Ce qui tourne, pour n'éteindre que le bouton concerné.
enum _Running { none, save, share }

class _DistributionExportActionState
    extends ConsumerState<DistributionExportAction> {
  _Running _running = _Running.none;

  /// Le plan à l'instant du tap.
  ///
  /// La saisie est relue, jamais observée : construire le plan à chaque frappe
  /// rebâtirait la table des positions — jusqu'à 500 lignes — pour des boutons
  /// qui n'ont besoin que de savoir s'il y a un résultat.
  (PlanPainter, DateTime)? _snapshot() {
    final date = DateTime.now();
    final painter = buildDistributionPlan(
      input: ref.read(distributionFormProvider),
      outcome: ref.read(distributionResultProvider),
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
      await action(
        context,
        painter: painter,
        tool: Tool.distribution,
        date: date,
      );
    } finally {
      if (mounted) setState(() => _running = _Running.none);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ready = ref.watch(distributionResultProvider) is DistributionReady;
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
