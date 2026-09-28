import 'package:fabrique/core/calc/tilt.dart';
import 'package:fabrique/core/persistence/preferences_store.dart';
import 'package:fabrique/core/persistence/settings_controller.dart';
import 'package:fabrique/features/level/level_controller.dart';
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

  const calibration = DeviceCalibration(edgesDeg: {0: -0.1, 1: 0.2});

  test('le calibrage du téléphone se retrouve à la prochaine ouverture', () {
    open().read(tiltCalibrationProvider.notifier).save(calibration);

    expect(open().read(tiltCalibrationProvider), calibration);
  });

  test('effacé, le calibrage ne revient pas', () {
    open().read(tiltCalibrationProvider.notifier).save(calibration);
    open().read(tiltCalibrationProvider.notifier).clear();

    expect(open().read(tiltCalibrationProvider), const DeviceCalibration());
  });

  test('un calibrage illisible est effacé, pas rejoué', () async {
    await store.writeJson(PreferencesStore.levelCalibrationKey, {
      'edgesDeg': 'penché',
    });

    expect(open().read(tiltCalibrationProvider), const DeviceCalibration());
    await pumpEventQueue();
    expect(store.readJson(PreferencesStore.levelCalibrationKey), isNull);
  });
}
