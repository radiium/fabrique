import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/calc/distribution.dart';

part 'distribution_form.freezed.dart';
part 'distribution_form.g.dart';

/// Ce que l'écran cherche — nommé par le résultat, pas par la saisie, parce
/// que c'est la question que l'utilisateur se pose en arrivant.
enum DistributionMode {
  /// Le nombre d'éléments est connu, on en déduit l'écart.
  spacing('Calcul écart'),

  /// L'écart est voulu, on cherche combien d'éléments y répondent.
  count('Calcul nombre');

  const DistributionMode(this.label);

  final String label;
}

/// Saisie complète de l'écran.
///
/// Sur-ensemble des deux modèles de `core/calc` : le nombre d'éléments et
/// l'écart visé y coexistent, sinon basculer de mode effacerait la valeur du
/// mode qu'on quitte. C'est de l'état d'écran, pas de la donnée de calcul —
/// d'où sa place ici et non dans `core/calc`.
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

    /// Les deux marges sont-elles liées ? N'a d'effet que sur la saisie : le
    /// calcul ne voit jamais que [startOffset] et [endOffset].
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

/// Un couple de bords et son nom — la disposition telle qu'elle se choisit et
/// telle qu'elle s'écrit.
///
/// Ici et non dans l'écran : le cartouche du plan exporté doit nommer la
/// disposition retenue, et il ne peut pas aller la chercher dans une grille de
/// tuiles. Même logique que le libellé porté par [DistributionMode].
class EdgeChoice {
  const EdgeChoice(this.start, this.end, this.label);

  final DistributionEdge start;
  final DistributionEdge end;
  final String label;
}

/// Les quatre dispositions, dans l'ordre où elles se présentent à l'écran :
/// la plus courante en tête.
const List<EdgeChoice> kEdgeChoices = [
  EdgeChoice(
    DistributionEdge.element,
    DistributionEdge.element,
    'Élément – Élément',
  ),
  EdgeChoice(DistributionEdge.gap, DistributionEdge.gap, 'Écart – Écart'),
  EdgeChoice(DistributionEdge.element, DistributionEdge.gap, 'Élément – Écart'),
  EdgeChoice(DistributionEdge.gap, DistributionEdge.element, 'Écart – Élément'),
];

/// Le nom de la disposition bornée par [start] et [end].
String edgeChoiceLabel(DistributionEdge start, DistributionEdge end) =>
    kEdgeChoices.firstWhere((c) => c.start == start && c.end == end).label;
