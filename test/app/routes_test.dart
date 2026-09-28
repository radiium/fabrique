import 'package:fabrique/app/routes.dart';
import 'package:fabrique/core/models/tool.dart';
import 'package:fabrique/features/converter/converter_screen.dart';
import 'package:fabrique/features/distribution/distribution_screen.dart';
import 'package:fabrique/features/drawers/drawers_screen.dart';
import 'package:fabrique/features/home/home_screen.dart';
import 'package:fabrique/features/layout/layout_screen.dart';
import 'package:fabrique/features/level/level_controller.dart';
import 'package:fabrique/features/level/level_screen.dart';
import 'package:fabrique/features/schema/schema_screen.dart';
import 'package:fabrique/features/settings/settings_screen.dart';
import 'package:fabrique/l10n/labels.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/app.dart';
import '../support/l10n.dart';

/// Les chemins sont construits par `AppRoutes`, les segments déclarés par le
/// routeur : rien ne relie les deux à la compilation, seulement ce test.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('l’accueil et les réglages ont leur écran', (tester) async {
    final router = await pumpApp(tester, AppRoutes.home);
    expect(find.byType(HomeScreen), findsOneWidget);

    router.go(AppRoutes.settings);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
  });

  for (final tool in Tool.values) {
    testWidgets('${tool.label(fr)} a son écran et sa page de schéma', (
      tester,
    ) async {
      final router = await pumpApp(tester, AppRoutes.tool(tool));
      final screen = switch (tool) {
        Tool.layout => LayoutScreen,
        Tool.distribution => DistributionScreen,
        Tool.drawers => DrawersScreen,
        Tool.level => LevelScreen,
        Tool.converter => ConverterScreen,
      };
      expect(find.byType(screen), findsOneWidget);

      router.go(AppRoutes.schema(tool));
      await tester.pumpAndSettle();
      expect(find.byType(SchemaScreen), findsOneWidget);

      // Le Niveau guette sa première lecture : le délai doit s'écouler.
      await tester.pump(kSensorSilenceDelay);
    });
  }
}
