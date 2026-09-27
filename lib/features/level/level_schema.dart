import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'level_controller.dart';
import 'level_painter.dart';

/// Le schéma du Niveau, branché sur le flux du capteur.
///
/// Sans paramètre de densité, et sans agrandissement : une bulle n'a pas de
/// détail à aller chercher, et la fiole occupe déjà toute la carte.
class LevelSchema extends ConsumerWidget {
  const LevelSchema({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomPaint(
      painter: LevelPainter(
        result: ref.watch(tiltResultProvider),
        l10n: AppLocalizations.of(context),
      ),
      size: Size.infinite,
    );
  }
}
