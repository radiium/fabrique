import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/calc/distribution.dart';
import '../../l10n/app_localizations.dart';

part 'distribution_form.freezed.dart';
part 'distribution_form.g.dart';

/// Ce que l'écran cherche, nommé par le résultat.
enum DistributionMode {
  /// Le nombre d'éléments est connu, on en déduit l'écart.
  spacing,

  /// L'écart est voulu, on cherche combien d'éléments y répondent.
  count;

  String label(AppLocalizations l10n) => switch (this) {
    DistributionMode.spacing => l10n.distributionModeSpacing,
    DistributionMode.count => l10n.distributionModeCount,
  };
}

/// Saisie complète de l'écran.
///
/// Réunit le nombre et l'écart visé, pour qu'un changement de mode n'efface
/// rien. État d'écran, donc hors de `core/calc`.
@freezed
abstract class DistributionFormState with _$DistributionFormState {
  const factory DistributionFormState({
    @Default(DistributionMode.spacing) DistributionMode mode,
    @Default(1800) double length,

    /// `0` = répartition de points purs.
    @Default(18) double elementWidth,
    @Default(5) int count,
    @Default(150) double targetSpacing,
    @Default(DistributionEdge.element) DistributionEdge startEdge,
    @Default(DistributionEdge.element) DistributionEdge endEdge,

    /// Marges liées. Le calcul ne voit que [startOffset] et [endOffset].
    @Default(true) bool symmetricOffsets,
    @Default(0) double startOffset,
    @Default(0) double endOffset,
  }) = _DistributionFormState;

  const DistributionFormState._();

  factory DistributionFormState.fromJson(Map<String, dynamic> json) =>
      _$DistributionFormStateFromJson(json);

  /// La saisie vue par le mode « je connais le nombre ».
  DistributionInput get spacingModeInput => DistributionInput(
    length: length,
    count: count,
    elementWidth: elementWidth,
    startEdge: startEdge,
    endEdge: endEdge,
    startOffset: startOffset,
    endOffset: endOffset,
  );

  /// La saisie vue par le mode « je veux cet écart ».
  DistributionTargetInput get countModeInput => DistributionTargetInput(
    length: length,
    targetSpacing: targetSpacing,
    elementWidth: elementWidth,
    startEdge: startEdge,
    endEdge: endEdge,
    startOffset: startOffset,
    endOffset: endOffset,
  );
}

/// Un couple de bords : la disposition telle qu'elle se choisit.
///
/// Ici pour que le cartouche du plan puisse nommer la disposition.
class EdgeChoice {
  const EdgeChoice(this.start, this.end);

  final DistributionEdge start;
  final DistributionEdge end;

  String label(AppLocalizations l10n) => edgeChoiceLabel(start, end, l10n);
}

/// Les quatre dispositions, la plus courante en tête.
const List<EdgeChoice> kEdgeChoices = [
  EdgeChoice(DistributionEdge.element, DistributionEdge.element),
  EdgeChoice(DistributionEdge.gap, DistributionEdge.gap),
  EdgeChoice(DistributionEdge.element, DistributionEdge.gap),
  EdgeChoice(DistributionEdge.gap, DistributionEdge.element),
];

/// Le nom de la disposition bornée par [start] et [end] : « Élément – Écart ».
String edgeChoiceLabel(
  DistributionEdge start,
  DistributionEdge end,
  AppLocalizations l10n,
) {
  String edge(DistributionEdge e) => switch (e) {
    DistributionEdge.element => l10n.distributionEdgeElement,
    DistributionEdge.gap => l10n.distributionEdgeGap,
  };
  return l10n.distributionEdgePair(edge(start), edge(end));
}
