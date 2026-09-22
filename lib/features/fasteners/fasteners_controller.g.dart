// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fasteners_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FastenerForm)
final fastenerFormProvider = FastenerFormProvider._();

final class FastenerFormProvider
    extends $NotifierProvider<FastenerForm, FastenerInput> {
  FastenerFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fastenerFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fastenerFormHash();

  @$internal
  @override
  FastenerForm create() => FastenerForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FastenerInput value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FastenerInput>(value),
    );
  }
}

String _$fastenerFormHash() => r'bba847137e105897448cbcaba069bcef53d989ec';

abstract class _$FastenerForm extends $Notifier<FastenerInput> {
  FastenerInput build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FastenerInput, FastenerInput>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FastenerInput, FastenerInput>,
              FastenerInput,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(fastenerResult)
final fastenerResultProvider = FastenerResultProvider._();

final class FastenerResultProvider
    extends
        $FunctionalProvider<FastenerResult?, FastenerResult?, FastenerResult?>
    with $Provider<FastenerResult?> {
  FastenerResultProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fastenerResultProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fastenerResultHash();

  @$internal
  @override
  $ProviderElement<FastenerResult?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FastenerResult? create(Ref ref) {
    return fastenerResult(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FastenerResult? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FastenerResult?>(value),
    );
  }
}

String _$fastenerResultHash() => r'623d56d62f9dc4728bd79fc26b20febc2303f581';
