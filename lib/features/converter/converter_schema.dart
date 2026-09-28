import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/measure_unit.dart';
import '../../l10n/app_localizations.dart';
import 'comparison_painter.dart';
import 'converter_controller.dart';
import 'converter_painter.dart';

/// Le schéma du Convertisseur, branché sur les providers.
///
/// Double règle pour les longueurs, comparaison à un repère sinon. Les deux
/// painters règlent seuls leur densité.
class ConverterSchema extends ConsumerWidget {
  const ConverterSchema({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(converterFormProvider);
    final result = ref.watch(converterResultProvider);
    final l10n = AppLocalizations.of(context);

    return CustomPaint(
      painter: input.quantity == Quantity.length
          ? RulerPainter(result: result, l10n: l10n)
          : ComparisonPainter(result: result, unit: input.unit, l10n: l10n),
      size: Size.infinite,
    );
  }
}
