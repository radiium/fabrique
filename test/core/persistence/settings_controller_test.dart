import 'package:fabrique/core/persistence/preferences_store.dart';
import 'package:fabrique/core/persistence/settings_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> open(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    final store = await PreferencesStore.open();
    final container = ProviderContainer(
      overrides: [preferencesStoreProvider.overrideWith((ref) => store)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('des réglages sans langue suivent le téléphone', () async {
    final container = await open({'settings': '{"haptics":false}'});
    final settings = await container.read(settingsControllerProvider.future);

    expect(settings.haptics, isFalse);
    expect(settings.language, AppLanguage.system);
  });

  test('une langue inconnue se relit comme « système »', () async {
    final container = await open({'settings': '{"language":"de"}'});
    final settings = await container.read(settingsControllerProvider.future);

    expect(settings.language, AppLanguage.system);
  });

  test('la langue choisie s’impose à l’app et survit au redémarrage', () async {
    final container = await open({});
    await container.read(settingsControllerProvider.future);
    await container
        .read(settingsControllerProvider.notifier)
        .setLanguage(AppLanguage.en);

    expect(container.read(appLocaleProvider), const Locale('en'));

    final store = await PreferencesStore.open();
    expect(store.readJson(PreferencesStore.settingsKey)?['language'], 'en');
  });

  test('une entrée illisible rend les défauts au lieu d’échouer', () async {
    final container = await open({'settings': '{"haptics":"oui"}'});
    final settings = await container.read(settingsControllerProvider.future);

    expect(settings, const Settings());
  });

  test(
    'sans stockage, les réglages restent modifiables et le signalent',
    () async {
      final container = ProviderContainer(
        overrides: [
          preferencesStoreProvider.overrideWith(
            (ref) => Future.error(StateError('stockage indisponible')),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(settingsControllerProvider.future);
      await container
          .read(settingsControllerProvider.notifier)
          .setLanguage(AppLanguage.en);

      expect(container.read(appLocaleProvider), const Locale('en'));
      expect(container.read(settingsStorageFailedProvider), isTrue);
    },
  );
}
