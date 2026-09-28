import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/distribution.dart';
import '../../core/widgets/app_disclosure.dart';
import '../../core/widgets/app_segmented_button.dart';
import '../../core/widgets/count_field.dart';
import '../../core/widgets/field_pair.dart';
import '../../core/widgets/labeled_field.dart';
import '../../core/widgets/number_field.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/numbers.dart';
import 'distribution_controller.dart';
import 'distribution_edge_grid.dart';
import 'distribution_form.dart';
import 'distribution_help.dart';
import 'distribution_target_callout.dart';

/// La largeur, les éléments, et ce qu'on cherche : seul groupe ouvert à
/// l'arrivée.
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
    final l10n = AppLocalizations.of(context);
    return AppDisclosure(
      title: l10n.distributionGeometry,
      icon: Icons.straighten,
      initiallyExpanded: true,
      summary: _summary(input, l10n),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: l10n.distributionModeLabel,
            about: aboutMode(l10n),
            child: AppSegmentedButton<DistributionMode>(
              segments: [
                for (final mode in DistributionMode.values)
                  AppSegment(value: mode, label: mode.label(l10n)),
              ],
              value: input.mode,
              onChanged: form.setMode,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FieldPair(
            first: NumberField(
              label: l10n.distributionLength,
              suffix: 'mm',
              about: aboutLength(l10n),
              value: input.length,
              onChanged: form.setLength,
            ),
            second: NumberField(
              label: l10n.distributionElementWidth,
              suffix: 'mm',
              about: aboutElementWidth(l10n),
              value: input.elementWidth,
              onChanged: form.setElementWidth,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Le mode échange la saisie et la réponse.
          if (input.mode == DistributionMode.spacing)
            CountField(
              label: l10n.distributionCount,
              about: aboutCount(l10n),
              value: input.count,
              onChanged: form.setCount,
              min: minDistributionCount(input.startEdge, input.endEdge),
              max: kMaxDistributionCount,
            )
          else ...[
            NumberField(
              label: l10n.distributionTargetSpacing,
              suffix: 'mm',
              help: l10n.distributionTargetSpacingHelp,
              about: aboutTargetSpacing(l10n),
              value: input.targetSpacing,
              onChanged: form.setTargetSpacing,
            ),
            // L'arbitrage près du champ : en tuile, il tomberait sous le schéma.
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

  /// Ce qu'on connaît : le nombre en « Calcul écart », l'écart visé en
  /// « Calcul nombre ». Sans largeur, les éléments sont des repères.
  static String _summary(DistributionFormState input, AppLocalizations l10n) {
    final hasWidth = input.elementWidth > 0;
    final length = l10n.number(input.length);
    final width = l10n.number(input.elementWidth);
    final target = l10n.number(input.targetSpacing);
    return switch ((input.mode, hasWidth)) {
      (DistributionMode.spacing, true) => l10n.distributionSummaryCount(
        input.count,
        width,
        length,
      ),
      (DistributionMode.spacing, false) => l10n.distributionSummaryCountMarks(
        input.count,
        length,
      ),
      (DistributionMode.count, true) => l10n.distributionSummaryTarget(
        width,
        length,
        target,
      ),
      (DistributionMode.count, false) => l10n.distributionSummaryTargetMarks(
        length,
        target,
      ),
    };
  }
}

/// Les bords et les marges : par défaut, bords aux éléments, marges nulles.
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
    final l10n = AppLocalizations.of(context);
    return AppDisclosure(
      title: l10n.distributionEdgesGroup,
      icon: Icons.border_vertical,
      summary: _summary(input, l10n),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: l10n.distributionEdges,
            about: aboutEdges(l10n),
            child: EdgeChoiceGrid(
              startEdge: input.startEdge,
              endEdge: input.endEdge,
              onChanged: form.setEdges,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledField(
            label: l10n.distributionMargins,
            help: l10n.distributionMarginsHelp,
            about: aboutOffsetMode(l10n),
            child: AppSegmentedButton<bool>(
              segments: [
                AppSegment(value: true, label: l10n.distributionSymmetric),
                AppSegment(value: false, label: l10n.distributionAsymmetric),
              ],
              value: input.symmetricOffsets,
              onChanged: form.setSymmetricOffsets,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (input.symmetricOffsets)
            NumberField(
              label: l10n.distributionMargin,
              suffix: 'mm',
              about: aboutOffset(l10n),
              value: input.startOffset,
              onChanged: form.setStartOffset,
            )
          else
            FieldPair(
              first: NumberField(
                label: l10n.distributionMarginStart,
                suffix: 'mm',
                about: aboutOffsetStart(l10n),
                value: input.startOffset,
                onChanged: form.setStartOffset,
              ),
              second: NumberField(
                label: l10n.distributionMarginEnd,
                suffix: 'mm',
                about: aboutOffsetEnd(l10n),
                value: input.endOffset,
                onChanged: form.setEndOffset,
              ),
            ),
        ],
      ),
    );
  }

  /// La disposition change l'écart obtenu, d'où sa place dans le résumé. Une
  /// marge si elles sont symétriques, début et fin sinon.
  static String _summary(DistributionFormState input, AppLocalizations l10n) {
    final edges = edgeChoiceLabel(input.startEdge, input.endEdge, l10n);
    final offsets = input.symmetricOffsets
        ? l10n.number(input.startOffset)
        : '${l10n.number(input.startOffset)} / '
              '${l10n.number(input.endOffset)}';
    return l10n.distributionSummaryEdges(edges, offsets);
  }
}
