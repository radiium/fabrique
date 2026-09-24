import 'dart:ui';

import 'package:fabrique/core/calc/fasteners.dart';
import 'package:fabrique/core/models/enums.dart';
import 'package:fabrique/features/fasteners/fasteners_controller.dart';
import 'package:fabrique/features/fasteners/fasteners_painter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Vignette d'un téléphone, plein écran, et une taille dégénérée.
  const sizes = [Size(336, 210), Size(800, 600), Size(40, 30)];

  test('chaque matériau, Ø et épaisseur se rend sans lever', () {
    // 3 mm : pièce plus fine que le lamage. 200 mm : pénétration plafonnée.
    for (final material in MaterialKind.values) {
      for (final diameter in screwDiameters) {
        for (final thickness in [3.0, 18.0, 200.0]) {
          final input = FastenerInput(
            material: material,
            screwDiameter: diameter,
            fixedThickness: thickness,
          );
          for (final compact in [true, false]) {
            for (final size in sizes) {
              FastenersPainter(
                result: computeFastener(input),
                input: input,
                compact: compact,
              ).paint(Canvas(PictureRecorder()), size);
            }
          }
        }
      }
    }
  });

  test('une saisie refusée se rend sans lever', () {
    for (final size in sizes) {
      const FastenersPainter(
        result: null,
        input: kFastenerDefaults,
      ).paint(Canvas(PictureRecorder()), size);
    }
  });
}
