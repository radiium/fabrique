import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/calc/drawers.dart';
import '../../core/format.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/error_banner.dart';
import '../../core/widgets/result_tile.dart';
import '../../core/widgets/schema_card.dart';
import '../../core/widgets/tool_scaffold.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/labels.dart';
import 'drawers_controller.dart';
import 'drawers_cut_list.dart';
import 'drawers_input_groups.dart';
import 'drawers_plan.dart';
import 'drawers_schema.dart';

class DrawersScreen extends ConsumerWidget {
  const DrawersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final input = ref.watch(drawersFormProvider);
    final outcome = ref.watch(drawersResultProvider);
    final result = outcome.result;
    final form = ref.read(drawersFormProvider.notifier);

    return ToolScaffold(
      title: Tool.drawers.label(l10n),
      onReset: form.reset,
      canReset: input != kDrawersDefaults,
      inputGroups: [
        DrawersOpeningGroup(input: input, form: form),
        DrawersFrontsGroup(input: input, form: form),
        DrawersSlideGroup(input: input, form: form),
        DrawersBoxGroup(input: input, form: form),
        // Dans la carte de saisie, pas près des résultats : sur mobile, ils
        // sont sous le schéma.
        if (outcome case DrawersFailure(:final message))
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ErrorBanner(message: message),
          ),
      ],
      visualization: const SchemaCard(
        expandFor: Tool.drawers,
        child: DrawersSchema(),
      ),
      results: [
        ResultTile(
          label: 'Façades — largeur × hauteur',
          value: result == null
              ? kNoValue
              : '${formatNumber(result.frontWidth)} × ${_heights(result)}',
          unit: 'mm',
          note: 'Jeu de ${formatNumber(input.frontGap)} mm entre façades',
        ),
        ResultTile(
          label: 'Caisse — largeur × longueur',
          value: result == null
              ? kNoValue
              : '${formatNumber(result.boxWidth)} × '
                    '${formatNumber(result.boxLength)}',
          unit: 'mm',
          note: result == null
              ? null
              : 'Hors tout, ${formatNumber(result.sideClearance)} mm de jeu '
                    'par côté',
        ),
        if (input.slide != SlideKind.woodOnWood)
          ResultTile(
            label: 'Longueur de glissière',
            value: formatNumber(result?.slideLength),
            unit: 'mm',
            note: result?.isSlideLengthAuto ?? true
                ? 'La plus grande qui tient'
                : 'Imposée',
          ),
        ResultTile(
          label: 'Axes de glissière',
          value: result == null
              ? kNoValue
              : result.slideAxes.map(formatNumber).join(' · '),
          unit: 'mm',
          note: 'Depuis le bas de l’ouverture, de haut en bas',
        ),
        CutListTable(pieces: result?.cutList),
      ],
      resultsFooter: const DrawersExportAction(),
    );
  }

  /// Une hauteur si elles sont toutes égales, la liste sinon.
  static String _heights(DrawersResult r) {
    final heights = r.fronts.map((f) => f.height).toSet();
    return heights.length == 1
        ? formatNumber(heights.single)
        : r.fronts.map((f) => formatNumber(f.height)).join(' · ');
  }
}
