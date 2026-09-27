import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'layout_controller.dart';
import 'layout_painter.dart';

/// Le schéma du Calepinage, branché sur les providers.
///
/// Point de construction unique du [LayoutPainter] : la vignette de l'écran et
/// la page plein écran le traversent toutes les deux, donc un seul endroit sait
/// de quoi le painter a besoin.
class LayoutSchema extends ConsumerWidget {
  const LayoutSchema({this.compact = false, super.key});

  /// Vignette : le dessin garde la place, les cotes tombent.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomPaint(
      painter: LayoutPainter(
        result: switch (ref.watch(layoutResultProvider)) {
          LayoutReady(:final result) => result,
          LayoutFailure() => null,
        },
        input: ref.watch(layoutFormProvider),
        l10n: AppLocalizations.of(context),
        compact: compact,
      ),
      size: Size.infinite,
    );
  }
}
