import 'package:fabrique/core/models/tool.dart';
import 'package:fabrique/core/persistence/preferences_store.dart';
import 'package:fabrique/core/persistence/settings_controller.dart';
import 'package:fabrique/features/distribution/distribution_controller.dart';
import 'package:fabrique/features/drawers/drawers_controller.dart';
import 'package:fabrique/features/layout/layout_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PreferencesStore store;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = await PreferencesStore.open();
  });

  /// Un container qui voit le disque, comme l'app après `main()`.
  ProviderContainer open() {
    final container = ProviderContainer(
      overrides: [preferencesStoreProvider.overrideWith((ref) => store)],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// Ouvre un écran-outil le temps de [use], puis le referme : le dispose
  /// vide la dernière frappe sur disque.
  Future<void> visit(
    ProviderSubscription<Object?> Function() listen,
    void Function() use,
  ) async {
    final subscription = listen();
    use();
    subscription.close();
    await pumpEventQueue();
  }

  test(
    'chaque outil retrouve sa saisie, sans écraser celle d’un autre',
    () async {
      // Le notifier se construit avant qu'un `Future` ne se résolve.
      final container = open();
      await visit(
        () => container.listen(layoutFormProvider, (_, _) {}),
        () => container.read(layoutFormProvider.notifier).setElementX(999),
      );
      await visit(
        () => container.listen(distributionFormProvider, (_, _) {}),
        () => container.read(distributionFormProvider.notifier).setCount(9),
      );

      // Les Tiroirs gardent une liste à trous : les hauteurs non fixées.
      await visit(
        () => container.listen(drawersFormProvider, (_, _) {}),
        () =>
            container.read(drawersFormProvider.notifier).setFrontHeight(1, 200),
      );

      final reopened = open();
      expect(reopened.read(layoutFormProvider).elementX, 999);
      expect(reopened.read(drawersFormProvider).fixedFrontHeights, [
        null,
        200,
        null,
      ]);
      expect(reopened.read(distributionFormProvider).count, 9);
    },
  );

  test('« réinitialiser » s’enregistre aussi — la prochaine ouverture est '
      'neuve', () async {
    final container = open();
    await visit(
      () => container.listen(distributionFormProvider, (_, _) {}),
      () => container.read(distributionFormProvider.notifier).setCount(9),
    );
    expect(open().read(distributionFormProvider).count, 9);

    final reopened = open();
    await visit(
      () => reopened.listen(distributionFormProvider, (_, _) {}),
      () => reopened.read(distributionFormProvider.notifier).reset(),
    );

    expect(open().read(distributionFormProvider), kDistributionDefaults);
  });

  test(
    'une saisie illisible ne bloque pas l’outil, et ne se rejoue pas',
    () async {
      final key = PreferencesStore.toolInputKey(Tool.distribution.id);
      // JSON valide, mais pas celui qu'attend `DistributionFormState`.
      await store.writeJson(key, {'mode': 'inconnu', 'length': 'beaucoup'});

      expect(open().read(distributionFormProvider), kDistributionDefaults);

      await pumpEventQueue();
      expect(
        store.readJson(key),
        isNull,
        reason: 'la clé fautive est effacée, pas relue à chaque lancement',
      );
    },
  );

  test('sans store, l’outil part de ses défauts', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(layoutFormProvider), kLayoutDefaults);
  });
}
