// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Settings _$SettingsFromJson(Map<String, dynamic> json) => _Settings(
  haptics: json['haptics'] as bool? ?? true,
  language:
      $enumDecodeNullable(
        _$AppLanguageEnumMap,
        json['language'],
        unknownValue: AppLanguage.system,
      ) ??
      AppLanguage.system,
);

Map<String, dynamic> _$SettingsToJson(_Settings instance) => <String, dynamic>{
  'haptics': instance.haptics,
  'language': _$AppLanguageEnumMap[instance.language]!,
};

const _$AppLanguageEnumMap = {
  AppLanguage.system: 'system',
  AppLanguage.fr: 'fr',
  AppLanguage.en: 'en',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(preferencesStore)
final preferencesStoreProvider = PreferencesStoreProvider._();

final class PreferencesStoreProvider
    extends
        $FunctionalProvider<
          AsyncValue<PreferencesStore>,
          PreferencesStore,
          FutureOr<PreferencesStore>
        >
    with $FutureModifier<PreferencesStore>, $FutureProvider<PreferencesStore> {
  PreferencesStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesStoreHash();

  @$internal
  @override
  $FutureProviderElement<PreferencesStore> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PreferencesStore> create(Ref ref) {
    return preferencesStore(ref);
  }
}

String _$preferencesStoreHash() => r'c29d93a35cc9cbdccf459eb705c6efd2b5661e8d';

@ProviderFor(SettingsController)
final settingsControllerProvider = SettingsControllerProvider._();

final class SettingsControllerProvider
    extends $AsyncNotifierProvider<SettingsController, Settings> {
  SettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsControllerHash();

  @$internal
  @override
  SettingsController create() => SettingsController();
}

String _$settingsControllerHash() =>
    r'4b262d663bee82589c646c49bd1ff7fe16287445';

abstract class _$SettingsController extends $AsyncNotifier<Settings> {
  FutureOr<Settings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Settings>, Settings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Settings>, Settings>,
              AsyncValue<Settings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Le réglage haptique prêt à consommer, sans `AsyncValue` à déballer.
///
/// `true` tant que les réglages chargent : le premier appui doit répondre
/// comme les suivants, pas attendre le disque.

@ProviderFor(hapticsEnabled)
final hapticsEnabledProvider = HapticsEnabledProvider._();

/// Le réglage haptique prêt à consommer, sans `AsyncValue` à déballer.
///
/// `true` tant que les réglages chargent : le premier appui doit répondre
/// comme les suivants, pas attendre le disque.

final class HapticsEnabledProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Le réglage haptique prêt à consommer, sans `AsyncValue` à déballer.
  ///
  /// `true` tant que les réglages chargent : le premier appui doit répondre
  /// comme les suivants, pas attendre le disque.
  HapticsEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hapticsEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hapticsEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hapticsEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hapticsEnabledHash() => r'2c7eb9d115de8cee1f52a74531b1435a709c7b41';

/// La locale imposée par le réglage, `null` pour suivre le téléphone.
///
/// `null` aussi tant que les réglages chargent : le premier écran s'affiche
/// dans la langue du téléphone plutôt que d'attendre le disque.

@ProviderFor(appLocale)
final appLocaleProvider = AppLocaleProvider._();

/// La locale imposée par le réglage, `null` pour suivre le téléphone.
///
/// `null` aussi tant que les réglages chargent : le premier écran s'affiche
/// dans la langue du téléphone plutôt que d'attendre le disque.

final class AppLocaleProvider
    extends $FunctionalProvider<Locale?, Locale?, Locale?>
    with $Provider<Locale?> {
  /// La locale imposée par le réglage, `null` pour suivre le téléphone.
  ///
  /// `null` aussi tant que les réglages chargent : le premier écran s'affiche
  /// dans la langue du téléphone plutôt que d'attendre le disque.
  AppLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleHash();

  @$internal
  @override
  $ProviderElement<Locale?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Locale? create(Ref ref) {
    return appLocale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$appLocaleHash() => r'ae001f9bb0fb76e5318919273bb5a315307d4c94';
