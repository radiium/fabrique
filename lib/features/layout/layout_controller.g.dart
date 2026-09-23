// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LayoutForm)
final layoutFormProvider = LayoutFormProvider._();

final class LayoutFormProvider
    extends $NotifierProvider<LayoutForm, LayoutInput> {
  LayoutFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'layoutFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$layoutFormHash();

  @$internal
  @override
  LayoutForm create() => LayoutForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LayoutInput value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LayoutInput>(value),
    );
  }
}

String _$layoutFormHash() => r'451b6f867fc5bb23d60232a027ad0a84c160e22a';

abstract class _$LayoutForm extends $Notifier<LayoutInput> {
  LayoutInput build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LayoutInput, LayoutInput>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LayoutInput, LayoutInput>,
              LayoutInput,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(layoutResult)
final layoutResultProvider = LayoutResultProvider._();

final class LayoutResultProvider
    extends $FunctionalProvider<LayoutOutcome, LayoutOutcome, LayoutOutcome>
    with $Provider<LayoutOutcome> {
  LayoutResultProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'layoutResultProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$layoutResultHash();

  @$internal
  @override
  $ProviderElement<LayoutOutcome> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LayoutOutcome create(Ref ref) {
    return layoutResult(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LayoutOutcome value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LayoutOutcome>(value),
    );
  }
}

String _$layoutResultHash() => r'b23ebfcf73d63c3b078966cf15caaa34a6128976';
