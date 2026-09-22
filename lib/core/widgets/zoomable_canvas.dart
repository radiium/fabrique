import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'app_card.dart';

/// Enveloppe la zone de visualisation : carte teintée + zoom/déplacement au
/// doigt.
///
/// Le painter passé ici ne calcule rien, il consomme un résultat déjà produit
/// par `core/calc`.
class ZoomableCanvas extends StatelessWidget {
  const ZoomableCanvas({
    required this.painter,
    this.minScale = 0.5,
    this.maxScale = 6,
    super.key,
  });

  final CustomPainter painter;
  final double minScale;
  final double maxScale;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      tinted: true,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: InteractiveViewer(
        minScale: minScale,
        maxScale: maxScale,
        child: CustomPaint(painter: painter, size: Size.infinite),
      ),
    );
  }
}
