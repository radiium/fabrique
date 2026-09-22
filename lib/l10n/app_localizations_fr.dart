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
  String get languageFrench => 'Français';

  @override
  String get settingsLockedSection => 'Verrouillé pour cette version';

  @override
  String get settingsLoadFailed => 'Réglages illisibles';
}
