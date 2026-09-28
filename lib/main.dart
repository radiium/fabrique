import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/persistence/preferences_store.dart';
import 'core/persistence/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Le store s'ouvre avant `runApp`, pour que les notifiers le lisent en
  // synchrone dans `build()`. S'il échoue, les outils partent de leurs défauts
  // et Réglages affiche l'échec.
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
