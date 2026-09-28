import 'dart:ui';

import 'package:fabrique/core/painting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Canvas fresh() => Canvas(PictureRecorder());

  group('la fenêtre', () {
    test('pose l’origine à gauche et l’étendue sur toute la largeur', () {
      final view = SchemaViewport.fit(
        rect: const Rect.fromLTWH(20, 0, 300, 30),
        spanMm: 1500,
      );
      expect(view.scale, 0.2);
      expect(view.x(0), 20);
      expect(view.x(1500), 320);
      expect(view.x(750), 170);
      expect(view.spanMm, 1500);
    });

    test('décalée, elle cadre la fin de la pièce', () {
      const view = SchemaViewport(
        rect: Rect.fromLTWH(20, 0, 300, 30),
        originMm: 1200,
        scale: 0.5,
      );
      expect(view.x(1200), 20);
      expect(view.x(1800), 320);
      expect(view.spanMm, 600);
    });

    test('une étendue nulle ne divise par rien', () {
      final view = SchemaViewport.fit(
        rect: const Rect.fromLTWH(0, 0, 300, 30),
        spanMm: 0,
      );
      expect(view.scale, 0);
      expect(view.spanMm, 0);
    });
  });

  test('une cote trop étroite se tait, sauf si elle est serrée', () {
    expect(
      drawHDimension(fresh(), x1: 100, x2: 106, y: 50, label: '40'),
      isFalse,
    );
    expect(
      drawHDimension(
        fresh(),
        x1: 100,
        x2: 106,
        y: 50,
        label: '40',
        tight: true,
      ),
      isTrue,
    );
  });

  test('une cote assez large garde son chiffre, serrée ou non', () {
    for (final tight in [false, true]) {
      expect(
        drawHDimension(
          fresh(),
          x1: 100,
          x2: 200,
          y: 50,
          label: '407,5',
          tight: tight,
        ),
        isTrue,
        reason: 'tight: $tight',
      );
    }
  });

  test('une cote sans chiffre ne prétend pas en avoir posé un', () {
    expect(
      drawHDimension(fresh(), x1: 100, x2: 200, y: 50, tight: true),
      isFalse,
    );
  });
}
