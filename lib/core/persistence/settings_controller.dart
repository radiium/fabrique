import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'preferences_store.dart';

part 'settings_controller.freezed.dart';
part 'settings_controller.g.dart';

/// Réglages globaux (écran Réglages). Thème verrouillé clair, langue FR.
@freezed
abstract class Settings with _$Settings {
  const factory Settings({@Default(true) bool haptics}) = _Settings;

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
/// `true` tant que les réglages chargent : le premier appui doit répondre
/// comme les suivants, pas attendre le disque.
@riverpod
bool hapticsEnabled(Ref ref) =>
    ref.watch(settingsControllerProvider).value?.haptics ?? true;
