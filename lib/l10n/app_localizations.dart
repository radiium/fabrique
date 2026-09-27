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
