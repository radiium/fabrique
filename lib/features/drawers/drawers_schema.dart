import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'drawers_controller.dart';
import 'drawers_painter.dart';

/// Le schéma des Tiroirs, branché sur les providers.
///
/// Point de construction unique du [DrawersPainter], partagé par la vignette
/// de l'écran et la page plein écran.
class DrawersSchema extends ConsumerWidget {
  const DrawersSchema({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomPaint(
      painter: DrawersPainter(
        result: ref.watch(drawersResultProvider),
        input: ref.watch(drawersFormProvider),
      ),
      size: Size.infinite,
    );
  }
}
