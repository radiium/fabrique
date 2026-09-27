import 'dart:math' as math;

import 'package:fabrique/core/calc/calc_exception.dart';
import 'package:fabrique/core/calc/drawers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Un caisson de référence, aux épaisseurs par défaut (18).
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

  void expectRefused(DrawersInput input, Matcher reason) => expect(
    () => computeDrawers(input),
    throwsA(isA<CalcException>().having((e) => e.reason, 'reason', reason)),
  );

  group('computeDrawers — cas de référence', () {
    test('trois tiroirs à billes en applique', () {
      final r = computeDrawers(base);

      // 562 + 2 × 18 : la façade couvre le caisson d'un bord à l'autre.
      expect(r.frontWidth, near(598));
      // (720 + 2 × 18 − 2 × 3) / 3 : un jeu entre deux façades, aucun au bord.
      expect(r.fronts.map((f) => f.height), everyElement(near(250)));
      expect(r.fronts.first.bottom + r.fronts.first.height, near(738));
      expect(r.fronts.last.bottom, near(-18));

      expect(r.carcassWidth, near(598));
      expect(r.carcassHeight, near(756));

      expect(r.sideClearance, 12.7);
      expect(r.boxWidth, near(536.6));
      expect(r.slideLength, 500);
      expect(r.isSlideLengthAuto, isTrue);
      expect(r.boxLength, 500);
      expect(r.boxSetback, 0);
      expect(r.bottomLift, kGrooveLift);

      // Le tiroir du milieu a un jeu entier au-dessus et au-dessous, ceux des
      // bouts perdent le recouvrement du caisson.
      expect(r.boxHeights[0], near(203.5));
      expect(r.boxHeights[1], near(223));
      expect(r.boxHeights[2], near(203.5));
      expect(r.boxBottoms[2], near(10));
      expect(r.slideAxes[2], near(10 + 203.5 / 2));
    });

    test('la fiche de débit regroupe les pièces identiques', () {
      final r = computeDrawers(base);

      final sides = r.cutList.where((p) => p.part == DrawerPart.side);
      expect(sides.map((p) => p.quantity), [4, 2]);
      expect(piece(r, DrawerPart.side).length, 500);
      expect(piece(r, DrawerPart.front).length, near(506.6));
      expect(piece(r, DrawerPart.back, width: 223).quantity, 1);

      final bottom = piece(r, DrawerPart.bottom);
      expect(bottom.quantity, 3);
      // Cotes intérieures, plus 6 de rainure de chaque côté.
      expect(bottom.length, near(518.6));
      expect(bottom.width, near(482));
      expect(bottom.thickness, 8);

      final front = piece(r, DrawerPart.drawerFront);
      expect(front.quantity, 3);
      expect(front.length, near(598));
      expect(front.thickness, 18);
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
      expect(r.boxSetback, 18);
      // 540 − 18 de façade : 522 utiles, la glissière de 500.
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
      expect(piece(r, DrawerPart.side).width, near(203.5 - 8));
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
      expect(r.fronts[1].height, near(225));
      expect(r.fronts[2].isFixed, isFalse);
    });

    test('des hauteurs toutes fixées doivent faire la hauteur', () {
      final r = computeDrawers(
        base.copyWith(fixedFrontHeights: const [300, 300, 150]),
      );
      expect(r.fronts.last.bottom, near(-18));

      expectRefused(
        base.copyWith(fixedFrontHeights: const [300, 300, 300]),
        isA<FixedHeightsTooTall>()
            .having((e) => e.fixed, 'fixed', near(900))
            .having((e) => e.available, 'available', near(750)),
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
      expect(computeDrawers(base).frontLeft, near(-18));
      expect(
        computeDrawers(base.copyWith(frontMount: FrontMount.inset)).frontLeft,
        near(3),
      );
    });

    test('une glissière latérale se centre sur son axe, dans le jeu', () {
      final r = computeDrawers(base);
      final slide = r.faceSections.first.slides.first.bounds;

      expect((slide.y0 + slide.y1) / 2, near(r.slideAxes.first));
      expect(slide.x0, 0);
      expect(slide.x1, near(r.sideClearance));
    });

    test('sous tiroir : glissières sous les côtés et dans le retrait, cachées vues de dessus', () {
      final r = computeDrawers(base.copyWith(slide: SlideKind.undermount));
      final face = r.faceSections.first;

      // Le L descend dans le dégagement de 3 sous la caisse et remonte
      // jusque sous le fond.
      expect(
        face.slides.map((s) => s.bounds.y0),
        everyElement(near(r.boxBottoms.first - 3)),
      );
      expect(
        face.slides.map((s) => s.bounds.y1).reduce(math.max),
        near(face.bottom.y0),
      );
      expect(r.topSection.slides, isEmpty);
    });

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
      expect(face.sides.first.bounds.x1 - face.bottom.x0, near(6));
      expect(face.bottom.y0, near(r.boxBottoms.last + kGrooveLift));
    });

    test('en rainure, le côté est entaillé à la place exacte du fond', () {
      final face = computeDrawers(base).faceSections.last;
      final side = face.sides.first.points;
      final b = face.bottom;

      expect(side, contains(SectionPoint(b.x0, b.y0)));
      expect(side, contains(SectionPoint(b.x0, b.y1)));
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

    test('les pièces d’une coupe ne se chevauchent jamais', () {
      for (final input in inputs) {
        final r = computeDrawers(input);
        for (final face in r.faceSections) {
          expectNoOverlap([
            ...face.sides.map((s) => s.points),
            _corners(face.bottom),
            ...face.slides.map((s) => s.points),
          ], reason: 'coupe de face, $input');
          for (final piece in [
            ...face.sides.map((s) => s.bounds),
            face.bottom,
          ]) {
            expect(piece.x0, greaterThanOrEqualTo(-1e-9), reason: '$input');
            expect(
              piece.x1,
              lessThanOrEqualTo(input.openingWidth + 1e-9),
              reason: '$input',
            );
          }
        }
        final t = r.topSection;
        expectNoOverlap([
          for (final p in [...t.flanks, ...t.walls, ...t.slides, t.front])
            _corners(p),
        ], reason: 'coupe de dessus, $input');
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
        isA<MustBePositive>().having(
          (e) => e.field,
          'field',
          PositiveField.openingWidth,
        ),
      );
      expectRefused(
        base.copyWith(sideThickness: 0),
        isA<MustBePositive>().having(
          (e) => e.field,
          'field',
          PositiveField.sideThickness,
        ),
      );
    });

    test('une valeur non finie', () {
      expectRefused(
        base.copyWith(openingDepth: double.nan),
        isA<IncompleteInput>(),
      );
    });

    test('une ouverture trop étroite pour la glissière et les côtés', () {
      expectRefused(
        base.copyWith(openingWidth: 50),
        isA<SlideAndSidesTooWide>()
            .having((e) => e.needed, 'needed', near(55.4))
            .having((e) => e.opening, 'opening', near(50)),
      );
    });

    test('une profondeur plus courte que la plus petite glissière', () {
      expectRefused(
        base.copyWith(openingDepth: 200),
        isA<DepthTooShortForSlides>().having(
          (e) => e.shortestSlide,
          'shortestSlide',
          near(250),
        ),
      );
    });

    test('une glissière imposée plus longue que la profondeur utile', () {
      expectRefused(
        base.copyWith(slideLength: 600),
        isA<SlideTooLong>()
            .having((e) => e.slide, 'slide', near(600))
            .having((e) => e.usefulDepth, 'usefulDepth', near(540)),
      );
    });

    test('une caisse trop basse', () {
      expectRefused(base.copyWith(openingHeight: 150), isA<BoxTooLow>());
    });

    test('une rainure qui traverse le côté', () {
      expectRefused(
        base.copyWith(grooveDepth: 15),
        isA<GrooveThroughSide>()
            .having((e) => e.groove, 'groove', near(15))
            .having((e) => e.side, 'side', near(15)),
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
        isA<MustNotBeNegative>().having(
          (e) => e.field,
          'field',
          NonNegativeField.frontGap,
        ),
      );
      expectRefused(
        base.copyWith(slide: SlideKind.custom, customSideClearance: -1),
        isA<MustNotBeNegative>().having(
          (e) => e.field,
          'field',
          NonNegativeField.sideClearance,
        ),
      );
    });
  });
}

List<SectionPoint> _corners(SectionRect r) => SectionPolygon.rect(r).points;

/// Le point est-il strictement dans le polygone ? Lancer de rayon.
bool _isInside(List<SectionPoint> polygon, double x, double y) {
  var isInside = false;
  for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    final a = polygon[i];
    final b = polygon[j];
    if ((a.y > y) != (b.y > y) &&
        x < (b.x - a.x) * (y - a.y) / (b.y - a.y) + a.x) {
      isInside = !isInside;
    }
  }
  return isInside;
}

/// Échantillonne l'intersection des boîtes de chaque paire : aucun point ne
/// doit tomber dans les deux pièces. Le pas décalé évite de tomber pile sur
/// une arête commune, où « dedans » ne veut rien dire.
void expectNoOverlap(
  List<List<SectionPoint>> pieces, {
  required String reason,
}) {
  const steps = 20;
  for (var i = 0; i < pieces.length; i++) {
    for (var j = i + 1; j < pieces.length; j++) {
      final a = SectionPolygon(pieces[i]).bounds;
      final b = SectionPolygon(pieces[j]).bounds;
      final x0 = math.max(a.x0, b.x0);
      final x1 = math.min(a.x1, b.x1);
      final y0 = math.max(a.y0, b.y0);
      final y1 = math.min(a.y1, b.y1);
      if (x1 - x0 <= 1e-9 || y1 - y0 <= 1e-9) continue;
      for (var u = 0; u < steps; u++) {
        for (var v = 0; v < steps; v++) {
          final x = x0 + (x1 - x0) * (u + 0.37) / steps;
          final y = y0 + (y1 - y0) * (v + 0.61) / steps;
          expect(
            _isInside(pieces[i], x, y) && _isInside(pieces[j], x, y),
            isFalse,
            reason: 'pièces $i et $j en ($x, $y), $reason',
          );
        }
      }
    }
  }
}
