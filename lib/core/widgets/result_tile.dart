import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';

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

  /// Unité rendue après la valeur, en plus petit et dans le gris des libellés
  /// — exactement le `suffixText` d'un `NumberField`.
  ///
  /// Sa place est ici et pas entre parenthèses dans [label] : une cote se lit
  /// d'un bloc (`12,5 %`, `250 mm`), et `Surface (mm²)` en en-tête est aussi
  /// laid qu'illisible à bout de bras. Le chiffre garde pour lui seul le gros
  /// style tabulaire, donc les valeurs restent alignées d'une tuile à l'autre.
  final String? unit;

  /// Courte justification optionnelle (ex. règle appliquée).
  final String? note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _copy(context),
      // Pas de rayon : la tuile touche les bords de sa carte, donc une encre
      // arrondie laisserait quatre coins de fond nu à chaque appui. Les coins
      // du haut et du bas sont déjà détourés par la carte elle-même.
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
                    // Les deux textes posent sur la même ligne de base : sans
                    // ça, l'unité flotte au milieu de la hauteur du chiffre.
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: Text(value, style: theme.textTheme.titleLarge),
                      ),
                      if (unit != null) ...[
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          unit!,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.label,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (note != null)
                    Text(note!, style: theme.textTheme.bodySmall),
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
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: value));
    messenger.showSnackBar(const SnackBar(content: Text('Copié')));
  }
}
