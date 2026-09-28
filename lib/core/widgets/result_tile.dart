import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'haptics.dart';

/// Une valeur calculée, copiable d'un tap.
class ResultTile extends StatelessWidget {
  const ResultTile({
    required this.label,
    required this.value,
    this.unit,
    this.note,
    super.key,
  });

  final String label;
  final String value;

  /// Unité après la valeur, plus petite et grise, comme le `suffixText` d'un
  /// `NumberField`. Hors de [label], pour aligner les chiffres.
  final String? unit;

  /// Courte justification optionnelle (ex. règle appliquée).
  final String? note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _copy(context),
      // Sans rayon : la tuile touche les bords, la carte détoure les coins.
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.labelLarge),
                  Row(
                    // Même ligne de base pour le chiffre et l'unité.
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: Text(value, style: theme.textTheme.titleLarge),
                      ),
                      if (unit case final unit?) ...[
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          unit,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.label,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (note case final note?)
                    Text(note, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.copy_outlined),
          ],
        ),
      ),
    );
  }

  Future<void> _copy(BuildContext context) async {
    hapticSelection(context);
    final messenger = ScaffoldMessenger.of(context);
    final copied = AppLocalizations.of(context).commonCopied;
    await Clipboard.setData(ClipboardData(text: value));
    // Remplace le « Copié » précédent, pour ne pas empiler les SnackBar.
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(copied)));
  }
}
