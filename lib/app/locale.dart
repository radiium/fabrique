import 'dart:ui';

/// Langue de repli quand le téléphone n'en préfère aucune que l'app parle.
const Locale kFallbackLocale = Locale('fr');

/// Choisit la langue de l'app parmi les langues préférées du téléphone.
///
/// La première langue prise en charge l'emporte, sans regarder la région.
/// Même signature que `localeListResolutionCallback`.
Locale resolveAppLocale(List<Locale>? preferred, Iterable<Locale> supported) {
  for (final locale in preferred ?? const <Locale>[]) {
    for (final candidate in supported) {
      if (candidate.languageCode == locale.languageCode) return candidate;
    }
  }
  return kFallbackLocale;
}
