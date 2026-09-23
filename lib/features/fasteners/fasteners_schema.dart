import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fasteners_controller.dart';
import 'fasteners_painter.dart';

/// Le schéma des Avant-trous, branché sur les providers.
///
/// Point de construction unique du [FastenersPainter], partagé par la vignette
/// de l'écran et la page plein écran.
class FastenersSchema extends ConsumerWidget {
  const FastenersSchema({this.compact = false, super.key});

  /// Vignette : la coupe seule, sans la colonne de cotes qui lui mange la
  /// moitié de la largeur.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomPaint(
      painter: FastenersPainter(
        result: ref.watch(fastenerResultProvider),
        input: ref.watch(fastenerFormProvider),
        compact: compact,
      ),
      size: Size.infinite,
    );
  }
}
