// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'converter_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConverterInput _$ConverterInputFromJson(Map<String, dynamic> json) =>
    _ConverterInput(
      value: (json['value'] as num).toDouble(),
      unit: $enumDecode(_$MeasureUnitEnumMap, json['unit']),
      compoundImperial: json['compoundImperial'] as bool? ?? true,
    );

Map<String, dynamic> _$ConverterInputToJson(_ConverterInput instance) =>
    <String, dynamic>{
      'value': instance.value,
      'unit': _$MeasureUnitEnumMap[instance.unit]!,
      'compoundImperial': instance.compoundImperial,
    };

const _$MeasureUnitEnumMap = {
  MeasureUnit.mm: 'mm',
  MeasureUnit.cm: 'cm',
  MeasureUnit.m: 'm',
  MeasureUnit.inch: 'inch',
  MeasureUnit.foot: 'foot',
  MeasureUnit.mm2: 'mm2',
  MeasureUnit.cm2: 'cm2',
  MeasureUnit.m2: 'm2',
  MeasureUnit.inch2: 'inch2',
  MeasureUnit.foot2: 'foot2',
  MeasureUnit.cm3: 'cm3',
  MeasureUnit.liter: 'liter',
  MeasureUnit.m3: 'm3',
  MeasureUnit.inch3: 'inch3',
  MeasureUnit.boardFoot: 'boardFoot',
  MeasureUnit.gram: 'gram',
  MeasureUnit.kilogram: 'kilogram',
  MeasureUnit.tonne: 'tonne',
  MeasureUnit.ounce: 'ounce',
  MeasureUnit.pound: 'pound',
  MeasureUnit.bar: 'bar',
  MeasureUnit.kilopascal: 'kilopascal',
  MeasureUnit.megapascal: 'megapascal',
  MeasureUnit.psi: 'psi',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConverterForm)
final converterFormProvider = ConverterFormProvider._();

final class ConverterFormProvider
    extends $NotifierProvider<ConverterForm, ConverterInput> {
  ConverterFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'converterFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$converterFormHash();

  @$internal
  @override
  ConverterForm create() => ConverterForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConverterInput value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConverterInput>(value),
    );
  }
}

String _$converterFormHash() => r'4e3eda66fef7748dca4853380ec26ff595fd4cd5';

abstract class _$ConverterForm extends $Notifier<ConverterInput> {
  ConverterInput build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ConverterInput, ConverterInput>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConverterInput, ConverterInput>,
              ConverterInput,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(converterResult)
final converterResultProvider = ConverterResultProvider._();

final class ConverterResultProvider
    extends
        $FunctionalProvider<
          ConverterResult?,
          ConverterResult?,
          ConverterResult?
        >
    with $Provider<ConverterResult?> {
  ConverterResultProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'converterResultProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$converterResultHash();

  @$internal
  @override
  $ProviderElement<ConverterResult?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ConverterResult? create(Ref ref) {
    return converterResult(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConverterResult? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConverterResult?>(value),
    );
  }
}

String _$converterResultHash() => r'0bfb5e533adaae1c7f72e14ee6ad14db0a49b0e2';
