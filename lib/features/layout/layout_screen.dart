import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/models/enums.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/app_segmented_button.dart';
import '../../core/widgets/app_switch_field.dart';
import '../../core/widgets/labeled_field.dart';
import '../../core/widgets/number_field.dart';
import '../../core/widgets/result_tile.dart';
import '../../core/widgets/tool_scaffold.dart';
import '../../core/widgets/zoomable_canvas.dart';
import 'layout_controller.dart';
import 'layout_painter.dart';

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
    final result = ref.watch(layoutResultProvider);
    final form = ref.read(layoutFormProvider.notifier);

    return ToolScaffold(
      title: Tool.layout.label,
      onReset: form.reset,
      canReset: input != kLayoutDefaults,
      input: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Les cotes vont par paires : six champs empilés repousseraient le
          // schéma — la vedette de l'écran — sous la ligne de flottaison.
          _Pair(
            first: NumberField(
              label: 'Surface — largeur',
              suffix: 'mm',
              value: input.surfaceX,
              onChanged: form.setSurfaceX,
            ),
            second: NumberField(
              label: 'Surface — longueur',
              suffix: 'mm',
              value: input.surfaceY,
              onChanged: form.setSurfaceY,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _Pair(
            first: NumberField(
              label: 'Élément — largeur',
              suffix: 'mm',
              value: input.elementX,
              onChanged: form.setElementX,
            ),
            second: NumberField(
              label: 'Élément — longueur',
              suffix: 'mm',
              value: input.elementY,
              onChanged: form.setElementY,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _Pair(
            first: NumberField(
              label: 'Jeu horizontal',
              suffix: 'mm',
              value: input.gapX,
              onChanged: form.setGapX,
            ),
            second: NumberField(
              label: 'Jeu vertical',
              suffix: 'mm',
              value: input.gapY,
              onChanged: form.setGapY,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppSwitchField(
            label: 'Inverser l’orientation',
            help: 'Pose les éléments dans l’autre sens. Le décalage suit.',
            value: input.flip,
            onChanged: form.setFlip,
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledField(
            label: 'Décalage des joints',
            help: 'Décale le départ de chaque rangée sur la précédente.',
            child: AppSegmentedButton<JointOffset>(
              value: input.offset,
              onChanged: form.setOffset,
              segments: [
                for (final offset in JointOffset.values)
                  AppSegment(value: offset, label: offset.label),
              ],
            ),
          ),
        ],
      ),
      visualization: ZoomableCanvas(
        painter: LayoutPainter(result: result, input: input),
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
        ResultTile(
          label: 'Total à prévoir',
          value: result == null ? kNoValue : '${result.totalCount}',
          note: 'Stock v1, sans réemploi des chutes',
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
          note: 'v1 sans réemploi des chutes — estimation pessimiste',
        ),
      ],
    );
  }
}

/// Deux champs de même famille côte à côte (largeur × longueur, jeu X × jeu Y).
///
/// Aucun des deux ne porte de boutons − / + : à cette largeur ils tiennent, là
/// où une paire de [NumberField] à pas serait illisible sur un téléphone.
class _Pair extends StatelessWidget {
  const _Pair({required this.first, required this.second});

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: second),
      ],
    );
  }
}
