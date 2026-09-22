import 'package:fabrique/app/theme.dart';
import 'package:fabrique/core/widgets/tool_scaffold.dart';
import 'package:fabrique/features/converter/converter_controller.dart';
import 'package:fabrique/features/converter/converter_screen.dart';
import 'package:fabrique/features/distribution/distribution_controller.dart';
import 'package:fabrique/features/distribution/distribution_screen.dart';
import 'package:fabrique/features/fasteners/fasteners_controller.dart';
import 'package:fabrique/features/fasteners/fasteners_screen.dart';
import 'package:fabrique/features/layout/layout_controller.dart';
import 'package:fabrique/features/layout/layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Le bouton « réinitialiser » de l'`AppBar`.
///
/// Deux choses qu'aucun test de cœur ne peut attraper : que l'icône soit bien
/// éteinte tant que la saisie est neuve — c'est elle qui porte le signal
/// « rien n'a été restauré » — et qu'un reset redescende jusque dans le texte
/// des champs, dont le `TextEditingController` vit à part de l'état.
void main() {
  final resetButton = find.widgetWithIcon(IconButton, Icons.restart_alt);

  Future<ProviderContainer> pump(WidgetTester tester, Widget screen) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: buildAppTheme(), home: screen),
      ),
    );
    return container;
  }

  bool isEnabled(WidgetTester tester) =>
      tester.widget<IconButton>(resetButton).onPressed != null;

  /// Chaque outil à saisie : ce qu'on pompe, comment on salit la saisie, et
  /// comment on lit qu'elle est revenue au départ.
  final tools =
      <
        ({
          String name,
          Widget screen,
          void Function(ProviderContainer) dirty,
          bool Function(ProviderContainer) isPristine,
        })
      >[
        (
          name: 'Convertisseur',
          screen: const ConverterScreen(),
          dirty: (c) => c.read(converterFormProvider.notifier).setValue(42),
          isPristine: (c) =>
              c.read(converterFormProvider) == kConverterDefaults,
        ),
        (
          name: 'Répartition',
          screen: const DistributionScreen(),
          dirty: (c) => c.read(distributionFormProvider.notifier).setCount(9),
          isPristine: (c) =>
              c.read(distributionFormProvider) == kDistributionDefaults,
        ),
        (
          name: 'Avant-trous',
          screen: const FastenersScreen(),
          dirty: (c) =>
              c.read(fastenerFormProvider.notifier).setScrewDiameter(6),
          isPristine: (c) => c.read(fastenerFormProvider) == kFastenerDefaults,
        ),
        (
          name: 'Calepinage',
          screen: const LayoutScreen(),
          dirty: (c) => c.read(layoutFormProvider.notifier).setSurfaceX(1234),
          isPristine: (c) => c.read(layoutFormProvider) == kLayoutDefaults,
        ),
      ];

  for (final tool in tools) {
    testWidgets('${tool.name} — éteint au départ, rend la saisie au tap', (
      tester,
    ) async {
      final container = await pump(tester, tool.screen);

      expect(resetButton, findsOneWidget, reason: tool.name);
      expect(
        isEnabled(tester),
        isFalse,
        reason: '${tool.name} : saisie neuve, rien à réinitialiser',
      );

      tool.dirty(container);
      await tester.pumpAndSettle();
      expect(isEnabled(tester), isTrue, reason: tool.name);

      await tester.tap(resetButton);
      await tester.pumpAndSettle();

      expect(tool.isPristine(container), isTrue, reason: tool.name);
      expect(isEnabled(tester), isFalse, reason: tool.name);
      expect(tester.takeException(), isNull, reason: tool.name);
    });
  }

  testWidgets('le reset redescend dans le texte des champs', (tester) async {
    final container = await pump(tester, const LayoutScreen());
    container.read(layoutFormProvider.notifier).setSurfaceX(1234);
    await tester.pumpAndSettle();
    expect(find.text('1234'), findsOneWidget);

    await tester.tap(resetButton);
    await tester.pumpAndSettle();

    expect(find.text('1234'), findsNothing);
    expect(find.text('3000'), findsOneWidget);
  });

  testWidgets('un outil sans saisie n’affiche pas l’action', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const ProviderScope(
          child: ToolScaffold(
            title: 'Niveau',
            input: SizedBox.shrink(),
            visualization: SizedBox.shrink(),
            results: [],
          ),
        ),
      ),
    );

    expect(resetButton, findsNothing);
  });
}
