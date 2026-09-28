import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'level_controller.dart';
import 'level_painter.dart';

/// Le schéma du Niveau, branché sur le flux du capteur.
///
/// Sans densité ni agrandissement : la fiole occupe déjà toute la carte.
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
