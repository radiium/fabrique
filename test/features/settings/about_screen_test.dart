import 'package:fabrique/app/routes.dart';
import 'package:fabrique/app/version.dart';
import 'package:fabrique/features/settings/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/app.dart';
import '../../support/phone.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('« À propos » s’ouvre depuis les réglages, avec la version', (
    tester,
  ) async {
    usePhone(tester);
    await pumpApp(tester, AppRoutes.settings);

    await tester.tap(find.text('À propos'));
    await tester.pumpAndSettle();

    expect(find.byType(AboutScreen), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AboutScreen),
        matching: find.text('Version $kAppVersion'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('les licences des composants s’ouvrent depuis « À propos »', (
    tester,
  ) async {
    usePhone(tester);
    await pumpApp(tester, AppRoutes.about);

    await tester.tap(find.text('Licences des composants'));
    await tester.pumpAndSettle();

    expect(find.byType(LicensePage), findsOneWidget);
  });

  testWidgets('« About » tient sur le téléphone en anglais', (tester) async {
    usePhone(tester);
    await pumpApp(tester, AppRoutes.about, locale: const Locale('en'));

    expect(find.text('Open source licenses'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
