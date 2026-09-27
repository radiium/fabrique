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
import '../../core/widgets/schema_card.dart';
import '../../core/widgets/tool_scaffold.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/labels.dart';
import '../../l10n/numbers.dart';
import 'converter_controller.dart';
import 'converter_schema.dart';

class ConverterScreen extends ConsumerWidget {
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final input = ref.watch(converterFormProvider);
    final result = ref.watch(converterResultProvider);
    final form = ref.read(converterFormProvider.notifier);

    final quantity = input.quantity;
    final isLength = quantity == Quantity.length;

    return ToolScaffold(
      title: Tool.converter.label(l10n),
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
            label: l10n.converterQuantity,
            child: AppDropdown<Quantity>(
              value: quantity,
              onSelected: form.setQuantity,
              entries: {for (final q in Quantity.values) q: q.label(l10n)},
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          NumberField(
            label: l10n.converterValue,
            // Le suffixe suit l'unité source : la saisie se lit d'un coup
            // d'œil sans remonter au sélecteur.
            suffix: input.unit.symbol(l10n),
            value: input.value,
            onChanged: form.setValue,
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledField(
            label: l10n.converterSourceUnit,
            child: AppSegmentedButton<MeasureUnit>(
              value: input.unit,
              onChanged: form.setUnit,
              segments: [
                for (final unit in quantity.units)
                  AppSegment(value: unit, label: unit.symbol(l10n)),
              ],
            ),
          ),
          // Décomposer en fractions de pouce n'a de sens que pour une
          // longueur. Masqué et non grisé ailleurs : un contrôle mort est pire
          // qu'un contrôle absent.
          if (isLength) ...[
            const SizedBox(height: AppSpacing.md),
            AppSwitchField(
              label: l10n.converterCompoundImperial,
              help: l10n.converterCompoundImperialHelp,
              value: input.compoundImperial,
              onChanged: form.setCompoundImperial,
            ),
          ],
        ],
      ),
      // La double règle ne vaut que pour des longueurs ; les autres grandeurs
      // se lisent en rapport à un repère.
      visualization: const SchemaCard(
        expandFor: Tool.converter,
        child: ConverterSchema(),
      ),
      results: [
        for (final unit in quantity.units)
          ResultTile(
            label: unit.label(l10n),
            value: l10n.number(result?.perUnit[unit]),
            unit: unit.symbol(l10n),
            note: unit == MeasureUnit.boardFoot
                ? l10n.converterBoardFootNote
                : null,
          ),
        if (isLength && input.compoundImperial)
          ResultTile(
            label: l10n.converterImperial,
            value: switch (result?.imperial) {
              final parts? => formatImperial(parts),
              null => kNoValue,
            },
            note: l10n.converterImperialNote,
          ),
      ],
    );
  }
}
