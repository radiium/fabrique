import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'distribution_controller.dart';
import 'distribution_painter.dart';

/// Le schéma de la Répartition, branché sur les providers.
///
/// Point de construction unique du [DistributionPainter], partagé par la
/// vignette de l'écran et la page plein écran. Une saisie refusée passe un
/// résultat `null` : c'est au painter de poser son tiret.
class DistributionSchema extends ConsumerWidget {
  const DistributionSchema({this.compact = false, super.key});

  /// Vignette : la numérotation des éléments tombe, elle ne sert qu'à relier
  /// le dessin à la table des positions.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(distributionFormProvider);
    final outcome = ref.watch(distributionResultProvider);

    return CustomPaint(
      painter: DistributionPainter(
        result: outcome is DistributionReady ? outcome.best : null,
        length: input.length,
        elementWidth: input.elementWidth,
        startOffset: input.startOffset,
        endOffset: input.endOffset,
        compact: compact,
      ),
      size: Size.infinite,
    );
  }
}
