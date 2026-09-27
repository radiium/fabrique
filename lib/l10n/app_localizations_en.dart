// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fabrique';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get themeLightLocked => 'Light';

  @override
  String get haptics => 'Haptic feedback';

  @override
  String get hapticsHelp =>
      'Short vibration on the − / + buttons and selectors.';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Phone language';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsLockedSection => 'Locked for this version';

  @override
  String get settingsLoadFailed => 'Settings unreadable';
}
