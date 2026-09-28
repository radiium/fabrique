import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tool.dart';
import 'preferences_store.dart';
import 'settings_controller.dart';

/// Délai entre la dernière frappe et l'écriture sur disque.
///
/// L'écriture est aussi faite au dispose du provider.
const Duration _writeDelay = Duration(milliseconds: 400);

/// Branche un notifier de saisie sur le disque : il restaure la dernière
/// saisie de son outil au `build()`, et enregistre les suivantes.
///
/// `restore()` remplace le retour du `build()`, sans toucher aux méthodes de
/// champ.
///
/// ```dart
/// class LayoutForm extends _$LayoutForm with PersistedForm<LayoutInput> {
///   @override
///   LayoutInput build() => restore();
///   // … tool, defaults, decode, encode
/// }
/// ```
mixin PersistedForm<T extends Object> on AnyNotifier<T, T> {
  /// L'outil dont on tient la saisie : il donne la clé de stockage.
  Tool get tool;

  /// Saisie de départ, si rien ne se relit, et cible de « réinitialiser ».
  T get defaults;

  T decode(Map<String, dynamic> json);

  Map<String, dynamic> encode(T input);

  /// État initial du notifier : le disque, sinon [defaults].
  ///
  /// À appeler depuis `build()` seulement : elle pose des écoutes liées au
  /// provider.
  T restore() {
    // `read` : un `watch` rebâtirait le notifier et écraserait la saisie. Sans
    // store (tests d'écran), l'outil part de ses défauts.
    final store = ref.read(preferencesStoreProvider).value;
    if (store == null) return defaults;

    final key = PreferencesStore.toolInputKey(tool.id);
    Timer? pendingWrite;
    T? unwritten;

    void flush() {
      pendingWrite?.cancel();
      pendingWrite = null;
      final value = unwritten;
      if (value == null) return;
      unwritten = null;
      unawaited(store.writeJson(key, encode(value)));
    }

    // La dernière frappe part sur disque au dispose, avant le timer.
    ref.onDispose(flush);

    listenSelf((previous, next) {
      // L'appel d'amorçage annonce ce qui sort du disque.
      if (previous == null) return;
      unwritten = next;
      pendingWrite?.cancel();
      pendingWrite = Timer(_writeDelay, flush);
    });

    return _readStored(store, key) ?? defaults;
  }

  T? _readStored(PreferencesStore store, String key) {
    try {
      final json = store.readJson(key);
      return json == null ? null : decode(json);
    } on Object catch (error) {
      // JSON tronqué ou d'un ancien modèle : on repart des défauts et on
      // efface, pour ne pas rejouer l'échec.
      debugPrint('Saisie enregistrée illisible ($key), effacée : $error');
      unawaited(store.remove(key));
      return null;
    }
  }
}
