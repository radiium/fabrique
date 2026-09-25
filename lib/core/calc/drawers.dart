import 'package:freezed_annotation/freezed_annotation.dart';

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

/// Tout ce que l'outil rend, prêt à afficher et à tracer.
@freezed
abstract class DrawersResult with _$DrawersResult {
  const factory DrawersResult({
    /// Façades de haut en bas, toutes de largeur [frontWidth].
    required List<DrawerFrontSlot> fronts,
    required double frontWidth,

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
  ),
  SlideKind.undermount => const SlideSpec(
    sideClearance: 5,
    lengthReduction: 10,
    nominalLengths: kUndermountLengths,
    bottomRecess: 13,
  ),
  SlideKind.woodOnWood => const SlideSpec(sideClearance: 1),
  SlideKind.custom => SlideSpec(
    sideClearance: input.customSideClearance,
    lengthReduction: input.customLengthReduction,
    nominalLengths: kBallBearingLengths,
  ),
};
