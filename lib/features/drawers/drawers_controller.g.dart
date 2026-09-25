// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawers_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tient la saisie. Une méthode par champ, qui fait `copyWith`.

@ProviderFor(DrawersForm)
final drawersFormProvider = DrawersFormProvider._();

/// Tient la saisie. Une méthode par champ, qui fait `copyWith`.
final class DrawersFormProvider
    extends $NotifierProvider<DrawersForm, DrawersInput> {
  /// Tient la saisie. Une méthode par champ, qui fait `copyWith`.
  DrawersFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'drawersFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$drawersFormHash();

  @$internal
  @override
  DrawersForm create() => DrawersForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DrawersInput value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DrawersInput>(value),
    );
  }
}

String _$drawersFormHash() => r'78e129c264d5a85d3bd225de4a7d9770a02e3f39';

/// Tient la saisie. Une méthode par champ, qui fait `copyWith`.

abstract class _$DrawersForm extends $Notifier<DrawersInput> {
  DrawersInput build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DrawersInput, DrawersInput>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DrawersInput, DrawersInput>,
              DrawersInput,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Le résultat est une dérivation, pas de l'état : temps réel, sans bouton.

@ProviderFor(drawersResult)
final drawersResultProvider = DrawersResultProvider._();

/// Le résultat est une dérivation, pas de l'état : temps réel, sans bouton.

final class DrawersResultProvider
    extends $FunctionalProvider<DrawersOutcome, DrawersOutcome, DrawersOutcome>
    with $Provider<DrawersOutcome> {
  /// Le résultat est une dérivation, pas de l'état : temps réel, sans bouton.
  DrawersResultProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'drawersResultProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$drawersResultHash();

  @$internal
  @override
  $ProviderElement<DrawersOutcome> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DrawersOutcome create(Ref ref) {
    return drawersResult(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DrawersOutcome value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DrawersOutcome>(value),
    );
  }
}

String _$drawersResultHash() => r'435c9f9f6eadde058dde60af9c3ee5599d00521d';
