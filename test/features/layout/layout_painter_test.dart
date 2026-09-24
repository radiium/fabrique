import 'dart:ui';

import 'package:fabrique/core/calc/layout.dart';
import 'package:fabrique/core/models/enums.dart';
import 'package:fabrique/features/layout/layout_controller.dart';
import 'package:fabrique/features/layout/layout_painter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Vignette d'un téléphone, plein écran, et une taille dégénérée.
  const sizes = [Size(336, 210), Size(800, 600), Size(40, 30)];

  test('chaque option de pose se rend sans lever', () {
    final inputs = [
      kLayoutDefaults,
      kLayoutDefaults.copyWith(flip: true),
      kLayoutDefaults.copyWith(offset: JointOffset.third, gapX: 3, gapY: 5),
      kLayoutDefaults.copyWith(perimeterGap: 10, balanceRows: true),
      kLayoutDefaults.copyWith(
        offset: JointOffset.straight,
        balanceRows: true,
        flip: true,
      ),
      // Un seul élément, qui remplit toute la surface.
      kLayoutDefaults.copyWith(elementX: 3000, elementY: 2000),
      // Dense : au-delà du seuil où les éléments cessent d'être cernés.
      kLayoutDefaults.copyWith(elementX: 60, elementY: 60),
    ];
    for (final input in inputs) {
      final result = computeLayout(input);
      for (final compact in [true, false]) {
        for (final size in sizes) {
          LayoutPainter(
            result: result,
            input: input,
            compact: compact,
          ).paint(Canvas(PictureRecorder()), size);
        }
      }
    }
  });

  test('une saisie refusée se rend sans lever', () {
    for (final size in sizes) {
      const LayoutPainter(
        result: null,
        input: kLayoutDefaults,
      ).paint(Canvas(PictureRecorder()), size);
    }
  });
}
