import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Fine couche au-dessus de `shared_preferences`.
///
/// Les réglages globaux, et la dernière saisie de chaque outil en JSON.
class PreferencesStore {
  const PreferencesStore(this._prefs);

  final SharedPreferences _prefs;

  static Future<PreferencesStore> open() async =>
      PreferencesStore(await SharedPreferences.getInstance());

  Map<String, dynamic>? readJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : null;
  }

  Future<void> writeJson(String key, Map<String, dynamic> value) =>
      _prefs.setString(key, jsonEncode(value));

  Future<void> remove(String key) => _prefs.remove(key);

  /// Clé de la dernière saisie d'un outil, à partir de son `Tool.id`.
  static String toolInputKey(String toolId) => 'tool_input_$toolId';

  static const String settingsKey = 'settings';
}
