import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'distribution_controller.dart';
import 'distribution_painter.dart';

/// Le schéma de la Répartition, branché sur les providers.
///
/// Point de construction unique du [DistributionPainter], partagé par la
/// vignette de l'écran et la page plein écran. Une saisie refusée passe un
/// résultat `null` : c'est au painter de poser son tiret.
///
/// Pas de mode vignette ici : la vue d'ensemble ne porte que la cote totale et
/// les deux panneaux de détail portent tout le reste, donc il n'y a rien à
/// faire tomber. La page plein écran montre le même dessin, en plus grand.
class DistributionSchema extends ConsumerWidget {
  const DistributionSchema({super.key});

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
      ),
      size: Size.infinite,
    );
  }
}
