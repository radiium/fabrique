import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/calc/calc_exception.dart';
import '../../core/calc/layout.dart';
import '../../core/models/enums.dart';
import '../../core/models/tool.dart';
import '../../core/persistence/persisted_form.dart';

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
  void setFlip(bool flip) => state = state.copyWith(flip: flip);
  void setOffset(JointOffset offset) => state = state.copyWith(offset: offset);
}

@riverpod
LayoutResult? layoutResult(Ref ref) {
  final input = ref.watch(layoutFormProvider);
  try {
    return computeLayout(input);
  } on CalcException {
    return null;
  }
}
