import 'package:freezed_annotation/freezed_annotation.dart';

import '../format.dart';
import 'calc_exception.dart';

part 'drawers.freezed.dart';
part 'drawers.g.dart';

/// La famille de glissière, qui fixe les jeux de la caisse.
///
/// Une glissière n'est pas une marque : c'est un jeu latéral, une réduction de
/// longueur et une contrainte sur le fond ([SlideSpec]). Suivre les catalogues
/// serait sans fin, et « Personnalisée » recopie une fiche fabricant.
enum SlideKind {
  /// Glissière latérale à billes, vissée sur le flanc et sur le côté.
  ballBearing,

  /// Glissière sous tiroir, cachée : elle impose un fond en retrait.
  undermount,

  /// Tiroir traditionnel qui coulisse sur des coulisseaux en bois, sans
  /// quincaillerie.
  woodOnWood,

  /// Jeux saisis à la main, depuis la fiche du fabricant.
  custom,
}

/// Comment la façade se pose devant l'ouverture.
enum FrontMount {
  /// Devant le caisson : la façade recouvre le chant des flancs.
  overlay,

  /// Dans l'ouverture : la façade affleure le chant et mange la profondeur.
  inset,
}

/// Quelles pièces de la caisse recouvrent les autres.
///
/// C'est la seule chose de l'assemblage qui change les cotes : queue d'aronde,
/// tourillons ou vis ne changent que la façon de faire.
enum BoxJoint {
  /// Les côtés courent sur toute la longueur, le devant et le dos entre eux.
  sidesOverlap,

  /// Le devant et le dos courent sur toute la largeur, les côtés entre eux.
  frontBackOverlap,
}

/// Comment le fond tient dans la caisse.
///
/// Ignoré avec une glissière qui impose le sien ([SlideSpec.bottomRecess]).
enum BottomMount {
  /// Pris dans une rainure des côtés, du devant et du dos.
  groove,

  /// Posé entre les côtés, le devant et le dos, sans rainure : vissé, collé
  /// ou sur tasseaux. Il fait les cotes intérieures de la caisse.
  between,

  /// Vissé ou cloué sous la caisse, à ses dimensions hors tout.
  underneath,
}

/// Une pièce de la fiche de débit.
enum DrawerPart { side, front, back, bottom, drawerFront }

/// Libellés d'affichage, partagés par l'écran et le cartouche du plan.
extension DrawerPartDisplay on DrawerPart {
  String get label => switch (this) {
    DrawerPart.side => 'Côté',
    DrawerPart.front => 'Devant',
    DrawerPart.back => 'Dos',
    DrawerPart.bottom => 'Fond',
    DrawerPart.drawerFront => 'Façade',
  };
}

extension SlideKindDisplay on SlideKind {
  String get label => switch (this) {
    SlideKind.ballBearing => 'À billes',
    SlideKind.undermount => 'Sous tiroir',
    SlideKind.woodOnWood => 'Bois sur bois',
    SlideKind.custom => 'Personnalisée',
  };
}

extension FrontMountDisplay on FrontMount {
  /// Court : ces libellés tiennent dans un segment de sélecteur.
  String get label => switch (this) {
    FrontMount.overlay => 'Applique',
    FrontMount.inset => 'Encastrée',
  };
}

extension BoxJointDisplay on BoxJoint {
  String get label => switch (this) {
    BoxJoint.sidesOverlap => 'Côtés recouvrants',
    BoxJoint.frontBackOverlap => 'Devant et dos recouvrants',
  };
}

extension BottomMountDisplay on BottomMount {
  String get label => switch (this) {
    BottomMount.groove => 'En rainure',
    BottomMount.between => 'Entre les côtés',
    BottomMount.underneath => 'Sous la caisse',
  };
}

/// Ce qu'une glissière impose à la caisse, en mm.
@freezed
abstract class SlideSpec with _$SlideSpec {
  const factory SlideSpec({
    /// Jeu entre le flanc du caisson et le côté du tiroir, de chaque côté.
    required double sideClearance,

    /// Ce que la caisse perd sur la longueur nominale de la glissière.
    @Default(0) double lengthReduction,

    /// Longueurs nominales vendues, croissantes. Vide = pas de glissière à
    /// choisir (bois sur bois) : la caisse prend la profondeur utile.
    @Default(<double>[]) List<double> nominalLengths,

    /// Retrait du fond sous la caisse, quand la glissière l'impose. `null` =
    /// montage du fond libre ([BottomMount]).
    double? bottomRecess,

    /// Place laissée sous la caisse, dans son compartiment.
    required double clearanceBelow,

    /// Place laissée au-dessus de la caisse : de quoi l'engager dans la
    /// glissière, ou le coulisseau du tiroir du dessus en bois sur bois.
    required double clearanceAbove,
  }) = _SlideSpec;
}

/// Saisie de l'outil Tiroirs : une ouverture, une colonne de tiroirs de même
/// largeur et même profondeur. Tout en mm.
@freezed
abstract class DrawersInput with _$DrawersInput {
  const factory DrawersInput({
    /// Cotes intérieures de l'ouverture, entre flancs, fond et dessus.
    required double openingWidth,
    required double openingHeight,
    required double openingDepth,

    /// Nombre de tiroirs de la colonne (>= 1).
    required int drawerCount,

    /// Hauteur de façade fixée, tiroir par tiroir, de haut en bas. `null` = le
    /// tiroir partage à parts égales ce que les hauteurs fixées laissent.
    @Default(<double?>[]) List<double?> fixedFrontHeights,
    @Default(SlideKind.ballBearing) SlideKind slide,

    /// Jeu latéral par côté, pour [SlideKind.custom] seulement.
    @Default(12.7) double customSideClearance,

    /// Réduction de longueur, pour [SlideKind.custom] seulement.
    @Default(0) double customLengthReduction,

    /// Longueur nominale imposée. `null` = la plus grande qui tient.
    double? slideLength,
    @Default(FrontMount.overlay) FrontMount frontMount,

    /// Jeu entre deux façades, et autour d'une façade encastrée.
    @Default(3) double frontGap,
    @Default(15) double sideThickness,
    @Default(8) double bottomThickness,

    /// Épaisseur des flancs du caisson : fixe le recouvrement en applique.
    @Default(19) double carcassThickness,

    /// Épaisseur de la façade : réduit la profondeur utile en pose encastrée.
    @Default(19) double frontThickness,
    @Default(BoxJoint.sidesOverlap) BoxJoint boxJoint,
    @Default(BottomMount.groove) BottomMount bottomMount,

    /// Profondeur de la rainure du fond, pour [BottomMount.groove].
    @Default(6) double grooveDepth,
  }) = _DrawersInput;

  factory DrawersInput.fromJson(Map<String, dynamic> json) =>
      _$DrawersInputFromJson(json);
}

/// Une façade de la colonne, de haut en bas.
@freezed
abstract class DrawerFrontSlot with _$DrawerFrontSlot {
  const factory DrawerFrontSlot({
    /// Bas de la façade, depuis le bas de l'ouverture. Négatif en applique :
    /// la façade descend sur le chant du caisson.
    required double bottom,
    required double height,

    /// La hauteur a-t-elle été fixée à la main, ou vient-elle du partage ?
    @Default(false) bool isFixed,
  }) = _DrawerFrontSlot;
}

/// Une ligne de la fiche de débit : des pièces identiques, regroupées.
@freezed
abstract class CutPiece with _$CutPiece {
  const factory CutPiece({
    required DrawerPart part,
    required int quantity,

    /// Longueur, dans le sens du fil.
    required double length,
    required double width,
    required double thickness,
  }) = _CutPiece;
}

/// Un rectangle d'une vue en coupe, en mm : [x0] < [x1], [y0] < [y1].
///
/// En x, depuis le flanc gauche de l'ouverture, dans les deux vues. En y,
/// depuis le bas de l'ouverture vers le haut dans la coupe de face, depuis le
/// chant du caisson vers le fond dans la coupe de dessus.
@freezed
abstract class SectionRect with _$SectionRect {
  const factory SectionRect({
    required double x0,
    required double y0,
    required double x1,
    required double y1,
  }) = _SectionRect;
}

/// Un tiroir dans la coupe de face : ce que coupe le plan vertical au milieu
/// de la profondeur.
@freezed
abstract class DrawerFaceSection with _$DrawerFaceSection {
  const factory DrawerFaceSection({
    required List<SectionRect> sides,
    required SectionRect bottom,

    /// Vides en bois sur bois.
    required List<SectionRect> slides,
  }) = _DrawerFaceSection;
}

/// Un tiroir dans la coupe de dessus : ce que coupe le plan horizontal à
/// mi-hauteur de la caisse.
@freezed
abstract class DrawerTopSection with _$DrawerTopSection {
  const factory DrawerTopSection({
    /// Les flancs du caisson, de part et d'autre de l'ouverture.
    required List<SectionRect> flanks,

    /// Côtés, devant et dos, chacun tel que l'assemblage le coupe.
    required List<SectionRect> walls,

    /// Vides sans glissière latérale : une glissière sous tiroir est cachée
    /// sous le fond.
    required List<SectionRect> slides,
    required SectionRect front,
  }) = _DrawerTopSection;
}

/// Tout ce que l'outil rend, prêt à afficher et à tracer.
@freezed
abstract class DrawersResult with _$DrawersResult {
  const factory DrawersResult({
    /// Façades de haut en bas, toutes de largeur [frontWidth].
    required List<DrawerFrontSlot> fronts,
    required double frontWidth,

    /// Bord gauche des façades, depuis le flanc gauche de l'ouverture.
    /// Négatif en applique.
    required double frontLeft,

    /// Jeu effectivement laissé entre flanc et côté, de chaque côté.
    required double sideClearance,

    /// Caisse hors tout.
    required double boxWidth,
    required double boxLength,

    /// Retrait de la caisse derrière le chant du caisson : l'épaisseur de la
    /// façade en pose encastrée, zéro en applique.
    @Default(0) double boxSetback,

    /// Hauteur de caisse de chaque tiroir, de haut en bas.
    required List<double> boxHeights,

    /// Bas de chaque caisse, depuis le bas de l'ouverture, de haut en bas.
    required List<double> boxBottoms,

    /// Hauteur du dessous du fond au-dessus du bas de la caisse : la position
    /// de la rainure, le retrait imposé par une glissière sous tiroir, zéro
    /// sinon.
    @Default(0) double bottomLift,

    /// Longueur nominale retenue. `null` sans glissière (bois sur bois).
    double? slideLength,

    /// La longueur a-t-elle été choisie par l'outil ?
    @Default(true) bool isSlideLengthAuto,

    /// Axe de chaque glissière, depuis le bas de l'ouverture, de haut en bas.
    required List<double> slideAxes,

    /// Fiche de débit, pièces identiques regroupées.
    required List<CutPiece> cutList,

    /// Chaque tiroir dans la coupe de face, de haut en bas.
    required List<DrawerFaceSection> faceSections,

    /// Un tiroir dans la coupe de dessus : ils sont tous pareils vus d'en
    /// haut.
    required DrawerTopSection topSection,
  }) = _DrawersResult;
}

/// Longueurs nominales courantes des glissières à billes, en mm.
const List<double> kBallBearingLengths = [
  250, 300, 350, 400, 450, 500, 550, 600, 650, 700, //
];

/// Longueurs nominales courantes des glissières sous tiroir, en mm.
const List<double> kUndermountLengths = [
  270, 300, 350, 400, 450, 500, 550, 600, //
];

/// Ce que la glissière choisie impose à la caisse.
///
/// Les valeurs sous tiroir sont celles d'un côté de 16 mm chez les grands
/// fabricants, indicatives : elles varient d'une gamme à l'autre, d'où
/// [SlideKind.custom].
SlideSpec slideSpecFor(DrawersInput input) => switch (input.slide) {
  SlideKind.ballBearing => const SlideSpec(
    sideClearance: 12.7,
    nominalLengths: kBallBearingLengths,
    clearanceBelow: 10,
    clearanceAbove: 20,
  ),
  SlideKind.undermount => const SlideSpec(
    sideClearance: 5,
    lengthReduction: 10,
    nominalLengths: kUndermountLengths,
    bottomRecess: 13,
    clearanceBelow: 3,
    clearanceAbove: 20,
  ),
  SlideKind.woodOnWood => const SlideSpec(
    sideClearance: 1,
    clearanceBelow: 0,
    clearanceAbove: 20,
  ),
  SlideKind.custom => SlideSpec(
    sideClearance: input.customSideClearance,
    lengthReduction: input.customLengthReduction,
    nominalLengths: kBallBearingLengths,
    clearanceBelow: 10,
    clearanceAbove: 20,
  ),
};

/// Hauteur du dessous du fond au-dessus du bas de la caisse, en rainure :
/// l'emplacement de la rainure sur les côtés, le devant et le dos.
const double kGrooveLift = 10;

/// Hauteur de profil d'une glissière latérale dans la coupe, en mm : un
/// ordre de grandeur pour la reconnaître, pas une cote.
const double kSideSlideProfile = 35;

/// Ce qu'une glissière sous tiroir avance sous le fond depuis le côté, dans la
/// coupe, en mm. Un ordre de grandeur, comme [kSideSlideProfile].
const double kUndermountSlideReach = 30;

/// Hauteur de caisse en dessous de laquelle le tiroir n'en est plus un.
const double kMinBoxHeight = 40;

/// Tolérance de comparaison entre deux cotes calculées, en mm.
const double _epsilon = 1e-6;

/// Calcule les façades, les caisses, la glissière et la fiche de débit.
///
/// Chaque tiroir a son **compartiment** : la part de l'ouverture derrière sa
/// façade, limitée au milieu du jeu entre deux façades. Sa caisse est la plus
/// haute qui y tient, dégagements de la glissière déduits
/// ([SlideSpec.clearanceBelow], [SlideSpec.clearanceAbove]).
///
/// Tout en mm. Lève [CalcException] sur une cote nulle ou négative, une
/// ouverture trop étroite pour la glissière et les côtés, une profondeur plus
/// courte que la plus petite glissière, une caisse trop basse, des hauteurs
/// fixées qui ne tiennent pas, une rainure qui traverse le côté.
DrawersResult computeDrawers(DrawersInput input) {
  _validate(input);
  final spec = slideSpecFor(input);
  _validateSlide(input, spec);

  final fronts = _fronts(input);
  final frontWidth = switch (input.frontMount) {
    FrontMount.overlay =>
      input.openingWidth + 2 * input.carcassThickness - input.frontGap,
    FrontMount.inset => input.openingWidth - 2 * input.frontGap,
  };
  if (frontWidth <= 0) {
    throw const CalcException(
      'Les jeux autour de la façade prennent toute la largeur intérieure',
    );
  }

  final side = input.sideThickness;
  final boxWidth = input.openingWidth - 2 * spec.sideClearance;
  if (boxWidth - 2 * side <= 0) {
    throw CalcException(
      'La glissière et les côtés prennent '
      '${formatNumber(2 * spec.sideClearance + 2 * side)} mm '
      'pour ${formatNumber(input.openingWidth)} mm de largeur intérieure',
    );
  }

  final boxSetback = switch (input.frontMount) {
    FrontMount.overlay => 0.0,
    FrontMount.inset => input.frontThickness,
  };
  final usefulDepth = input.openingDepth - boxSetback;
  if (usefulDepth <= 0) {
    throw const CalcException(
      'La façade encastrée prend toute la profondeur intérieure',
    );
  }
  final (slideLength, isSlideLengthAuto) = _slideLength(
    input,
    spec,
    usefulDepth,
  );
  final boxLength = switch (slideLength) {
    final length? => length - spec.lengthReduction,
    null => usefulDepth,
  };
  if (boxLength - 2 * side <= 0) {
    throw CalcException(
      'Caisse trop courte : ${formatNumber(boxLength)} mm de longueur',
    );
  }

  final bottomLift =
      spec.bottomRecess ??
      switch (input.bottomMount) {
        BottomMount.groove => kGrooveLift,
        BottomMount.between || BottomMount.underneath => 0.0,
      };

  final boxBottoms = <double>[];
  final boxHeights = <double>[];
  for (var i = 0; i < fronts.length; i++) {
    final top = i == 0
        ? input.openingHeight
        : fronts[i - 1].bottom - input.frontGap / 2;
    final bottom = i == fronts.length - 1
        ? 0.0
        : fronts[i].bottom - input.frontGap / 2;
    final height = top - bottom - spec.clearanceBelow - spec.clearanceAbove;
    if (height < kMinBoxHeight ||
        height - bottomLift - input.bottomThickness <= 0) {
      throw CalcException(
        'Caisse trop basse : ${formatNumber(height)} mm pour le tiroir '
        '${i + 1} (${formatNumber(kMinBoxHeight)} au minimum)',
      );
    }
    boxBottoms.add(bottom + spec.clearanceBelow);
    boxHeights.add(height);
  }

  final slideAxes = [
    for (var i = 0; i < boxBottoms.length; i++)
      switch (input.slide) {
        // Une glissière latérale se centre sur le côté.
        SlideKind.ballBearing ||
        SlideKind.custom => boxBottoms[i] + boxHeights[i] / 2,
        // Sous tiroir, le dessous de la glissière. Bois sur bois, le dessus
        // du coulisseau : la caisse est posée dessus.
        SlideKind.undermount || SlideKind.woodOnWood => boxBottoms[i],
      },
  ];

  final frontLeft = (input.openingWidth - frontWidth) / 2;

  return DrawersResult(
    fronts: fronts,
    frontWidth: frontWidth,
    frontLeft: frontLeft,
    sideClearance: spec.sideClearance,
    boxWidth: boxWidth,
    boxLength: boxLength,
    boxSetback: boxSetback,
    boxHeights: boxHeights,
    boxBottoms: boxBottoms,
    bottomLift: bottomLift,
    slideLength: slideLength,
    isSlideLengthAuto: isSlideLengthAuto,
    slideAxes: slideAxes,
    cutList: _cutList(
      input,
      spec,
      fronts: fronts,
      frontWidth: frontWidth,
      boxWidth: boxWidth,
      boxLength: boxLength,
      boxHeights: boxHeights,
    ),
    faceSections: [
      for (var i = 0; i < boxBottoms.length; i++)
        _faceSection(
          input,
          spec,
          boxWidth: boxWidth,
          boxBottom: boxBottoms[i],
          boxHeight: boxHeights[i],
          bottomLift: bottomLift,
          slideAxis: slideLength == null ? null : slideAxes[i],
        ),
    ],
    topSection: _topSection(
      input,
      spec,
      frontLeft: frontLeft,
      frontWidth: frontWidth,
      boxWidth: boxWidth,
      boxLength: boxLength,
      boxSetback: boxSetback,
      slideLength: slideLength,
    ),
  );
}

/// Un tiroir dans la coupe de face.
///
/// [slideAxis] est `null` sans glissière (bois sur bois).
DrawerFaceSection _faceSection(
  DrawersInput input,
  SlideSpec spec, {
  required double boxWidth,
  required double boxBottom,
  required double boxHeight,
  required double bottomLift,
  required double? slideAxis,
}) {
  final side = input.sideThickness;
  final bottom = input.bottomThickness;
  final left = spec.sideClearance;
  final right = left + boxWidth;
  final top = boxBottom + boxHeight;
  final floor = boxBottom + bottomLift;
  final width = input.openingWidth;

  final isUnderneath =
      spec.bottomRecess == null && input.bottomMount == BottomMount.underneath;
  final sidesFrom = isUnderneath ? boxBottom + bottom : boxBottom;

  final bottomRect = switch (spec.bottomRecess) {
    _? => SectionRect(
      x0: left + side,
      y0: floor,
      x1: right - side,
      y1: floor + bottom,
    ),
    null => switch (input.bottomMount) {
      BottomMount.groove => SectionRect(
        x0: left + side - input.grooveDepth,
        y0: floor,
        x1: right - side + input.grooveDepth,
        y1: floor + bottom,
      ),
      BottomMount.between => SectionRect(
        x0: left + side,
        y0: floor,
        x1: right - side,
        y1: floor + bottom,
      ),
      BottomMount.underneath => SectionRect(
        x0: left,
        y0: boxBottom,
        x1: right,
        y1: boxBottom + bottom,
      ),
    },
  };

  final slides = switch ((slideAxis, spec.bottomRecess)) {
    (null, _) => const <SectionRect>[],
    // Sous tiroir : du flanc jusque sous le fond, dans le retrait.
    (_?, _?) => [
      SectionRect(
        x0: 0,
        y0: boxBottom,
        x1: left + side + kUndermountSlideReach,
        y1: floor,
      ),
      SectionRect(
        x0: right - side - kUndermountSlideReach,
        y0: boxBottom,
        x1: width,
        y1: floor,
      ),
    ],
    // Latérale : dans le jeu, centrée sur son axe.
    (final axis?, null) => [
      SectionRect(
        x0: 0,
        y0: axis - kSideSlideProfile / 2,
        x1: left,
        y1: axis + kSideSlideProfile / 2,
      ),
      SectionRect(
        x0: right,
        y0: axis - kSideSlideProfile / 2,
        x1: width,
        y1: axis + kSideSlideProfile / 2,
      ),
    ],
  };

  return DrawerFaceSection(
    sides: [
      SectionRect(x0: left, y0: sidesFrom, x1: left + side, y1: top),
      SectionRect(x0: right - side, y0: sidesFrom, x1: right, y1: top),
    ],
    bottom: bottomRect,
    slides: slides,
  );
}

/// Un tiroir dans la coupe de dessus.
DrawerTopSection _topSection(
  DrawersInput input,
  SlideSpec spec, {
  required double frontLeft,
  required double frontWidth,
  required double boxWidth,
  required double boxLength,
  required double boxSetback,
  required double? slideLength,
}) {
  final carcass = input.carcassThickness;
  final width = input.openingWidth;
  final depth = input.openingDepth;
  final side = input.sideThickness;
  final left = spec.sideClearance;
  final right = left + boxWidth;
  final near = boxSetback;
  final far = near + boxLength;

  final walls = switch (input.boxJoint) {
    BoxJoint.sidesOverlap => [
      SectionRect(x0: left, y0: near, x1: left + side, y1: far),
      SectionRect(x0: right - side, y0: near, x1: right, y1: far),
      SectionRect(x0: left + side, y0: near, x1: right - side, y1: near + side),
      SectionRect(x0: left + side, y0: far - side, x1: right - side, y1: far),
    ],
    BoxJoint.frontBackOverlap => [
      SectionRect(x0: left, y0: near + side, x1: left + side, y1: far - side),
      SectionRect(x0: right - side, y0: near + side, x1: right, y1: far - side),
      SectionRect(x0: left, y0: near, x1: right, y1: near + side),
      SectionRect(x0: left, y0: far - side, x1: right, y1: far),
    ],
  };

  final slides = switch ((slideLength, spec.bottomRecess)) {
    (final length?, null) => [
      SectionRect(x0: 0, y0: near, x1: left, y1: near + length),
      SectionRect(x0: right, y0: near, x1: width, y1: near + length),
    ],
    (null, _) || (_?, _?) => const <SectionRect>[],
  };

  final front = switch (input.frontMount) {
    FrontMount.overlay => SectionRect(
      x0: frontLeft,
      y0: -input.frontThickness,
      x1: frontLeft + frontWidth,
      y1: 0,
    ),
    FrontMount.inset => SectionRect(
      x0: frontLeft,
      y0: 0,
      x1: frontLeft + frontWidth,
      y1: input.frontThickness,
    ),
  };

  return DrawerTopSection(
    flanks: [
      SectionRect(x0: -carcass, y0: 0, x1: 0, y1: depth),
      SectionRect(x0: width, y0: 0, x1: width + carcass, y1: depth),
    ],
    walls: walls,
    slides: slides,
    front: front,
  );
}

void _validate(DrawersInput input) {
  final values = [
    input.openingWidth,
    input.openingHeight,
    input.openingDepth,
    input.customSideClearance,
    input.customLengthReduction,
    input.frontGap,
    input.sideThickness,
    input.bottomThickness,
    input.carcassThickness,
    input.frontThickness,
    input.grooveDepth,
    ?input.slideLength,
    for (final height in input.fixedFrontHeights) ?height,
  ];
  if (values.any((v) => !v.isFinite)) {
    throw const CalcException('Saisie incomplète');
  }

  for (final (value, message) in [
    (input.openingWidth, 'La largeur intérieure doit être supérieure à 0'),
    (input.openingHeight, 'La hauteur intérieure doit être supérieure à 0'),
    (input.openingDepth, 'La profondeur intérieure doit être supérieure à 0'),
    (input.carcassThickness, "L'épaisseur du caisson doit être supérieure à 0"),
    (input.frontThickness, "L'épaisseur de façade doit être supérieure à 0"),
    (input.sideThickness, "L'épaisseur des côtés doit être supérieure à 0"),
    (input.bottomThickness, "L'épaisseur du fond doit être supérieure à 0"),
  ]) {
    if (value <= 0) throw CalcException(message);
  }

  if (input.drawerCount < 1) {
    throw const CalcException('Il faut au moins un tiroir');
  }
  if (input.frontGap < 0) {
    throw const CalcException('Le jeu entre façades ne peut pas être négatif');
  }
  if (input.fixedFrontHeights.any((h) => h != null && h <= 0)) {
    throw const CalcException('Une hauteur de façade doit être supérieure à 0');
  }
}

/// Ce que seule la glissière choisie rend invalide.
void _validateSlide(DrawersInput input, SlideSpec spec) {
  if (spec.sideClearance < 0) {
    throw const CalcException('Le jeu par côté ne peut pas être négatif');
  }
  if (spec.lengthReduction < 0) {
    throw const CalcException(
      'La réduction de longueur ne peut pas être négative',
    );
  }
  if (input.slideLength case final length?
      when spec.nominalLengths.isNotEmpty && length <= 0) {
    throw const CalcException(
      'La longueur de glissière doit être supérieure à 0',
    );
  }
  // Une glissière qui impose son fond rend la rainure sans objet.
  if (spec.bottomRecess == null && input.bottomMount == BottomMount.groove) {
    if (input.grooveDepth <= 0) {
      throw const CalcException(
        'La profondeur de rainure doit être supérieure à 0',
      );
    }
    if (input.grooveDepth >= input.sideThickness) {
      throw CalcException(
        'Une rainure de ${formatNumber(input.grooveDepth)} mm traverse '
        'un côté de ${formatNumber(input.sideThickness)} mm',
      );
    }
  }
}

/// Les façades de haut en bas : les hauteurs fixées, et les autres à parts
/// égales de ce qui reste.
///
/// En applique, la colonne couvre le chant du caisson, moins un demi-jeu en
/// haut et en bas (le jeu avec le voisin). Encastrée, elle a un jeu tout
/// autour.
List<DrawerFrontSlot> _fronts(DrawersInput input) {
  final count = input.drawerCount;
  final gap = input.frontGap;
  final carcass = input.carcassThickness;
  final height = input.openingHeight;
  final (top, span) = switch (input.frontMount) {
    FrontMount.overlay => (
      height + carcass - gap / 2,
      height + 2 * carcass - count * gap,
    ),
    FrontMount.inset => (height - gap, height - (count + 1) * gap),
  };
  if (span <= 0) {
    throw const CalcException(
      'Les jeux entre façades prennent toute la hauteur intérieure',
    );
  }

  final fixed = [
    for (var i = 0; i < count; i++) input.fixedFrontHeights.elementAtOrNull(i),
  ];
  final fixedSum = fixed.nonNulls.fold(0.0, (sum, h) => sum + h);
  final freeCount = fixed.where((h) => h == null).length;
  final shared = freeCount == 0 ? 0.0 : (span - fixedSum) / freeCount;
  final fits = freeCount == 0 ? (fixedSum - span).abs() < _epsilon : shared > 0;
  if (!fits) {
    throw CalcException(
      'Les hauteurs fixées font ${formatNumber(fixedSum)} mm '
      'pour ${formatNumber(span)} mm de façades',
    );
  }

  final slots = <DrawerFrontSlot>[];
  var cursor = top;
  for (final h in fixed) {
    final slot = DrawerFrontSlot(
      bottom: cursor - (h ?? shared),
      height: h ?? shared,
      isFixed: h != null,
    );
    slots.add(slot);
    cursor = slot.bottom - gap;
  }
  return slots;
}

/// La longueur nominale retenue, et si l'outil l'a choisie.
///
/// `null` sans glissière à choisir (bois sur bois) : la caisse prend alors la
/// profondeur utile.
(double?, bool) _slideLength(
  DrawersInput input,
  SlideSpec spec,
  double usefulDepth,
) {
  if (spec.nominalLengths.isEmpty) return (null, true);
  if (input.slideLength case final imposed?) {
    if (imposed > usefulDepth) {
      throw CalcException(
        'Une glissière de ${formatNumber(imposed)} mm ne tient pas dans '
        '${formatNumber(usefulDepth)} mm de profondeur utile',
      );
    }
    return (imposed, false);
  }
  final fitting = spec.nominalLengths.where((l) => l <= usefulDepth);
  if (fitting.isEmpty) {
    throw CalcException(
      'La profondeur utile (${formatNumber(usefulDepth)} mm) est plus courte '
      'que la plus petite glissière '
      '(${formatNumber(spec.nominalLengths.first)} mm)',
    );
  }
  return (fitting.last, true);
}

/// La fiche de débit : côtés, devants, dos, fonds, façades, dans cet ordre,
/// les pièces identiques regroupées.
List<CutPiece> _cutList(
  DrawersInput input,
  SlideSpec spec, {
  required List<DrawerFrontSlot> fronts,
  required double frontWidth,
  required double boxWidth,
  required double boxLength,
  required List<double> boxHeights,
}) {
  final side = input.sideThickness;
  final bottom = input.bottomThickness;
  final innerWidth = boxWidth - 2 * side;
  final innerLength = boxLength - 2 * side;
  final (sideLength, crossLength) = switch (input.boxJoint) {
    BoxJoint.sidesOverlap => (boxLength, innerWidth),
    BoxJoint.frontBackOverlap => (innerLength, boxWidth),
  };

  // Le fond, en travers × en profondeur : le fil court d'un côté à l'autre.
  final (bottomAcross, bottomDeep) = switch (spec.bottomRecess) {
    // Entre les côtés, sous le dos qui est posé dessus.
    _? => (innerWidth, boxLength - side),
    null => switch (input.bottomMount) {
      BottomMount.groove => (
        innerWidth + 2 * input.grooveDepth,
        innerLength + 2 * input.grooveDepth,
      ),
      BottomMount.between => (innerWidth, innerLength),
      BottomMount.underneath => (boxWidth, boxLength),
    },
  };

  // Un fond dessous raccourcit les parois de son épaisseur.
  final wallCut =
      spec.bottomRecess == null && input.bottomMount == BottomMount.underneath
      ? bottom
      : 0.0;
  final backCut = switch (spec.bottomRecess) {
    final recess? => recess + bottom,
    null => wallCut,
  };

  final pieces = [
    for (final h in boxHeights)
      CutPiece(
        part: DrawerPart.side,
        quantity: 2,
        length: sideLength,
        width: h - wallCut,
        thickness: side,
      ),
    for (final h in boxHeights)
      CutPiece(
        part: DrawerPart.front,
        quantity: 1,
        length: crossLength,
        width: h - wallCut,
        thickness: side,
      ),
    for (final h in boxHeights)
      CutPiece(
        part: DrawerPart.back,
        quantity: 1,
        length: crossLength,
        width: h - backCut,
        thickness: side,
      ),
    for (final _ in boxHeights)
      CutPiece(
        part: DrawerPart.bottom,
        quantity: 1,
        length: bottomAcross,
        width: bottomDeep,
        thickness: bottom,
      ),
    for (final front in fronts)
      CutPiece(
        part: DrawerPart.drawerFront,
        quantity: 1,
        length: frontWidth,
        width: front.height,
        thickness: input.frontThickness,
      ),
  ];

  final grouped = <CutPiece>[];
  for (final piece in pieces) {
    final index = grouped.indexWhere((g) => _isSameCut(g, piece));
    if (index < 0) {
      grouped.add(piece);
    } else {
      grouped[index] = grouped[index].copyWith(
        quantity: grouped[index].quantity + piece.quantity,
      );
    }
  }
  return grouped;
}

/// Deux pièces se débitent pareil : même rôle, mêmes cotes au µm près.
bool _isSameCut(CutPiece a, CutPiece b) =>
    a.part == b.part &&
    (a.length - b.length).abs() < _epsilon &&
    (a.width - b.width).abs() < _epsilon &&
    (a.thickness - b.thickness).abs() < _epsilon;
