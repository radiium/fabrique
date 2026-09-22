import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../core/calc/calc_exception.dart';
import '../../core/calc/tilt.dart';

part 'level_controller.g.dart';

/// Cadence de lecture — 20 ms, soit 50 Hz.
///
/// Le défaut de `sensors_plus` est `normalInterval`, 200 ms : une bulle qui ne
/// bouge que cinq fois par seconde saute d'une position à l'autre au lieu de
/// glisser, et un niveau qui saute n'inspire aucune confiance.
const Duration _samplingPeriod = SensorInterval.gameInterval;

/// Poids d'une mesure neuve dans le lissage passe-bas.
///
/// L'accéléromètre d'un téléphone est bruité de quelques centièmes de g : brut,
/// l'angle frémit en permanence au dixième de degré, juste au-dessus du seuil
/// de niveau. 0.12 à 50 Hz amortit le bruit en gardant la réponse au geste.
const double _smoothing = 0.12;

/// Flux capteur, lissé. Seule la lecture `sensors_plus` vit ici ; la math est
/// dans `core/calc/tilt.dart`.
///
/// Le filtre est ici et non dans `core/calc` parce qu'il conditionne un flux —
/// il a une mémoire, il dépend de la cadence d'échantillonnage. `computeTilt`
/// reste une fonction pure d'une seule lecture.
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
    // Même contrat que les autres outils : une lecture aberrante rend `null`,
    // l'écran affiche un tiret. `computeTilt` lève sur un vecteur nul ou non
    // fini, ce qu'un capteur qui décroche peut très bien produire.
    return null;
  }
}
