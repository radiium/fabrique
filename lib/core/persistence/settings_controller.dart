import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'preferences_store.dart';

part 'settings_controller.freezed.dart';
part 'settings_controller.g.dart';

/// Langue de l'app : celle du téléphone, ou une langue imposée.
enum AppLanguage {
  system,
  fr,
  en;

  /// La locale à imposer à l'app, `null` pour suivre le téléphone.
  Locale? get locale => switch (this) {
    AppLanguage.system => null,
    AppLanguage.fr => const Locale('fr'),
    AppLanguage.en => const Locale('en'),
  };
}

/// Réglages globaux (écran Réglages). Thème verrouillé clair.
@freezed
abstract class Settings with _$Settings {
  const factory Settings({
    @Default(true) bool haptics,
    // Une langue inconnue (version plus récente) se relit « système ».
    @JsonKey(unknownEnumValue: AppLanguage.system)
    @Default(AppLanguage.system)
    AppLanguage language,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
}

@Riverpod(keepAlive: true)
Future<PreferencesStore> preferencesStore(Ref ref) => PreferencesStore.open();

@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  @override
  Future<Settings> build() async {
    final store = await ref.watch(preferencesStoreProvider.future);
    final json = store.readJson(PreferencesStore.settingsKey);
    return json == null ? const Settings() : Settings.fromJson(json);
  }

  Future<void> setHaptics(bool enabled) =>
      _update((s) => s.copyWith(haptics: enabled));

  Future<void> setLanguage(AppLanguage language) =>
      _update((s) => s.copyWith(language: language));

  Future<void> _update(Settings Function(Settings) change) async {
    final current = await future;
    final next = change(current);
    state = AsyncData(next);
    final store = await ref.read(preferencesStoreProvider.future);
    await store.writeJson(PreferencesStore.settingsKey, next.toJson());
  }
}

/// Le réglage haptique prêt à consommer, sans `AsyncValue` à déballer.
///
/// `true` tant que les réglages chargent, pour que le premier appui vibre.
@riverpod
bool hapticsEnabled(Ref ref) =>
    ref.watch(settingsControllerProvider).value?.haptics ?? true;

/// La locale imposée par le réglage, `null` pour suivre le téléphone.
///
/// `null` aussi pendant le chargement : langue du téléphone d'abord.
@riverpod
Locale? appLocale(Ref ref) =>
    ref.watch(settingsControllerProvider).value?.language.locale;
