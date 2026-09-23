import 'dart:ui';

import 'package:fabrique/core/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// Les primitives de cotation portent deux choses qu'aucun autre test ne peut
/// attraper : le passage des millimètres à la feuille, et le fait qu'une cote
/// trop étroite pour son chiffre le dise au lieu de le taire.
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

    test('deux fenêtres d’un même schéma gardent chacune son échelle', () {
      final overview = SchemaViewport.fit(
        rect: const Rect.fromLTWH(20, 0, 300, 30),
        spanMm: 1800,
      );
      final detail = SchemaViewport(
        rect: const Rect.fromLTWH(20, 50, 120, 40),
        originMm: 0,
        scale: overview.scale * 1.5,
      );
      // Le même élément de 18 mm, une fois et demie plus large dans le détail.
      expect(
        detail.x(18) - detail.x(0),
        closeTo((overview.x(18) - overview.x(0)) * 1.5, 1e-9),
      );
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

  test('un chiffre sorti va du côté demandé', () {
    for (final side in [1.0, -1.0]) {
      expect(
        drawHDimension(
          fresh(),
          x1: 100,
          x2: 106,
          y: 50,
          label: '40',
          tight: true,
          labelSide: side,
        ),
        isTrue,
        reason: 'labelSide: $side',
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
