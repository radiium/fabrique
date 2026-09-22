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

String _$layoutFormHash() => r'ed3a0ad166ffc7d764c6f7b57b9eeea195e995e5';

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
    extends $FunctionalProvider<LayoutResult?, LayoutResult?, LayoutResult?>
    with $Provider<LayoutResult?> {
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
  $ProviderElement<LayoutResult?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LayoutResult? create(Ref ref) {
    return layoutResult(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LayoutResult? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LayoutResult?>(value),
    );
  }
}

String _$layoutResultHash() => r'465861ca074301a909bdfd79a2272f5f957b7257';
