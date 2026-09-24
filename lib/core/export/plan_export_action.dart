import 'dart:async';

import 'package:flutter/material.dart';

import '../models/tool.dart';
import '../widgets/app_card_actions.dart';
import '../widgets/haptics.dart';
import 'plan.dart';
import 'plan_export.dart';

/// Les deux gestes du plan d'un outil : l'enregistrer, ou l'envoyer.
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
///
/// Sans Riverpod : chaque outil l'enveloppe dans un widget qui lit ses propres
/// providers, et le passe en [ready] et [buildPlan].
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

  /// Construit le plan à l'instant du tap, daté de `date`. `null` quand la
  /// saisie est refusée.
  ///
  /// Une fonction et non un plan tout fait : la saisie est relue au tap,
  /// jamais observée. Construire le plan à chaque frappe rebâtirait sa table
  /// (jusqu'à 500 positions, ou une liste de débit tirée de 5000 éléments)
  /// pour des boutons qui n'ont besoin que de savoir s'il y a un résultat.
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
