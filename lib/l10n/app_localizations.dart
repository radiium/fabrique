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
