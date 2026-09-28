import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/calc/calc_exception.dart';
import '../../core/calc/distribution.dart';
import '../../core/models/tool.dart';
import '../../core/persistence/persisted_form.dart';
import 'distribution_form.dart';

part 'distribution_controller.g.dart';

/// Ce que l'écran a à afficher : une répartition, ou le motif de son refus.
sealed class DistributionOutcome {
  const DistributionOutcome();
}

/// Une répartition calculée, plus l'autre borne quand on cherchait un écart.
final class DistributionReady extends DistributionOutcome {
  const DistributionReady({required this.best, this.other});

  final DistributionResult best;

  /// L'autre solution entière qui encadre l'écart visé. `null` en mode
  /// « je connais le nombre ».
  final DistributionResult? other;
}

/// Saisie refusée par le cœur, avec son motif : l'écran le rédige dans la
/// langue de l'app.
final class DistributionFailure extends DistributionOutcome {
  const DistributionFailure(this.reason);

  final CalcError reason;
}

/// Saisie de départ, et cible du bouton « réinitialiser ».
const DistributionFormState kDistributionDefaults = DistributionFormState();

/// Tient la saisie. Une méthode par champ, qui fait `copyWith`.
@riverpod
class DistributionForm extends _$DistributionForm
    with PersistedForm<DistributionFormState> {
  @override
  Tool get tool => Tool.distribution;

  @override
  DistributionFormState get defaults => kDistributionDefaults;

  @override
  DistributionFormState decode(Map<String, dynamic> json) =>
      DistributionFormState.fromJson(json);

  @override
  Map<String, dynamic> encode(DistributionFormState input) => input.toJson();

  @override
  DistributionFormState build() => restore();

  /// Le mode revient aussi au départ.
  void reset() => state = kDistributionDefaults;

  void setMode(DistributionMode mode) => state = state.copyWith(mode: mode);

  void setLength(double mm) => state = state.copyWith(length: mm);

  void setElementWidth(double mm) => state = state.copyWith(elementWidth: mm);

  void setCount(int count) => state = state.copyWith(count: count);

  void setTargetSpacing(double mm) => state = state.copyWith(targetSpacing: mm);

  /// Adopte une des deux répartitions qui encadrent l'écart visé : son nombre
  /// devient la saisie, en mode « Calcul écart ».
  ///
  /// Recopier l'écart obtenu reposerait la question sans fin.
  void adopt(int count) =>
      state = state.copyWith(mode: DistributionMode.spacing, count: count);

  void setEdges(DistributionEdge start, DistributionEdge end) =>
      state = state.copyWith(startEdge: start, endEdge: end);

  /// Repasser en symétrique réaligne la fin sur le début.
  void setSymmetricOffsets(bool symmetric) => state = state.copyWith(
    symmetricOffsets: symmetric,
    endOffset: symmetric ? state.startOffset : state.endOffset,
  );

  void setStartOffset(double mm) => state = state.copyWith(
    startOffset: mm,
    endOffset: state.symmetricOffsets ? mm : state.endOffset,
  );

  void setEndOffset(double mm) => state = state.copyWith(endOffset: mm);
}

/// Le résultat, dérivé de la saisie.
@riverpod
DistributionOutcome distributionResult(Ref ref) {
  final form = ref.watch(distributionFormProvider);
  try {
    switch (form.mode) {
      case DistributionMode.spacing:
        return DistributionReady(
          best: computeDistribution(form.spacingModeInput),
        );
      case DistributionMode.count:
        final found = computeDistributionForSpacing(form.countModeInput);
        return DistributionReady(best: found.best, other: found.other);
    }
  } on CalcException catch (e) {
    return DistributionFailure(e.reason);
  }
}
