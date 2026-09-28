import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/calc/calc_exception.dart';
import '../../core/calc/units/imperial.dart';
import '../../core/calc/units/measures.dart';
import '../../core/models/measure_unit.dart';
import '../../core/models/tool.dart';
import '../../core/persistence/persisted_form.dart';

part 'converter_controller.freezed.dart';
part 'converter_controller.g.dart';

@freezed
abstract class ConverterInput with _$ConverterInput {
  const factory ConverterInput({
    required double value,
    required MeasureUnit unit,

    /// Affiche l'impérial en composé (pied + pouce + fraction).
    ///
    /// Longueurs seulement. Conservé au changement de catégorie.
    @Default(true) bool compoundImperial,
  }) = _ConverterInput;

  const ConverterInput._();

  factory ConverterInput.fromJson(Map<String, dynamic> json) =>
      _$ConverterInputFromJson(json);

  /// Déduite de l'unité plutôt que stockée : elle ne peut pas la contredire.
  Quantity get quantity => unit.quantity;
}

/// La valeur saisie convertie dans toutes les unités de sa catégorie.
@freezed
abstract class ConverterResult with _$ConverterResult {
  const factory ConverterResult({
    required Quantity quantity,

    /// La valeur dans l'unité pivot de la catégorie (mm, mm², mm³, g, Pa).
    required double base,
    required Map<MeasureUnit, double> perUnit,

    /// Décomposition pied + pouce + fraction — `null` hors longueur.
    ImperialParts? imperial,
  }) = _ConverterResult;
}

/// Saisie de départ, et cible du bouton « réinitialiser ».
const ConverterInput kConverterDefaults = ConverterInput(
  value: 100,
  unit: MeasureUnit.mm,
);

@riverpod
class ConverterForm extends _$ConverterForm with PersistedForm<ConverterInput> {
  @override
  Tool get tool => Tool.converter;

  @override
  ConverterInput get defaults => kConverterDefaults;

  @override
  ConverterInput decode(Map<String, dynamic> json) =>
      ConverterInput.fromJson(json);

  @override
  Map<String, dynamic> encode(ConverterInput input) => input.toJson();

  @override
  ConverterInput build() => restore();

  void reset() => state = kConverterDefaults;

  void setValue(double v) => state = state.copyWith(value: v);

  void setUnit(MeasureUnit u) => state = state.copyWith(unit: u);

  /// Garde la valeur et prend l'unité courante de la nouvelle famille.
  void setQuantity(Quantity q) {
    if (q == state.quantity) return;
    state = state.copyWith(unit: q.defaultUnit);
  }

  void setCompoundImperial(bool on) =>
      state = state.copyWith(compoundImperial: on);
}

@riverpod
ConverterResult? converterResult(Ref ref) {
  final input = ref.watch(converterFormProvider);
  try {
    final base = toBase(input.value, input.unit);
    return ConverterResult(
      quantity: input.quantity,
      base: base,
      perUnit: convertAll(input.value, input.unit),
      // `base` est en mm, ce qu'attend `mmToImperial`.
      imperial: input.quantity == Quantity.length ? mmToImperial(base) : null,
    );
  } on CalcException {
    return null;
  }
}
