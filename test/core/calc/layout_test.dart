import 'package:fabrique/core/calc/calc_exception.dart';
import 'package:fabrique/core/calc/layout.dart';
import 'package:fabrique/core/models/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('computeLayout — comptages', () {
    test('pile-poil : 10 pleines, aucune coupe, 0 % de perte', () {
      final r = computeLayout(
        const LayoutInput(
          surfaceX: 1000,
          surfaceY: 1000,
          elementX: 100,
          elementY: 1000,
          offset: JointOffset.straight,
        ),
      );

      expect(r.fullCount, 10);
      expect(r.cutCount, 0);
      expect(r.totalCount, 10);
      expect(r.coveredArea, closeTo(1000 * 1000, 1e-6));
      expect(r.surfaceArea, closeTo(1000 * 1000, 1e-6));
      expect(r.wastePercent, closeTo(0, 1e-9));
    });

    test('coupe en X : 10 pleines + 1 coupe de 50, perte ≈ 4.5 %', () {
      final r = computeLayout(
        const LayoutInput(
          surfaceX: 1050,
          surfaceY: 1000,
          elementX: 100,
          elementY: 1000,
          offset: JointOffset.straight,
        ),
      );

      expect(r.fullCount, 10);
      expect(r.cutCount, 1);
      expect(r.totalCount, 11);

      final cut = r.elements.singleWhere((e) => e.isCut);
      expect(cut.w, closeTo(50, 1e-9));
      expect(cut.x, closeTo(1000, 1e-9));

      // 11 éléments consommés pour 1 050 000 mm² couverts.
      expect(r.coveredArea, closeTo(1050 * 1000, 1e-6));
      expect(r.wastePercent, closeTo(50000 / 1100000 * 100, 1e-6));
    });

    test('refente en Y : 2 rangées pleines + 1 rabotée marquée coupe', () {
      final r = computeLayout(
        const LayoutInput(
          surfaceX: 1000,
          surfaceY: 250,
          elementX: 1000,
          elementY: 100,
          offset: JointOffset.straight,
        ),
      );

      expect(r.elements, hasLength(3));
      expect(r.fullCount, 2);
      expect(r.cutCount, 1);

      final last = r.elements.last;
      expect(last.isCut, isTrue);
      expect(last.h, closeTo(50, 1e-9));
      expect(last.y, closeTo(200, 1e-9));
    });

    test('décalage ½ : 2 coupes sur la rangée décalée', () {
      final r = computeLayout(
        const LayoutInput(
          surfaceX: 1000,
          surfaceY: 200,
          elementX: 100,
          elementY: 100,
        ),
      );

      final row0 = r.elements.where((e) => e.y == 0).toList();
      final row1 = r.elements.where((e) => e.y == 100).toList();

      expect(row0.where((e) => e.isCut), isEmpty);
      expect(row1.where((e) => e.isCut), hasLength(2));

      // Demi-élément à chaque bout de la rangée décalée.
      expect(row1.first.w, closeTo(50, 1e-9));
      expect(row1.first.x, closeTo(0, 1e-9));
      expect(row1.last.w, closeTo(50, 1e-9));

      expect(r.cutCount, 2);
      expect(r.totalCount, 21);
      // Surface entièrement couverte, mais 21 éléments consommés : la perte v1
      // est volontairement pessimiste (pas de réemploi des chutes).
      expect(r.coveredArea, closeTo(r.surfaceArea, 1e-6));
      expect(r.wastePercent, closeTo(10000 / 210000 * 100, 1e-6));
    });

    test('décalage ⅓ : le motif se répète toutes les 3 rangées', () {
      final r = computeLayout(
        const LayoutInput(
          surfaceX: 1000,
          surfaceY: 400,
          elementX: 100,
          elementY: 100,
          offset: JointOffset.third,
        ),
      );

      final row0 = r.elements.where((e) => e.y == 0).toList();
      final row3 = r.elements.where((e) => e.y == 300).toList();

      // La rangée 3 revient au départ de la rangée 0 : que des pleines.
      expect(row0.where((e) => e.isCut), isEmpty);
      expect(row3.where((e) => e.isCut), isEmpty);
      expect(row3, hasLength(row0.length));
    });
  });

  group('computeLayout — options', () {
    test('le décalage pivote avec l’inversion', () {
      // Élément allongé posé verticalement : les rangées deviennent des
      // colonnes, et le décalage joue le long des lames — donc en Y.
      final r = computeLayout(
        const LayoutInput(
          surfaceX: 400,
          surfaceY: 1000,
          elementX: 500,
          elementY: 100,
          flip: true,
        ),
      );

      // Colonnes de 100 de large empilées selon X.
      final columns = <double, List<PlacedElement>>{};
      for (final e in r.elements) {
        columns.putIfAbsent(e.x, () => []).add(e);
      }
      final xs = columns.keys.toList()..sort();
      expect(xs, [0, 100, 200, 300]);

      // Chaque élément est debout : 100 de large, 500 de haut.
      expect(columns[0.0]!.first.w, closeTo(100, 1e-9));
      expect(columns[0.0]!.first.h, closeTo(500, 1e-9));

      // Le décalage d'un demi-élément (250) sépare deux colonnes voisines.
      final first = columns[0.0]!.map((e) => e.y).toList()..sort();
      final second = columns[100.0]!.map((e) => e.y).toList()..sort();
      expect(first, [0, 500]);
      expect(second, [0, 250, 750]);
    });

    test('inversion + décalage droit : les colonnes restent alignées', () {
      final r = computeLayout(
        const LayoutInput(
          surfaceX: 400,
          surfaceY: 1000,
          elementX: 500,
          elementY: 100,
          flip: true,
          offset: JointOffset.straight,
        ),
      );
      final ys = r.elements.map((e) => e.y).toSet().toList()..sort();
      expect(ys, [0, 500]);
      expect(r.cutCount, 0);
    });

    test(
      'inverser deux fois une surface carrée revient au motif de départ',
      () {
        // Sur une surface carrée et un élément carré, la rotation d'un quart de
        // tour doit rendre exactement les mêmes comptes.
        const base = LayoutInput(
          surfaceX: 900,
          surfaceY: 900,
          elementX: 300,
          elementY: 150,
        );
        final droit = computeLayout(base);
        final pivote = computeLayout(base.copyWith(flip: true));

        expect(pivote.fullCount, droit.fullCount);
        expect(pivote.cutCount, droit.cutCount);
        expect(pivote.coveredArea, closeTo(droit.coveredArea, 1e-6));
        expect(pivote.wastePercent, closeTo(droit.wastePercent, 1e-9));

        // Mêmes rectangles, à la transposition près.
        final droitSet = droit.elements
            .map((e) => '${e.x},${e.y},${e.w},${e.h}')
            .toSet();
        final pivoteSet = pivote.elements
            .map((e) => '${e.y},${e.x},${e.h},${e.w}')
            .toSet();
        expect(pivoteSet, droitSet);
      },
    );

    test('flip échange elementX et elementY', () {
      final flipped = computeLayout(
        const LayoutInput(
          surfaceX: 1000,
          surfaceY: 1000,
          elementX: 1000,
          elementY: 100,
          flip: true,
          offset: JointOffset.straight,
        ),
      );
      final reference = computeLayout(
        const LayoutInput(
          surfaceX: 1000,
          surfaceY: 1000,
          elementX: 100,
          elementY: 1000,
          offset: JointOffset.straight,
        ),
      );

      expect(flipped.fullCount, reference.fullCount);
      expect(flipped.cutCount, reference.cutCount);
      expect(flipped.coveredArea, closeTo(reference.coveredArea, 1e-6));
    });

    test('gapX réduit les éléments pleins et sort les jeux de coveredArea', () {
      const base = LayoutInput(
        surfaceX: 1000,
        surfaceY: 100,
        elementX: 100,
        elementY: 100,
        offset: JointOffset.straight,
      );
      final sansJeu = computeLayout(base);
      final avecJeu = computeLayout(base.copyWith(gapX: 5));

      expect(sansJeu.fullCount, 10);
      expect(avecJeu.fullCount, lessThan(sansJeu.fullCount));
      expect(avecJeu.coveredArea, lessThan(avecJeu.surfaceArea));
      expect(avecJeu.coveredArea, closeTo(9 * 100 * 100 + 55 * 100, 1e-6));
    });

    test('gapY espace les rangées', () {
      const base = LayoutInput(
        surfaceX: 100,
        surfaceY: 1000,
        elementX: 100,
        elementY: 100,
        offset: JointOffset.straight,
      );
      final sansJeu = computeLayout(base);
      final avecJeu = computeLayout(base.copyWith(gapY: 100));

      expect(sansJeu.totalCount, 10);
      expect(avecJeu.totalCount, 5);
      expect(avecJeu.cutCount, 0);
    });

    test('un jeu qui ne tombe pas juste rabote la dernière rangée', () {
      final r = computeLayout(
        const LayoutInput(
          surfaceX: 100,
          surfaceY: 1000,
          elementX: 100,
          elementY: 100,
          gapY: 10,
          offset: JointOffset.straight,
        ),
      );

      expect(r.fullCount, 9);
      expect(r.cutCount, 1);
      expect(r.elements.last.h, closeTo(10, 1e-9));
    });
  });

  group('computeLayout — invariants', () {
    test('aucun élément ne sort de la surface', () {
      final r = computeLayout(
        const LayoutInput(
          surfaceX: 1337,
          surfaceY: 842,
          elementX: 123,
          elementY: 77,
          gapX: 3,
          gapY: 2,
          offset: JointOffset.third,
        ),
      );

      expect(r.elements, isNotEmpty);
      for (final e in r.elements) {
        expect(e.x, greaterThanOrEqualTo(-1e-9));
        expect(e.y, greaterThanOrEqualTo(-1e-9));
        expect(e.x + e.w, lessThanOrEqualTo(1337 + 1e-9));
        expect(e.y + e.h, lessThanOrEqualTo(842 + 1e-9));
        expect(e.w, greaterThan(0));
        expect(e.h, greaterThan(0));
      }
      expect(r.totalCount, r.fullCount + r.cutCount);
      expect(r.totalCount, r.elements.length);
      expect(r.coveredArea, lessThanOrEqualTo(r.surfaceArea + 1e-6));
      expect(r.wastePercent, inInclusiveRange(0, 100));
    });
  });

  group('computeLayout — entrées invalides', () {
    LayoutInput input({
      double surfaceX = 1000,
      double surfaceY = 1000,
      double elementX = 100,
      double elementY = 100,
      double gapX = 0,
      double gapY = 0,
    }) => LayoutInput(
      surfaceX: surfaceX,
      surfaceY: surfaceY,
      elementX: elementX,
      elementY: elementY,
      gapX: gapX,
      gapY: gapY,
    );

    test('dimension nulle ou négative → CalcException', () {
      expect(
        () => computeLayout(input(elementX: 0)),
        throwsA(isA<CalcException>()),
      );
      expect(
        () => computeLayout(input(elementY: -10)),
        throwsA(isA<CalcException>()),
      );
      expect(
        () => computeLayout(input(surfaceX: -1)),
        throwsA(isA<CalcException>()),
      );
      expect(
        () => computeLayout(input(surfaceY: 0)),
        throwsA(isA<CalcException>()),
      );
    });

    test('jeu négatif → CalcException', () {
      expect(
        () => computeLayout(input(gapX: -1)),
        throwsA(isA<CalcException>()),
      );
      expect(
        () => computeLayout(input(gapY: -1)),
        throwsA(isA<CalcException>()),
      );
    });

    test('élément plus grand que la surface → CalcException', () {
      expect(
        () => computeLayout(input(elementX: 1200)),
        throwsA(isA<CalcException>()),
      );
      expect(
        () => computeLayout(input(elementY: 1200)),
        throwsA(isA<CalcException>()),
      );
    });

    test('élément exactement à la dimension de la surface → accepté', () {
      final r = computeLayout(input(elementX: 1000, elementY: 1000));
      expect(r.totalCount, 1);
      expect(r.cutCount, 0);
    });
  });
}
