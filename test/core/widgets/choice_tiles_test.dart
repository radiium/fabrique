import 'package:fabrique/core/widgets/choice_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app.dart';

class _BlankPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(_BlankPainter oldDelegate) => false;
}

void main() {
  testWidgets('reprendre la tuile déjà choisie ne notifie rien', (
    tester,
  ) async {
    final changes = <int>[];
    await tester.pumpWidget(
      testApp(
        home: Scaffold(
          body: ChoiceTiles<int>(
            value: 1,
            onChanged: changes.add,
            tiles: [
              for (final v in [1, 2, 3])
                ChoiceTile(
                  value: v,
                  label: 'Option $v',
                  preview: ({required selected}) => _BlankPainter(),
                ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Option 1'));
    await tester.tap(find.text('Option 3'));

    expect(changes, [3]);
  });
}
