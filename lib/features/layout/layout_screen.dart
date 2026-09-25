import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/calc/layout.dart';
import '../../core/format.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/error_banner.dart';
import '../../core/widgets/result_tile.dart';
import '../../core/widgets/schema_card.dart';
import '../../core/widgets/tool_scaffold.dart';
import 'layout_controller.dart';
import 'layout_input_groups.dart';
import 'layout_plan.dart';
import 'layout_schema.dart';

/// Millimètres carrés dans un mètre carré.
///
/// Le cœur travaille en mm ; une surface d'atelier s'y compte en millions, ce
/// qui ne se lit pas. Conversion à la frontière UI, comme le veut la règle de
/// l'unité interne unique.
const double _mm2PerM2 = 1000 * 1000;

/// Outil signature. Un seul outil unifié, pas de sélecteur de mode.
class LayoutScreen extends ConsumerWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(layoutFormProvider);
    final outcome = ref.watch(layoutResultProvider);
    final result = outcome is LayoutReady ? outcome.result : null;
    final form = ref.read(layoutFormProvider.notifier);

    return ToolScaffold(
      title: Tool.layout.label,
      onReset: form.reset,
      canReset: input != kLayoutDefaults,
      inputGroups: [
        LayoutSurfaceGroup(input: input, form: form),
        LayoutElementGroup(input: input, form: form),
        LayoutGapsGroup(input: input, form: form),
        // Le refus s'affiche dans la carte de saisie. Sur mobile, les
        // résultats sont sous le schéma : un message posé là serait lu deux
        // écrans plus bas que le champ fautif.
        if (outcome case LayoutFailure(:final message))
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ErrorBanner(message: message),
          ),
      ],
      visualization: const SchemaCard(
        expandFor: Tool.layout,
        child: LayoutSchema(compact: true),
      ),
      results: [
        ResultTile(
          label: 'Éléments entiers',
          value: result == null ? kNoValue : '${result.fullCount}',
        ),
        ResultTile(
          label: 'Éléments à couper',
          value: result == null ? kNoValue : '${result.cutCount}',
          note: 'Surlignés en orange sur le schéma',
        ),
        if (result case LayoutResult(:final balancedRow?, :final balancedEnd))
          ResultTile(
            label: 'Rangées de bord',
            value: formatNumber(balancedRow),
            unit: 'mm',
            note: _balancedNote(balancedEnd),
          ),
        ResultTile(
          label: 'Total à prévoir',
          value: result == null ? kNoValue : '${result.totalCount}',
          note: 'Stock sans réemploi des chutes',
        ),
        ResultTile(
          label: 'Surface',
          value: formatNumber(
            result == null ? null : result.surfaceArea / _mm2PerM2,
          ),
          unit: 'm²',
          note: result == null
              ? null
              : 'Couverte : '
                    '${formatNumber(result.coveredArea / _mm2PerM2)} m²',
        ),
        ResultTile(
          label: 'Perte',
          value: formatNumber(result?.wastePercent),
          unit: '%',
          note: 'Sans réemploi des chutes — estimation pessimiste',
        ),
      ],
      resultsFooter: const LayoutExportAction(),
    );
  }
}

/// Ce que l'équilibrage a réellement produit.
///
/// Il ne change aucun autre chiffre de la carte — même nombre d'éléments, même
/// perte — donc sans cette tuile l'option semblerait sans effet.
///
/// [end] est la longueur des pièces de bout, nulle quand l'axe de pose ne
/// s'est pas équilibré (tout décalage autre que droit).
String _balancedNote(double? end) {
  const base = 'Première et dernière, à la même épaisseur';
  return end == null ? base : '$base. Pièces de bout : ${formatNumber(end)} mm';
}
