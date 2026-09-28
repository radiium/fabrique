/// Le motif d'un refus de calcul, sans texte.
///
/// L'UI en fait une phrase par un `switch` sans joker. Les cotes portées sont
/// en millimètres bruts.
library;

import '../models/measure_unit.dart';

sealed class CalcError {
  const CalcError();
}

/// Un champ vide ou non numérique.
final class IncompleteInput extends CalcError {
  const IncompleteInput();
}

/// Une valeur infinie ou `NaN` passée à une conversion.
final class NonFiniteValue extends CalcError {
  const NonFiniteValue();
}

/// Une longueur négative passée à l'impérial composé.
final class NegativeLength extends CalcError {
  const NegativeLength();
}

/// Un dénominateur d'impérial composé nul ou négatif.
final class InvalidDenominator extends CalcError {
  const InvalidDenominator();
}

/// Deux unités de grandeurs différentes.
final class IncompatibleUnits extends CalcError {
  const IncompatibleUnits(this.from, this.to);

  final MeasureUnit from;
  final MeasureUnit to;
}

/// Un seuil de niveau négatif ou non fini.
final class InvalidLevelThreshold extends CalcError {
  const InvalidLevelThreshold();
}

/// Une lecture d'accéléromètre non finie, ou nulle sur les trois axes.
final class InvalidSensorReading extends CalcError {
  const InvalidSensorReading();
}

/// Une cote qui doit être strictement positive.
final class MustBePositive extends CalcError {
  const MustBePositive(this.field);

  final PositiveField field;
}

/// Une cote qui peut être nulle, jamais négative.
final class MustNotBeNegative extends CalcError {
  const MustNotBeNegative(this.field);

  final NonNegativeField field;
}

/// Les cotes qui doivent être strictement positives, nommées comme à l'écran.
enum PositiveField {
  totalWidth,
  surfaceWidth,
  surfaceLength,
  tileWidth,
  tileLength,
  openingWidth,
  openingHeight,
  openingDepth,
  carcassThickness,
  frontThickness,
  sideThickness,
  bottomThickness,
  frontHeight,
  slideLength,
  grooveDepth,
}

/// Les cotes et comptes qui peuvent être nuls, jamais négatifs.
enum NonNegativeField {
  elementWidth,
  margin,
  elementCount,
  targetGap,
  horizontalGap,
  verticalGap,
  perimeterGap,
  frontGap,
  sideClearance,
  lengthReduction,
}

// Répartition

/// Les marges ne laissent rien à répartir.
final class MarginsFillWidth extends CalcError {
  const MarginsFillWidth();
}

/// La disposition des bords demande plus d'éléments que la saisie.
final class TooFewElements extends CalcError {
  const TooFewElements(this.minCount);

  final int minCount;
}

/// Plus d'éléments que le plafond de l'outil.
final class TooManyElements extends CalcError {
  const TooManyElements(this.maxCount);

  final int maxCount;
}

/// Les éléments ne tiennent pas dans la largeur disponible.
final class ElementsOverflow extends CalcError {
  const ElementsOverflow({
    required this.count,
    required this.occupied,
    required this.available,
  });

  final int count;
  final double occupied;
  final double available;
}

/// Largeur d'élément et écart visé nuls : aucun pas à répartir.
final class WidthAndGapBothZero extends CalcError {
  const WidthAndGapBothZero();
}

/// Aucun nombre d'éléments ne tombe sur l'écart visé.
final class NoDistributionForGap extends CalcError {
  const NoDistributionForGap();
}

/// Un écart visé si petit qu'il dépasserait le plafond d'éléments.
final class GapTooSmall extends CalcError {
  const GapTooSmall(this.maxCount);

  final int maxCount;
}

// Calepinage

/// L'élément est plus grand que la zone à couvrir.
///
/// Cotes dans le sens de pose. La zone est la surface moins le jeu
/// périphérique : les deux cotes figurent dans le message.
final class TileLargerThanSurface extends CalcError {
  const TileLargerThanSurface({
    required this.tileWidth,
    required this.tileLength,
    required this.surfaceWidth,
    required this.surfaceLength,
  });

  final double tileWidth;
  final double tileLength;
  final double surfaceWidth;
  final double surfaceLength;
}

/// Plus d'éléments que le plafond du dessin.
///
/// [count] reste un `double` : une faute de frappe peut dépasser un entier.
final class TooManyTiles extends CalcError {
  const TooManyTiles({required this.count, required this.maxCount});

  final double count;
  final int maxCount;
}

/// Le jeu périphérique ne laisse rien à couvrir.
final class PerimeterGapFillsSurface extends CalcError {
  const PerimeterGapFillsSurface({required this.gap, required this.smallest});

  final double gap;
  final double smallest;
}

// Tiroirs

/// Aucun tiroir demandé.
final class NoDrawer extends CalcError {
  const NoDrawer();
}

/// Les jeux autour de la façade prennent toute la largeur intérieure.
final class FrontGapsFillWidth extends CalcError {
  const FrontGapsFillWidth();
}

/// Les jeux entre façades prennent toute la hauteur intérieure.
final class FrontGapsFillHeight extends CalcError {
  const FrontGapsFillHeight();
}

/// La façade encastrée prend toute la profondeur intérieure.
final class InsetFrontFillsDepth extends CalcError {
  const InsetFrontFillsDepth();
}

/// Glissières et côtés plus larges que l'ouverture.
final class SlideAndSidesTooWide extends CalcError {
  const SlideAndSidesTooWide({required this.needed, required this.opening});

  final double needed;
  final double opening;
}

/// Une caisse sans longueur utile.
final class BoxTooShort extends CalcError {
  const BoxTooShort(this.length);

  final double length;
}

/// Une caisse plus basse que le minimum, pour le tiroir [drawer] (compté
/// depuis 1).
final class BoxTooLow extends CalcError {
  const BoxTooLow({
    required this.height,
    required this.drawer,
    required this.minimum,
  });

  final double height;
  final int drawer;
  final double minimum;
}

/// Une rainure aussi profonde que le côté est épais.
final class GrooveThroughSide extends CalcError {
  const GrooveThroughSide({required this.groove, required this.side});

  final double groove;
  final double side;
}

/// Les hauteurs de façade fixées dépassent la hauteur disponible.
final class FixedHeightsTooTall extends CalcError {
  const FixedHeightsTooTall({required this.fixed, required this.available});

  final double fixed;
  final double available;
}

/// Une glissière imposée plus longue que la profondeur utile.
final class SlideTooLong extends CalcError {
  const SlideTooLong({required this.slide, required this.usefulDepth});

  final double slide;
  final double usefulDepth;
}

/// Une profondeur utile plus courte que la plus petite glissière du modèle.
final class DepthTooShortForSlides extends CalcError {
  const DepthTooShortForSlides({
    required this.usefulDepth,
    required this.shortestSlide,
  });

  final double usefulDepth;
  final double shortestSlide;
}
