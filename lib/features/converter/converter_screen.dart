import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/calc/units/imperial.dart';
import '../../core/format.dart';
import '../../core/models/measure_unit.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_segmented_button.dart';
import '../../core/widgets/app_switch_field.dart';
import '../../core/widgets/labeled_field.dart';
import '../../core/widgets/number_field.dart';
import '../../core/widgets/result_tile.dart';
import '../../core/widgets/tool_scaffold.dart';
import '../../core/widgets/zoomable_canvas.dart';
import 'comparison_painter.dart';
import 'converter_controller.dart';
import 'converter_painter.dart';

class ConverterScreen extends ConsumerWidget {
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(converterFormProvider);
    final result = ref.watch(converterResultProvider);
    final form = ref.read(converterFormProvider.notifier);

    final quantity = input.quantity;
    final isLength = quantity == Quantity.length;

    return ToolScaffold(
      title: Tool.converter.label,
      onReset: form.reset,
      canReset: input != kConverterDefaults,
      input: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // La grandeur commande tout le reste de la carte — unités, schéma,
          // tuiles — donc elle vient en premier. En liste déroulante et non en
          // segments : « Pression » écrit en toutes lettres ne tient pas dans
          // un segment de téléphone, là où « kPa » tient.
          LabeledField(
            label: 'Grandeur',
            child: AppDropdown<Quantity>(
              value: quantity,
              onSelected: form.setQuantity,
              entries: {for (final q in Quantity.values) q: q.label},
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          NumberField(
            label: 'Valeur',
            // Le suffixe suit l'unité source : la saisie se lit d'un coup
            // d'œil sans remonter au sélecteur.
            suffix: input.unit.symbol,
            value: input.value,
            onChanged: form.setValue,
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledField(
            label: 'Unité source',
            child: AppSegmentedButton<MeasureUnit>(
              value: input.unit,
              onChanged: form.setUnit,
              segments: [
                for (final unit in quantity.units)
                  AppSegment(value: unit, label: unit.symbol),
              ],
            ),
          ),
          // Décomposer en fractions de pouce n'a de sens que pour une
          // longueur. Masqué et non grisé ailleurs : un contrôle mort est pire
          // qu'un contrôle absent.
          if (isLength) ...[
            const SizedBox(height: AppSpacing.md),
            AppSwitchField(
              label: 'Impérial composé',
              help: 'Pied + pouce + fraction, arrondi au 1/16 de pouce.',
              value: input.compoundImperial,
              onChanged: form.setCompoundImperial,
            ),
          ],
        ],
      ),
      // La double règle ne vaut que pour des longueurs ; les autres grandeurs
      // se lisent en rapport à un repère.
      visualization: ZoomableCanvas(
        painter: isLength
            ? RulerPainter(result: result)
            : ComparisonPainter(result: result, unit: input.unit),
      ),
      results: [
        for (final unit in quantity.units)
          ResultTile(
            label: unit.label,
            value: formatNumber(result?.perUnit[unit]),
            unit: unit.symbol,
            note: unit == MeasureUnit.boardFoot
                ? 'L’unité d’achat du bois dur — 144 po³'
                : null,
          ),
        if (isLength && input.compoundImperial)
          ResultTile(
            label: 'Impérial',
            value: result?.imperial == null
                ? kNoValue
                : formatImperial(result!.imperial!),
            note: 'Arrondi au 1/16 de pouce',
          ),
      ],
    );
  }
}
