import 'package:fabrique/core/calc/drawers.dart';
import 'package:fabrique/features/drawers/drawers_cut_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';

void main() {
  testWidgets('un tap copie la fiche, une pièce par ligne pour un tableur', (
    tester,
  ) async {
    String? copied;
    final messenger = tester.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        copied = (call.arguments as Map)['text'] as String?;
      }
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );
    await tester.pumpWidget(
      testApp(
        home: const Scaffold(
          body: CutListTable(
            pieces: [
              CutPiece(
                part: DrawerPart.side,
                quantity: 4,
                length: 500,
                width: 203.5,
                thickness: 15,
              ),
              CutPiece(
                part: DrawerPart.bottom,
                quantity: 2,
                length: 518.6,
                width: 482,
                thickness: 8,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byType(CutListTable));
    await tester.pump();

    expect(copied, 'Côté\t4\t500\t203,5\t15\nFond\t2\t518,6\t482\t8');
    expect(find.text('Copié'), findsOneWidget);
  });

  testWidgets('saisie refusée : rien à copier', (tester) async {
    await tester.pumpWidget(
      testApp(home: const Scaffold(body: CutListTable(pieces: null))),
    );

    expect(find.byIcon(Icons.copy_outlined), findsNothing);
    expect(tester.widget<InkWell>(find.byType(InkWell)).onTap, isNull);
  });
}
