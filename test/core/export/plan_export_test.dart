import 'dart:ui' as ui;

import 'package:fabrique/core/export/plan.dart';
import 'package:fabrique/core/export/plan_export.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

class _BlankDrawing extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(_BlankDrawing oldDelegate) => false;
}

void main() {
  testWidgets('le PNG sort aux proportions d’une A4', (tester) async {
    // Le painter se rejoue hors de l'arbre de widgets : c'est le seul endroit
    // où un encodage qui échoue se verrait.
    await tester.runAsync(() async {
      final bytes = await renderPlanPng(
        PlanPainter(
          plan: const Plan(title: 'Essai', fields: []),
          drawing: _BlankDrawing(),
        ),
        width: 600,
      );

      final codec = await ui.instantiateImageCodec(bytes);
      final image = (await codec.getNextFrame()).image;
      codec.dispose();
      addTearDown(image.dispose);

      expect(image.width, 600);
      expect(image.height, (600 / kPlanAspectRatio).round());
      // Signature PNG — l'encodeur peut rendre un buffer non vide dans un autre
      // format si `ImageByteFormat` change sous nos pieds.
      expect(bytes.take(4), [0x89, 0x50, 0x4E, 0x47]);
    });
  });
}
