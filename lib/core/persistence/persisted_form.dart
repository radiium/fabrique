import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tool.dart';
import 'preferences_store.dart';
import 'settings_controller.dart';

/// Délai entre la dernière frappe et l'écriture sur disque.
///
/// Le calcul est temps réel, donc l'état change à chaque caractère ; écrire
/// autant serait absurde pour une donnée qu'on ne relit qu'au lancement. 400 ms
/// tient dans une pause de frappe, et l'écriture est de toute façon rejouée au
/// dispose du provider — quitter l'écran n'attend pas le timer.
const Duration _writeDelay = Duration(milliseconds: 400);

/// Branche un notifier de saisie sur le disque : il restaure la dernière
/// saisie de son outil au `build()`, et enregistre les suivantes.
///
/// S'applique à un notifier de saisie déjà écrit, sans rien changer à ses
/// méthodes de champ : c'est `restore()` qui remplace le retour du `build()`.
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

  /// Saisie de départ, quand rien n'est enregistré ou que ce qui l'est ne se
  /// relit pas. C'est aussi la cible du bouton « réinitialiser ».
  T get defaults;

  T decode(Map<String, dynamic> json);

  Map<String, dynamic> encode(T input);

  /// État initial du notifier : le disque, sinon [defaults].
  ///
  /// À appeler depuis `build()`, et de là seulement — elle pose des écoutes
  /// dont le cycle de vie est celui du provider.
  T restore() {
    // `read` et non `watch` : si le store arrivait après coup, un `watch`
    // rebâtirait le notifier et écraserait ce qui vient d'être tapé. Il n'a pas
    // à arriver après coup — `main()` l'ouvre avant `runApp` — et s'il manque
    // (tests d'écran, `shared_preferences` indisponible), l'outil part de ses
    // défauts sans jamais se faire reconstruire sous les doigts.
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

    // Quitter l'écran dispose le provider : la dernière frappe doit partir sur
    // disque même si le timer n'a pas encore rendu la main.
    ref.onDispose(flush);

    listenSelf((previous, next) {
      // `previous == null` est l'appel d'amorçage, juste après le build : ce
      // qu'il annonce sort du disque, le réécrire ne dirait rien de neuf.
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
    } on Object {
      // JSON tronqué, ou écrit par une version précédente du modèle. Un outil
      // qui refuse de s'ouvrir est pire que la perte d'une saisie : on repart
      // des défauts, et on efface pour ne pas rejouer l'échec à chaque
      // lancement.
      unawaited(store.remove(key));
      return null;
    }
  }
}
