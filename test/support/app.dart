import 'package:fabrique/app/router.dart';
import 'package:fabrique/app/theme.dart';
import 'package:fabrique/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Monte l'app entière, routeur compris, sur [location].
///
/// Rend le routeur, pour naviguer ensuite sans remonter un second arbre.
/// Le français par défaut : c'est la langue de référence des textes.
Future<GoRouter> pumpApp(
  WidgetTester tester,
  String location, {
  Locale locale = const Locale('fr'),
}) async {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  final router = container.read(routerProvider)..go(location);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: buildAppTheme(),
        routerConfig: router,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

/// Une `MaterialApp` de test : le thème et les textes de l'app, sans routeur.
///
/// Tout widget qui lit `AppLocalizations` a besoin de ses délégués, jusqu'au
/// plus petit contrôle partagé.
Widget testApp({required Widget home, Locale locale = const Locale('fr')}) =>
    MaterialApp(
      theme: buildAppTheme(),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: home,
    );
