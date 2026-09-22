// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Flux capteur, lissé. Seule la lecture `sensors_plus` vit ici ; la math est
/// dans `core/calc/tilt.dart`.
///
/// Le filtre est ici et non dans `core/calc` parce qu'il conditionne un flux —
/// il a une mémoire, il dépend de la cadence d'échantillonnage. `computeTilt`
/// reste une fonction pure d'une seule lecture.

@ProviderFor(accelStream)
final accelStreamProvider = AccelStreamProvider._();

/// Flux capteur, lissé. Seule la lecture `sensors_plus` vit ici ; la math est
/// dans `core/calc/tilt.dart`.
///
/// Le filtre est ici et non dans `core/calc` parce qu'il conditionne un flux —
/// il a une mémoire, il dépend de la cadence d'échantillonnage. `computeTilt`
/// reste une fonction pure d'une seule lecture.

final class AccelStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<AccelReading>,
          AccelReading,
          Stream<AccelReading>
        >
    with $FutureModifier<AccelReading>, $StreamProvider<AccelReading> {
  /// Flux capteur, lissé. Seule la lecture `sensors_plus` vit ici ; la math est
  /// dans `core/calc/tilt.dart`.
  ///
  /// Le filtre est ici et non dans `core/calc` parce qu'il conditionne un flux —
  /// il a une mémoire, il dépend de la cadence d'échantillonnage. `computeTilt`
  /// reste une fonction pure d'une seule lecture.
  AccelStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accelStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accelStreamHash();

  @$internal
  @override
  $StreamProviderElement<AccelReading> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<AccelReading> create(Ref ref) {
    return accelStream(ref);
  }
}

String _$accelStreamHash() => r'e3cf44f758cc506d82ff0a7f6659e344c5b34824';

/// Offset de calibrage posé par le bouton « mettre à zéro ».

@ProviderFor(TiltZero)
final tiltZeroProvider = TiltZeroProvider._();

/// Offset de calibrage posé par le bouton « mettre à zéro ».
final class TiltZeroProvider
    extends $NotifierProvider<TiltZero, AccelReading?> {
  /// Offset de calibrage posé par le bouton « mettre à zéro ».
  TiltZeroProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tiltZeroProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tiltZeroHash();

  @$internal
  @override
  TiltZero create() => TiltZero();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccelReading? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccelReading?>(value),
    );
  }
}

String _$tiltZeroHash() => r'6568d3ef13840fd2e02b425fd53055e56c633733';

/// Offset de calibrage posé par le bouton « mettre à zéro ».

abstract class _$TiltZero extends $Notifier<AccelReading?> {
  AccelReading? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AccelReading?, AccelReading?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AccelReading?, AccelReading?>,
              AccelReading?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(tiltResult)
final tiltResultProvider = TiltResultProvider._();

final class TiltResultProvider
    extends $FunctionalProvider<TiltResult?, TiltResult?, TiltResult?>
    with $Provider<TiltResult?> {
  TiltResultProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tiltResultProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tiltResultHash();

  @$internal
  @override
  $ProviderElement<TiltResult?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TiltResult? create(Ref ref) {
    return tiltResult(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TiltResult? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TiltResult?>(value),
    );
  }
}

String _$tiltResultHash() => r'60a1a185fa1209cd335aa222b81742434f13223c';
