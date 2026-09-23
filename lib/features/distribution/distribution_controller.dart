import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/calc/calc_exception.dart';
import '../../core/calc/distribution.dart';
import 'distribution_form.dart';
import '../../core/models/tool.dart';
import '../../core/persistence/persisted_form.dart';

part 'distribution_controller.g.dart';

/// Ce que l'écran a à afficher : une répartition, ou la raison de son absence.
///
/// **Écart assumé à la convention `CalcException` → `null`.** Le tiret suffit
/// tant qu'une saisie invalide n'est qu'une frappe en cours ; ici les refus
/// sont métier — « les 11 éléments occupent 110 mm pour 100 disponibles » — et
/// c'est l'information la plus utile que l'outil puisse rendre. La taire
/// laisserait l'utilisateur chercher lequel des huit contrôles est fautif.
sealed class DistributionOutcome {
  const DistributionOutcome();
}

/// Une répartition calculée, plus l'autre borne quand on cherchait un écart.
final class DistributionReady extends DistributionOutcome {
  const DistributionReady({required this.best, this.other});

  final DistributionResult best;

  /// L'autre solution entière qui encadre l'écart visé. Toujours `null` en
  /// mode « je connais le nombre » : il n'y a alors rien à arbitrer.
  final DistributionResult? other;
}

/// Saisie refusée par le cœur — [message] est rédigé pour être affiché tel
/// quel.
final class DistributionFailure extends DistributionOutcome {
  const DistributionFailure(this.message);

  final String message;
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

  /// Le mode revient lui aussi au départ : c'est une saisie comme une autre,
  /// et laisser l'écran sur « Nombre » après un reset ferait mentir le neuf.
  void reset() => state = kDistributionDefaults;

  void setMode(DistributionMode mode) => state = state.copyWith(mode: mode);

  void setLength(double mm) => state = state.copyWith(length: mm);

  void setElementWidth(double mm) => state = state.copyWith(elementWidth: mm);

  void setCount(int count) => state = state.copyWith(count: count);

  void setTargetSpacing(double mm) => state = state.copyWith(targetSpacing: mm);

  /// Adopte une des deux répartitions qui encadrent l'écart visé : son nombre
  /// d'éléments devient la saisie, et l'écran passe en « Calcul écart ».
  ///
  /// Changer de mode plutôt que recopier l'écart obtenu dans [setTargetSpacing]
  /// n'est pas un détail : recopié, l'écart reposerait la même question, et
  /// l'inversion retomberait rarement sur un entier exact — l'écran rendrait
  /// alors une alternative de plus, sans fin. Le nombre, lui, est la réponse.
  void adopt(int count) =>
      state = state.copyWith(mode: DistributionMode.spacing, count: count);

  void setEdges(DistributionEdge start, DistributionEdge end) =>
      state = state.copyWith(startEdge: start, endEdge: end);

  /// Repasser en symétrique réaligne la fin sur le début : laisser traîner un
  /// marge de fin devenue invisible ferait mentir le schéma.
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

/// Le résultat est une dérivation, pas de l'état : temps réel, sans bouton.
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
    return DistributionFailure(e.message);
  }
}
