import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'distribution_controller.dart';
import 'distribution_painter.dart';

/// Le schéma de la Répartition, branché sur les providers.
///
/// Point de construction unique du [DistributionPainter], pour la vignette
/// et le plein écran. Sans mode vignette : le dessin est le même.
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
        l10n: AppLocalizations.of(context),
      ),
      size: Size.infinite,
    );
  }
}
