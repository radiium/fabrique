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
import '../../l10n/calc_errors.dart';
import '../../l10n/labels.dart';
import '../../l10n/numbers.dart';
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
        if (outcome case DrawersFailure(:final reason))
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ErrorBanner(message: l10n.calcError(reason)),
          ),
      ],
      visualization: const SchemaCard(
        expandFor: Tool.drawers,
        child: DrawersSchema(),
      ),
      results: [
        ResultTile(
          label: l10n.drawersFrontsResult,
          value: result == null
              ? kNoValue
              : '${l10n.number(result.frontWidth)} × ${_heights(result, l10n)}',
          unit: 'mm',
          note: l10n.drawersFrontsResultNote(l10n.number(input.frontGap)),
        ),
        ResultTile(
          label: l10n.drawersBoxResult,
          value: result == null
              ? kNoValue
              : '${l10n.number(result.boxWidth)} × '
                    '${l10n.number(result.boxLength)}',
          unit: 'mm',
          note: result == null
              ? null
              : l10n.drawersBoxResultNote(l10n.number(result.sideClearance)),
        ),
        if (input.slide != SlideKind.woodOnWood)
          ResultTile(
            label: l10n.drawersSlideLength,
            value: l10n.number(result?.slideLength),
            unit: 'mm',
            note: result?.isSlideLengthAuto ?? true
                ? l10n.drawersSlideLengthAutoNote
                : l10n.drawersSlideLengthImposedNote,
          ),
        ResultTile(
          label: l10n.drawersSlideAxes,
          value: result == null
              ? kNoValue
              : result.slideAxes.map(l10n.number).join(' · '),
          unit: 'mm',
          note: l10n.drawersSlideAxesNote,
        ),
        CutListTable(pieces: result?.cutList),
      ],
      resultsFooter: const DrawersExportAction(),
    );
  }

  /// Une hauteur si elles sont toutes égales, la liste sinon.
  static String _heights(DrawersResult r, AppLocalizations l10n) {
    final heights = r.fronts.map((f) => f.height).toSet();
    return heights.length == 1
        ? l10n.number(heights.single)
        : r.fronts.map((f) => l10n.number(f.height)).join(' · ');
  }
}
