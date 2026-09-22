// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distribution_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tient la saisie. Une méthode par champ, qui fait `copyWith`.

@ProviderFor(DistributionForm)
final distributionFormProvider = DistributionFormProvider._();

/// Tient la saisie. Une méthode par champ, qui fait `copyWith`.
final class DistributionFormProvider
    extends $NotifierProvider<DistributionForm, DistributionFormState> {
  /// Tient la saisie. Une méthode par champ, qui fait `copyWith`.
  DistributionFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'distributionFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$distributionFormHash();

  @$internal
  @override
  DistributionForm create() => DistributionForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DistributionFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DistributionFormState>(value),
    );
  }
}

String _$distributionFormHash() => r'8eda7194e50be9bc8439635e1aea3709fcb17990';

/// Tient la saisie. Une méthode par champ, qui fait `copyWith`.

abstract class _$DistributionForm extends $Notifier<DistributionFormState> {
  DistributionFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DistributionFormState, DistributionFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DistributionFormState, DistributionFormState>,
              DistributionFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Le résultat est une dérivation, pas de l'état : temps réel, sans bouton.

@ProviderFor(distributionResult)
final distributionResultProvider = DistributionResultProvider._();

/// Le résultat est une dérivation, pas de l'état : temps réel, sans bouton.

final class DistributionResultProvider
    extends
        $FunctionalProvider<
          DistributionOutcome,
          DistributionOutcome,
          DistributionOutcome
        >
    with $Provider<DistributionOutcome> {
  /// Le résultat est une dérivation, pas de l'état : temps réel, sans bouton.
  DistributionResultProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'distributionResultProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$distributionResultHash();

  @$internal
  @override
  $ProviderElement<DistributionOutcome> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DistributionOutcome create(Ref ref) {
    return distributionResult(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DistributionOutcome value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DistributionOutcome>(value),
    );
  }
}

String _$distributionResultHash() =>
    r'1b7b30544beba31beed812b1895f79219f5ad41f';
