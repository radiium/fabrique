import 'package:fabrique/app/router.dart';
import 'package:fabrique/app/theme.dart';
import 'package:fabrique/core/models/tool.dart';
import 'package:fabrique/core/widgets/schema_card.dart';
import 'package:fabrique/features/schema/schema_screen.dart';
import 'package:fabrique/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Le schéma d'un outil se regarde en plein écran, et c'est la vignette qui y
/// mène. Deux choses que ni `flutter analyze` ni les tests du cœur ne voient :
/// un painter qui lève une fois sorti de sa vignette (il n'y dessine pas les
/// mêmes annotations), et une route qui ne mène nulle part.
void main() {
  Future<void> pumpTool(WidgetTester tester, Tool tool) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final router = container.read(routerProvider)..go('/tool/${tool.id}');
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          theme: buildAppTheme(),
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
  }

  for (final tool in Tool.values.where((t) => t != Tool.level)) {
    testWidgets('${tool.label} — la vignette ouvre le schéma en plein écran', (
      tester,
    ) async {
      await pumpTool(tester, tool);

      await tester.tap(find.byType(SchemaCard));
      await tester.pumpAndSettle();

      expect(find.byType(SchemaScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final tool in Tool.values.where((t) => t != Tool.level)) {
    testWidgets('${tool.label} — les quatre quarts de tour se rendent', (
      tester,
    ) async {
      // Pivoter donne au painter une boîte à l'autre proportion : c'est le
      // seul endroit où un schéma large se dessine dans un cadre haut, et
      // une division par une largeur devenue minuscule ne se verrait pas
      // ailleurs.
      await pumpTool(tester, tool);
      await tester.tap(find.byType(SchemaCard));
      await tester.pumpAndSettle();

      for (var turn = 1; turn <= 4; turn++) {
        await tester.tap(find.byTooltip('Pivoter le schéma'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: 'quart de tour $turn');
        expect(
          tester.widget<RotatedBox>(find.byType(RotatedBox)).quarterTurns,
          turn % 4,
        );
      }
    });
  }

  testWidgets('le schéma se réduit en deçà de son ajustement', (tester) async {
    // `InteractiveViewer` plafonne la réduction à `viewport / cadre` : sans
    // débord de cadrage, ce plancher vaut 1 et `minScale` ne sert à rien. Rien
    // dans le code ne le dit, seul un vrai pincement le montre.
    await pumpTool(tester, Tool.layout);
    await tester.tap(find.byType(SchemaCard));
    await tester.pumpAndSettle();

    final fit = find.widgetWithIcon(IconButton, Icons.fit_screen);
    expect(
      tester.widget<IconButton>(fit).onPressed,
      isNull,
      reason: 'rien n’a bougé, l’action doit être éteinte',
    );

    final center = tester.getCenter(find.byType(InteractiveViewer));
    final first = await tester.startGesture(center - const Offset(80, 0));
    final second = await tester.startGesture(center + const Offset(80, 0));
    await first.moveTo(center - const Offset(10, 0));
    await second.moveTo(center + const Offset(10, 0));
    await tester.pump();
    await first.up();
    await second.up();
    await tester.pumpAndSettle();

    final view = tester
        .widget<InteractiveViewer>(find.byType(InteractiveViewer))
        .transformationController!;
    expect(view.value.getMaxScaleOnAxis(), lessThan(1));
    expect(tester.widget<IconButton>(fit).onPressed, isNotNull);

    await tester.tap(fit);
    await tester.pumpAndSettle();
    expect(view.value.isIdentity(), isTrue);
  });

  testWidgets('le Niveau n’a rien à agrandir', (tester) async {
    // Une bulle n'a pas de détail à aller chercher, et une page par-dessus
    // couperait des yeux le flux du capteur.
    await pumpTool(tester, Tool.level);

    await tester.tap(find.byType(SchemaCard));
    await tester.pumpAndSettle();

    expect(find.byType(SchemaScreen), findsNothing);
  });
}
