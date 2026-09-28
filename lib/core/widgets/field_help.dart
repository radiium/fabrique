import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// L'explication d'un champ, écrite comme une donnée pour être réutilisable.
///
/// Le [body] dit ce que le libellé ne dit pas.
@immutable
class FieldHelp {
  const FieldHelp({
    required this.title,
    required this.body,
    this.bullets = const [],
  });

  /// En général le libellé du champ, repris tel quel.
  final String title;

  final String body;

  /// Points détachés, pour ce qui s'énumère.
  final List<String> bullets;
}

/// Ouvre l'explication dans une feuille basse.
///
/// Une feuille : elle ne déforme pas une paire de champs, se ferme d'un
/// glissement, et recouvre les résultats plutôt que le champ.
Future<void> showFieldHelp(BuildContext context, FieldHelp help) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: AppColors.cardSurface,
    // Sans `isScrollControlled`, la feuille plafonne à mi-écran et tronque.
    isScrollControlled: true,
    builder: (context) => _FieldHelpSheet(help: help),
  );
}

class _FieldHelpSheet extends StatelessWidget {
  const _FieldHelpSheet({required this.help});

  final FieldHelp help;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final body = theme.textTheme.bodyLarge?.copyWith(height: 1.45);

    return SafeArea(
      child: Padding(
        // La poignée occupe déjà le haut.
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(help.title, style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              Text(help.body, style: body),
              for (final bullet in help.bullets) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiret cadratin : un séparateur visuel, pas de la ponctuation.
                    Text('—', style: body?.copyWith(color: AppColors.label)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text(bullet, style: body)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
