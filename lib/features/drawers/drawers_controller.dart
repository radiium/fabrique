import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/calc/drawers.dart';

part 'drawers_controller.g.dart';

/// Saisie de départ, et cible du bouton « réinitialiser » : un caisson de
/// cuisine de 600, trois tiroirs à billes, façades en applique.
const DrawersInput kDrawersDefaults = DrawersInput(
  openingWidth: 562,
  openingHeight: 720,
  openingDepth: 540,
  drawerCount: 3,
);

/// Borne haute du nombre de tiroirs : au-delà, une colonne n'est plus une
/// colonne de tiroirs mais un casier.
const int kMaxDrawerCount = 10;

/// Tient la saisie. Une méthode par champ, qui fait `copyWith`.
///
/// Pas encore persistée : la saisie ne se garde qu'une fois le calcul branché.
@riverpod
class DrawersForm extends _$DrawersForm {
  @override
  DrawersInput build() => kDrawersDefaults;

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

/// Résultat de la maquette : les cotes des défauts, écrites à la main.
///
/// L'écran et le schéma se jugent sur des chiffres plausibles avant que le
/// calcul existe. Il ne suit pas la saisie.
const DrawersResult kDrawersPreview = DrawersResult(
  fronts: [
    DrawerFrontSlot(bottom: 487.83, height: 249.67),
    DrawerFrontSlot(bottom: 235.17, height: 249.67),
    DrawerFrontSlot(bottom: -17.5, height: 249.67),
  ],
  frontWidth: 597,
  sideClearance: 12.7,
  boxWidth: 536.6,
  boxLength: 500,
  boxHeights: [180, 180, 180],
  boxBottoms: [507.83, 255.17, 10],
  bottomLift: 10,
  slideLength: 500,
  slideAxes: [542.83, 290.17, 45],
  cutList: [
    CutPiece(
      part: DrawerPart.side,
      quantity: 6,
      length: 500,
      width: 180,
      thickness: 15,
    ),
    CutPiece(
      part: DrawerPart.front,
      quantity: 3,
      length: 506.6,
      width: 180,
      thickness: 15,
    ),
    CutPiece(
      part: DrawerPart.back,
      quantity: 3,
      length: 506.6,
      width: 180,
      thickness: 15,
    ),
    CutPiece(
      part: DrawerPart.bottom,
      quantity: 3,
      length: 517.6,
      width: 481,
      thickness: 8,
    ),
    CutPiece(
      part: DrawerPart.drawerFront,
      quantity: 3,
      length: 597,
      width: 249.67,
      thickness: 19,
    ),
  ],
);

/// Le résultat est une dérivation, pas de l'état : temps réel, sans bouton.
@riverpod
DrawersResult? drawersResult(Ref ref) {
  // TODO(drawers): brancher le calcul du cœur à la place de la maquette.
  return kDrawersPreview;
}
