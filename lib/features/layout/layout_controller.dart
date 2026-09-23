import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/calc/calc_exception.dart';
import '../../core/calc/layout.dart';
import '../../core/models/enums.dart';
import '../../core/models/tool.dart';
import '../../core/persistence/persisted_form.dart';
import 'layout_presets.dart';

part 'layout_controller.g.dart';

/// Saisie de départ, et cible du bouton « réinitialiser ».
const LayoutInput kLayoutDefaults = LayoutInput(
  surfaceX: 3000,
  surfaceY: 2000,
  elementX: 1200,
  elementY: 200,
);

@riverpod
class LayoutForm extends _$LayoutForm with PersistedForm<LayoutInput> {
  @override
  Tool get tool => Tool.layout;

  @override
  LayoutInput get defaults => kLayoutDefaults;

  @override
  LayoutInput decode(Map<String, dynamic> json) => LayoutInput.fromJson(json);

  @override
  Map<String, dynamic> encode(LayoutInput input) => input.toJson();

  @override
  LayoutInput build() => restore();

  void reset() => state = kLayoutDefaults;

  void setSurfaceX(double mm) => state = state.copyWith(surfaceX: mm);
  void setSurfaceY(double mm) => state = state.copyWith(surfaceY: mm);
  void setElementX(double mm) => state = state.copyWith(elementX: mm);
  void setElementY(double mm) => state = state.copyWith(elementY: mm);
  void setGapX(double mm) => state = state.copyWith(gapX: mm);
  void setGapY(double mm) => state = state.copyWith(gapY: mm);
  void setPerimeterGap(double mm) => state = state.copyWith(perimeterGap: mm);
  void setBalanceRows(bool on) => state = state.copyWith(balanceRows: on);
  void setFlip(bool flip) => state = state.copyWith(flip: flip);
  void setOffset(JointOffset offset) => state = state.copyWith(offset: offset);

  /// Pré-remplit format, jeux et décalage depuis un produit courant.
  ///
  /// Une seule affectation et non six appels de champ : six `copyWith`
  /// enchaînés feraient six reconstructions de l'écran, dont cinq sur des
  /// états intermédiaires que personne n'a demandés.
  void applyPreset(LayoutPreset preset) => state = preset.applyTo(state);
}

/// Ce que l'écran a à afficher : un calepinage, ou la raison de son absence.
///
/// **Écart assumé à la convention `CalcException` → `null`**, le même que la
/// Répartition. L'outil a huit contrôles et ses refus sont métier — « l'élément
/// fait 1200 mm pour une zone à couvrir de 980 » : un tiret muet laisserait
/// chercher lequel des huit est fautif, et le jeu périphérique rend l'écart
/// invisible puisque la zone à couvrir n'est plus la surface saisie.
sealed class LayoutOutcome {
  const LayoutOutcome();
}

final class LayoutReady extends LayoutOutcome {
  const LayoutReady(this.result);

  final LayoutResult result;
}

/// Saisie refusée par le cœur — [message] est rédigé pour être affiché tel
/// quel.
final class LayoutFailure extends LayoutOutcome {
  const LayoutFailure(this.message);

  final String message;
}

@riverpod
LayoutOutcome layoutResult(Ref ref) {
  final input = ref.watch(layoutFormProvider);
  try {
    return LayoutReady(computeLayout(input));
  } on CalcException catch (error) {
    return LayoutFailure(error.message);
  }
}
