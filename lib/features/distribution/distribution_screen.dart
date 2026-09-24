import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/calc/distribution.dart';
import '../../core/format.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/app_disclosure.dart';
import '../../core/widgets/app_segmented_button.dart';
import '../../core/widgets/error_banner.dart';
import '../../core/widgets/field_pair.dart';
import '../../core/widgets/labeled_field.dart';
import '../../core/widgets/number_field.dart';
import '../../core/widgets/result_tile.dart';
import '../../core/widgets/schema_card.dart';
import '../../core/widgets/tool_scaffold.dart';
import 'distribution_controller.dart';
import 'distribution_edge_grid.dart';
import 'distribution_form.dart';
import 'distribution_help.dart';
import 'distribution_plan.dart';
import 'distribution_positions_table.dart';
import 'distribution_schema.dart';
import 'distribution_target_callout.dart';

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
      input: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: 'Mode de calcul',
            about: kAboutMode,
            child: AppSegmentedButton<DistributionMode>(
              segments: [
                for (final mode in DistributionMode.values)
                  AppSegment(value: mode, label: mode.label),
              ],
              value: input.mode,
              onChanged: form.setMode,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Les deux cotes de la géométrie vont par paire, sans boutons − / + :
          // à cette largeur, une paire de champs à pas serait illisible.
          FieldPair(
            first: NumberField(
              label: 'Largeur totale',
              suffix: 'mm',
              about: kAboutLength,
              value: input.length,
              onChanged: form.setLength,
            ),
            second: NumberField(
              label: 'Largeur d’un élément',
              suffix: 'mm',
              about: kAboutElementWidth,
              value: input.elementWidth,
              onChanged: form.setElementWidth,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Le champ qui reste est celui que l'on connaît : le mode ne change
          // pas seulement le résultat, il échange la saisie et la réponse.
          if (input.mode == DistributionMode.spacing)
            NumberField(
              label: 'Nombre d’éléments',
              about: kAboutCount,
              value: input.count.toDouble(),
              onChanged: (v) => form.setCount(v.round()),
              decimal: false,
              step: 1,
              min: minDistributionCount(
                input.startEdge,
                input.endEdge,
              ).toDouble(),
              max: kMaxDistributionCount.toDouble(),
            )
          else ...[
            NumberField(
              label: 'Écart souhaité',
              suffix: 'mm',
              help: 'Le nombre d’éléments s’ajuste au plus proche.',
              about: kAboutTargetSpacing,
              value: input.targetSpacing,
              onChanged: form.setTargetSpacing,
              step: 5,
            ),
            // L'arbitrage se pose là où la question est posée. En tuile de
            // résultat, il se lirait sous le schéma sur mobile — deux écrans
            // plus bas que le champ qu'il concerne.
            if (ready case final ready?) ...[
              const SizedBox(height: AppSpacing.sm),
              TargetCallout(
                best: ready.best,
                other: ready.other,
                onAdopt: form.adopt,
              ),
            ],
          ],
          // Le refus s'affiche là où on peut le corriger. Sur mobile, les
          // résultats sont sous le schéma : un message posé là serait lu deux
          // écrans plus bas que le champ fautif.
          if (outcome is DistributionFailure) ...[
            const SizedBox(height: AppSpacing.md),
            ErrorBanner(message: outcome.message),
          ],
        ],
      ),
      inputFooter: AppDisclosure(
        title: 'Réglages avancés',
        modified: _advancedModified(input),
        child: _AdvancedSettings(input: input, form: form),
      ),
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

/// Ce qu'on ne règle qu'une fois sur dix, laissé par défaut sur le cas le plus
/// courant : bords aux éléments, marges nulles.
class _AdvancedSettings extends StatelessWidget {
  const _AdvancedSettings({required this.input, required this.form});

  final DistributionFormState input;
  final DistributionForm form;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledField(
          label: 'Type de répartition',
          about: kAboutEdges,
          child: EdgeChoiceGrid(
            startEdge: input.startEdge,
            endEdge: input.endEdge,
            onChanged: form.setEdges,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        LabeledField(
          label: 'Marges',
          help: 'Réservées avant répartition — un chant, un tasseau en place.',
          about: kAboutOffsetMode,
          child: AppSegmentedButton<bool>(
            segments: const [
              AppSegment(value: true, label: 'Symétriques'),
              AppSegment(value: false, label: 'Asymétriques'),
            ],
            value: input.symmetricOffsets,
            onChanged: form.setSymmetricOffsets,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (input.symmetricOffsets)
          NumberField(
            label: 'Marge',
            suffix: 'mm',
            about: kAboutOffset,
            value: input.startOffset,
            onChanged: form.setStartOffset,
            step: 1,
          )
        else
          FieldPair(
            first: NumberField(
              label: 'Marge début',
              suffix: 'mm',
              about: kAboutOffsetStart,
              value: input.startOffset,
              onChanged: form.setStartOffset,
            ),
            second: NumberField(
              label: 'Marge fin',
              suffix: 'mm',
              about: kAboutOffsetEnd,
              value: input.endOffset,
              onChanged: form.setEndOffset,
            ),
          ),
      ],
    );
  }
}

/// Au moins un réglage replié n'est plus à son défaut.
///
/// Comparé champ par champ et non sur l'état entier : ce qui est resté visible
/// dans la carte n'a rien à voir avec la pastille du panneau.
bool _advancedModified(DistributionFormState input) =>
    input.startEdge != kDistributionDefaults.startEdge ||
    input.endEdge != kDistributionDefaults.endEdge ||
    input.symmetricOffsets != kDistributionDefaults.symmetricOffsets ||
    input.startOffset != kDistributionDefaults.startOffset ||
    input.endOffset != kDistributionDefaults.endOffset;
