import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../core/calc/calc_exception.dart';
import '../../core/calc/tilt.dart';

part 'level_controller.g.dart';

/// Cadence de lecture : 20 ms, soit 50 Hz. À 200 ms, la bulle saute.
const Duration _samplingPeriod = SensorInterval.gameInterval;

/// Poids d'une mesure neuve dans le lissage passe-bas.
///
/// Brut, l'angle frémit au dixième de degré ; 0,12 à 50 Hz amortit le bruit.
const double _smoothing = 0.12;

/// Flux capteur, lissé.
///
/// Le filtre a une mémoire, d'où sa place hors de `core/calc`.
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

/// Offset de calibrage posé par le bouton « mettre à zéro ».
@riverpod
class TiltZero extends _$TiltZero {
  @override
  AccelReading? build() => null;

  void calibrate(AccelReading reading) => state = reading;

  void reset() => state = null;
}

@riverpod
TiltResult? tiltResult(Ref ref) {
  final reading = ref.watch(accelStreamProvider).value;
  if (reading == null) return null;
  try {
    return computeTilt(reading, zero: ref.watch(tiltZeroProvider));
  } on CalcException {
    // `computeTilt` lève sur un vecteur nul ou non fini, qu'un capteur qui
    // décroche peut produire.
    return null;
  }
}
