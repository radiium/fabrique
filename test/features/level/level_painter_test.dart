import 'dart:ui';

import 'package:fabrique/core/calc/tilt.dart';
import 'package:fabrique/features/level/level_painter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Vignette d'un téléphone, carte large, et une taille dégénérée.
  const sizes = [Size(336, 210), Size(800, 600), Size(40, 30)];

  test('à plat, incliné ou hors fiole, la bulle se rend sans lever', () {
    // Au-delà du bord de la fiole, la bulle doit rester dessinable.
    const angles = [0.0, 0.3, -4.0, 15.0, -89.9, 90.0];
    for (final pitch in angles) {
      for (final roll in angles) {
        final result = TiltResult(
          pitchDeg: pitch,
          rollDeg: roll,
          isLevel: pitch.abs() < 0.5 && roll.abs() < 0.5,
        );
        for (final size in sizes) {
          LevelPainter(result: result).paint(Canvas(PictureRecorder()), size);
        }
      }
    }
  });

  test('sans lecture du capteur, la fiole se rend sans lever', () {
    for (final size in sizes) {
      const LevelPainter(result: null).paint(Canvas(PictureRecorder()), size);
    }
  });
}
