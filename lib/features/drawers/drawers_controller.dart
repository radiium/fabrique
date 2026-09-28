import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/calc/calc_exception.dart';
import '../../core/calc/drawers.dart';
import '../../core/models/tool.dart';
import '../../core/persistence/persisted_form.dart';

part 'drawers_controller.g.dart';

/// Saisie de départ, et cible du bouton « réinitialiser » : un caisson de
/// 600 × 720 hors tout en panneaux de 18, trois tiroirs à billes, façades en
/// applique.
const DrawersInput kDrawersDefaults = DrawersInput(
  openingWidth: 564,
  openingHeight: 684,
  openingDepth: 540,
  drawerCount: 3,
);

/// Borne haute du nombre de tiroirs : au-delà, c'est un casier.
const int kMaxDrawerCount = 10;

/// Tient la saisie. Une méthode par champ, qui fait `copyWith`.
@riverpod
class DrawersForm extends _$DrawersForm with PersistedForm<DrawersInput> {
  @override
  Tool get tool => Tool.drawers;

  @override
  DrawersInput get defaults => kDrawersDefaults;

  @override
  DrawersInput decode(Map<String, dynamic> json) => DrawersInput.fromJson(json);

  @override
  Map<String, dynamic> encode(DrawersInput input) => input.toJson();

  @override
  DrawersInput build() => restore();

  void reset() => state = kDrawersDefaults;

  void setOpeningWidth(double mm) => state = state.copyWith(openingWidth: mm);
  void setOpeningHeight(double mm) => state = state.copyWith(openingHeight: mm);
  void setOpeningDepth(double mm) => state = state.copyWith(openingDepth: mm);

  /// Garde les hauteurs fixées des tiroirs qui restent, et oublie les autres.
  void setDrawerCount(int count) {
    final fixed = [
      for (var i = 0; i < count; i++)
        i < state.fixedFrontHeights.length ? state.fixedFrontHeights[i] : null,
    ];
    state = state.copyWith(
      drawerCount: count,
      fixedFrontHeights: fixed.every((h) => h == null) ? const [] : fixed,
    );
  }

  /// Fixe la hauteur de la façade [index], comptée de haut en bas.
  void setFrontHeight(int index, double mm) {
    final fixed = [
      for (var i = 0; i < state.drawerCount; i++)
        i < state.fixedFrontHeights.length ? state.fixedFrontHeights[i] : null,
    ];
    fixed[index] = mm;
    state = state.copyWith(fixedFrontHeights: fixed);
  }

  /// Rend toutes les façades à parts égales.
  void resetFrontHeights() =>
      state = state.copyWith(fixedFrontHeights: const []);

  void setSlide(SlideKind slide) =>
      state = state.copyWith(slide: slide, slideLength: null);
  void setCustomSideClearance(double mm) =>
      state = state.copyWith(customSideClearance: mm);
  void setCustomLengthReduction(double mm) =>
      state = state.copyWith(customLengthReduction: mm);

  /// `null` rend le choix de la longueur à l'outil.
  void setSlideLength(double? mm) => state = state.copyWith(slideLength: mm);

  void setFrontMount(FrontMount mount) =>
      state = state.copyWith(frontMount: mount);
  void setFrontGap(double mm) => state = state.copyWith(frontGap: mm);
  void setSideThickness(double mm) => state = state.copyWith(sideThickness: mm);
  void setBottomThickness(double mm) =>
      state = state.copyWith(bottomThickness: mm);
  void setCarcassThickness(double mm) =>
      state = state.copyWith(carcassThickness: mm);
  void setFrontThickness(double mm) =>
      state = state.copyWith(frontThickness: mm);
  void setBoxJoint(BoxJoint joint) => state = state.copyWith(boxJoint: joint);
  void setBottomMount(BottomMount mount) =>
      state = state.copyWith(bottomMount: mount);
  void setGrooveDepth(double mm) => state = state.copyWith(grooveDepth: mm);
}

/// Ce que l'écran a à afficher : un résultat, ou le motif de son refus.
sealed class DrawersOutcome {
  const DrawersOutcome();
}

final class DrawersReady extends DrawersOutcome {
  const DrawersReady(this.result);

  final DrawersResult result;
}

/// Saisie refusée par le cœur, avec son motif : l'écran le rédige dans la
/// langue de l'app.
final class DrawersFailure extends DrawersOutcome {
  const DrawersFailure(this.reason);

  final CalcError reason;
}

/// Le résultat, ou `null` sur un refus.
extension DrawersOutcomeResult on DrawersOutcome {
  DrawersResult? get result => switch (this) {
    DrawersReady(:final result) => result,
    DrawersFailure() => null,
  };
}

/// Le résultat, dérivé de la saisie.
@riverpod
DrawersOutcome drawersResult(Ref ref) {
  final input = ref.watch(drawersFormProvider);
  try {
    return DrawersReady(computeDrawers(input));
  } on CalcException catch (error) {
    return DrawersFailure(error.reason);
  }
}
