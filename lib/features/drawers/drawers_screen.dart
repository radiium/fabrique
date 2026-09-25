import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/calc/drawers.dart';
import '../../core/format.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/result_tile.dart';
import '../../core/widgets/schema_card.dart';
import '../../core/widgets/tool_scaffold.dart';
import 'drawers_controller.dart';
import 'drawers_cut_list.dart';
import 'drawers_input_groups.dart';
import 'drawers_schema.dart';

class DrawersScreen extends ConsumerWidget {
  const DrawersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(drawersFormProvider);
    final result = ref.watch(drawersResultProvider);
    final form = ref.read(drawersFormProvider.notifier);

    return ToolScaffold(
      title: Tool.drawers.label,
      onReset: form.reset,
      canReset: input != kDrawersDefaults,
      inputGroups: [
        DrawersOpeningGroup(input: input, form: form),
        DrawersFrontsGroup(input: input, form: form),
        DrawersSlideGroup(input: input, form: form),
        DrawersBoxGroup(input: input, form: form),
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
