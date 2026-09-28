import 'package:freezed_annotation/freezed_annotation.dart';

import 'calc_exception.dart';

part 'distribution.freezed.dart';
part 'distribution.g.dart';

/// Borne du nombre d'éléments : un `1 / 0.001` saisi par mégarde donnerait
/// un million de positions et figerait l'écran.
const int kMaxDistributionCount = 500;

/// Ce qui borne la répartition à chaque extrémité.
///
/// Fixe le nombre de jeux : `N + 1` entre deux écarts, `N - 1` entre deux
/// éléments.
enum DistributionEdge {
  /// Un jeu contre le bord, comme un barreaudage entre deux montants.
  gap,

  /// Un élément collé au bord, comme des étagères affleurantes.
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

    /// Bande soustraite au début avant de répartir : un chant, un tasseau.
    @Default(0) double startOffset,

    /// Bande soustraite à la fin.
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

    /// Écart visé entre deux éléments, en mm, rarement atteignable exactement.
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
    /// Nombre d'éléments répartis : le résultat cherché en mode écart visé.
    required int count,

    /// Nombre de jeux : `N + 1` entre deux écarts, `N - 1` entre deux éléments.
    required int gapCount,

    /// Jeu libre entre deux éléments voisins, en mm.
    required double spacing,

    /// Entraxe : `spacing + elementWidth`, la cote que l'on reporte.
    required double pitch,

    /// Largeur réellement répartie : `length` moins les deux marges.
    required double span,

    /// Bord d'attaque de chaque élément depuis l'origine, en mm. Pour une
    /// largeur nulle, la position du point.
    required List<double> positions,

    /// Centre de chaque élément, en mm : l'axe de perçage ou de vissage.
    required List<double> centers,
  }) = _DistributionResult;
}

/// Les deux répartitions entières qui encadrent un écart visé.
///
/// La plus serrée sert une contrainte de maximum (barreaudage), [best] une
/// allure.
@freezed
abstract class DistributionTargetResult with _$DistributionTargetResult {
  const factory DistributionTargetResult({
    /// Celle dont l'écart réel est le plus proche de la cible.
    required DistributionResult best,

    /// La borne de l'autre côté de la cible. `null` si la cible tombe juste ou si
    /// ce voisin est irréalisable.
    required DistributionResult? other,
  }) = _DistributionTargetResult;
}

/// Nombre de jeux pour [count] éléments : `count + 1`, moins un par bord
/// occupé par un élément.
int _gapCount(int count, DistributionEdge start, DistributionEdge end) =>
    count + 1 - _edgeElements(start, end);

/// Nombre d'extrémités occupées par un élément (0, 1 ou 2), qui est aussi le
/// nombre minimal d'éléments.
int _edgeElements(DistributionEdge start, DistributionEdge end) =>
    (start == DistributionEdge.element ? 1 : 0) +
    (end == DistributionEdge.element ? 1 : 0);

/// Nombre minimal d'éléments qu'admet une disposition, pour borner le champ.
int minDistributionCount(DistributionEdge start, DistributionEdge end) =>
    _edgeElements(start, end);

/// Valide la géométrie commune aux deux modes et rend la longueur utile.
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
/// Le jeu vaut `(utile − éléments) / nombre de jeux`.
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
/// Inverse `utile = N × largeur + (N + c) × écart` et rend les répartitions
/// des deux entiers qui encadrent `N`.
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
  // Un message clair plutôt que deux bornes qui échouent plus bas.
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
      // Une borne peut être irréalisable ; l'autre reste valable.
      return null;
    }
  }

  // Le `Set` dédoublonne une cible qui tombe juste.
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
