import 'dart:ui';

import 'package:fabrique/core/calc/distribution.dart';
import 'package:fabrique/features/distribution/distribution_painter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Vignette d'un téléphone, plein écran, et une taille dégénérée.
  const sizes = [Size(336, 255), Size(800, 600), Size(40, 30)];

  test('chaque disposition, largeur et marge se rend sans lever', () {
    // Au moins 2 : un élément seul ne peut pas border les deux côtés. Au
    // maximum, des éléments de 3 mm pour tenir dans la largeur.
    const counts = [
      (2, 0.0),
      (2, 18.0),
      (5, 1.0),
      (5, 18.0),
      (kMaxDistributionCount, 0.0),
      (kMaxDistributionCount, 3.0),
    ];
    const margins = [(0.0, 0.0), (40.0, 5.0)];

    for (final start in DistributionEdge.values) {
      for (final end in DistributionEdge.values) {
        for (final (count, width) in counts) {
          for (final (startOffset, endOffset) in margins) {
            final input = DistributionInput(
              length: 1800,
              count: count,
              elementWidth: width,
              startEdge: start,
              endEdge: end,
              startOffset: startOffset,
              endOffset: endOffset,
            );
            final painter = DistributionPainter(
              result: computeDistribution(input),
              length: input.length,
              elementWidth: width,
              startOffset: startOffset,
              endOffset: endOffset,
            );
            for (final size in sizes) {
              painter.paint(Canvas(PictureRecorder()), size);
            }
          }
        }
      }
    }
  });

  test('des éléments qui remplissent toute la largeur se rendent', () {
    // Aucun jeu : le cas limite accepté par le cœur.
    const input = DistributionInput(
      length: 100,
      count: 5,
      elementWidth: 20,
      startEdge: DistributionEdge.element,
      endEdge: DistributionEdge.element,
    );
    final painter = DistributionPainter(
      result: computeDistribution(input),
      length: 100,
      elementWidth: 20,
      startOffset: 0,
      endOffset: 0,
    );
    for (final size in sizes) {
      painter.paint(Canvas(PictureRecorder()), size);
    }
  });

  test('une saisie refusée se rend sans lever', () {
    for (final size in sizes) {
      const DistributionPainter(
        result: null,
        length: 1800,
        elementWidth: 18,
        startOffset: 0,
        endOffset: 0,
      ).paint(Canvas(PictureRecorder()), size);
    }
  });
}
