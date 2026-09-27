import 'dart:ui';

import 'package:fabrique/core/calc/tilt.dart';
import 'package:fabrique/features/level/level_painter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/l10n.dart';

void main() {
  /// Vignette d'un téléphone, carte large, et une taille dégénérée.
  const sizes = [Size(336, 210), Size(800, 600), Size(40, 30)];

  for (final l10n in allLocales) {
    group(l10n.localeName, () {
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
              LevelPainter(
                result: result,
                l10n: l10n,
              ).paint(Canvas(PictureRecorder()), size);
            }
          }
        }
      });

      test('sans lecture du capteur, la fiole se rend sans lever', () {
        for (final size in sizes) {
          LevelPainter(
            result: null,
            l10n: l10n,
          ).paint(Canvas(PictureRecorder()), size);
        }
      });
    });
  }
}
