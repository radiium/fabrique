import 'package:fabrique/core/calc/calc_exception.dart';
import 'package:fabrique/core/calc/drawers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Un caisson de cuisine de 600 : les défauts de l'écran.
  const base = DrawersInput(
    openingWidth: 562,
    openingHeight: 720,
    openingDepth: 540,
    drawerCount: 3,
  );

  Matcher near(double value) => closeTo(value, 1e-3);

  CutPiece piece(DrawersResult r, DrawerPart part, {double? width}) =>
      r.cutList.firstWhere(
        (p) =>
            p.part == part && (width == null || (p.width - width).abs() < 1e-3),
      );

  void expectRefused(DrawersInput input, String fragment) => expect(
    () => computeDrawers(input),
    throwsA(
      isA<CalcException>().having(
        (e) => e.message,
        'message',
        contains(fragment),
      ),
    ),
  );

  group('computeDrawers — cas de référence', () {
    test('trois tiroirs à billes en applique', () {
      final r = computeDrawers(base);

      // 562 + 2 × 19 de recouvrement, moins un jeu partagé avec les voisins.
      expect(r.frontWidth, near(597));
      // (720 + 2 × 19 − 3 × 3) / 3
      expect(r.fronts.map((f) => f.height), everyElement(near(249.667)));
      expect(r.fronts.first.bottom + r.fronts.first.height, near(737.5));
      expect(r.fronts.last.bottom, near(-17.5));

      expect(r.sideClearance, 12.7);
      expect(r.boxWidth, near(536.6));
      expect(r.slideLength, 500);
      expect(r.isSlideLengthAuto, isTrue);
      expect(r.boxLength, 500);
      expect(r.boxSetback, 0);
      expect(r.bottomLift, kGrooveLift);

      // Le tiroir du milieu a un jeu entier au-dessus et au-dessous, ceux des
      // bouts perdent le recouvrement du caisson.
      expect(r.boxHeights[0], near(203.667));
      expect(r.boxHeights[1], near(222.667));
      expect(r.boxHeights[2], near(203.667));
      expect(r.boxBottoms[2], near(10));
      expect(r.slideAxes[2], near(10 + 203.667 / 2));
    });

    test('la fiche de débit regroupe les pièces identiques', () {
      final r = computeDrawers(base);

      final sides = r.cutList.where((p) => p.part == DrawerPart.side);
      expect(sides.map((p) => p.quantity), [4, 2]);
      expect(piece(r, DrawerPart.side).length, 500);
      expect(piece(r, DrawerPart.front).length, near(506.6));
      expect(piece(r, DrawerPart.back, width: 222.667).quantity, 1);

      final bottom = piece(r, DrawerPart.bottom);
      expect(bottom.quantity, 3);
      // Cotes intérieures, plus 6 de rainure de chaque côté.
      expect(bottom.length, near(518.6));
      expect(bottom.width, near(482));
      expect(bottom.thickness, 8);

      final front = piece(r, DrawerPart.drawerFront);
      expect(front.quantity, 3);
      expect(front.length, near(597));
      expect(front.thickness, 19);
    });

    test('sous tiroir : largeur intérieure = ouverture − 42 avec des côtés '
        'de 16, fond en retrait sous le dos', () {
      final r = computeDrawers(
        base.copyWith(slide: SlideKind.undermount, sideThickness: 16),
      );

      expect(r.boxWidth - 2 * 16, near(562 - 42));
      expect(r.slideLength, 500);
      expect(r.boxLength, 490);
      expect(r.bottomLift, 13);
      expect(r.slideAxes, r.boxBottoms);

      final side = piece(r, DrawerPart.side);
      final back = piece(r, DrawerPart.back, width: side.width - 13 - 8);
      expect(back.quantity, 2);
      final bottom = piece(r, DrawerPart.bottom);
      expect(bottom.length, near(520));
      expect(bottom.width, near(490 - 16));
    });

    test('bois sur bois : pas de glissière, la caisse prend la profondeur', () {
      final r = computeDrawers(
        base.copyWith(slide: SlideKind.woodOnWood, slideLength: 450),
      );

      expect(r.slideLength, isNull);
      expect(r.boxLength, 540);
      expect(r.boxBottoms.last, 0);
      expect(r.slideAxes, r.boxBottoms);
    });

    test('façade encastrée : jeu tout autour, la caisse recule', () {
      final r = computeDrawers(base.copyWith(frontMount: FrontMount.inset));

      expect(r.frontWidth, near(556));
      // (720 − 4 × 3) / 3
      expect(r.fronts.map((f) => f.height), everyElement(near(236)));
      expect(r.fronts.last.bottom, near(3));
      expect(r.boxSetback, 19);
      // 540 − 19 de façade : 521 utiles, la glissière de 500.
      expect(r.slideLength, 500);
    });

    test('devant et dos recouvrants : les côtés passent entre eux', () {
      final r = computeDrawers(
        base.copyWith(boxJoint: BoxJoint.frontBackOverlap),
      );

      expect(piece(r, DrawerPart.side).length, 470);
      expect(piece(r, DrawerPart.front).length, near(536.6));
    });

    test('fond sous la caisse : les parois perdent son épaisseur', () {
      final r = computeDrawers(
        base.copyWith(bottomMount: BottomMount.underneath),
      );

      expect(r.bottomLift, 0);
      expect(piece(r, DrawerPart.side).width, near(203.667 - 8));
      final bottom = piece(r, DrawerPart.bottom);
      expect(bottom.length, near(536.6));
      expect(bottom.width, 500);
    });

    test('fond entre les côtés : les cotes intérieures', () {
      final r = computeDrawers(base.copyWith(bottomMount: BottomMount.between));

      expect(r.bottomLift, 0);
      final bottom = piece(r, DrawerPart.bottom);
      expect(bottom.length, near(506.6));
      expect(bottom.width, 470);
    });
  });

  group('computeDrawers — hauteurs et glissière', () {
    test('une hauteur fixée, les autres se partagent le reste', () {
      final r = computeDrawers(
        base.copyWith(fixedFrontHeights: const [300, null, null]),
      );

      expect(r.fronts[0].height, 300);
      expect(r.fronts[0].isFixed, isTrue);
      expect(r.fronts[1].height, near(224.5));
      expect(r.fronts[2].isFixed, isFalse);
    });

    test('des hauteurs toutes fixées doivent faire la hauteur', () {
      final r = computeDrawers(
        base.copyWith(fixedFrontHeights: const [300, 300, 149]),
      );
      expect(r.fronts.last.bottom, near(-17.5));

      expectRefused(
        base.copyWith(fixedFrontHeights: const [300, 300, 300]),
        'Les hauteurs fixées font 900 mm pour 749 mm',
      );
    });

    test('une longueur imposée remplace le choix automatique', () {
      final r = computeDrawers(base.copyWith(slideLength: 450));

      expect(r.slideLength, 450);
      expect(r.isSlideLengthAuto, isFalse);
      expect(r.boxLength, 450);
    });

    test('la réduction de longueur personnalisée raccourcit la caisse', () {
      final r = computeDrawers(
        base.copyWith(
          slide: SlideKind.custom,
          customSideClearance: 13,
          customLengthReduction: 5,
        ),
      );

      expect(r.boxWidth, 536);
      expect(r.boxLength, 495);
    });
  });

  group('computeDrawers — coupes', () {
    test('les façades se centrent sur l’ouverture', () {
      expect(computeDrawers(base).frontLeft, near(-17.5));
      expect(
        computeDrawers(base.copyWith(frontMount: FrontMount.inset)).frontLeft,
        near(3),
      );
    });

    test('une glissière latérale se centre sur son axe, dans le jeu', () {
      final r = computeDrawers(base);
      final slide = r.faceSections.first.slides.first;

      expect((slide.y0 + slide.y1) / 2, near(r.slideAxes.first));
      expect(slide.x0, 0);
      expect(slide.x1, near(r.sideClearance));
    });

    test(
      'sous tiroir : glissières dans le retrait, cachées vues de dessus',
      () {
        final r = computeDrawers(base.copyWith(slide: SlideKind.undermount));
        final face = r.faceSections.first;

        expect(face.slides.first.y0, near(r.boxBottoms.first));
        expect(face.slides.first.y1, near(face.bottom.y0));
        expect(r.topSection.slides, isEmpty);
      },
    );

    test('bois sur bois : aucune glissière à dessiner', () {
      final r = computeDrawers(base.copyWith(slide: SlideKind.woodOnWood));

      expect(r.faceSections.expand((s) => s.slides), isEmpty);
      expect(r.topSection.slides, isEmpty);
    });

    test('la coupe de dessus suit l’assemblage', () {
      double longestWall(BoxJoint joint) {
        final walls = computeDrawers(base.copyWith(boxJoint: joint))
            .topSection
            .walls;
        return walls.first.y1 - walls.first.y0;
      }

      // Le premier mur est un côté : pleine longueur, ou entre devant et dos.
      expect(longestWall(BoxJoint.sidesOverlap), 500);
      expect(longestWall(BoxJoint.frontBackOverlap), 470);
    });

    test('la façade en applique est devant le chant, encastrée derrière', () {
      final overlay = computeDrawers(base).topSection.front;
      final inset = computeDrawers(base.copyWith(frontMount: FrontMount.inset))
          .topSection
          .front;

      expect(overlay.y1, 0);
      expect(inset.y0, 0);
    });

    test('le fond de la coupe de face suit sa pose', () {
      final r = computeDrawers(base);
      final face = r.faceSections.last;
      // En rainure : il entre de 6 dans chaque côté, à 10 du bas.
      expect(face.sides.first.x1 - face.bottom.x0, near(6));
      expect(face.bottom.y0, near(r.boxBottoms.last + kGrooveLift));
    });
  });

  group('computeDrawers — invariants', () {
    final inputs = [
      for (final mount in FrontMount.values)
        for (final slide in SlideKind.values)
          for (final bottom in BottomMount.values)
            for (final count in [1, 2, 5])
              base.copyWith(
                frontMount: mount,
                slide: slide,
                bottomMount: bottom,
                drawerCount: count,
              ),
    ];

    test('les façades et leurs jeux couvrent la colonne', () {
      for (final input in inputs) {
        final r = computeDrawers(input);
        for (var i = 1; i < r.fronts.length; i++) {
          expect(
            r.fronts[i - 1].bottom - r.fronts[i].bottom - r.fronts[i].height,
            near(input.frontGap),
            reason: '$input',
          );
        }
      }
    });

    test('chaque caisse tient dans l’ouverture, sous la précédente', () {
      for (final input in inputs) {
        final r = computeDrawers(input);
        var ceiling = input.openingHeight;
        for (var i = 0; i < r.boxBottoms.length; i++) {
          expect(r.boxBottoms[i], greaterThanOrEqualTo(0), reason: '$input');
          expect(
            r.boxBottoms[i] + r.boxHeights[i],
            lessThanOrEqualTo(ceiling + 1e-9),
            reason: '$input',
          );
          ceiling = r.boxBottoms[i];
        }
      }
    });

    test('deux côtés, un devant, un dos, un fond et une façade par tiroir', () {
      for (final input in inputs) {
        final r = computeDrawers(input);
        int count(DrawerPart part) => r.cutList
            .where((p) => p.part == part)
            .fold(0, (sum, p) => sum + p.quantity);
        expect(count(DrawerPart.side), 2 * input.drawerCount);
        for (final part in [
          DrawerPart.front,
          DrawerPart.back,
          DrawerPart.bottom,
          DrawerPart.drawerFront,
        ]) {
          expect(count(part), input.drawerCount, reason: '$part $input');
        }
      }
    });
  });

  group('computeDrawers — refus', () {
    test('une cote nulle', () {
      expectRefused(
        base.copyWith(openingWidth: 0),
        'La largeur intérieure doit être supérieure à 0',
      );
      expectRefused(
        base.copyWith(sideThickness: 0),
        "L'épaisseur des côtés doit être supérieure à 0",
      );
    });

    test('une valeur non finie', () {
      expectRefused(
        base.copyWith(openingDepth: double.nan),
        'Saisie incomplète',
      );
    });

    test('une ouverture trop étroite pour la glissière et les côtés', () {
      expectRefused(
        base.copyWith(openingWidth: 50),
        'La glissière et les côtés prennent 55.4 mm pour 50 mm',
      );
    });

    test('une profondeur plus courte que la plus petite glissière', () {
      expectRefused(
        base.copyWith(openingDepth: 200),
        'plus courte que la plus petite glissière (250 mm)',
      );
    });

    test('une glissière imposée plus longue que la profondeur utile', () {
      expectRefused(
        base.copyWith(slideLength: 600),
        'Une glissière de 600 mm ne tient pas dans 540 mm',
      );
    });

    test('une caisse trop basse', () {
      expectRefused(base.copyWith(openingHeight: 150), 'Caisse trop basse');
    });

    test('une rainure qui traverse le côté', () {
      expectRefused(
        base.copyWith(grooveDepth: 15),
        'Une rainure de 15 mm traverse un côté de 15 mm',
      );
    });

    test('la rainure est ignorée quand la glissière impose le fond', () {
      expect(
        () => computeDrawers(
          base.copyWith(slide: SlideKind.undermount, grooveDepth: 15),
        ),
        returnsNormally,
      );
    });

    test('des jeux négatifs', () {
      expectRefused(
        base.copyWith(frontGap: -1),
        'Le jeu entre façades ne peut pas être négatif',
      );
      expectRefused(
        base.copyWith(slide: SlideKind.custom, customSideClearance: -1),
        'Le jeu par côté ne peut pas être négatif',
      );
    });
  });
}
