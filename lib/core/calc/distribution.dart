import 'package:freezed_annotation/freezed_annotation.dart';

import 'calc_exception.dart';

part 'distribution.freezed.dart';
part 'distribution.g.dart';

/// Garde-fou : au-delà, la table de positions n'est plus lisible et le schéma
/// n'est plus qu'une trame grise — mais surtout un `1 / 0.001` saisi par
/// mégarde génèrerait un million de positions et figerait l'écran.
const int kMaxDistributionCount = 500;

/// Ce qui borne la répartition à chaque extrémité.
///
/// C'est ce choix, et lui seul, qui fixe le nombre de jeux : une rangée bordée
/// de deux écarts en a un de plus que d'éléments, une rangée bordée de deux
/// éléments un de moins.
enum DistributionEdge {
  /// La rangée commence (ou finit) par un jeu : aucun élément ne touche le
  /// bord. Le barreaudage entre deux montants.
  gap,

  /// La rangée commence (ou finit) par un élément collé au bord. Un rang de
  /// lames pleine largeur, une série d'étagères affleurantes.
  element,
}

/// Saisie du mode « je connais le nombre d'éléments ».
@freezed
abstract class DistributionInput with _$DistributionInput {
  const factory DistributionInput({
    /// Largeur totale à garnir, en mm.
    required double length,

    /// Nombre d'éléments à répartir (>= 0).
    required int count,

    /// Largeur d'un élément, en mm. `0` = répartition de points purs.
    @Default(0) double elementWidth,

    /// Bord de départ, à l'origine.
    @Default(DistributionEdge.gap) DistributionEdge startEdge,

    /// Bord d'arrivée.
    @Default(DistributionEdge.gap) DistributionEdge endEdge,

    /// « Marge » de début : une bande de largeur soustraite avant toute
    /// répartition. Sert à réserver une largeur imposée — un chant, un tasseau
    /// existant — que le calcul n'a pas à redistribuer.
    @Default(0) double startOffset,

    /// « Marge » de fin. Distinct de [startOffset] : une répartition
    /// asymétrique est un cas courant dès qu'un bord est contraint.
    @Default(0) double endOffset,
  }) = _DistributionInput;

  factory DistributionInput.fromJson(Map<String, dynamic> json) =>
      _$DistributionInputFromJson(json);
}

/// Saisie du mode « je veux un écart donné » : même géométrie, mais c'est le
/// nombre d'éléments que l'on cherche.
@freezed
abstract class DistributionTargetInput with _$DistributionTargetInput {
  const factory DistributionTargetInput({
    /// Largeur totale à garnir, en mm.
    required double length,

    /// Écart visé entre deux éléments, en mm. Presque jamais atteignable
    /// exactement — voir [computeDistributionForSpacing].
    required double targetSpacing,

    /// Largeur d'un élément, en mm.
    @Default(0) double elementWidth,
    @Default(DistributionEdge.gap) DistributionEdge startEdge,
    @Default(DistributionEdge.gap) DistributionEdge endEdge,
    @Default(0) double startOffset,
    @Default(0) double endOffset,
  }) = _DistributionTargetInput;

  factory DistributionTargetInput.fromJson(Map<String, dynamic> json) =>
      _$DistributionTargetInputFromJson(json);
}

/// Une répartition complète, prête à tracer.
@freezed
abstract class DistributionResult with _$DistributionResult {
  const factory DistributionResult({
    /// Nombre d'éléments effectivement répartis. Redondant avec la saisie dans
    /// le premier mode, mais c'est *le* résultat cherché dans le second.
    required int count,

    /// Nombre de jeux. C'est la règle de l'outil, rendue explicite : `N + 1`
    /// bordé de deux écarts, `N - 1` bordé de deux éléments.
    required int gapCount,

    /// Jeu libre entre deux éléments voisins, en mm.
    required double spacing,

    /// Entraxe : `spacing + elementWidth`. C'est lui que l'on reporte au
    /// crayon — le jeu, on ne le mesure jamais directement.
    required double pitch,

    /// Largeur réellement répartie : `length` moins les deux marges.
    required double span,

    /// Bord d'attaque de chaque élément depuis l'origine, en mm. Pour une
    /// largeur nulle, c'est la position du point.
    required List<double> positions,

    /// Centre de chaque élément, en mm — l'axe de perçage ou de vissage.
    required List<double> centers,
  }) = _DistributionResult;
}

/// Les deux seules réponses entières qui encadrent un écart visé.
///
/// Le nombre d'éléments est entier, l'écart visé ne l'est presque jamais : il
/// existe toujours une solution qui serre un peu plus et une qui relâche un
/// peu. Plutôt qu'un réglage d'arrondi, on rend les deux — celui qui a une
/// contrainte de maximum (barreaudage) lit la plus serrée, celui qui cherche
/// une allure lit [best].
@freezed
abstract class DistributionTargetResult with _$DistributionTargetResult {
  const factory DistributionTargetResult({
    /// Celle dont l'écart réel est le plus proche de la cible.
    required DistributionResult best,

    /// L'autre borne, de l'autre côté de la cible. `null` quand la cible tombe
    /// juste, ou quand ce voisin n'est pas réalisable.
    required DistributionResult? other,
  }) = _DistributionTargetResult;
}

/// Nombre de jeux pour [count] éléments : `count + 1`, moins un par bord
/// occupé par un élément.
int _gapCount(int count, DistributionEdge start, DistributionEdge end) =>
    count + 1 - _edgeElements(start, end);

/// Combien d'extrémités sont occupées par un élément (0, 1 ou 2).
///
/// C'est aussi, tel quel, le nombre minimal d'éléments que la disposition
/// admet : un seul élément ne peut pas toucher les deux bords, et une rangée
/// qui doit commencer par un élément en compte au moins un.
int _edgeElements(DistributionEdge start, DistributionEdge end) =>
    (start == DistributionEdge.element ? 1 : 0) +
    (end == DistributionEdge.element ? 1 : 0);

/// Nombre minimal d'éléments qu'admet une disposition — de quoi borner le
/// champ de saisie sans que l'écran ait à refaire le raisonnement.
int minDistributionCount(DistributionEdge start, DistributionEdge end) =>
    _edgeElements(start, end);

/// Valide la géométrie commune aux deux modes et rend la longueur utile.
///
/// Les messages sont rédigés pour être affichés tels quels : c'est la seule
/// chose que l'utilisateur puisse lire quand le schéma reste vide.
double _validatedSpan({
  required double length,
  required double elementWidth,
  required double startOffset,
  required double endOffset,
}) {
  if (!length.isFinite ||
      !elementWidth.isFinite ||
      !startOffset.isFinite ||
      !endOffset.isFinite) {
    throw const CalcException(IncompleteInput());
  }
  if (length <= 0) {
    throw const CalcException(MustBePositive(PositiveField.totalWidth));
  }
  if (elementWidth < 0) {
    throw const CalcException(MustNotBeNegative(NonNegativeField.elementWidth));
  }
  if (startOffset < 0 || endOffset < 0) {
    throw const CalcException(MustNotBeNegative(NonNegativeField.margin));
  }

  final span = length - startOffset - endOffset;
  if (span <= 0) {
    throw const CalcException(MarginsFillWidth());
  }
  return span;
}

/// Répartit [DistributionInput.count] éléments sur la longueur utile.
///
/// Le jeu vaut `(utile − éléments) / nombre de jeux` ; tout le reste — les
/// positions, les centres — en découle par addition de l'entraxe.
DistributionResult computeDistribution(DistributionInput input) {
  final span = _validatedSpan(
    length: input.length,
    elementWidth: input.elementWidth,
    startOffset: input.startOffset,
    endOffset: input.endOffset,
  );

  final count = input.count;
  final width = input.elementWidth;
  final minCount = _edgeElements(input.startEdge, input.endEdge);

  if (count < 0) {
    throw const CalcException(MustNotBeNegative(NonNegativeField.elementCount));
  }
  if (count < minCount) {
    throw CalcException(TooFewElements(minCount));
  }
  if (count > kMaxDistributionCount) {
    throw const CalcException(TooManyElements(kMaxDistributionCount));
  }

  final occupied = count * width;
  if (occupied > span) {
    throw CalcException(
      ElementsOverflow(count: count, occupied: occupied, available: span),
    );
  }

  // Garanti >= 1 par le contrôle de [minCount] ci-dessus.
  final gaps = _gapCount(count, input.startEdge, input.endEdge);
  final spacing = (span - occupied) / gaps;
  final pitch = spacing + width;

  // Le premier élément est collé à la marge de début, ou repoussé d'un jeu.
  final first =
      input.startOffset +
      (input.startEdge == DistributionEdge.element ? 0 : spacing);

  final positions = List<double>.generate(
    count,
    (i) => first + pitch * i,
    growable: false,
  );

  return DistributionResult(
    count: count,
    gapCount: gaps,
    spacing: spacing,
    pitch: pitch,
    span: span,
    positions: positions,
    centers: List<double>.generate(
      count,
      (i) => positions[i] + width / 2,
      growable: false,
    ),
  );
}

/// Cherche le nombre d'éléments qui approche au plus près
/// [DistributionTargetInput.targetSpacing].
///
/// En inversant `utile = N × largeur + (N + c) × écart`, avec `c` le décalage
/// de comptage des jeux, on obtient `N = (utile − c × écart) / (largeur +
/// écart)` — généralement fractionnaire. On évalue les deux entiers qui
/// l'encadrent et on rend les deux répartitions complètes.
DistributionTargetResult computeDistributionForSpacing(
  DistributionTargetInput input,
) {
  final span = _validatedSpan(
    length: input.length,
    elementWidth: input.elementWidth,
    startOffset: input.startOffset,
    endOffset: input.endOffset,
  );

  final target = input.targetSpacing;
  final width = input.elementWidth;

  if (!target.isFinite) {
    throw const CalcException(IncompleteInput());
  }
  if (target < 0) {
    throw const CalcException(MustNotBeNegative(NonNegativeField.targetGap));
  }
  if (width + target <= 0) {
    throw const CalcException(WidthAndGapBothZero());
  }

  // c = 1 − (bords occupés par un élément).
  final c = 1 - _edgeElements(input.startEdge, input.endEdge);
  final exact = (span - c * target) / (width + target);
  if (!exact.isFinite) {
    throw const CalcException(NoDistributionForGap());
  }
  // Dit franchement que l'écart est trop petit, plutôt que de laisser les deux
  // bornes échouer plus bas sur un message vague.
  if (exact.floor() > kMaxDistributionCount) {
    throw const CalcException(GapTooSmall(kMaxDistributionCount));
  }

  DistributionResult? evaluate(int count) {
    if (count < 0 || count > kMaxDistributionCount) return null;
    try {
      return computeDistribution(
        DistributionInput(
          length: input.length,
          count: count,
          elementWidth: width,
          startEdge: input.startEdge,
          endEdge: input.endEdge,
          startOffset: input.startOffset,
          endOffset: input.endOffset,
        ),
      );
    } on CalcException {
      // Une borne peut être irréalisable — un élément de trop ne rentre plus,
      // un élément de moins viole le bord demandé. L'autre reste valable.
      return null;
    }
  }

  // Le `Set` dédoublonne le cas où la cible tombe juste : une seule réponse.
  final candidates = <int>{
    exact.floor(),
    exact.ceil(),
  }.map(evaluate).nonNulls.toList(growable: false);

  if (candidates.isEmpty) {
    throw const CalcException(NoDistributionForGap());
  }

  candidates.sort(
    (a, b) => (a.spacing - target).abs().compareTo((b.spacing - target).abs()),
  );

  return DistributionTargetResult(
    best: candidates.first,
    other: candidates.length > 1 ? candidates[1] : null,
  );
}
