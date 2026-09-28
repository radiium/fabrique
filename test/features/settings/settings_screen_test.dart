import 'package:fabrique/app/app.dart';
import 'package:fabrique/app/router.dart';
import 'package:fabrique/app/routes.dart';
import 'package:fabrique/core/persistence/preferences_store.dart';
import 'package:fabrique/core/persistence/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/phone.dart';

void main() {
  testWidgets('choisir English passe toute l’app en anglais', (tester) async {
    usePhone(tester);
    tester.platformDispatcher.localesTestValue = const [Locale('fr')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    SharedPreferences.setMockInitialValues({});
    final store = await PreferencesStore.open();

    final container = ProviderContainer(
      overrides: [preferencesStoreProvider.overrideWith((ref) => store)],
    );
    addTearDown(container.dispose);
    container.read(routerProvider).go(AppRoutes.settings);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const FabriqueApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Réglages'), findsOneWidget);

    await tester.tap(find.text('Langue du téléphone'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('English'), findsWidgets);
  });

  testWidgets('en « système », un téléphone en allemand lit le français', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const [Locale('de')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    SharedPreferences.setMockInitialValues({});
    final store = await PreferencesStore.open();

    final container = ProviderContainer(
      overrides: [preferencesStoreProvider.overrideWith((ref) => store)],
    );
    addTearDown(container.dispose);
    container.read(routerProvider).go(AppRoutes.settings);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const FabriqueApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Réglages'), findsOneWidget);
  });
}
