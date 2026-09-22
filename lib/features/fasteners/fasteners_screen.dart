import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/calc/fasteners.dart';
import '../../core/format.dart';
import '../../core/models/enums.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/labeled_field.dart';
import '../../core/widgets/number_field.dart';
import '../../core/widgets/result_tile.dart';
import '../../core/widgets/tool_scaffold.dart';
import '../../core/widgets/zoomable_canvas.dart';
import 'fasteners_controller.dart';
import 'fasteners_painter.dart';

class FastenersScreen extends ConsumerWidget {
  const FastenersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(fastenerFormProvider);
    final result = ref.watch(fastenerResultProvider);
    final form = ref.read(fastenerFormProvider.notifier);

    return ToolScaffold(
      title: Tool.fasteners.label,
      onReset: form.reset,
      canReset: input != kFastenerDefaults,
      input: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: 'Matériau',
            help: 'Pilote le coefficient d’avant-trou.',
            child: AppDropdown<MaterialKind>(
              value: input.material,
              onSelected: form.setMaterial,
              entries: {for (final m in MaterialKind.values) m: m.label},
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledField(
            label: 'Ø de vis',
            child: AppDropdown<double>(
              value: input.screwDiameter,
              onSelected: form.setScrewDiameter,
              entries: {
                for (final d in screwDiameters) d: '${formatNumber(d)} mm',
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          NumberField(
            label: 'Épaisseur pièce à fixer',
            suffix: 'mm',
            value: input.fixedThickness,
            onChanged: form.setFixedThickness,
          ),
        ],
      ),
      visualization: ZoomableCanvas(
        painter: FastenersPainter(result: result, input: input),
      ),
      results: [
        ResultTile(
          label: 'Ø trou de passage',
          value: formatNumber(result?.clearanceHole),
          unit: 'mm',
          note: 'Ø vis + ${formatNumber(clearanceAllowance)} mm',
        ),
        ResultTile(
          label: 'Ø avant-trou de guidage',
          value: formatNumber(result?.pilotHole),
          unit: 'mm',
          // La justification cite le coefficient réellement appliqué : si la
          // table bouge, la note suit sans qu'on y pense.
          note:
              '${formatNumber(pilotHoleFactor[input.material])} × Ø vis '
              '(${input.material.label.toLowerCase()}) — règle de l’art '
              'indicative',
        ),
        ResultTile(
          label: 'Lamage — Ø × profondeur',
          value: result == null
              ? kNoValue
              : '${formatNumber(result.counterboreDia)} × '
                    '${formatNumber(result.counterboreDepth)}',
          unit: 'mm',
          note: 'Ø tête ≈ ${formatNumber(counterboreDiaFactor)} × Ø vis',
        ),
        ResultTile(
          label: 'Longueur de vis',
          value: formatNumber(result?.screwLength),
          unit: 'mm',
          note: result == null ? null : _penetrationNote(result.penetration),
        ),
      ],
    );
  }

  /// Dit d'où sort la longueur, et signale l'écrêtage quand il mord — sinon la
  /// longueur semble décrocher de l'épaisseur sans raison.
  static String _penetrationNote(double penetration) {
    final base =
        'Pénétration de ${formatNumber(penetration)} mm dans le '
        'support';
    return penetration >= maxPenetration
        ? '$base — plafonnée à ${formatNumber(maxPenetration)} mm'
        : '$base (${formatNumber(penetrationFactor)} × épaisseur)';
  }
}
