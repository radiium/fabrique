import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// Nom de l'app, barre de titre et accueil
  ///
  /// In fr, this message translates to:
  /// **'Fabrique'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get theme;

  /// No description provided for @themeLightLocked.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get themeLightLocked;

  /// No description provided for @haptics.
  ///
  /// In fr, this message translates to:
  /// **'Retour haptique'**
  String get haptics;

  /// No description provided for @hapticsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Vibration brève sur les boutons − / + et les sélecteurs.'**
  String get hapticsHelp;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// Suivre la langue du téléphone
  ///
  /// In fr, this message translates to:
  /// **'Langue du téléphone'**
  String get languageSystem;

  /// Chaque langue s'affiche dans sa propre langue : identique dans tous les ARB
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageEnglish.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @settingsLockedSection.
  ///
  /// In fr, this message translates to:
  /// **'Verrouillé pour cette version'**
  String get settingsLockedSection;

  /// Titre affiché si shared_preferences échoue à l'ouverture
  ///
  /// In fr, this message translates to:
  /// **'Réglages illisibles'**
  String get settingsLoadFailed;

  /// No description provided for @toolLayout.
  ///
  /// In fr, this message translates to:
  /// **'Calepinage'**
  String get toolLayout;

  /// Sous-titre d'accueil, une ligne tronquée au-delà d'environ 34 caractères
  ///
  /// In fr, this message translates to:
  /// **'Pose sur surface, % de perte'**
  String get toolLayoutSubtitle;

  /// No description provided for @toolDistribution.
  ///
  /// In fr, this message translates to:
  /// **'Répartition'**
  String get toolDistribution;

  /// No description provided for @toolDistributionSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Écart ou nombre d’éléments'**
  String get toolDistributionSubtitle;

  /// No description provided for @toolDrawers.
  ///
  /// In fr, this message translates to:
  /// **'Tiroirs'**
  String get toolDrawers;

  /// No description provided for @toolDrawersSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Débit, façades, glissières'**
  String get toolDrawersSubtitle;

  /// No description provided for @toolLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau'**
  String get toolLevel;

  /// No description provided for @toolLevelSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Bulle et inclinomètre'**
  String get toolLevelSubtitle;

  /// No description provided for @toolConverter.
  ///
  /// In fr, this message translates to:
  /// **'Convertisseur'**
  String get toolConverter;

  /// No description provided for @toolConverterSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Cinq grandeurs, unités d’atelier'**
  String get toolConverterSubtitle;

  /// No description provided for @quantityLength.
  ///
  /// In fr, this message translates to:
  /// **'Longueur'**
  String get quantityLength;

  /// No description provided for @quantityArea.
  ///
  /// In fr, this message translates to:
  /// **'Surface'**
  String get quantityArea;

  /// No description provided for @quantityVolume.
  ///
  /// In fr, this message translates to:
  /// **'Volume'**
  String get quantityVolume;

  /// No description provided for @quantityMass.
  ///
  /// In fr, this message translates to:
  /// **'Masse'**
  String get quantityMass;

  /// No description provided for @quantityPressure.
  ///
  /// In fr, this message translates to:
  /// **'Pression'**
  String get quantityPressure;

  /// Symbole du pouce, décliné en po² et po³ ; tient dans un segment de sélecteur
  ///
  /// In fr, this message translates to:
  /// **'po'**
  String get unitInchSymbol;

  /// Symbole du pied, décliné en pi²
  ///
  /// In fr, this message translates to:
  /// **'pi'**
  String get unitFootSymbol;

  /// Symbole du pied-planche
  ///
  /// In fr, this message translates to:
  /// **'pmp'**
  String get unitBoardFootSymbol;

  /// No description provided for @unitMillimeters.
  ///
  /// In fr, this message translates to:
  /// **'Millimètres'**
  String get unitMillimeters;

  /// No description provided for @unitCentimeters.
  ///
  /// In fr, this message translates to:
  /// **'Centimètres'**
  String get unitCentimeters;

  /// No description provided for @unitMeters.
  ///
  /// In fr, this message translates to:
  /// **'Mètres'**
  String get unitMeters;

  /// No description provided for @unitInches.
  ///
  /// In fr, this message translates to:
  /// **'Pouces'**
  String get unitInches;

  /// No description provided for @unitFeet.
  ///
  /// In fr, this message translates to:
  /// **'Pieds'**
  String get unitFeet;

  /// No description provided for @unitSquareMillimeters.
  ///
  /// In fr, this message translates to:
  /// **'Millimètres carrés'**
  String get unitSquareMillimeters;

  /// No description provided for @unitSquareCentimeters.
  ///
  /// In fr, this message translates to:
  /// **'Centimètres carrés'**
  String get unitSquareCentimeters;

  /// No description provided for @unitSquareMeters.
  ///
  /// In fr, this message translates to:
  /// **'Mètres carrés'**
  String get unitSquareMeters;

  /// No description provided for @unitSquareInches.
  ///
  /// In fr, this message translates to:
  /// **'Pouces carrés'**
  String get unitSquareInches;

  /// No description provided for @unitSquareFeet.
  ///
  /// In fr, this message translates to:
  /// **'Pieds carrés'**
  String get unitSquareFeet;

  /// No description provided for @unitCubicCentimeters.
  ///
  /// In fr, this message translates to:
  /// **'Centimètres cubes'**
  String get unitCubicCentimeters;

  /// No description provided for @unitLiters.
  ///
  /// In fr, this message translates to:
  /// **'Litres'**
  String get unitLiters;

  /// No description provided for @unitCubicMeters.
  ///
  /// In fr, this message translates to:
  /// **'Mètres cubes'**
  String get unitCubicMeters;

  /// No description provided for @unitCubicInches.
  ///
  /// In fr, this message translates to:
  /// **'Pouces cubes'**
  String get unitCubicInches;

  /// No description provided for @unitBoardFeet.
  ///
  /// In fr, this message translates to:
  /// **'Pieds-planche'**
  String get unitBoardFeet;

  /// No description provided for @unitGrams.
  ///
  /// In fr, this message translates to:
  /// **'Grammes'**
  String get unitGrams;

  /// No description provided for @unitKilograms.
  ///
  /// In fr, this message translates to:
  /// **'Kilogrammes'**
  String get unitKilograms;

  /// No description provided for @unitTonnes.
  ///
  /// In fr, this message translates to:
  /// **'Tonnes'**
  String get unitTonnes;

  /// No description provided for @unitOunces.
  ///
  /// In fr, this message translates to:
  /// **'Onces'**
  String get unitOunces;

  /// No description provided for @unitPounds.
  ///
  /// In fr, this message translates to:
  /// **'Livres'**
  String get unitPounds;

  /// No description provided for @unitBars.
  ///
  /// In fr, this message translates to:
  /// **'Bars'**
  String get unitBars;

  /// No description provided for @unitKilopascals.
  ///
  /// In fr, this message translates to:
  /// **'Kilopascals'**
  String get unitKilopascals;

  /// No description provided for @unitMegapascals.
  ///
  /// In fr, this message translates to:
  /// **'Mégapascals'**
  String get unitMegapascals;

  /// No description provided for @unitPsi.
  ///
  /// In fr, this message translates to:
  /// **'Livres par pouce carré'**
  String get unitPsi;

  /// Segment de sélecteur : 9 caractères au plus
  ///
  /// In fr, this message translates to:
  /// **'Droit'**
  String get jointOffsetStraight;

  /// Séparateur décimal des nombres affichés ; la saisie accepte les deux
  ///
  /// In fr, this message translates to:
  /// **','**
  String get decimalSeparator;

  /// Nom du schéma cliquable pour un lecteur d'écran
  ///
  /// In fr, this message translates to:
  /// **'Agrandir le schéma'**
  String get commonExpandSchema;

  /// No description provided for @commonCopied.
  ///
  /// In fr, this message translates to:
  /// **'Copié'**
  String get commonCopied;

  /// Nom du ⓘ pour un lecteur d'écran
  ///
  /// In fr, this message translates to:
  /// **'Aide : {label}'**
  String commonHelpFor(String label);

  /// No description provided for @commonReset.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser la saisie'**
  String get commonReset;

  /// No description provided for @commonDecrement.
  ///
  /// In fr, this message translates to:
  /// **'Un de moins'**
  String get commonDecrement;

  /// No description provided for @commonIncrement.
  ///
  /// In fr, this message translates to:
  /// **'Un de plus'**
  String get commonIncrement;

  /// Légende d'unité sous chaque schéma
  ///
  /// In fr, this message translates to:
  /// **'Cotes en mm'**
  String get commonUnitNote;

  /// No description provided for @calcIncompleteInput.
  ///
  /// In fr, this message translates to:
  /// **'Saisie incomplète'**
  String get calcIncompleteInput;

  /// No description provided for @calcNonFiniteValue.
  ///
  /// In fr, this message translates to:
  /// **'Valeur non finie'**
  String get calcNonFiniteValue;

  /// No description provided for @calcNegativeLength.
  ///
  /// In fr, this message translates to:
  /// **'Longueur négative'**
  String get calcNegativeLength;

  /// No description provided for @calcInvalidDenominator.
  ///
  /// In fr, this message translates to:
  /// **'Dénominateur invalide'**
  String get calcInvalidDenominator;

  /// No description provided for @calcIncompatibleUnits.
  ///
  /// In fr, this message translates to:
  /// **'Conversion impossible : {from} ({fromQuantity}) vers {to} ({toQuantity})'**
  String calcIncompatibleUnits(
    String from,
    String fromQuantity,
    String to,
    String toQuantity,
  );

  /// No description provided for @calcInvalidLevelThreshold.
  ///
  /// In fr, this message translates to:
  /// **'Seuil de niveau invalide'**
  String get calcInvalidLevelThreshold;

  /// No description provided for @calcInvalidSensorReading.
  ///
  /// In fr, this message translates to:
  /// **'Lecture accéléromètre invalide'**
  String get calcInvalidSensorReading;

  /// Refus de saisie : nomme la cote comme l'écran
  ///
  /// In fr, this message translates to:
  /// **'La largeur totale doit être supérieure à 0'**
  String get calcPositiveTotalWidth;

  /// No description provided for @calcPositiveSurfaceWidth.
  ///
  /// In fr, this message translates to:
  /// **'La largeur de surface doit être un nombre positif'**
  String get calcPositiveSurfaceWidth;

  /// No description provided for @calcPositiveSurfaceLength.
  ///
  /// In fr, this message translates to:
  /// **'La longueur de surface doit être un nombre positif'**
  String get calcPositiveSurfaceLength;

  /// No description provided for @calcPositiveTileWidth.
  ///
  /// In fr, this message translates to:
  /// **'La largeur d\'élément doit être un nombre positif'**
  String get calcPositiveTileWidth;

  /// No description provided for @calcPositiveTileLength.
  ///
  /// In fr, this message translates to:
  /// **'La longueur d\'élément doit être un nombre positif'**
  String get calcPositiveTileLength;

  /// No description provided for @calcPositiveOpeningWidth.
  ///
  /// In fr, this message translates to:
  /// **'La largeur intérieure doit être supérieure à 0'**
  String get calcPositiveOpeningWidth;

  /// No description provided for @calcPositiveOpeningHeight.
  ///
  /// In fr, this message translates to:
  /// **'La hauteur intérieure doit être supérieure à 0'**
  String get calcPositiveOpeningHeight;

  /// No description provided for @calcPositiveOpeningDepth.
  ///
  /// In fr, this message translates to:
  /// **'La profondeur intérieure doit être supérieure à 0'**
  String get calcPositiveOpeningDepth;

  /// No description provided for @calcPositiveCarcassThickness.
  ///
  /// In fr, this message translates to:
  /// **'L\'épaisseur du caisson doit être supérieure à 0'**
  String get calcPositiveCarcassThickness;

  /// No description provided for @calcPositiveFrontThickness.
  ///
  /// In fr, this message translates to:
  /// **'L\'épaisseur de façade doit être supérieure à 0'**
  String get calcPositiveFrontThickness;

  /// No description provided for @calcPositiveSideThickness.
  ///
  /// In fr, this message translates to:
  /// **'L\'épaisseur des côtés doit être supérieure à 0'**
  String get calcPositiveSideThickness;

  /// No description provided for @calcPositiveBottomThickness.
  ///
  /// In fr, this message translates to:
  /// **'L\'épaisseur du fond doit être supérieure à 0'**
  String get calcPositiveBottomThickness;

  /// No description provided for @calcPositiveFrontHeight.
  ///
  /// In fr, this message translates to:
  /// **'Une hauteur de façade doit être supérieure à 0'**
  String get calcPositiveFrontHeight;

  /// No description provided for @calcPositiveSlideLength.
  ///
  /// In fr, this message translates to:
  /// **'La longueur de glissière doit être supérieure à 0'**
  String get calcPositiveSlideLength;

  /// No description provided for @calcPositiveGrooveDepth.
  ///
  /// In fr, this message translates to:
  /// **'La profondeur de rainure doit être supérieure à 0'**
  String get calcPositiveGrooveDepth;

  /// No description provided for @calcNonNegativeElementWidth.
  ///
  /// In fr, this message translates to:
  /// **'La largeur d\'un élément ne peut pas être négative'**
  String get calcNonNegativeElementWidth;

  /// No description provided for @calcNonNegativeMargin.
  ///
  /// In fr, this message translates to:
  /// **'Une marge ne peut pas être négative'**
  String get calcNonNegativeMargin;

  /// No description provided for @calcNonNegativeElementCount.
  ///
  /// In fr, this message translates to:
  /// **'Le nombre d\'éléments ne peut pas être négatif'**
  String get calcNonNegativeElementCount;

  /// No description provided for @calcNonNegativeTargetGap.
  ///
  /// In fr, this message translates to:
  /// **'L\'écart visé ne peut pas être négatif'**
  String get calcNonNegativeTargetGap;

  /// No description provided for @calcNonNegativeHorizontalGap.
  ///
  /// In fr, this message translates to:
  /// **'Le jeu horizontal ne peut pas être négatif'**
  String get calcNonNegativeHorizontalGap;

  /// No description provided for @calcNonNegativeVerticalGap.
  ///
  /// In fr, this message translates to:
  /// **'Le jeu vertical ne peut pas être négatif'**
  String get calcNonNegativeVerticalGap;

  /// No description provided for @calcNonNegativePerimeterGap.
  ///
  /// In fr, this message translates to:
  /// **'Le jeu périphérique ne peut pas être négatif'**
  String get calcNonNegativePerimeterGap;

  /// No description provided for @calcNonNegativeFrontGap.
  ///
  /// In fr, this message translates to:
  /// **'Le jeu entre façades ne peut pas être négatif'**
  String get calcNonNegativeFrontGap;

  /// No description provided for @calcNonNegativeSideClearance.
  ///
  /// In fr, this message translates to:
  /// **'Le jeu par côté ne peut pas être négatif'**
  String get calcNonNegativeSideClearance;

  /// No description provided for @calcNonNegativeLengthReduction.
  ///
  /// In fr, this message translates to:
  /// **'La réduction de longueur ne peut pas être négative'**
  String get calcNonNegativeLengthReduction;

  /// No description provided for @calcMarginsFillWidth.
  ///
  /// In fr, this message translates to:
  /// **'Les marges occupent toute la largeur : il ne reste rien à répartir'**
  String get calcMarginsFillWidth;

  /// No description provided for @calcTooFewElements.
  ///
  /// In fr, this message translates to:
  /// **'Cette disposition demande au moins {count, plural, one{{count} élément} other{{count} éléments}}'**
  String calcTooFewElements(int count);

  /// No description provided for @calcTooManyElements.
  ///
  /// In fr, this message translates to:
  /// **'Trop d\'éléments : {max} au maximum'**
  String calcTooManyElements(int max);

  /// No description provided for @calcElementsOverflow.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, one{{count} élément occupe} other{Les {count} éléments occupent}} {occupied} mm pour {available} mm disponibles'**
  String calcElementsOverflow(int count, String occupied, String available);

  /// No description provided for @calcWidthAndGapBothZero.
  ///
  /// In fr, this message translates to:
  /// **'Largeur et écart ne peuvent pas être nuls tous les deux'**
  String get calcWidthAndGapBothZero;

  /// No description provided for @calcNoDistributionForGap.
  ///
  /// In fr, this message translates to:
  /// **'Aucune répartition ne correspond à cet écart'**
  String get calcNoDistributionForGap;

  /// No description provided for @calcGapTooSmall.
  ///
  /// In fr, this message translates to:
  /// **'Écart trop petit : il faudrait plus de {max} éléments'**
  String calcGapTooSmall(int max);

  /// Zone à couvrir : la surface moins le jeu périphérique
  ///
  /// In fr, this message translates to:
  /// **'L\'élément fait {tileWidth} × {tileLength} mm pour une zone à couvrir de {surfaceWidth} × {surfaceLength} mm'**
  String calcTileLargerThanSurface(
    String tileWidth,
    String tileLength,
    String surfaceWidth,
    String surfaceLength,
  );

  /// L'ordre de grandeur dit où chercher la faute de frappe
  ///
  /// In fr, this message translates to:
  /// **'Cette saisie demanderait {count} éléments, {max} au maximum'**
  String calcTooManyTiles(String count, int max);

  /// No description provided for @calcPerimeterGapFillsSurface.
  ///
  /// In fr, this message translates to:
  /// **'Le jeu périphérique de {gap} mm ne laisse rien à couvrir sur {smallest} mm'**
  String calcPerimeterGapFillsSurface(String gap, String smallest);

  /// No description provided for @calcNoDrawer.
  ///
  /// In fr, this message translates to:
  /// **'Il faut au moins un tiroir'**
  String get calcNoDrawer;

  /// No description provided for @calcFrontGapsFillWidth.
  ///
  /// In fr, this message translates to:
  /// **'Les jeux autour de la façade prennent toute la largeur intérieure'**
  String get calcFrontGapsFillWidth;

  /// No description provided for @calcFrontGapsFillHeight.
  ///
  /// In fr, this message translates to:
  /// **'Les jeux entre façades prennent toute la hauteur intérieure'**
  String get calcFrontGapsFillHeight;

  /// No description provided for @calcInsetFrontFillsDepth.
  ///
  /// In fr, this message translates to:
  /// **'La façade encastrée prend toute la profondeur intérieure'**
  String get calcInsetFrontFillsDepth;

  /// No description provided for @calcSlideAndSidesTooWide.
  ///
  /// In fr, this message translates to:
  /// **'La glissière et les côtés prennent {needed} mm pour {opening} mm de largeur intérieure'**
  String calcSlideAndSidesTooWide(String needed, String opening);

  /// No description provided for @calcBoxTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Caisse trop courte : {length} mm de longueur'**
  String calcBoxTooShort(String length);

  /// No description provided for @calcBoxTooLow.
  ///
  /// In fr, this message translates to:
  /// **'Caisse trop basse : {height} mm pour le tiroir {drawer} ({minimum} au minimum)'**
  String calcBoxTooLow(String height, int drawer, String minimum);

  /// No description provided for @calcGrooveThroughSide.
  ///
  /// In fr, this message translates to:
  /// **'Une rainure de {groove} mm traverse un côté de {side} mm'**
  String calcGrooveThroughSide(String groove, String side);

  /// No description provided for @calcFixedHeightsTooTall.
  ///
  /// In fr, this message translates to:
  /// **'Les hauteurs fixées font {fixed} mm pour {available} mm de façades'**
  String calcFixedHeightsTooTall(String fixed, String available);

  /// No description provided for @calcSlideTooLong.
  ///
  /// In fr, this message translates to:
  /// **'Une glissière de {slide} mm ne tient pas dans {usefulDepth} mm de profondeur utile'**
  String calcSlideTooLong(String slide, String usefulDepth);

  /// No description provided for @calcDepthTooShortForSlides.
  ///
  /// In fr, this message translates to:
  /// **'La profondeur utile ({usefulDepth} mm) est plus courte que la plus petite glissière ({shortest} mm)'**
  String calcDepthTooShortForSlides(String usefulDepth, String shortest);

  /// No description provided for @converterQuantity.
  ///
  /// In fr, this message translates to:
  /// **'Grandeur'**
  String get converterQuantity;

  /// No description provided for @converterValue.
  ///
  /// In fr, this message translates to:
  /// **'Valeur'**
  String get converterValue;

  /// No description provided for @converterSourceUnit.
  ///
  /// In fr, this message translates to:
  /// **'Unité source'**
  String get converterSourceUnit;

  /// No description provided for @converterCompoundImperial.
  ///
  /// In fr, this message translates to:
  /// **'Impérial composé'**
  String get converterCompoundImperial;

  /// No description provided for @converterCompoundImperialHelp.
  ///
  /// In fr, this message translates to:
  /// **'Pied + pouce + fraction, arrondi au 1/16 de pouce.'**
  String get converterCompoundImperialHelp;

  /// Note de ResultTile, une ligne : le tiret sépare
  ///
  /// In fr, this message translates to:
  /// **'L’unité d’achat du bois dur — 144 po³'**
  String get converterBoardFootNote;

  /// No description provided for @converterImperial.
  ///
  /// In fr, this message translates to:
  /// **'Impérial'**
  String get converterImperial;

  /// No description provided for @converterImperialNote.
  ///
  /// In fr, this message translates to:
  /// **'Arrondi au 1/16 de pouce'**
  String get converterImperialNote;

  /// Légende de schéma
  ///
  /// In fr, this message translates to:
  /// **'Rapport hors échelle — formes non à l’échelle'**
  String get converterOutOfScale;

  /// No description provided for @levelRoll.
  ///
  /// In fr, this message translates to:
  /// **'Inclinaison latérale'**
  String get levelRoll;

  /// No description provided for @levelRollNote.
  ///
  /// In fr, this message translates to:
  /// **'Gauche ⇄ droite'**
  String get levelRollNote;

  /// No description provided for @levelPitch.
  ///
  /// In fr, this message translates to:
  /// **'Inclinaison longitudinale'**
  String get levelPitch;

  /// No description provided for @levelPitchNote.
  ///
  /// In fr, this message translates to:
  /// **'Avant ⇄ arrière'**
  String get levelPitchNote;

  /// No description provided for @levelState.
  ///
  /// In fr, this message translates to:
  /// **'État'**
  String get levelState;

  /// Aussi dessiné sous la fiole
  ///
  /// In fr, this message translates to:
  /// **'À plat'**
  String get levelFlat;

  /// No description provided for @levelOff.
  ///
  /// In fr, this message translates to:
  /// **'Hors niveau'**
  String get levelOff;

  /// No description provided for @levelFromHorizontal.
  ///
  /// In fr, this message translates to:
  /// **'Par rapport à l’horizontale'**
  String get levelFromHorizontal;

  /// No description provided for @levelFromZero.
  ///
  /// In fr, this message translates to:
  /// **'Par rapport au zéro posé'**
  String get levelFromZero;

  /// No description provided for @levelSetZero.
  ///
  /// In fr, this message translates to:
  /// **'Mettre à zéro'**
  String get levelSetZero;

  /// No description provided for @levelCancelZero.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get levelCancelZero;

  /// No description provided for @levelHorizontalHelp.
  ///
  /// In fr, this message translates to:
  /// **'Les angles sont donnés par rapport à l’horizontale.'**
  String get levelHorizontalHelp;

  /// No description provided for @levelZeroHelp.
  ///
  /// In fr, this message translates to:
  /// **'Zéro posé : les angles sont relatifs à la surface calibrée.'**
  String get levelZeroHelp;

  /// No description provided for @levelSensorUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Accéléromètre indisponible'**
  String get levelSensorUnavailable;

  /// No description provided for @levelSensorUnavailableHelp.
  ///
  /// In fr, this message translates to:
  /// **'Cet outil demande un appareil équipé d’un accéléromètre.'**
  String get levelSensorUnavailableHelp;

  /// No description provided for @distributionModeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mode de calcul'**
  String get distributionModeLabel;

  /// Segment de sélecteur : 9 caractères au plus, sauf vérification sur appareil
  ///
  /// In fr, this message translates to:
  /// **'Calcul écart'**
  String get distributionModeSpacing;

  /// No description provided for @distributionModeCount.
  ///
  /// In fr, this message translates to:
  /// **'Calcul nombre'**
  String get distributionModeCount;

  /// Un bord de rangée, dans « Élément – Écart »
  ///
  /// In fr, this message translates to:
  /// **'Élément'**
  String get distributionEdgeElement;

  /// No description provided for @distributionEdgeGap.
  ///
  /// In fr, this message translates to:
  /// **'Écart'**
  String get distributionEdgeGap;

  /// Une disposition : bord de début, bord de fin
  ///
  /// In fr, this message translates to:
  /// **'{start} – {end}'**
  String distributionEdgePair(String start, String end);

  /// No description provided for @distributionGeometry.
  ///
  /// In fr, this message translates to:
  /// **'Géométrie'**
  String get distributionGeometry;

  /// No description provided for @distributionLength.
  ///
  /// In fr, this message translates to:
  /// **'Largeur totale'**
  String get distributionLength;

  /// No description provided for @distributionElementWidth.
  ///
  /// In fr, this message translates to:
  /// **'Largeur d’un élément'**
  String get distributionElementWidth;

  /// No description provided for @distributionCount.
  ///
  /// In fr, this message translates to:
  /// **'Nombre d’éléments'**
  String get distributionCount;

  /// No description provided for @distributionTargetSpacing.
  ///
  /// In fr, this message translates to:
  /// **'Écart souhaité'**
  String get distributionTargetSpacing;

  /// No description provided for @distributionTargetSpacingHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le nombre d’éléments s’ajuste au plus proche.'**
  String get distributionTargetSpacingHelp;

  /// No description provided for @distributionEdgesGroup.
  ///
  /// In fr, this message translates to:
  /// **'Bords et marges'**
  String get distributionEdgesGroup;

  /// No description provided for @distributionEdges.
  ///
  /// In fr, this message translates to:
  /// **'Type de répartition'**
  String get distributionEdges;

  /// No description provided for @distributionMargins.
  ///
  /// In fr, this message translates to:
  /// **'Marges'**
  String get distributionMargins;

  /// No description provided for @distributionMarginsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Réservées avant répartition — un chant, un tasseau en place.'**
  String get distributionMarginsHelp;

  /// No description provided for @distributionSymmetric.
  ///
  /// In fr, this message translates to:
  /// **'Symétriques'**
  String get distributionSymmetric;

  /// No description provided for @distributionAsymmetric.
  ///
  /// In fr, this message translates to:
  /// **'Asymétriques'**
  String get distributionAsymmetric;

  /// No description provided for @distributionMargin.
  ///
  /// In fr, this message translates to:
  /// **'Marge'**
  String get distributionMargin;

  /// No description provided for @distributionMarginStart.
  ///
  /// In fr, this message translates to:
  /// **'Marge début'**
  String get distributionMarginStart;

  /// No description provided for @distributionMarginEnd.
  ///
  /// In fr, this message translates to:
  /// **'Marge fin'**
  String get distributionMarginEnd;

  /// Résumé du groupe replié
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, one{{count} élément} other{{count} éléments}} de {width} sur {length} mm'**
  String distributionSummaryCount(int count, String width, String length);

  /// Sans largeur d'élément, les éléments sont des repères
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, one{{count} repère} other{{count} repères}} sur {length} mm'**
  String distributionSummaryCountMarks(int count, String length);

  /// No description provided for @distributionSummaryTarget.
  ///
  /// In fr, this message translates to:
  /// **'Éléments de {width} sur {length} mm · écart visé {target} mm'**
  String distributionSummaryTarget(String width, String length, String target);

  /// No description provided for @distributionSummaryTargetMarks.
  ///
  /// In fr, this message translates to:
  /// **'Repères sur {length} mm · écart visé {target} mm'**
  String distributionSummaryTargetMarks(String length, String target);

  /// No description provided for @distributionSummaryEdges.
  ///
  /// In fr, this message translates to:
  /// **'{edges} · marges {margins} mm'**
  String distributionSummaryEdges(String edges, String margins);

  /// No description provided for @distributionCountNote.
  ///
  /// In fr, this message translates to:
  /// **'Pour un écart visé de {target} mm'**
  String distributionCountNote(String target);

  /// No description provided for @distributionGapObtained.
  ///
  /// In fr, this message translates to:
  /// **'Écart obtenu'**
  String get distributionGapObtained;

  /// No description provided for @distributionGap.
  ///
  /// In fr, this message translates to:
  /// **'Écart'**
  String get distributionGap;

  /// No description provided for @distributionPitch.
  ///
  /// In fr, this message translates to:
  /// **'Entraxe'**
  String get distributionPitch;

  /// No description provided for @distributionPitchNote.
  ///
  /// In fr, this message translates to:
  /// **'D’un bord d’élément au bord suivant'**
  String get distributionPitchNote;

  /// No description provided for @distributionGapRule.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, one{{count} élément} other{{count} éléments}} → {gaps, plural, one{{gaps} écart} other{{gaps} écarts}}'**
  String distributionGapRule(int count, int gaps);

  /// No description provided for @distributionCalloutExact.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, one{{count} élément} other{{count} éléments}} · {spacing} mm exact'**
  String distributionCalloutExact(int count, String spacing);

  /// No description provided for @distributionCalloutOther.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, one{{count} élément} other{{count} éléments}} → {spacing} mm réel'**
  String distributionCalloutOther(int count, String spacing);

  /// Annonce du lecteur d'écran
  ///
  /// In fr, this message translates to:
  /// **'Prendre {count, plural, one{{count} élément} other{{count} éléments}}, écart de {spacing} millimètres'**
  String distributionCalloutAdoptLabel(int count, String spacing);

  /// No description provided for @distributionCalloutAdopt.
  ///
  /// In fr, this message translates to:
  /// **'Prendre'**
  String get distributionCalloutAdopt;

  /// No description provided for @distributionPositions.
  ///
  /// In fr, this message translates to:
  /// **'Positions depuis l’origine'**
  String get distributionPositions;

  /// No description provided for @distributionNoElement.
  ///
  /// In fr, this message translates to:
  /// **'Aucun élément'**
  String get distributionNoElement;

  /// En-tête de colonne, suivi de « (mm) »
  ///
  /// In fr, this message translates to:
  /// **'Bord'**
  String get distributionEdgeColumn;

  /// No description provided for @distributionPositionColumn.
  ///
  /// In fr, this message translates to:
  /// **'Position'**
  String get distributionPositionColumn;

  /// No description provided for @distributionCenterColumn.
  ///
  /// In fr, this message translates to:
  /// **'Centre'**
  String get distributionCenterColumn;

  /// No description provided for @distributionSchemaStart.
  ///
  /// In fr, this message translates to:
  /// **'Début'**
  String get distributionSchemaStart;

  /// No description provided for @distributionSchemaEnd.
  ///
  /// In fr, this message translates to:
  /// **'Fin'**
  String get distributionSchemaEnd;

  /// No description provided for @distributionSchemaLegend.
  ///
  /// In fr, this message translates to:
  /// **'Cotes en mm — Détails ×{zoom}'**
  String distributionSchemaLegend(String zoom);

  /// Case du cartouche, mise en capitales
  ///
  /// In fr, this message translates to:
  /// **'Éléments'**
  String get distributionPlanElements;

  /// No description provided for @distributionPlanGaps.
  ///
  /// In fr, this message translates to:
  /// **'Écarts'**
  String get distributionPlanGaps;

  /// No description provided for @distributionPlanFallback.
  ///
  /// In fr, this message translates to:
  /// **'{count} positions — à copier depuis l’app'**
  String distributionPlanFallback(int count);

  /// No description provided for @distributionAboutModeBody.
  ///
  /// In fr, this message translates to:
  /// **'Détermine si l’écart entre les éléments ou leur nombre doit être calculé à partir des autres valeurs.'**
  String get distributionAboutModeBody;

  /// No description provided for @distributionAboutModeSpacing.
  ///
  /// In fr, this message translates to:
  /// **'Calcul écart : vous donnez le nombre d’éléments, l’outil rend l’écart entre eux.'**
  String get distributionAboutModeSpacing;

  /// No description provided for @distributionAboutModeCount.
  ///
  /// In fr, this message translates to:
  /// **'Calcul nombre : vous donnez l’écart voulu, l’outil rend le nombre d’éléments qui s’en approche le plus.'**
  String get distributionAboutModeCount;

  /// No description provided for @distributionAboutLengthBody.
  ///
  /// In fr, this message translates to:
  /// **'Largeur totale disponible pour répartir les éléments : l’intérieur du cadre, l’entre-deux poteaux.'**
  String get distributionAboutLengthBody;

  /// No description provided for @distributionAboutElementWidthBody.
  ///
  /// In fr, this message translates to:
  /// **'Largeur occupée par chaque élément (barreau, lame, étagère). Saisissez 0 pour positionner des repères, traçages ou axes de perçage.'**
  String get distributionAboutElementWidthBody;

  /// No description provided for @distributionAboutCountBody.
  ///
  /// In fr, this message translates to:
  /// **'Nombre d’éléments à répartir dans la largeur disponible.\n\nUne disposition qui démarre ou finit par un élément en exige au moins un. Deux si elle fait les deux. Le champ ne descend pas en dessous, et plafonne à 500.'**
  String get distributionAboutCountBody;

  /// No description provided for @distributionAboutTargetBody.
  ///
  /// In fr, this message translates to:
  /// **'Distance souhaitée entre deux éléments consécutifs. Ne tombe presque jamais juste : le nombre d’éléments est entier, l’écart ne l’est pas. L’outil rend donc les deux répartitions entières qui encadrent votre cible, la plus proche en premier. Si vous avez un maximum à ne pas dépasser (un barreaudage à 110 mm) lisez la plus serrée des deux.'**
  String get distributionAboutTargetBody;

  /// No description provided for @distributionAboutEdgesBody.
  ///
  /// In fr, this message translates to:
  /// **'Définit par quoi la rangée commence et finit : un élément collé au bord, ou un écart. Chaque combinaison change le nombre d’écarts, donc le résultat. Le schéma de chaque tuile le montre.'**
  String get distributionAboutEdgesBody;

  /// No description provided for @distributionAboutMarginsBody.
  ///
  /// In fr, this message translates to:
  /// **'Définit si les deux marges se règlent ensemble ou séparément. Une marge réserve une bande à une extrémité (un chant, un tasseau déjà en place), retirée de la largeur totale avant le calcul.'**
  String get distributionAboutMarginsBody;

  /// No description provided for @distributionAboutMarginsSymmetric.
  ///
  /// In fr, this message translates to:
  /// **'Symétriques : une seule marge, reprise à l’identique des deux côtés.'**
  String get distributionAboutMarginsSymmetric;

  /// No description provided for @distributionAboutMarginsAsymmetric.
  ///
  /// In fr, this message translates to:
  /// **'Asymétriques : une marge par côté. C’est le cas dès qu’une extrémité est contrainte et pas l’autre.'**
  String get distributionAboutMarginsAsymmetric;

  /// No description provided for @distributionAboutMarginBody.
  ///
  /// In fr, this message translates to:
  /// **'Marge identique au début et à la fin. Sa valeur est retirée de la largeur totale avant le calcul de la répartition.'**
  String get distributionAboutMarginBody;

  /// No description provided for @distributionAboutMarginStartBody.
  ///
  /// In fr, this message translates to:
  /// **'Marge appliquée au début, côté gauche du schéma. Sa valeur est retirée de la largeur totale avant le calcul de la répartition.'**
  String get distributionAboutMarginStartBody;

  /// No description provided for @distributionAboutMarginEndBody.
  ///
  /// In fr, this message translates to:
  /// **'Marge appliquée à la fin, côté droit du schéma. Sa valeur est retirée de la largeur totale avant le calcul de la répartition.'**
  String get distributionAboutMarginEndBody;

  /// Case du cartouche, mise en capitales
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get planDate;

  /// En-tête de la colonne des numéros
  ///
  /// In fr, this message translates to:
  /// **'N°'**
  String get planIndex;

  /// No description provided for @layoutSurfaceGroup.
  ///
  /// In fr, this message translates to:
  /// **'Surface'**
  String get layoutSurfaceGroup;

  /// Libellé à deux étages : le tiret sépare
  ///
  /// In fr, this message translates to:
  /// **'Surface — largeur'**
  String get layoutSurfaceWidth;

  /// No description provided for @layoutSurfaceLength.
  ///
  /// In fr, this message translates to:
  /// **'Surface — longueur'**
  String get layoutSurfaceLength;

  /// No description provided for @layoutElementGroup.
  ///
  /// In fr, this message translates to:
  /// **'Élément et pose'**
  String get layoutElementGroup;

  /// No description provided for @layoutMaterial.
  ///
  /// In fr, this message translates to:
  /// **'Matériau'**
  String get layoutMaterial;

  /// No description provided for @layoutCustom.
  ///
  /// In fr, this message translates to:
  /// **'Personnalisé'**
  String get layoutCustom;

  /// Nom de produit, suivi de son format : la valeur fermée du sélecteur tronque en silence
  ///
  /// In fr, this message translates to:
  /// **'Placo'**
  String get layoutMaterialDrywall;

  /// No description provided for @layoutMaterialTile.
  ///
  /// In fr, this message translates to:
  /// **'Carrelage'**
  String get layoutMaterialTile;

  /// No description provided for @layoutMaterialFlooring.
  ///
  /// In fr, this message translates to:
  /// **'Parquet'**
  String get layoutMaterialFlooring;

  /// No description provided for @layoutMaterialDecking.
  ///
  /// In fr, this message translates to:
  /// **'Terrasse'**
  String get layoutMaterialDecking;

  /// No description provided for @layoutMaterialPanel.
  ///
  /// In fr, this message translates to:
  /// **'Panneau'**
  String get layoutMaterialPanel;

  /// No description provided for @layoutElementWidth.
  ///
  /// In fr, this message translates to:
  /// **'Élément — largeur'**
  String get layoutElementWidth;

  /// No description provided for @layoutElementLength.
  ///
  /// In fr, this message translates to:
  /// **'Élément — longueur'**
  String get layoutElementLength;

  /// No description provided for @layoutOffset.
  ///
  /// In fr, this message translates to:
  /// **'Décalage des joints'**
  String get layoutOffset;

  /// No description provided for @layoutFlip.
  ///
  /// In fr, this message translates to:
  /// **'Inverser l’orientation'**
  String get layoutFlip;

  /// No description provided for @layoutFlipHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le décalage de joints suit.'**
  String get layoutFlipHelp;

  /// No description provided for @layoutBalance.
  ///
  /// In fr, this message translates to:
  /// **'Équilibrer les rangées'**
  String get layoutBalance;

  /// No description provided for @layoutBalanceHelp.
  ///
  /// In fr, this message translates to:
  /// **'Évite de finir sur une rangée plus mince qu’un demi-élément.'**
  String get layoutBalanceHelp;

  /// No description provided for @layoutSummaryOffset.
  ///
  /// In fr, this message translates to:
  /// **'décalage {offset}'**
  String layoutSummaryOffset(String offset);

  /// No description provided for @layoutSummaryFlipped.
  ///
  /// In fr, this message translates to:
  /// **'orientation inversée'**
  String get layoutSummaryFlipped;

  /// No description provided for @layoutSummaryBalanced.
  ///
  /// In fr, this message translates to:
  /// **'rangées équilibrées'**
  String get layoutSummaryBalanced;

  /// No description provided for @layoutGapsGroup.
  ///
  /// In fr, this message translates to:
  /// **'Jeux'**
  String get layoutGapsGroup;

  /// No description provided for @layoutGapX.
  ///
  /// In fr, this message translates to:
  /// **'Jeu horizontal'**
  String get layoutGapX;

  /// No description provided for @layoutGapY.
  ///
  /// In fr, this message translates to:
  /// **'Jeu vertical'**
  String get layoutGapY;

  /// No description provided for @layoutPerimeterGap.
  ///
  /// In fr, this message translates to:
  /// **'Jeu périphérique'**
  String get layoutPerimeterGap;

  /// No description provided for @layoutPerimeterGapHelp.
  ///
  /// In fr, this message translates to:
  /// **'Retrait tout autour de la pose, contre les quatre bords.'**
  String get layoutPerimeterGapHelp;

  /// No description provided for @layoutNoGap.
  ///
  /// In fr, this message translates to:
  /// **'Aucun jeu'**
  String get layoutNoGap;

  /// No description provided for @layoutSummaryGaps.
  ///
  /// In fr, this message translates to:
  /// **'entre éléments {x} × {y} · périphérique {perimeter} mm'**
  String layoutSummaryGaps(String x, String y, String perimeter);

  /// No description provided for @layoutFullCount.
  ///
  /// In fr, this message translates to:
  /// **'Éléments entiers'**
  String get layoutFullCount;

  /// No description provided for @layoutCutCount.
  ///
  /// In fr, this message translates to:
  /// **'Éléments à couper'**
  String get layoutCutCount;

  /// No description provided for @layoutCutNote.
  ///
  /// In fr, this message translates to:
  /// **'Surlignés en orange sur le schéma'**
  String get layoutCutNote;

  /// No description provided for @layoutBalancedRows.
  ///
  /// In fr, this message translates to:
  /// **'Rangées de bord'**
  String get layoutBalancedRows;

  /// No description provided for @layoutBalancedNote.
  ///
  /// In fr, this message translates to:
  /// **'Première et dernière, à la même épaisseur'**
  String get layoutBalancedNote;

  /// No description provided for @layoutBalancedEndNote.
  ///
  /// In fr, this message translates to:
  /// **'Première et dernière, à la même épaisseur. Pièces de bout : {end} mm'**
  String layoutBalancedEndNote(String end);

  /// No description provided for @layoutTotal.
  ///
  /// In fr, this message translates to:
  /// **'Total à prévoir'**
  String get layoutTotal;

  /// No description provided for @layoutTotalNote.
  ///
  /// In fr, this message translates to:
  /// **'Stock sans réemploi des chutes'**
  String get layoutTotalNote;

  /// No description provided for @layoutSurface.
  ///
  /// In fr, this message translates to:
  /// **'Surface'**
  String get layoutSurface;

  /// No description provided for @layoutCovered.
  ///
  /// In fr, this message translates to:
  /// **'Couverte : {area} m²'**
  String layoutCovered(String area);

  /// No description provided for @layoutWaste.
  ///
  /// In fr, this message translates to:
  /// **'Perte'**
  String get layoutWaste;

  /// No description provided for @layoutWasteNote.
  ///
  /// In fr, this message translates to:
  /// **'Sans réemploi des chutes — estimation pessimiste'**
  String get layoutWasteNote;

  /// Case du cartouche, mise en capitales
  ///
  /// In fr, this message translates to:
  /// **'Élément'**
  String get layoutPlanElement;

  /// No description provided for @layoutPlanOffset.
  ///
  /// In fr, this message translates to:
  /// **'Décalage'**
  String get layoutPlanOffset;

  /// No description provided for @layoutPlanGap.
  ///
  /// In fr, this message translates to:
  /// **'Jeu'**
  String get layoutPlanGap;

  /// No description provided for @layoutPlanPerimeterGap.
  ///
  /// In fr, this message translates to:
  /// **'Jeu périph.'**
  String get layoutPlanPerimeterGap;

  /// No description provided for @layoutPlanFull.
  ///
  /// In fr, this message translates to:
  /// **'Entiers'**
  String get layoutPlanFull;

  /// No description provided for @layoutPlanCut.
  ///
  /// In fr, this message translates to:
  /// **'À couper'**
  String get layoutPlanCut;

  /// No description provided for @layoutPlanTotal.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get layoutPlanTotal;

  /// No description provided for @layoutPlanWaste.
  ///
  /// In fr, this message translates to:
  /// **'Perte'**
  String get layoutPlanWaste;

  /// No description provided for @layoutPlanCuts.
  ///
  /// In fr, this message translates to:
  /// **'Pièces à couper'**
  String get layoutPlanCuts;

  /// En-tête de colonne, suivi de « (mm) »
  ///
  /// In fr, this message translates to:
  /// **'Larg.'**
  String get layoutPlanWidthColumn;

  /// No description provided for @layoutPlanLengthColumn.
  ///
  /// In fr, this message translates to:
  /// **'Long.'**
  String get layoutPlanLengthColumn;

  /// No description provided for @layoutPlanCountColumn.
  ///
  /// In fr, this message translates to:
  /// **'Nb'**
  String get layoutPlanCountColumn;

  /// No description provided for @layoutPlanNoCut.
  ///
  /// In fr, this message translates to:
  /// **'Aucune coupe, tout tombe juste'**
  String get layoutPlanNoCut;

  /// No description provided for @layoutPlanCutsFallback.
  ///
  /// In fr, this message translates to:
  /// **'{count} cotes de coupe — à lire dans l’app'**
  String layoutPlanCutsFallback(int count);

  /// No description provided for @layoutPlanNote.
  ///
  /// In fr, this message translates to:
  /// **'Perte estimée sans réemploi des chutes. Chaque coupe consomme un élément entier.'**
  String get layoutPlanNote;

  /// No description provided for @layoutAboutPerimeterBody.
  ///
  /// In fr, this message translates to:
  /// **'Le retrait laissé tout autour de la pose, contre les quatre bords. La pièce ne rétrécit pas : c’est la pose qui recule, donc la surface annoncée reste celle du sol ou du mur.'**
  String get layoutAboutPerimeterBody;

  /// No description provided for @layoutAboutPerimeterFlooring.
  ///
  /// In fr, this message translates to:
  /// **'Parquet et stratifié : le joint de dilatation, autour de 10 mm.'**
  String get layoutAboutPerimeterFlooring;

  /// No description provided for @layoutAboutPerimeterTile.
  ///
  /// In fr, this message translates to:
  /// **'Carrelage : le joint au mur, autour de 5 mm.'**
  String get layoutAboutPerimeterTile;

  /// No description provided for @layoutAboutPerimeterDrywall.
  ///
  /// In fr, this message translates to:
  /// **'Plaque de plâtre : le jeu au sol, autour de 10 mm.'**
  String get layoutAboutPerimeterDrywall;

  /// No description provided for @layoutAboutPerimeterNone.
  ///
  /// In fr, this message translates to:
  /// **'Une pose jointive contre les murs se laisse à 0.'**
  String get layoutAboutPerimeterNone;

  /// No description provided for @layoutAboutOffsetBody.
  ///
  /// In fr, this message translates to:
  /// **'De combien chaque rangée démarre en retrait de la précédente. Le décalage suit le sens de pose : inverser l’orientation le fait pivoter avec le reste du motif.'**
  String get layoutAboutOffsetBody;

  /// No description provided for @layoutAboutOffsetStraight.
  ///
  /// In fr, this message translates to:
  /// **'Droit : toutes les rangées démarrent au même endroit, les joints s’alignent en croix.'**
  String get layoutAboutOffsetStraight;

  /// No description provided for @layoutAboutOffsetHalf.
  ///
  /// In fr, this message translates to:
  /// **'½ : le décalage classique des lames courtes et des plaques.'**
  String get layoutAboutOffsetHalf;

  /// No description provided for @layoutAboutOffsetThird.
  ///
  /// In fr, this message translates to:
  /// **'⅓ : la règle des carreaux et des lames de plus de 60 cm, où un demi décalage fait tuiler le milieu de l’élément.'**
  String get layoutAboutOffsetThird;

  /// No description provided for @layoutAboutOffsetSquare.
  ///
  /// In fr, this message translates to:
  /// **'Sur un élément carré ou une plaque pleine, l’effet reste marginal.'**
  String get layoutAboutOffsetSquare;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
