import 'dart:ui';

import 'package:fabrique/app/locale.dart';
import 'package:fabrique/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Locale resolve(List<Locale>? preferred) =>
      resolveAppLocale(preferred, AppLocalizations.supportedLocales);

  test('un français régional lit le français', () {
    expect(resolve(const [Locale('fr', 'CA')]), const Locale('fr'));
  });

  test('la première langue prise en charge l’emporte', () {
    expect(
      resolve(const [Locale('de'), Locale('en', 'GB'), Locale('fr')]),
      const Locale('en'),
    );
  });

  test('sans langue prise en charge, l’app parle anglais', () {
    expect(resolve(const [Locale('de'), Locale('ja')]), kFallbackLocale);
    expect(resolve(null), kFallbackLocale);
  });
}
