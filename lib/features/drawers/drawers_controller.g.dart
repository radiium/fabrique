// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawers_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tient la saisie. Une méthode par champ, qui fait `copyWith`.
///
/// Pas encore persistée : la saisie ne se garde qu'une fois le calcul branché.

@ProviderFor(DrawersForm)
final drawersFormProvider = DrawersFormProvider._();

/// Tient la saisie. Une méthode par champ, qui fait `copyWith`.
///
/// Pas encore persistée : la saisie ne se garde qu'une fois le calcul branché.
final class DrawersFormProvider
    extends $NotifierProvider<DrawersForm, DrawersInput> {
  /// Tient la saisie. Une méthode par champ, qui fait `copyWith`.
  ///
  /// Pas encore persistée : la saisie ne se garde qu'une fois le calcul branché.
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

String _$drawersFormHash() => r'94b4144ae4c77cf9de5514b013e404155bae535f';

/// Tient la saisie. Une méthode par champ, qui fait `copyWith`.
///
/// Pas encore persistée : la saisie ne se garde qu'une fois le calcul branché.

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
    extends $FunctionalProvider<DrawersResult?, DrawersResult?, DrawersResult?>
    with $Provider<DrawersResult?> {
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
  $ProviderElement<DrawersResult?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DrawersResult? create(Ref ref) {
    return drawersResult(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DrawersResult? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DrawersResult?>(value),
    );
  }
}

String _$drawersResultHash() => r'd251f106e326ef16063d7d395513161cb192db13';
