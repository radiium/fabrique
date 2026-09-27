import 'package:fabrique/core/widgets/result_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';

void main() {
  testWidgets('des copies à la suite ne font pas la queue', (tester) async {
    // Sans réponse de la plateforme, la copie n'aboutit jamais et aucun
    // SnackBar ne s'affiche : le test passerait pour rien.
    final messenger = tester.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (_) async {
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );
    await tester.pumpWidget(
      testApp(
        home: const Scaffold(
          body: ResultTile(label: 'Écart', value: '250'),
        ),
      ),
    );

    await tester.tap(find.byType(ResultTile));
    await tester.tap(find.byType(ResultTile));
    // 6 s : au-delà d'un SnackBar (4 s), en deçà de deux mis bout à bout.
    for (var i = 0; i < 60; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.byType(SnackBar), findsNothing);
  });
}
