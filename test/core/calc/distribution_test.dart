import 'package:fabrique/core/calc/calc_exception.dart';
import 'package:fabrique/core/calc/distribution.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Des points sans épaisseur, bordés de jeux.
  DistributionResult points(double length, int count) =>
      computeDistribution(DistributionInput(length: length, count: count));

  void expectPositions(List<double> actual, List<double> expected) {
    expect(actual, hasLength(expected.length));
    for (var i = 0; i < expected.length; i++) {
      expect(actual[i], closeTo(expected[i], 1e-9), reason: 'position $i');
    }
  }

  group('computeDistribution — points purs (largeur 0)', () {
    test('3 points sur 100 → 25 / 50 / 75, jamais les extrémités', () {
      final r = points(100, 3);
      expect(r.spacing, closeTo(25, 1e-9));
      expectPositions(r.positions, [25, 50, 75]);
    });

    test('0 point → aucune position, entraxe = longueur', () {
      final r = points(100, 0);
      expect(r.spacing, closeTo(100, 1e-9));
      expect(r.positions, isEmpty);
    });

    test('N points → N+1 espaces', () {
      for (var n = 0; n <= 10; n++) {
        final r = points(1000, n);
        expect(r.positions, hasLength(n));
        expect(r.spacing * (n + 1), closeTo(1000, 1e-9), reason: '$n points');
      }
    });

    test('positions strictement croissantes et dans la longueur', () {
      final r = points(1234.5, 7);
      expect(r.positions.first, greaterThan(0));
      expect(r.positions.last, lessThan(1234.5));
      for (var i = 1; i < r.positions.length; i++) {
        expect(r.positions[i], greaterThan(r.positions[i - 1]));
      }
    });

    test('sans épaisseur, entraxe et jeu se confondent', () {
      final r = points(1000, 4);
      expect(r.pitch, closeTo(r.spacing, 1e-9));
      expectPositions(r.centers, r.positions);
    });
  });

  group('computeDistribution — éléments de largeur', () {
    test('2 éléments de 20 sur 100, bordés de jeux', () {
      final r = computeDistribution(
        const DistributionInput(length: 100, count: 2, elementWidth: 20),
      );
      // 100 − 40 d'éléments = 60, répartis en 3 jeux.
      expect(r.spacing, closeTo(20, 1e-9));
      expect(r.pitch, closeTo(40, 1e-9));
      expectPositions(r.positions, [20, 60]);
      expectPositions(r.centers, [30, 70]);
    });

    test("l'entraxe vaut toujours jeu + largeur", () {
      final r = computeDistribution(
        const DistributionInput(length: 2000, count: 15, elementWidth: 21),
      );
      expect(r.spacing, closeTo(1685 / 16, 1e-9));
      expect(r.pitch, closeTo(1685 / 16 + 21, 1e-9));
      expect(r.count, 15);
      expect(r.span, closeTo(2000, 1e-9));
    });
  });

  group('computeDistribution — bords', () {
    const length = 100.0;
    const width = 10.0;

    test('élément / élément → N−1 jeux, collé aux deux bords', () {
      final r = computeDistribution(
        const DistributionInput(
          length: length,
          count: 3,
          elementWidth: width,
          startEdge: DistributionEdge.element,
          endEdge: DistributionEdge.element,
        ),
      );
      expect(r.spacing, closeTo(35, 1e-9));
      expectPositions(r.positions, [0, 45, 90]);
      expect(r.positions.last + width, closeTo(length, 1e-9));
    });

    test('le nombre de jeux suit les bords', () {
      DistributionResult withEdges(
        DistributionEdge start,
        DistributionEdge end,
      ) => computeDistribution(
        DistributionInput(
          length: 1000,
          count: 4,
          elementWidth: 10,
          startEdge: start,
          endEdge: end,
        ),
      );
      const gap = DistributionEdge.gap;
      const element = DistributionEdge.element;

      expect(withEdges(gap, gap).gapCount, 5);
      expect(withEdges(element, element).gapCount, 3);
      expect(withEdges(element, gap).gapCount, 4);
      expect(withEdges(gap, element).gapCount, 4);

      expect(minDistributionCount(gap, gap), 0);
      expect(minDistributionCount(element, gap), 1);
      expect(minDistributionCount(element, element), 2);
    });

    test('quels que soient les bords, la rangée remplit exactement', () {
      for (final start in DistributionEdge.values) {
        for (final end in DistributionEdge.values) {
          final r = computeDistribution(
            DistributionInput(
              length: 1234.5,
              count: 6,
              elementWidth: 37.5,
              startEdge: start,
              endEdge: end,
              startOffset: 12,
              endOffset: 8,
            ),
          );
          final reason = '$start / $end';

          final head = start == DistributionEdge.element ? 0 : r.spacing;
          expect(r.positions.first, closeTo(12 + head, 1e-9), reason: reason);

          final tail = end == DistributionEdge.element ? 0 : r.spacing;
          expect(
            r.positions.last + 37.5 + tail,
            closeTo(1234.5 - 8, 1e-9),
            reason: reason,
          );
          expect(r.spacing, greaterThan(0), reason: reason);
        }
      }
    });
  });

  group('computeDistribution — marges', () {
    test('marges asymétriques : tout glisse vers le départ imposé', () {
      final r = computeDistribution(
        const DistributionInput(
          length: 1000,
          count: 3,
          startOffset: 200,
          endOffset: 0,
        ),
      );
      expect(r.span, closeTo(800, 1e-9));
      expect(r.spacing, closeTo(200, 1e-9));
      expectPositions(r.positions, [400, 600, 800]);
    });
  });

  group('computeDistribution — erreurs', () {
    void expectMessage(void Function() body, Matcher message) {
      expect(
        body,
        throwsA(
          isA<CalcException>().having((e) => e.message, 'message', message),
        ),
      );
    }

    test('longueur invalide', () {
      expect(() => points(0, 3), throwsA(isA<CalcException>()));
      expect(() => points(-100, 3), throwsA(isA<CalcException>()));
      expect(() => points(double.nan, 3), throwsA(isA<CalcException>()));
    });

    test('nombre négatif', () {
      expect(() => points(100, -1), throwsA(isA<CalcException>()));
    });

    test('largeur ou marge négative', () {
      expect(
        () => computeDistribution(
          const DistributionInput(length: 100, count: 2, elementWidth: -1),
        ),
        throwsA(isA<CalcException>()),
      );
      expect(
        () => computeDistribution(
          const DistributionInput(length: 100, count: 2, startOffset: -1),
        ),
        throwsA(isA<CalcException>()),
      );
    });

    test('les marges mangent toute la largeur', () {
      expectMessage(
        () => computeDistribution(
          const DistributionInput(
            length: 100,
            count: 2,
            startOffset: 60,
            endOffset: 40,
          ),
        ),
        contains('marges'),
      );
    });

    test('un seul élément ne peut pas border les deux côtés', () {
      expectMessage(
        () => computeDistribution(
          const DistributionInput(
            length: 100,
            count: 1,
            elementWidth: 10,
            startEdge: DistributionEdge.element,
            endEdge: DistributionEdge.element,
          ),
        ),
        contains('au moins 2'),
      );
    });

    test('une rangée bordée d’un élément en compte au moins un', () {
      expectMessage(
        () => computeDistribution(
          const DistributionInput(
            length: 100,
            count: 0,
            elementWidth: 10,
            startEdge: DistributionEdge.element,
          ),
        ),
        contains('au moins 1'),
      );
    });

    test('ça ne rentre pas : le message donne les deux cotes', () {
      expectMessage(
        () => computeDistribution(
          const DistributionInput(length: 100, count: 11, elementWidth: 10),
        ),
        allOf(contains('110'), contains('100')),
      );
    });

    test('nombre d’éléments déraisonnable', () {
      expectMessage(
        () => computeDistribution(
          const DistributionInput(
            length: 100000,
            count: kMaxDistributionCount + 1,
          ),
        ),
        contains('$kMaxDistributionCount'),
      );
    });

    test('le cas limite pile à la longueur passe', () {
      final r = computeDistribution(
        const DistributionInput(
          length: 100,
          count: 10,
          elementWidth: 10,
          startEdge: DistributionEdge.element,
          endEdge: DistributionEdge.element,
        ),
      );
      expect(r.spacing, closeTo(0, 1e-9));
      expect(r.positions.last + 10, closeTo(100, 1e-9));
    });
  });

  group('computeDistributionForSpacing', () {
    void expectTargetMessage(void Function() body, Matcher message) {
      expect(
        body,
        throwsA(
          isA<CalcException>().having((e) => e.message, 'message', message),
        ),
      );
    }

    test('cible atteinte pile : une seule réponse', () {
      final r = computeDistributionForSpacing(
        const DistributionTargetInput(length: 100, targetSpacing: 25),
      );
      expect(r.best.count, 3);
      expect(r.best.spacing, closeTo(25, 1e-9));
      expect(r.other, isNull);
      expectPositions(r.best.positions, [25, 50, 75]);
    });

    test('cible atteinte pile avec largeur et bords élément', () {
      final r = computeDistributionForSpacing(
        const DistributionTargetInput(
          length: 100,
          targetSpacing: 35,
          elementWidth: 10,
          startEdge: DistributionEdge.element,
          endEdge: DistributionEdge.element,
        ),
      );
      expect(r.best.count, 3);
      expect(r.best.spacing, closeTo(35, 1e-9));
      expect(r.other, isNull);
    });

    test('cible entre deux entiers : les deux bornes sont rendues', () {
      final r = computeDistributionForSpacing(
        const DistributionTargetInput(
          length: 2000,
          targetSpacing: 100,
          elementWidth: 21,
        ),
      );
      // 15 → 105,3 (plus lâche) · 16 → 97,9 (plus serré) : 16 est plus proche.
      expect(r.best.count, 16);
      expect(r.best.spacing, closeTo(1664 / 17, 1e-9));
      expect(r.other, isNotNull);
      expect(r.other!.count, 15);
      expect(r.other!.spacing, closeTo(1685 / 16, 1e-9));
    });

    test('un écart plafond se lit sur la borne serrée', () {
      // Barreaudage : 110 mm maximum entre deux barreaux de 20.
      final r = computeDistributionForSpacing(
        const DistributionTargetInput(
          length: 1000,
          targetSpacing: 110,
          elementWidth: 20,
        ),
      );
      final tightest = [
        r.best,
        ?r.other,
      ].reduce((a, b) => a.spacing <= b.spacing ? a : b);
      expect(tightest.spacing, lessThanOrEqualTo(110));
      expect(tightest.count, 7);
      expect(tightest.spacing, closeTo(107.5, 1e-9));
    });

    test('les deux bornes encadrent la cible, la meilleure au plus près', () {
      for (final target in [10.0, 33.0, 57.5, 120.0, 250.0]) {
        final r = computeDistributionForSpacing(
          DistributionTargetInput(
            length: 1500,
            targetSpacing: target,
            elementWidth: 18,
          ),
        );
        final other = r.other;
        if (other == null) continue;
        final reason = 'cible $target';
        expect(
          (r.best.spacing - target).abs(),
          lessThanOrEqualTo((other.spacing - target).abs()),
          reason: reason,
        );
        final spacings = [r.best.spacing, other.spacing]..sort();
        expect(spacings.first, lessThanOrEqualTo(target), reason: reason);
        expect(spacings.last, greaterThanOrEqualTo(target), reason: reason);
      }
    });

    test('les marges valent aussi dans ce mode', () {
      final r = computeDistributionForSpacing(
        const DistributionTargetInput(
          length: 1000,
          targetSpacing: 200,
          startOffset: 100,
          endOffset: 100,
        ),
      );
      expect(r.best.span, closeTo(800, 1e-9));
      expect(r.best.count, 3);
      expect(r.best.spacing, closeTo(200, 1e-9));
      expectPositions(r.best.positions, [300, 500, 700]);
    });

    test('écart nul sans largeur (indéterminé) ou négatif', () {
      expect(
        () => computeDistributionForSpacing(
          const DistributionTargetInput(length: 1000, targetSpacing: 0),
        ),
        throwsA(isA<CalcException>()),
      );
      expect(
        () => computeDistributionForSpacing(
          const DistributionTargetInput(length: 1000, targetSpacing: -10),
        ),
        throwsA(isA<CalcException>()),
      );
    });

    test('écart minuscule : refus net plutôt qu’un million de positions', () {
      expect(
        () => computeDistributionForSpacing(
          const DistributionTargetInput(length: 1000, targetSpacing: 0.001),
        ),
        throwsA(
          isA<CalcException>().having(
            (e) => e.message,
            'message',
            contains('trop petit'),
          ),
        ),
      );
    });

    test(
      'cible inatteignable : on rend le plus proche possible, sans lever',
      () {
        // 500 mm d'écart ne tiennent pas dans 100 mm. Le minimum imposé par les
        // bords (2 éléments) donne 80 : c'est la réponse la plus proche, et la
        // rendre vaut mieux qu'un tiret.
        final r = computeDistributionForSpacing(
          const DistributionTargetInput(
            length: 100,
            targetSpacing: 500,
            elementWidth: 10,
            startEdge: DistributionEdge.element,
            endEdge: DistributionEdge.element,
          ),
        );
        expect(r.best.count, 2);
        expect(r.best.spacing, closeTo(80, 1e-9));
        expect(r.other, isNull);
      },
    );

    test('aucune borne réalisable : erreur explicite', () {
      // Bords élément/élément → 2 éléments minimum, soit 120 mm dans 100.
      expectTargetMessage(
        () => computeDistributionForSpacing(
          const DistributionTargetInput(
            length: 100,
            targetSpacing: 10,
            elementWidth: 60,
            startEdge: DistributionEdge.element,
            endEdge: DistributionEdge.element,
          ),
        ),
        contains('Aucune répartition'),
      );
    });
  });
}
