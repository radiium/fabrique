import 'package:fabrique/core/format.dart';
import 'package:fabrique/core/widgets/error_banner.dart';
import 'package:fabrique/features/drawers/drawers_controller.dart';
import 'package:fabrique/features/drawers/drawers_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';
import '../../support/phone.dart';

void main() {
  Future<ProviderContainer> pumpDrawers(WidgetTester tester) async {
    usePhone(tester);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: testApp(home: const DrawersScreen()),
      ),
    );
    return container;
  }

  Finder text(String value) => find.text(value, skipOffstage: false);

  testWidgets('les résultats suivent la saisie', (tester) async {
    final container = await pumpDrawers(tester);

    // (684 + 2 × 18 − 2 × 3) / 3.
    expect(text('600 × 238'), findsOneWidget);
    expect(text('Côté ×4'), findsOneWidget);

    container.read(drawersFormProvider.notifier).setDrawerCount(2);
    await tester.pumpAndSettle();

    expect(text('600 × 358.5'), findsOneWidget);
    expect(text('Côté ×4'), findsOneWidget);
  });

  testWidgets('un refus s’affiche dans la carte de saisie, résultats éteints', (
    tester,
  ) async {
    final container = await pumpDrawers(tester);

    container.read(drawersFormProvider.notifier).setOpeningWidth(50);
    await tester.pumpAndSettle();

    expect(find.byType(ErrorBanner, skipOffstage: false), findsOneWidget);
    expect(
      text(
        'La glissière et les côtés prennent 55.4 mm pour 50 mm de largeur '
        'intérieure',
      ),
      findsOneWidget,
    );
    expect(text(kNoValue), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
