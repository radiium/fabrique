import 'package:fabrique/app/app.dart';
import 'package:fabrique/core/models/tool.dart';
import 'package:fabrique/core/persistence/preferences_store.dart';
import 'package:fabrique/core/persistence/settings_controller.dart';
import 'package:fabrique/features/home/tool_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/phone.dart';

/// Écran de bureau : trois tuiles de 280 px au moins tiennent dans sa largeur.
const Size _kDesktop = Size(1280, 800);

Future<void> _pumpHome(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final store = await PreferencesStore.open();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [preferencesStoreProvider.overrideWith((ref) => store)],
      child: const FabriqueApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void _useDesktop(WidgetTester tester) {
  tester.view.physicalSize = _kDesktop;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Finder _cards({required bool isTile}) => find.byWidgetPredicate(
  (widget) => widget is ToolCard && widget.isTile == isTile,
);

void main() {
  testWidgets('sur le téléphone, les outils sont en liste', (tester) async {
    usePhone(tester);
    await _pumpHome(tester);

    expect(_cards(isTile: false), findsNWidgets(Tool.values.length));
    expect(_cards(isTile: true), findsNothing);
  });

  testWidgets('sur un écran large, les outils sont en grille de trois', (
    tester,
  ) async {
    _useDesktop(tester);
    await _pumpHome(tester);

    final tiles = _cards(isTile: true);
    expect(tiles, findsNWidgets(Tool.values.length));
    final rects = [
      for (var i = 0; i < Tool.values.length; i++) tester.getRect(tiles.at(i)),
    ];
    expect(rects[1].top, rects[0].top);
    expect(rects[2].top, rects[0].top);
    expect(rects[3].top, greaterThan(rects[0].bottom));
    expect(rects[3].width, rects[0].width);
    expect(rects[4].width, rects[0].width);
  });

  testWidgets('en grille, un texte agrandi ne déborde pas des tuiles', (
    tester,
  ) async {
    _useDesktop(tester);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await _pumpHome(tester);

    expect(tester.takeException(), isNull);
    final tiles = _cards(isTile: true);
    expect(
      tester.getRect(tiles.at(1)).height,
      tester.getRect(tiles.at(0)).height,
    );
  });
}
