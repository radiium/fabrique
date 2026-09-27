import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/measure_unit.dart';
import '../../l10n/app_localizations.dart';
import 'comparison_painter.dart';
import 'converter_controller.dart';
import 'converter_painter.dart';

/// Le schéma du Convertisseur, branché sur les providers.
///
/// Deux painters derrière une seule vue : la double règle ne vaut que pour des
/// longueurs, les autres grandeurs passent par la comparaison à un repère.
///
/// Sans paramètre de densité : ces deux painters se régulent déjà seuls — les
/// graduations secondaires ne s'affichent qu'au-dessus de 5 px, et un libellé
/// qui chevaucherait le précédent est sauté.
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
