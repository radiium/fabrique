import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../core/calc/calc_exception.dart';
import '../../core/calc/tilt.dart';
import '../../core/calc/tilt_calibration.dart';
import '../../core/persistence/preferences_store.dart';
import '../../core/persistence/settings_controller.dart';

part 'level_controller.g.dart';

/// Cadence de lecture : 20 ms, soit 50 Hz. À 200 ms, la bulle saute.
const Duration _samplingPeriod = SensorInterval.gameInterval;

/// Poids d'une mesure neuve dans le lissage passe-bas.
///
/// Brut, l'angle frémit au dixième de degré ; 0,12 à 50 Hz amortit le bruit.
const double _smoothing = 0.12;

/// Délai sans première lecture au-delà duquel le capteur est déclaré muet.
///
/// Un navigateur sans capteur, ou qui en refuse l'accès, n'émet rien et ne
/// lève rien.
const Duration kSensorSilenceDelay = Duration(seconds: 2);

/// Flux capteur, lissé.
///
/// Le filtre a une mémoire et dépend de la cadence : il reste hors de
/// `core/calc`.
@riverpod
Stream<AccelReading> accelStream(Ref ref) {
  AccelReading? smoothed;
  return accelerometerEventStream(samplingPeriod: _samplingPeriod).map((event) {
    final raw = AccelReading(event.x, event.y, event.z);
    final previous = smoothed;
    final next = previous == null
        ? raw
        : AccelReading(
            _towards(previous.x, raw.x),
            _towards(previous.y, raw.y),
            _towards(previous.z, raw.z),
          );
    smoothed = next;
    return next;
  });
}

double _towards(double previous, double target) =>
    previous + (target - previous) * _smoothing;

/// Passe à `true` après [kSensorSilenceDelay]. Ne compte que tant qu'aucune
/// lecture n'est arrivée.
@riverpod
class SensorSilence extends _$SensorSilence {
  @override
  bool build() {
    final timer = Timer(kSensorSilenceDelay, () => state = true);
    ref.onDispose(timer.cancel);
    return false;
  }
}

/// Attente avant une mesure immobile : le temps que la main quitte le
/// téléphone et que le lissage se stabilise.
const Duration kSettleDelay = Duration(seconds: 1);

/// Durée sur laquelle une mesure immobile fait la moyenne des lectures.
const Duration kSampleWindow = Duration(seconds: 1);

/// Recueille les lectures du capteur pendant [kSampleWindow], après
/// [kSettleDelay].
///
/// Construit dans le `build()` du notifier : il s'arrête avec le provider.
class _SteadySampler {
  _SteadySampler(this._ref) {
    _ref
      ..listen(accelStreamProvider, (_, next) {
        if (next.value case final reading?) _samples?.add(reading);
      })
      ..onDispose(cancel);
  }

  final Ref _ref;
  Timer? _timer;
  List<AccelReading>? _samples;

  void start(void Function(List<AccelReading> samples) onDone) {
    cancel();
    _timer = Timer(kSettleDelay, () {
      // La lecture en cours compte : un capteur qui ne bouge pas n'émet pas
      // forcément pendant la fenêtre.
      final samples = [?_ref.read(accelStreamProvider).value];
      _samples = samples;
      _timer = Timer(kSampleWindow, () {
        _samples = null;
        onDone(samples);
      });
    });
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
    _samples = null;
  }
}

/// Calibrage du téléphone, lu et écrit sur disque à chaque changement.
@riverpod
class TiltCalibration extends _$TiltCalibration {
  static const String _key = PreferencesStore.levelCalibrationKey;

  @override
  DeviceCalibration build() {
    // `read`, comme une saisie restaurée. Sans store (tests), non calibré.
    final store = ref.read(preferencesStoreProvider).value;
    if (store == null) return const DeviceCalibration();
    try {
      final json = store.readJson(_key);
      return json == null
          ? const DeviceCalibration()
          : DeviceCalibration.fromJson(json);
    } on Object catch (error) {
      debugPrint('Calibrage du Niveau illisible, effacé : $error');
      unawaited(store.remove(_key));
      return const DeviceCalibration();
    }
  }

  void save(DeviceCalibration calibration) {
    state = calibration;
    if (ref.read(preferencesStoreProvider).value case final store?) {
      unawaited(store.writeJson(_key, calibration.toJson()));
    }
  }

  void clear() {
    state = const DeviceCalibration();
    if (ref.read(preferencesStoreProvider).value case final store?) {
      unawaited(store.remove(_key));
    }
  }
}

@riverpod
TiltResult? tiltResult(Ref ref) {
  final reading = ref.watch(accelStreamProvider).value;
  if (reading == null) return null;
  try {
    return computeTilt(
      reading,
      calibration: ref.watch(tiltCalibrationProvider),
    );
  } on CalcException {
    // `computeTilt` lève sur un vecteur nul ou non fini, qu'un capteur qui
    // décroche peut produire.
    return null;
  }
}

/// Une étape de l'assistant de calibrage.
sealed class CalibrationStep {
  const CalibrationStep();
}

/// En attente de « Mesurer », pour la mesure [step] (1 ou 2).
final class CalibrationWaiting extends CalibrationStep {
  const CalibrationWaiting(this.step);

  final int step;
}

final class CalibrationMeasuring extends CalibrationStep {
  const CalibrationMeasuring(this.step);

  final int step;
}

/// Calibrage enregistré ; [biasDeg] est l'écart corrigé.
final class CalibrationDone extends CalibrationStep {
  const CalibrationDone(this.biasDeg);

  final double biasDeg;
}

final class CalibrationFailed extends CalibrationStep {
  const CalibrationFailed(this.reason);

  final CalcError reason;
}

/// L'assistant de calibrage par retournement : deux mesures immobiles, la
/// seconde après un demi-tour sur place.
@riverpod
class CalibrationWizard extends _$CalibrationWizard {
  late _SteadySampler _sampler;
  TiltResult? _first;

  @override
  CalibrationStep build() {
    _sampler = _SteadySampler(ref);
    _first = null;
    return const CalibrationWaiting(1);
  }

  void measure() {
    if (state case CalibrationWaiting(:final step)) {
      state = CalibrationMeasuring(step);
      _sampler.start(_finish);
    }
  }

  void restart() {
    _sampler.cancel();
    _first = null;
    state = const CalibrationWaiting(1);
  }

  void _finish(List<AccelReading> samples) {
    try {
      // Sans calibrage : c'est le biais brut qui se mesure.
      final tilt = computeTilt(steadyReading(samples));
      final first = _first;
      if (first == null) {
        _first = tilt;
        state = const CalibrationWaiting(2);
        return;
      }
      final outcome = calibrateByReversal(
        ref.read(tiltCalibrationProvider),
        first,
        tilt,
      );
      ref.read(tiltCalibrationProvider.notifier).save(outcome.calibration);
      state = CalibrationDone(outcome.biasDeg);
    } on CalcException catch (error) {
      _first = null;
      state = CalibrationFailed(error.reason);
    }
  }
}
