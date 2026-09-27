// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Fabrique';

  @override
  String get settings => 'Réglages';

  @override
  String get theme => 'Thème';

  @override
  String get themeLightLocked => 'Clair';

  @override
  String get haptics => 'Retour haptique';

  @override
  String get hapticsHelp =>
      'Vibration brève sur les boutons − / + et les sélecteurs.';

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Langue du téléphone';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsLockedSection => 'Verrouillé pour cette version';

  @override
  String get settingsLoadFailed => 'Réglages illisibles';

  @override
  String get toolLayout => 'Calepinage';

  @override
  String get toolLayoutSubtitle => 'Pose sur surface, % de perte';

  @override
  String get toolDistribution => 'Répartition';

  @override
  String get toolDistributionSubtitle => 'Écart ou nombre d’éléments';

  @override
  String get toolDrawers => 'Tiroirs';

  @override
  String get toolDrawersSubtitle => 'Débit, façades, glissières';

  @override
  String get toolLevel => 'Niveau';

  @override
  String get toolLevelSubtitle => 'Bulle et inclinomètre';

  @override
  String get toolConverter => 'Convertisseur';

  @override
  String get toolConverterSubtitle => 'Cinq grandeurs, unités d’atelier';

  @override
  String get quantityLength => 'Longueur';

  @override
  String get quantityArea => 'Surface';

  @override
  String get quantityVolume => 'Volume';

  @override
  String get quantityMass => 'Masse';

  @override
  String get quantityPressure => 'Pression';

  @override
  String get unitInchSymbol => 'po';

  @override
  String get unitFootSymbol => 'pi';

  @override
  String get unitBoardFootSymbol => 'pmp';

  @override
  String get unitMillimeters => 'Millimètres';

  @override
  String get unitCentimeters => 'Centimètres';

  @override
  String get unitMeters => 'Mètres';

  @override
  String get unitInches => 'Pouces';

  @override
  String get unitFeet => 'Pieds';

  @override
  String get unitSquareMillimeters => 'Millimètres carrés';

  @override
  String get unitSquareCentimeters => 'Centimètres carrés';

  @override
  String get unitSquareMeters => 'Mètres carrés';

  @override
  String get unitSquareInches => 'Pouces carrés';

  @override
  String get unitSquareFeet => 'Pieds carrés';

  @override
  String get unitCubicCentimeters => 'Centimètres cubes';

  @override
  String get unitLiters => 'Litres';

  @override
  String get unitCubicMeters => 'Mètres cubes';

  @override
  String get unitCubicInches => 'Pouces cubes';

  @override
  String get unitBoardFeet => 'Pieds-planche';

  @override
  String get unitGrams => 'Grammes';

  @override
  String get unitKilograms => 'Kilogrammes';

  @override
  String get unitTonnes => 'Tonnes';

  @override
  String get unitOunces => 'Onces';

  @override
  String get unitPounds => 'Livres';

  @override
  String get unitBars => 'Bars';

  @override
  String get unitKilopascals => 'Kilopascals';

  @override
  String get unitMegapascals => 'Mégapascals';

  @override
  String get unitPsi => 'Livres par pouce carré';

  @override
  String get jointOffsetStraight => 'Droit';

  @override
  String get decimalSeparator => ',';

  @override
  String get commonExpandSchema => 'Agrandir le schéma';

  @override
  String get commonCopied => 'Copié';

  @override
  String commonHelpFor(String label) {
    return 'Aide : $label';
  }

  @override
  String get commonReset => 'Réinitialiser la saisie';

  @override
  String get commonDecrement => 'Un de moins';

  @override
  String get commonIncrement => 'Un de plus';

  @override
  String get commonUnitNote => 'Cotes en mm';

  @override
  String get calcIncompleteInput => 'Saisie incomplète';

  @override
  String get calcNonFiniteValue => 'Valeur non finie';

  @override
  String get calcNegativeLength => 'Longueur négative';

  @override
  String get calcInvalidDenominator => 'Dénominateur invalide';

  @override
  String calcIncompatibleUnits(
    String from,
    String fromQuantity,
    String to,
    String toQuantity,
  ) {
    return 'Conversion impossible : $from ($fromQuantity) vers $to ($toQuantity)';
  }

  @override
  String get calcInvalidLevelThreshold => 'Seuil de niveau invalide';

  @override
  String get calcInvalidSensorReading => 'Lecture accéléromètre invalide';

  @override
  String get calcPositiveTotalWidth =>
      'La largeur totale doit être supérieure à 0';

  @override
  String get calcPositiveSurfaceWidth =>
      'La largeur de surface doit être un nombre positif';

  @override
  String get calcPositiveSurfaceLength =>
      'La longueur de surface doit être un nombre positif';

  @override
  String get calcPositiveTileWidth =>
      'La largeur d\'élément doit être un nombre positif';

  @override
  String get calcPositiveTileLength =>
      'La longueur d\'élément doit être un nombre positif';

  @override
  String get calcPositiveOpeningWidth =>
      'La largeur intérieure doit être supérieure à 0';

  @override
  String get calcPositiveOpeningHeight =>
      'La hauteur intérieure doit être supérieure à 0';

  @override
  String get calcPositiveOpeningDepth =>
      'La profondeur intérieure doit être supérieure à 0';

  @override
  String get calcPositiveCarcassThickness =>
      'L\'épaisseur du caisson doit être supérieure à 0';

  @override
  String get calcPositiveFrontThickness =>
      'L\'épaisseur de façade doit être supérieure à 0';

  @override
  String get calcPositiveSideThickness =>
      'L\'épaisseur des côtés doit être supérieure à 0';

  @override
  String get calcPositiveBottomThickness =>
      'L\'épaisseur du fond doit être supérieure à 0';

  @override
  String get calcPositiveFrontHeight =>
      'Une hauteur de façade doit être supérieure à 0';

  @override
  String get calcPositiveSlideLength =>
      'La longueur de glissière doit être supérieure à 0';

  @override
  String get calcPositiveGrooveDepth =>
      'La profondeur de rainure doit être supérieure à 0';

  @override
  String get calcNonNegativeElementWidth =>
      'La largeur d\'un élément ne peut pas être négative';

  @override
  String get calcNonNegativeMargin => 'Une marge ne peut pas être négative';

  @override
  String get calcNonNegativeElementCount =>
      'Le nombre d\'éléments ne peut pas être négatif';

  @override
  String get calcNonNegativeTargetGap =>
      'L\'écart visé ne peut pas être négatif';

  @override
  String get calcNonNegativeHorizontalGap =>
      'Le jeu horizontal ne peut pas être négatif';

  @override
  String get calcNonNegativeVerticalGap =>
      'Le jeu vertical ne peut pas être négatif';

  @override
  String get calcNonNegativePerimeterGap =>
      'Le jeu périphérique ne peut pas être négatif';

  @override
  String get calcNonNegativeFrontGap =>
      'Le jeu entre façades ne peut pas être négatif';

  @override
  String get calcNonNegativeSideClearance =>
      'Le jeu par côté ne peut pas être négatif';

  @override
  String get calcNonNegativeLengthReduction =>
      'La réduction de longueur ne peut pas être négative';

  @override
  String get calcMarginsFillWidth =>
      'Les marges occupent toute la largeur : il ne reste rien à répartir';

  @override
  String calcTooFewElements(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '$count élément',
    );
    return 'Cette disposition demande au moins $_temp0';
  }

  @override
  String calcTooManyElements(int max) {
    return 'Trop d\'éléments : $max au maximum';
  }

  @override
  String calcElementsOverflow(int count, String occupied, String available) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Les $count éléments occupent',
      one: '$count élément occupe',
    );
    return '$_temp0 $occupied mm pour $available mm disponibles';
  }

  @override
  String get calcWidthAndGapBothZero =>
      'Largeur et écart ne peuvent pas être nuls tous les deux';

  @override
  String get calcNoDistributionForGap =>
      'Aucune répartition ne correspond à cet écart';

  @override
  String calcGapTooSmall(int max) {
    return 'Écart trop petit : il faudrait plus de $max éléments';
  }

  @override
  String calcTileLargerThanSurface(
    String tileWidth,
    String tileLength,
    String surfaceWidth,
    String surfaceLength,
  ) {
    return 'L\'élément fait $tileWidth × $tileLength mm pour une zone à couvrir de $surfaceWidth × $surfaceLength mm';
  }

  @override
  String calcTooManyTiles(String count, int max) {
    return 'Cette saisie demanderait $count éléments, $max au maximum';
  }

  @override
  String calcPerimeterGapFillsSurface(String gap, String smallest) {
    return 'Le jeu périphérique de $gap mm ne laisse rien à couvrir sur $smallest mm';
  }

  @override
  String get calcNoDrawer => 'Il faut au moins un tiroir';

  @override
  String get calcFrontGapsFillWidth =>
      'Les jeux autour de la façade prennent toute la largeur intérieure';

  @override
  String get calcFrontGapsFillHeight =>
      'Les jeux entre façades prennent toute la hauteur intérieure';

  @override
  String get calcInsetFrontFillsDepth =>
      'La façade encastrée prend toute la profondeur intérieure';

  @override
  String calcSlideAndSidesTooWide(String needed, String opening) {
    return 'La glissière et les côtés prennent $needed mm pour $opening mm de largeur intérieure';
  }

  @override
  String calcBoxTooShort(String length) {
    return 'Caisse trop courte : $length mm de longueur';
  }

  @override
  String calcBoxTooLow(String height, int drawer, String minimum) {
    return 'Caisse trop basse : $height mm pour le tiroir $drawer ($minimum au minimum)';
  }

  @override
  String calcGrooveThroughSide(String groove, String side) {
    return 'Une rainure de $groove mm traverse un côté de $side mm';
  }

  @override
  String calcFixedHeightsTooTall(String fixed, String available) {
    return 'Les hauteurs fixées font $fixed mm pour $available mm de façades';
  }

  @override
  String calcSlideTooLong(String slide, String usefulDepth) {
    return 'Une glissière de $slide mm ne tient pas dans $usefulDepth mm de profondeur utile';
  }

  @override
  String calcDepthTooShortForSlides(String usefulDepth, String shortest) {
    return 'La profondeur utile ($usefulDepth mm) est plus courte que la plus petite glissière ($shortest mm)';
  }
}
