import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/calc/calc_exception.dart';
import '../../core/calc/fasteners.dart';
import '../../core/models/enums.dart';
import '../../core/models/tool.dart';
import '../../core/persistence/persisted_form.dart';

part 'fasteners_controller.g.dart';

/// Diamètres de vis proposés au dropdown, en mm.
const List<double> screwDiameters = [3, 3.5, 4, 4.5, 5, 6];

/// Saisie de départ, et cible du bouton « réinitialiser ».
const FastenerInput kFastenerDefaults = FastenerInput(
  material: MaterialKind.softwood,
  screwDiameter: 4,
  fixedThickness: 18,
);

@riverpod
class FastenerForm extends _$FastenerForm with PersistedForm<FastenerInput> {
  @override
  Tool get tool => Tool.fasteners;

  @override
  FastenerInput get defaults => kFastenerDefaults;

  @override
  FastenerInput decode(Map<String, dynamic> json) =>
      FastenerInput.fromJson(json);

  @override
  Map<String, dynamic> encode(FastenerInput input) => input.toJson();

  @override
  FastenerInput build() => restore();

  void reset() => state = kFastenerDefaults;

  void setMaterial(MaterialKind m) => state = state.copyWith(material: m);
  void setScrewDiameter(double mm) => state = state.copyWith(screwDiameter: mm);
  void setFixedThickness(double mm) =>
      state = state.copyWith(fixedThickness: mm);
}

@riverpod
FastenerResult? fastenerResult(Ref ref) {
  final input = ref.watch(fastenerFormProvider);
  try {
    return computeFastener(input);
  } on CalcException {
    return null;
  }
}
