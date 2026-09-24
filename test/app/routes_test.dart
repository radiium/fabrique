import 'package:fabrique/app/router.dart';
import 'package:fabrique/app/routes.dart';
import 'package:fabrique/core/models/tool.dart';
import 'package:fabrique/features/converter/converter_screen.dart';
import 'package:fabrique/features/distribution/distribution_screen.dart';
import 'package:fabrique/features/fasteners/fasteners_screen.dart';
import 'package:fabrique/features/home/home_screen.dart';
import 'package:fabrique/features/layout/layout_screen.dart';
import 'package:fabrique/features/level/level_screen.dart';
import 'package:fabrique/features/playground/playground_screen.dart';
import 'package:fabrique/features/schema/schema_screen.dart';
import 'package:fabrique/features/settings/settings_screen.dart';
import 'package:fabrique/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Les chemins sont construits par `AppRoutes`, les segments déclarés par le
/// routeur : rien ne relie les deux à la compilation, seulement ce test.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  /// Monte l'app sur [location], et rend son routeur pour naviguer ensuite
  /// sans remonter un second arbre.
  Future<GoRouter> pumpAt(WidgetTester tester, String location) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final router = container.read(routerProvider)..go(location);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('fr'),
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

  testWidgets('l’accueil, les réglages et le playground ont leur écran', (
    tester,
  ) async {
    final router = await pumpAt(tester, AppRoutes.home);
    expect(find.byType(HomeScreen), findsOneWidget);

    router.go(AppRoutes.settings);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    router.go(AppRoutes.playground);
    await tester.pumpAndSettle();
    expect(find.byType(PlaygroundScreen), findsOneWidget);
  });

  for (final tool in Tool.values) {
    testWidgets('${tool.label} a son écran et sa page de schéma', (
      tester,
    ) async {
      final router = await pumpAt(tester, AppRoutes.tool(tool));
      final screen = switch (tool) {
        Tool.layout => LayoutScreen,
        Tool.distribution => DistributionScreen,
        Tool.fasteners => FastenersScreen,
        Tool.level => LevelScreen,
        Tool.converter => ConverterScreen,
      };
      expect(find.byType(screen), findsOneWidget);

      router.go(AppRoutes.schema(tool));
      await tester.pumpAndSettle();
      expect(find.byType(SchemaScreen), findsOneWidget);
    });
  }
}
