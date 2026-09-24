import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/persistence/preferences_store.dart';
import 'core/persistence/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Le store est ouvert **avant** `runApp` pour être disponible en synchrone :
  // chaque outil restaure sa dernière saisie dans le `build()` de son notifier,
  // qui ne peut pas attendre un `Future`. Ouvrir ici, c'est aussi garantir
  // qu'il n'arrivera jamais après coup — un store en retard rebâtirait un
  // formulaire déjà rempli, sous les doigts.
  //
  // S'il échoue, l'app démarre quand même : les outils partent de leurs
  // défauts, et l'écran Réglages affiche l'échec puisque le provider non
  // surchargé retentera l'ouverture pour son compte.
  PreferencesStore? store;
  try {
    store = await PreferencesStore.open();
  } on Object {
    store = null;
  }

  runApp(
    ProviderScope(
      overrides: [
        if (store case final opened?)
          preferencesStoreProvider.overrideWith((ref) => opened),
      ],
      child: const FabriqueApp(),
    ),
  );
}
