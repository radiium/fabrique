import 'dart:ui';

/// Langue de repli quand le téléphone n'en préfère aucune que l'app parle.
///
/// L'anglais plutôt que le français : c'est celle que lit le plus probablement
/// un téléphone réglé dans une troisième langue.
const Locale kFallbackLocale = Locale('en');

/// Choisit la langue de l'app parmi les langues préférées du téléphone.
///
/// La première langue prise en charge l'emporte, sans regarder la région :
/// `fr_CA` et `fr_BE` lisent le français. Même signature que
/// `localeListResolutionCallback`.
Locale resolveAppLocale(List<Locale>? preferred, Iterable<Locale> supported) {
  for (final locale in preferred ?? const <Locale>[]) {
    for (final candidate in supported) {
      if (candidate.languageCode == locale.languageCode) return candidate;
    }
  }
  return kFallbackLocale;
}
