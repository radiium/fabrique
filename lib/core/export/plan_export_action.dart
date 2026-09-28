import 'dart:async';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../models/tool.dart';
import '../widgets/app_card_actions.dart';
import '../widgets/haptics.dart';
import 'plan.dart';
import 'plan_export.dart';

/// Les deux gestes du plan d'un outil : l'enregistrer, ou l'envoyer.
///
/// Enregistrer d'abord : le partage Android n'offre pas d'action
/// « enregistrer ». En icône (`compact`), l'enregistrement seul. Éteints tant
/// que la saisie est refusée. Chaque outil fournit [ready] et [buildPlan].
class PlanExportAction extends StatefulWidget {
  const PlanExportAction({
    required this.tool,
    required this.ready,
    required this.buildPlan,
    this.compact = false,
    super.key,
  });

  /// L'outil dont on exporte le plan : il nomme le fichier.
  final Tool tool;

  /// La saisie est acceptée, il y a un plan à exporter.
  final bool ready;

  /// Construit le plan au tap, daté de `date`. `null` si la saisie est
  /// refusée. Une fonction, pour ne pas rebâtir la table à chaque frappe.
  final PlanPainter? Function(DateTime date) buildPlan;

  /// `true` = l'icône de l'`AppBar`, `false` = la rangée en pied de carte.
  final bool compact;

  @override
  State<PlanExportAction> createState() => _PlanExportActionState();
}

/// Ce qui tourne, pour n'éteindre que le bouton concerné.
enum _Running { none, save, share }

class _PlanExportActionState extends State<PlanExportAction> {
  _Running _running = _Running.none;

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
    final date = DateTime.now();
    final painter = widget.buildPlan(date);
    if (painter == null) return;

    setState(() => _running = which);
    try {
      await action(context, painter: painter, tool: widget.tool, date: date);
    } finally {
      if (mounted) setState(() => _running = _Running.none);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final idle = widget.ready && _running == _Running.none;

    if (widget.compact) {
      return IconButton(
        icon: _running == _Running.save
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.download),
        tooltip: l10n.planExportTooltip,
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
          label: l10n.planExport,
          busy: _running == _Running.save,
          onTap: idle ? () => _run(_Running.save, savePlan) : null,
        ),
        CardAction(
          icon: Icons.share,
          label: l10n.planShare,
          busy: _running == _Running.share,
          onTap: idle ? () => _run(_Running.share, sharePlan) : null,
        ),
      ],
    );
  }
}
