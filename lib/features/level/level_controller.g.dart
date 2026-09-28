// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Flux capteur, lissé.
///
/// Le filtre a une mémoire et dépend de la cadence : il reste hors de
/// `core/calc`.

@ProviderFor(accelStream)
final accelStreamProvider = AccelStreamProvider._();

/// Flux capteur, lissé.
///
/// Le filtre a une mémoire et dépend de la cadence : il reste hors de
/// `core/calc`.

final class AccelStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<AccelReading>,
          AccelReading,
          Stream<AccelReading>
        >
    with $FutureModifier<AccelReading>, $StreamProvider<AccelReading> {
  /// Flux capteur, lissé.
  ///
  /// Le filtre a une mémoire et dépend de la cadence : il reste hors de
  /// `core/calc`.
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

/// Passe à `true` après [kSensorSilenceDelay]. Ne compte que tant qu'aucune
/// lecture n'est arrivée.

@ProviderFor(SensorSilence)
final sensorSilenceProvider = SensorSilenceProvider._();

/// Passe à `true` après [kSensorSilenceDelay]. Ne compte que tant qu'aucune
/// lecture n'est arrivée.
final class SensorSilenceProvider
    extends $NotifierProvider<SensorSilence, bool> {
  /// Passe à `true` après [kSensorSilenceDelay]. Ne compte que tant qu'aucune
  /// lecture n'est arrivée.
  SensorSilenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sensorSilenceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sensorSilenceHash();

  @$internal
  @override
  SensorSilence create() => SensorSilence();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$sensorSilenceHash() => r'7d4fb3d3c2b41319b8fcff399331e40fb3588f0c';

/// Passe à `true` après [kSensorSilenceDelay]. Ne compte que tant qu'aucune
/// lecture n'est arrivée.

abstract class _$SensorSilence extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Calibrage du téléphone, lu et écrit sur disque à chaque changement.

@ProviderFor(TiltCalibration)
final tiltCalibrationProvider = TiltCalibrationProvider._();

/// Calibrage du téléphone, lu et écrit sur disque à chaque changement.
final class TiltCalibrationProvider
    extends $NotifierProvider<TiltCalibration, DeviceCalibration> {
  /// Calibrage du téléphone, lu et écrit sur disque à chaque changement.
  TiltCalibrationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tiltCalibrationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tiltCalibrationHash();

  @$internal
  @override
  TiltCalibration create() => TiltCalibration();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceCalibration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceCalibration>(value),
    );
  }
}

String _$tiltCalibrationHash() => r'08f021801e13a3c43317622b723374cb8f563479';

/// Calibrage du téléphone, lu et écrit sur disque à chaque changement.

abstract class _$TiltCalibration extends $Notifier<DeviceCalibration> {
  DeviceCalibration build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DeviceCalibration, DeviceCalibration>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeviceCalibration, DeviceCalibration>,
              DeviceCalibration,
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

String _$tiltResultHash() => r'32a215fb0866a2830b02cf480bcdb61366abea3a';

/// L'assistant de calibrage par retournement : deux mesures immobiles, la
/// seconde après un demi-tour sur place.

@ProviderFor(CalibrationWizard)
final calibrationWizardProvider = CalibrationWizardProvider._();

/// L'assistant de calibrage par retournement : deux mesures immobiles, la
/// seconde après un demi-tour sur place.
final class CalibrationWizardProvider
    extends $NotifierProvider<CalibrationWizard, CalibrationStep> {
  /// L'assistant de calibrage par retournement : deux mesures immobiles, la
  /// seconde après un demi-tour sur place.
  CalibrationWizardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calibrationWizardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calibrationWizardHash();

  @$internal
  @override
  CalibrationWizard create() => CalibrationWizard();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalibrationStep value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalibrationStep>(value),
    );
  }
}

String _$calibrationWizardHash() => r'875862702a998e9d84205316c4bab657934d6f40';

/// L'assistant de calibrage par retournement : deux mesures immobiles, la
/// seconde après un demi-tour sur place.

abstract class _$CalibrationWizard extends $Notifier<CalibrationStep> {
  CalibrationStep build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CalibrationStep, CalibrationStep>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CalibrationStep, CalibrationStep>,
              CalibrationStep,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
