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
    /// N'a de sens qu'en longueur : on ne décompose pas une pression en
    /// fractions de pouce. Le réglage est conservé au changement de catégorie
    /// pour qu'un aller-retour ne le perde pas, mais l'écran le masque ailleurs.
    @Default(true) bool compoundImperial,
  }) = _ConverterInput;

  const ConverterInput._();

  factory ConverterInput.fromJson(Map<String, dynamic> json) =>
      _$ConverterInputFromJson(json);

  /// La catégorie se déduit de l'unité plutôt que d'être stockée à côté : deux
  /// champs pourraient se contredire (une unité de masse dans une catégorie
  /// « Longueur »), un seul ne le peut pas.
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

  /// Changer de catégorie garde la valeur saisie et retombe sur l'unité
  /// courante de la nouvelle famille : on vient souvent convertir le même
  /// nombre d'une grandeur à l'autre, et retaper « 2400 » serait une punition.
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
      // Le pivot des longueurs est le millimètre : `base` est directement ce
      // qu'attend `mmToImperial`.
      imperial: input.quantity == Quantity.length ? mmToImperial(base) : null,
    );
  } on CalcException {
    return null;
  }
}
