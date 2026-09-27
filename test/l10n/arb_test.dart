import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Les ARB des deux langues, clé pour clé.
///
/// `gen-l10n` ne fait qu'avertir d'une clé manquante, et l'app afficherait
/// alors le français au milieu de l'anglais.
void main() {
  Map<String, dynamic> read(String locale) =>
      jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
          as Map<String, dynamic>;

  Set<String> messages(Map<String, dynamic> arb) =>
      arb.keys.where((key) => !key.startsWith('@')).toSet();

  /// Les `{placeholders}` d'un message, pluriels ICU compris.
  Set<String> placeholders(String message) =>
      RegExp(r'\{(\w+)[,}]')
          .allMatches(message)
          .map((m) => m.group(1)!)
          .toSet();

  final fr = read('fr');
  final en = read('en');

  test('l’anglais a exactement les clés du français', () {
    expect(messages(en), messages(fr));
  });

  test('chaque message garde ses paramètres d’une langue à l’autre', () {
    for (final key in messages(fr)) {
      expect(
        placeholders(en[key] as String),
        placeholders(fr[key] as String),
        reason: key,
      );
    }
  });
}
