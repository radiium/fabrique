import 'dart:ui';

import 'package:fabrique/l10n/app_localizations.dart';

/// Les textes de l'app hors d'un arbre de widgets : noms de tests, painters
/// montés seuls, plans construits sans écran.
final AppLocalizations fr = lookupAppLocalizations(const Locale('fr'));
final AppLocalizations en = lookupAppLocalizations(const Locale('en'));

/// Les textes de chaque langue de l'app, pour les tests qui les passent
/// toutes en revue.
final List<AppLocalizations> allLocales = [
  for (final locale in AppLocalizations.supportedLocales)
    lookupAppLocalizations(locale),
];
