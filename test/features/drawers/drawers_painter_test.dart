import 'dart:ui';

import 'package:fabrique/core/calc/drawers.dart';
import 'package:fabrique/features/drawers/drawers_controller.dart';
import 'package:fabrique/features/drawers/drawers_painter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Vignette d'un téléphone, plein écran, et une taille dégénérée.
  const sizes = [Size(336, 210), Size(800, 600), Size(40, 30)];

  test('chaque pose, glissière et fond se rendent sans lever', () {
    for (final mount in FrontMount.values) {
      for (final slide in SlideKind.values) {
        for (final bottom in BottomMount.values) {
          final input = kDrawersDefaults.copyWith(
            frontMount: mount,
            slide: slide,
            bottomMount: bottom,
          );
          for (final size in sizes) {
            DrawersPainter(
              result: computeDrawers(input),
              input: input,
            ).paint(Canvas(PictureRecorder()), size);
          }
        }
      }
    }
  });

  test('une saisie refusée se rend sans lever', () {
    for (final size in sizes) {
      const DrawersPainter(
        result: null,
        input: kDrawersDefaults,
      ).paint(Canvas(PictureRecorder()), size);
    }
  });

  test('les pictogrammes se rendent sans lever', () {
    // 48 × 30 : la place d'un pictogramme dans sa tuile.
    for (final size in [...sizes, const Size(48, 30)]) {
      for (final selected in [true, false]) {
        for (final joint in BoxJoint.values) {
          BoxJointPreviewPainter(
            joint: joint,
            selected: selected,
          ).paint(Canvas(PictureRecorder()), size);
        }
        for (final mount in BottomMount.values) {
          BottomMountPreviewPainter(
            mount: mount,
            selected: selected,
          ).paint(Canvas(PictureRecorder()), size);
        }
      }
    }
  });
}
