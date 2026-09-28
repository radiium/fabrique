import 'package:fabrique/app/routes.dart';
import 'package:fabrique/core/models/tool.dart';
import 'package:fabrique/core/widgets/schema_card.dart';
import 'package:fabrique/features/schema/schema_screen.dart';
import 'package:fabrique/l10n/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/app.dart';
import '../support/l10n.dart';

void main() {
  for (final tool in Tool.values.where((t) => t != Tool.level)) {
    testWidgets('${tool.label(fr)} — la vignette ouvre le schéma, qui pivote', (
      tester,
    ) async {
      // Pivoter donne au painter une boîte haute : le seul cas de ce format.
      await pumpApp(tester, AppRoutes.tool(tool));
      await tester.tap(find.byType(SchemaCard));
      await tester.pumpAndSettle();
      expect(find.byType(SchemaScreen), findsOneWidget);

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
    // Sans débord de cadrage, `InteractiveViewer` ignore `minScale`.
    await pumpApp(tester, AppRoutes.tool(Tool.layout));
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
    await pumpApp(tester, AppRoutes.tool(Tool.level));

    await tester.tap(find.byType(SchemaCard));
    await tester.pumpAndSettle();

    expect(find.byType(SchemaScreen), findsNothing);
  });
}
