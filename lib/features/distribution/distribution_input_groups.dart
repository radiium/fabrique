import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/distribution.dart';
import '../../core/format.dart';
import '../../core/widgets/app_disclosure.dart';
import '../../core/widgets/app_segmented_button.dart';
import '../../core/widgets/field_pair.dart';
import '../../core/widgets/labeled_field.dart';
import '../../core/widgets/number_field.dart';
import 'distribution_controller.dart';
import 'distribution_edge_grid.dart';
import 'distribution_form.dart';
import 'distribution_help.dart';
import 'distribution_target_callout.dart';

/// La largeur, les éléments, et ce qu'on cherche : seul groupe ouvert à
/// l'arrivée, c'est ce qu'on vient de mesurer.
class DistributionGeometryGroup extends StatelessWidget {
  const DistributionGeometryGroup({
    required this.input,
    required this.ready,
    required this.form,
    super.key,
  });

  final DistributionFormState input;

  /// Le calcul abouti, pour proposer l'autre borne. `null` sur un refus.
  final DistributionReady? ready;
  final DistributionForm form;

  @override
  Widget build(BuildContext context) {
    return AppDisclosure(
      title: 'Géométrie',
      icon: Icons.straighten,
      initiallyExpanded: true,
      summary: _summary(input),
      child: Column(
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
        ],
      ),
    );
  }

  /// Ce qu'on connaît, dit comme on le dirait : le nombre en « Calcul écart »,
  /// l'écart visé en « Calcul nombre ». Sans largeur, les éléments sont des
  /// repères.
  static String _summary(DistributionFormState input) {
    final hasWidth = input.elementWidth > 0;
    final span = 'sur ${formatNumber(input.length)} mm';
    final width = hasWidth ? ' de ${formatNumber(input.elementWidth)}' : '';
    return switch (input.mode) {
      DistributionMode.spacing =>
        '${input.count} ${hasWidth ? 'élément' : 'repère'}'
            '${pluralS(input.count)}$width $span',
      DistributionMode.count =>
        '${hasWidth ? 'Éléments' : 'Repères'}$width $span · '
            'écart visé ${formatNumber(input.targetSpacing)} mm',
    };
  }
}

/// Les bords et les marges, laissés par défaut sur le cas le plus courant :
/// bords aux éléments, marges nulles.
class DistributionEdgesGroup extends StatelessWidget {
  const DistributionEdgesGroup({
    required this.input,
    required this.form,
    super.key,
  });

  final DistributionFormState input;
  final DistributionForm form;

  @override
  Widget build(BuildContext context) {
    return AppDisclosure(
      title: 'Bords et marges',
      icon: Icons.border_vertical,
      summary: _summary(input),
      child: Column(
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
            help:
                'Réservées avant répartition — un chant, un tasseau en place.',
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
      ),
    );
  }

  /// La disposition change le nombre de jeux, donc l'écart obtenu : repliée
  /// sans résumé, elle cacherait la raison d'un écart inattendu. Les marges
  /// s'écrivent comme on les saisit, une valeur si elles sont symétriques,
  /// début et fin sinon.
  static String _summary(DistributionFormState input) {
    final edges = edgeChoiceLabel(input.startEdge, input.endEdge);
    final offsets = input.symmetricOffsets
        ? formatNumber(input.startOffset)
        : '${formatNumber(input.startOffset)} / '
              '${formatNumber(input.endOffset)}';
    return '$edges · marges $offsets mm';
  }
}
