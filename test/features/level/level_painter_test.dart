import 'dart:ui';

import 'package:fabrique/core/calc/tilt.dart';
import 'package:fabrique/features/level/level_painter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/l10n.dart';

void main() {
  /// Vignette d'un téléphone, carte large, et une taille dégénérée.
  const sizes = [Size(368, 368), Size(800, 600), Size(40, 30)];

  for (final l10n in allLocales) {
    group(l10n.localeName, () {
      test('à plat, la consigne se rend sans lever', () {
        for (final size in sizes) {
          LevelPainter(
            result: const FlatTilt(),
            l10n: l10n,
          ).paint(Canvas(PictureRecorder()), size);
        }
      });

      test('sur chaque tranche, se rend sans lever', () {
        for (var turns = 0; turns < 4; turns++) {
          for (final angle in const [0.0, 0.3, -12.0, 45.0]) {
            final result = TiltResult.edge(
              angleDeg: angle,
              quarterTurns: turns,
              isLevel: angle.abs() < 0.5,
              isCalibrated: false,
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

      test('sans lecture du capteur, le dessin se rend sans lever', () {
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
