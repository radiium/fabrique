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

  @override
  String get converterQuantity => 'Grandeur';

  @override
  String get converterValue => 'Valeur';

  @override
  String get converterSourceUnit => 'Unité source';

  @override
  String get converterCompoundImperial => 'Impérial composé';

  @override
  String get converterCompoundImperialHelp =>
      'Pied + pouce + fraction, arrondi au 1/16 de pouce.';

  @override
  String get converterBoardFootNote => 'L’unité d’achat du bois dur — 144 po³';

  @override
  String get converterImperial => 'Impérial';

  @override
  String get converterImperialNote => 'Arrondi au 1/16 de pouce';

  @override
  String get converterOutOfScale =>
      'Rapport hors échelle — formes non à l’échelle';

  @override
  String get levelRoll => 'Inclinaison latérale';

  @override
  String get levelRollNote => 'Gauche ⇄ droite';

  @override
  String get levelPitch => 'Inclinaison longitudinale';

  @override
  String get levelPitchNote => 'Avant ⇄ arrière';

  @override
  String get levelState => 'État';

  @override
  String get levelFlat => 'À plat';

  @override
  String get levelOff => 'Hors niveau';

  @override
  String get levelFromHorizontal => 'Par rapport à l’horizontale';

  @override
  String get levelFromZero => 'Par rapport au zéro posé';

  @override
  String get levelSetZero => 'Mettre à zéro';

  @override
  String get levelCancelZero => 'Annuler';

  @override
  String get levelHorizontalHelp =>
      'Les angles sont donnés par rapport à l’horizontale.';

  @override
  String get levelZeroHelp =>
      'Zéro posé : les angles sont relatifs à la surface calibrée.';

  @override
  String get levelSensorUnavailable => 'Accéléromètre indisponible';

  @override
  String get levelSensorUnavailableHelp =>
      'Cet outil demande un appareil équipé d’un accéléromètre.';

  @override
  String get distributionModeLabel => 'Mode de calcul';

  @override
  String get distributionModeSpacing => 'Calcul écart';

  @override
  String get distributionModeCount => 'Calcul nombre';

  @override
  String get distributionEdgeElement => 'Élément';

  @override
  String get distributionEdgeGap => 'Écart';

  @override
  String distributionEdgePair(String start, String end) {
    return '$start – $end';
  }

  @override
  String get distributionGeometry => 'Géométrie';

  @override
  String get distributionLength => 'Largeur totale';

  @override
  String get distributionElementWidth => 'Largeur d’un élément';

  @override
  String get distributionCount => 'Nombre d’éléments';

  @override
  String get distributionTargetSpacing => 'Écart souhaité';

  @override
  String get distributionTargetSpacingHelp =>
      'Le nombre d’éléments s’ajuste au plus proche.';

  @override
  String get distributionEdgesGroup => 'Bords et marges';

  @override
  String get distributionEdges => 'Type de répartition';

  @override
  String get distributionMargins => 'Marges';

  @override
  String get distributionMarginsHelp =>
      'Réservées avant répartition — un chant, un tasseau en place.';

  @override
  String get distributionSymmetric => 'Symétriques';

  @override
  String get distributionAsymmetric => 'Asymétriques';

  @override
  String get distributionMargin => 'Marge';

  @override
  String get distributionMarginStart => 'Marge début';

  @override
  String get distributionMarginEnd => 'Marge fin';

  @override
  String distributionSummaryCount(int count, String width, String length) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '$count élément',
    );
    return '$_temp0 de $width sur $length mm';
  }

  @override
  String distributionSummaryCountMarks(int count, String length) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count repères',
      one: '$count repère',
    );
    return '$_temp0 sur $length mm';
  }

  @override
  String distributionSummaryTarget(String width, String length, String target) {
    return 'Éléments de $width sur $length mm · écart visé $target mm';
  }

  @override
  String distributionSummaryTargetMarks(String length, String target) {
    return 'Repères sur $length mm · écart visé $target mm';
  }

  @override
  String distributionSummaryEdges(String edges, String margins) {
    return '$edges · marges $margins mm';
  }

  @override
  String distributionCountNote(String target) {
    return 'Pour un écart visé de $target mm';
  }

  @override
  String get distributionGapObtained => 'Écart obtenu';

  @override
  String get distributionGap => 'Écart';

  @override
  String get distributionPitch => 'Entraxe';

  @override
  String get distributionPitchNote => 'D’un bord d’élément au bord suivant';

  @override
  String distributionGapRule(int count, int gaps) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '$count élément',
    );
    String _temp1 = intl.Intl.pluralLogic(
      gaps,
      locale: localeName,
      other: '$gaps écarts',
      one: '$gaps écart',
    );
    return '$_temp0 → $_temp1';
  }

  @override
  String distributionCalloutExact(int count, String spacing) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '$count élément',
    );
    return '$_temp0 · $spacing mm exact';
  }

  @override
  String distributionCalloutOther(int count, String spacing) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '$count élément',
    );
    return '$_temp0 → $spacing mm réel';
  }

  @override
  String distributionCalloutAdoptLabel(int count, String spacing) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '$count élément',
    );
    return 'Prendre $_temp0, écart de $spacing millimètres';
  }

  @override
  String get distributionCalloutAdopt => 'Prendre';

  @override
  String get distributionPositions => 'Positions depuis l’origine';

  @override
  String get distributionNoElement => 'Aucun élément';

  @override
  String get distributionEdgeColumn => 'Bord';

  @override
  String get distributionPositionColumn => 'Position';

  @override
  String get distributionCenterColumn => 'Centre';

  @override
  String get distributionSchemaStart => 'Début';

  @override
  String get distributionSchemaEnd => 'Fin';

  @override
  String distributionSchemaLegend(String zoom) {
    return 'Cotes en mm — Détails ×$zoom';
  }

  @override
  String get distributionPlanElements => 'Éléments';

  @override
  String get distributionPlanGaps => 'Écarts';

  @override
  String distributionPlanFallback(int count) {
    return '$count positions — à copier depuis l’app';
  }

  @override
  String get distributionAboutModeBody =>
      'Détermine si l’écart entre les éléments ou leur nombre doit être calculé à partir des autres valeurs.';

  @override
  String get distributionAboutModeSpacing =>
      'Calcul écart : vous donnez le nombre d’éléments, l’outil rend l’écart entre eux.';

  @override
  String get distributionAboutModeCount =>
      'Calcul nombre : vous donnez l’écart voulu, l’outil rend le nombre d’éléments qui s’en approche le plus.';

  @override
  String get distributionAboutLengthBody =>
      'Largeur totale disponible pour répartir les éléments : l’intérieur du cadre, l’entre-deux poteaux.';

  @override
  String get distributionAboutElementWidthBody =>
      'Largeur occupée par chaque élément (barreau, lame, étagère). Saisissez 0 pour positionner des repères, traçages ou axes de perçage.';

  @override
  String get distributionAboutCountBody =>
      'Nombre d’éléments à répartir dans la largeur disponible.\n\nUne disposition qui démarre ou finit par un élément en exige au moins un. Deux si elle fait les deux. Le champ ne descend pas en dessous, et plafonne à 500.';

  @override
  String get distributionAboutTargetBody =>
      'Distance souhaitée entre deux éléments consécutifs. Ne tombe presque jamais juste : le nombre d’éléments est entier, l’écart ne l’est pas. L’outil rend donc les deux répartitions entières qui encadrent votre cible, la plus proche en premier. Si vous avez un maximum à ne pas dépasser (un barreaudage à 110 mm) lisez la plus serrée des deux.';

  @override
  String get distributionAboutEdgesBody =>
      'Définit par quoi la rangée commence et finit : un élément collé au bord, ou un écart. Chaque combinaison change le nombre d’écarts, donc le résultat. Le schéma de chaque tuile le montre.';

  @override
  String get distributionAboutMarginsBody =>
      'Définit si les deux marges se règlent ensemble ou séparément. Une marge réserve une bande à une extrémité (un chant, un tasseau déjà en place), retirée de la largeur totale avant le calcul.';

  @override
  String get distributionAboutMarginsSymmetric =>
      'Symétriques : une seule marge, reprise à l’identique des deux côtés.';

  @override
  String get distributionAboutMarginsAsymmetric =>
      'Asymétriques : une marge par côté. C’est le cas dès qu’une extrémité est contrainte et pas l’autre.';

  @override
  String get distributionAboutMarginBody =>
      'Marge identique au début et à la fin. Sa valeur est retirée de la largeur totale avant le calcul de la répartition.';

  @override
  String get distributionAboutMarginStartBody =>
      'Marge appliquée au début, côté gauche du schéma. Sa valeur est retirée de la largeur totale avant le calcul de la répartition.';

  @override
  String get distributionAboutMarginEndBody =>
      'Marge appliquée à la fin, côté droit du schéma. Sa valeur est retirée de la largeur totale avant le calcul de la répartition.';

  @override
  String get planDate => 'Date';

  @override
  String get planIndex => 'N°';

  @override
  String get layoutSurfaceGroup => 'Surface';

  @override
  String get layoutSurfaceWidth => 'Surface — largeur';

  @override
  String get layoutSurfaceLength => 'Surface — longueur';

  @override
  String get layoutElementGroup => 'Élément et pose';

  @override
  String get layoutMaterial => 'Matériau';

  @override
  String get layoutCustom => 'Personnalisé';

  @override
  String get layoutMaterialDrywall => 'Placo';

  @override
  String get layoutMaterialTile => 'Carrelage';

  @override
  String get layoutMaterialFlooring => 'Parquet';

  @override
  String get layoutMaterialDecking => 'Terrasse';

  @override
  String get layoutMaterialPanel => 'Panneau';

  @override
  String get layoutElementWidth => 'Élément — largeur';

  @override
  String get layoutElementLength => 'Élément — longueur';

  @override
  String get layoutOffset => 'Décalage des joints';

  @override
  String get layoutFlip => 'Inverser l’orientation';

  @override
  String get layoutFlipHelp => 'Le décalage de joints suit.';

  @override
  String get layoutBalance => 'Équilibrer les rangées';

  @override
  String get layoutBalanceHelp =>
      'Évite de finir sur une rangée plus mince qu’un demi-élément.';

  @override
  String layoutSummaryOffset(String offset) {
    return 'décalage $offset';
  }

  @override
  String get layoutSummaryFlipped => 'orientation inversée';

  @override
  String get layoutSummaryBalanced => 'rangées équilibrées';

  @override
  String get layoutGapsGroup => 'Jeux';

  @override
  String get layoutGapX => 'Jeu horizontal';

  @override
  String get layoutGapY => 'Jeu vertical';

  @override
  String get layoutPerimeterGap => 'Jeu périphérique';

  @override
  String get layoutPerimeterGapHelp =>
      'Retrait tout autour de la pose, contre les quatre bords.';

  @override
  String get layoutNoGap => 'Aucun jeu';

  @override
  String layoutSummaryGaps(String x, String y, String perimeter) {
    return 'entre éléments $x × $y · périphérique $perimeter mm';
  }

  @override
  String get layoutFullCount => 'Éléments entiers';

  @override
  String get layoutCutCount => 'Éléments à couper';

  @override
  String get layoutCutNote => 'Surlignés en orange sur le schéma';

  @override
  String get layoutBalancedRows => 'Rangées de bord';

  @override
  String get layoutBalancedNote => 'Première et dernière, à la même épaisseur';

  @override
  String layoutBalancedEndNote(String end) {
    return 'Première et dernière, à la même épaisseur. Pièces de bout : $end mm';
  }

  @override
  String get layoutTotal => 'Total à prévoir';

  @override
  String get layoutTotalNote => 'Stock sans réemploi des chutes';

  @override
  String get layoutSurface => 'Surface';

  @override
  String layoutCovered(String area) {
    return 'Couverte : $area m²';
  }

  @override
  String get layoutWaste => 'Perte';

  @override
  String get layoutWasteNote =>
      'Sans réemploi des chutes — estimation pessimiste';

  @override
  String get layoutPlanElement => 'Élément';

  @override
  String get layoutPlanOffset => 'Décalage';

  @override
  String get layoutPlanGap => 'Jeu';

  @override
  String get layoutPlanPerimeterGap => 'Jeu périph.';

  @override
  String get layoutPlanFull => 'Entiers';

  @override
  String get layoutPlanCut => 'À couper';

  @override
  String get layoutPlanTotal => 'Total';

  @override
  String get layoutPlanWaste => 'Perte';

  @override
  String get layoutPlanCuts => 'Pièces à couper';

  @override
  String get layoutPlanWidthColumn => 'Larg.';

  @override
  String get layoutPlanLengthColumn => 'Long.';

  @override
  String get layoutPlanCountColumn => 'Nb';

  @override
  String get layoutPlanNoCut => 'Aucune coupe, tout tombe juste';

  @override
  String layoutPlanCutsFallback(int count) {
    return '$count cotes de coupe — à lire dans l’app';
  }

  @override
  String get layoutPlanNote =>
      'Perte estimée sans réemploi des chutes. Chaque coupe consomme un élément entier.';

  @override
  String get layoutAboutPerimeterBody =>
      'Le retrait laissé tout autour de la pose, contre les quatre bords. La pièce ne rétrécit pas : c’est la pose qui recule, donc la surface annoncée reste celle du sol ou du mur.';

  @override
  String get layoutAboutPerimeterFlooring =>
      'Parquet et stratifié : le joint de dilatation, autour de 10 mm.';

  @override
  String get layoutAboutPerimeterTile =>
      'Carrelage : le joint au mur, autour de 5 mm.';

  @override
  String get layoutAboutPerimeterDrywall =>
      'Plaque de plâtre : le jeu au sol, autour de 10 mm.';

  @override
  String get layoutAboutPerimeterNone =>
      'Une pose jointive contre les murs se laisse à 0.';

  @override
  String get layoutAboutOffsetBody =>
      'De combien chaque rangée démarre en retrait de la précédente. Le décalage suit le sens de pose : inverser l’orientation le fait pivoter avec le reste du motif.';

  @override
  String get layoutAboutOffsetStraight =>
      'Droit : toutes les rangées démarrent au même endroit, les joints s’alignent en croix.';

  @override
  String get layoutAboutOffsetHalf =>
      '½ : le décalage classique des lames courtes et des plaques.';

  @override
  String get layoutAboutOffsetThird =>
      '⅓ : la règle des carreaux et des lames de plus de 60 cm, où un demi décalage fait tuiler le milieu de l’élément.';

  @override
  String get layoutAboutOffsetSquare =>
      'Sur un élément carré ou une plaque pleine, l’effet reste marginal.';

  @override
  String get drawerPartSide => 'Côté';

  @override
  String get drawerPartFront => 'Devant';

  @override
  String get drawerPartBack => 'Dos';

  @override
  String get drawerPartBottom => 'Fond';

  @override
  String get drawerPartDrawerFront => 'Façade';

  @override
  String get slideBallBearing => 'À billes';

  @override
  String get slideUndermount => 'Sous tiroir';

  @override
  String get slideWoodOnWood => 'Bois sur bois';

  @override
  String get slideCustom => 'Personnalisée';

  @override
  String get frontMountOverlay => 'Applique';

  @override
  String get frontMountInset => 'Encastrée';

  @override
  String get boxJointSidesOverlap => 'Côtés recouvrants';

  @override
  String get boxJointFrontBackOverlap => 'Devant et dos recouvrants';

  @override
  String get bottomMountGroove => 'En rainure';

  @override
  String get bottomMountBetween => 'Entre les côtés';

  @override
  String get bottomMountUnderneath => 'Sous la caisse';

  @override
  String get drawersOpening => 'Ouverture';

  @override
  String get drawersOpeningWidth => 'Largeur intérieure';

  @override
  String get drawersOpeningHeight => 'Hauteur intérieure';

  @override
  String get drawersOpeningDepth => 'Profondeur intérieure';

  @override
  String get drawersCarcassThickness => 'Épaisseur du caisson';

  @override
  String drawersSummaryOpening(
    String width,
    String height,
    String depth,
    String carcass,
  ) {
    return '$width × $height × $depth mm · caisson $carcass mm';
  }

  @override
  String get drawersFrontsGroup => 'Tiroirs et façades';

  @override
  String get drawersCount => 'Nombre de tiroirs';

  @override
  String get drawersHeights => 'Hauteurs';

  @override
  String get drawersHeightsAdjusted => 'Ajustées';

  @override
  String get drawersHeightsEqual => 'Égales';

  @override
  String get drawersFrontMount => 'Pose de la façade';

  @override
  String get drawersFrontThickness => 'Épaisseur de façade';

  @override
  String get drawersFrontGap => 'Jeu entre façades';

  @override
  String drawersSummaryFronts(
    int count,
    String heights,
    String mount,
    String thickness,
    String gap,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tiroirs',
      one: '$count tiroir',
    );
    return '$_temp0 · hauteurs $heights · $mount, façade $thickness · jeu $gap mm';
  }

  @override
  String get drawersSlide => 'Glissière';

  @override
  String get drawersSideClearance => 'Jeu par côté';

  @override
  String get drawersLengthReduction => 'Réduction de longueur';

  @override
  String get drawersSlideLength => 'Longueur de glissière';

  @override
  String get drawersSlideLengthAuto => 'Automatique';

  @override
  String drawersSummaryCustomSlide(String clearance, String reduction) {
    return 'jeu $clearance, réduction $reduction mm';
  }

  @override
  String get drawersSummaryAutoLength => 'longueur automatique';

  @override
  String drawersSummaryLength(String length) {
    return 'longueur $length mm';
  }

  @override
  String get drawersBox => 'Caisse';

  @override
  String get drawersSideThickness => 'Épaisseur des côtés';

  @override
  String get drawersSideThicknessHelp => 'Aussi le devant et le dos.';

  @override
  String get drawersBottomThickness => 'Épaisseur du fond';

  @override
  String get drawersBoxJoint => 'Assemblage';

  @override
  String get drawersBottom => 'Fond';

  @override
  String get drawersBottomImposedHelp => 'Imposé par la glissière sous tiroir.';

  @override
  String drawersBottomRecess(String recess) {
    return 'En retrait de $recess mm';
  }

  @override
  String get drawersGrooveDepth => 'Profondeur de rainure';

  @override
  String drawersSummaryRecess(String recess) {
    return 'en retrait de $recess mm';
  }

  @override
  String drawersSummaryGroove(String depth) {
    return 'en rainure de $depth mm';
  }

  @override
  String drawersSummaryBox(
    String side,
    String bottom,
    String joint,
    String mount,
  ) {
    return 'côtés $side, fond $bottom mm · $joint · fond $mount';
  }

  @override
  String get drawersEditHeights => 'Modifier les hauteurs des façades';

  @override
  String drawersHeightsTopToBottom(String heights) {
    return 'De haut en bas : $heights mm';
  }

  @override
  String get drawersFrontHeights => 'Hauteurs des façades';

  @override
  String get drawersFrontHeightsHelp =>
      'Une hauteur saisie reste fixe. Les autres façades se partagent le reste.';

  @override
  String get drawersHeightShared => 'Partagée';

  @override
  String get drawersHeightFixed => 'Fixée';

  @override
  String get drawersResetHeights => 'Remettre à égales';

  @override
  String drawersDrawer(int number) {
    return 'Tiroir $number';
  }

  @override
  String drawersDrawerTop(int number) {
    return 'Tiroir $number (haut)';
  }

  @override
  String drawersDrawerBottom(int number) {
    return 'Tiroir $number (bas)';
  }

  @override
  String get drawersCutList => 'Fiche de débit';

  @override
  String get drawersCutListPart => 'Pièce';

  @override
  String get drawersCutListSizes => 'L × l × ép (mm)';

  @override
  String get drawersFrontsResult => 'Façades — largeur × hauteur';

  @override
  String drawersFrontsResultNote(String gap) {
    return 'Jeu de $gap mm entre façades';
  }

  @override
  String get drawersBoxResult => 'Caisse — largeur × longueur';

  @override
  String drawersBoxResultNote(String clearance) {
    return 'Hors tout, $clearance mm de jeu par côté';
  }

  @override
  String get drawersSlideLengthAutoNote => 'La plus grande qui tient';

  @override
  String get drawersSlideLengthImposedNote => 'Imposée';

  @override
  String get drawersSlideAxes => 'Axes de glissière';

  @override
  String get drawersSlideAxesNote =>
      'Depuis le bas de l’ouverture, de haut en bas';

  @override
  String get drawersPlanFronts => 'Façades';

  @override
  String drawersPlanFrontsValue(String mount, String gap) {
    return '$mount, jeu $gap';
  }

  @override
  String get drawersPlanDepth => 'Profondeur';

  @override
  String get drawersPlanThicknesses => 'Ép. côtés / fond';

  @override
  String get drawersPlanFrontThickness => 'Ép. façade';

  @override
  String get drawersPlanLength => 'Longueur';

  @override
  String get drawersPlanCount => 'Nb';

  @override
  String get drawersPlanLengthColumn => 'L (mm)';

  @override
  String get drawersPlanWidthColumn => 'l (mm)';

  @override
  String drawersPlanCutListFallback(int count) {
    return '$count lignes de débit — à lire dans l’app';
  }

  @override
  String get drawersPlanAxes => 'Axes de glissière, tiroir 1 en haut';

  @override
  String get drawersPlanAxesColumn => 'Depuis le bas de l’ouverture';

  @override
  String drawersPlanAxesFallback(int count) {
    return '$count axes — à lire dans l’app';
  }

  @override
  String get drawersPlanUndermountNote =>
      'Cotes de glissière sous tiroir indicatives. Vérifier sur la fiche du fabricant.';

  @override
  String get drawersAboutOpeningBody =>
      'Cotes intérieures du caisson, là où vont les tiroirs : entre les flancs, entre le fond et le dessus, du chant au panneau arrière.';

  @override
  String get drawersAboutFrontHeightsBody =>
      'Par défaut, les façades se partagent la hauteur à parts égales. Une hauteur fixée reste fixe, et les autres façades se partagent le reste.';

  @override
  String get drawersAboutSlideBody =>
      'Elle fixe le jeu entre les flancs et la caisse, et sa longueur.';

  @override
  String get drawersAboutSlideBallBearing =>
      'À billes : glissière latérale, 12,7 mm de jeu de chaque côté.';

  @override
  String get drawersAboutSlideUndermount =>
      'Sous tiroir : glissière cachée sous la caisse. Elle impose un fond en retrait. Cotes indicatives, à vérifier sur la fiche du fabricant.';

  @override
  String get drawersAboutSlideWood =>
      'Bois sur bois : le tiroir coulisse sur des coulisseaux en bois, sans quincaillerie.';

  @override
  String get drawersAboutSlideCustom =>
      'Personnalisée : les jeux de votre fiche fabricant.';

  @override
  String get drawersAboutFrontMountBody =>
      'Où se pose la façade par rapport au caisson.';

  @override
  String get drawersAboutFrontMountOverlay =>
      'Applique : devant le caisson. La façade recouvre le chant des flancs, à fleur de leurs bords.';

  @override
  String get drawersAboutFrontMountInset =>
      'Encastrée : dans l’ouverture. La façade affleure le chant, avec un jeu tout autour.';

  @override
  String get drawersAboutBoxJointBody =>
      'Quelles pièces courent d’un bout à l’autre. Il change la longueur du devant, du dos et des côtés, pas le type d’assemblage.';

  @override
  String get drawersAboutBottomBody => 'Comment le fond tient dans la caisse.';

  @override
  String get drawersAboutBottomGroove =>
      'En rainure : pris dans une rainure des quatre pièces. Il dépasse de la profondeur de rainure de chaque côté.';

  @override
  String get drawersAboutBottomBetween =>
      'Entre les côtés : posé à l’intérieur sans rainure, vissé, collé ou sur tasseaux. Il fait les cotes intérieures de la caisse.';

  @override
  String get drawersAboutBottomUnderneath =>
      'Sous la caisse : vissé ou cloué dessous, aux dimensions hors tout.';

  @override
  String get drawersAboutSlideLengthBody =>
      'Par défaut, la plus grande longueur vendue qui tient dans la profondeur. Imposez-en une si vous avez déjà vos glissières.';

  @override
  String planDateValue(String day, String month, String year) {
    return '$day/$month/$year';
  }

  @override
  String get planExport => 'Exporter';

  @override
  String get planShare => 'Partager';

  @override
  String get planExportTooltip => 'Exporter le plan';

  @override
  String get planDownloaded => 'Plan téléchargé';

  @override
  String get planSaved => 'Plan enregistré dans vos photos';

  @override
  String get planView => 'Voir';

  @override
  String get planPhotosDenied => 'Accès aux photos refusé';

  @override
  String get planSaveFailed => 'Enregistrement impossible';

  @override
  String get planExportFailed => 'Export impossible';

  @override
  String get schemaFit => 'Ajuster à l’écran';

  @override
  String get schemaRotate => 'Pivoter le schéma';
}
