import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/calc/distribution.dart';
import '../../core/format.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/error_banner.dart';
import '../../core/widgets/result_tile.dart';
import '../../core/widgets/schema_card.dart';
import '../../core/widgets/tool_scaffold.dart';
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
    final input = ref.watch(distributionFormProvider);
    final outcome = ref.watch(distributionResultProvider);
    final form = ref.read(distributionFormProvider.notifier);

    final ready = outcome is DistributionReady ? outcome : null;
    final result = ready?.best;

    return ToolScaffold(
      title: Tool.distribution.label,
      onReset: form.reset,
      canReset: input != kDistributionDefaults,
      inputGroups: [
        DistributionGeometryGroup(input: input, ready: ready, form: form),
        DistributionEdgesGroup(input: input, form: form),
        // Le refus s'affiche dans la carte de saisie. Sur mobile, les
        // résultats sont sous le schéma : un message posé là serait lu deux
        // écrans plus bas que le champ fautif.
        if (outcome case DistributionFailure(:final message))
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ErrorBanner(message: message),
          ),
      ],
      // Plus haute que le 16/10 commun : la vue d'ensemble et les deux
      // panneaux de détail s'empilent, et ils s'empilent en hauteur de texte.
      // Le rapport est calé pour que la boîte de référence du painter tienne
      // au facteur 1 sur un téléphone — ni agrandie, ni réduite.
      visualizationAspectRatio: 5 / 4,
      visualization: const SchemaCard(
        expandFor: Tool.distribution,
        child: DistributionSchema(),
      ),
      results: [
        if (input.mode == DistributionMode.count)
          ResultTile(
            label: 'Nombre d’éléments',
            value: result == null ? kNoValue : '${result.count}',
            note:
                'Pour un écart visé de ${formatNumber(input.targetSpacing)} '
                'mm',
          ),
        ResultTile(
          label: input.mode == DistributionMode.count
              ? 'Écart obtenu'
              : 'Écart',
          value: formatNumber(result?.spacing),
          unit: 'mm',
          note: result == null ? null : _gapRule(result),
        ),
        // Sans épaisseur, l'entraxe *est* l'écart : deux tuiles identiques ne
        // diraient rien de plus.
        if (input.elementWidth > 0)
          ResultTile(
            label: 'Entraxe',
            value: formatNumber(result?.pitch),
            unit: 'mm',
            note: 'D’un bord d’élément au bord suivant',
          ),
        PositionsTable(result: result, hasWidth: input.elementWidth > 0),
      ],
      resultsFooter: const DistributionExportAction(),
    );
  }

  /// Rappelle la règle du modèle avec les chiffres en cours. Le nombre de jeux
  /// vient du cœur : il dépend des bords, et l'écran n'a pas à le redéduire.
  static String _gapRule(DistributionResult r) =>
      '${r.count} élément${pluralS(r.count)} → '
      '${r.gapCount} écart${pluralS(r.gapCount)}';
}
