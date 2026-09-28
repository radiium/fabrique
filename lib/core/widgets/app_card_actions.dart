import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'haptics.dart';

/// Ce qu'on fait d'une carte une fois lue : un libellé, une icône, une action.
class CardAction {
  const CardAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.busy = false,
  });

  final IconData icon;

  /// Un verbe court : les libellés partagent la largeur, sans troncature.
  final String label;

  /// `null` éteint le bouton sans le masquer.
  final VoidCallback? onTap;

  /// Action en cours : le bouton ne répond plus, pour qu'un double appui
  /// n'ouvre pas deux feuilles de partage.
  final bool busy;
}

/// Le pied d'une carte : une rangée de boutons pleins, à parts égales.
///
/// Hors du rembourrage de la carte ([ToolScaffold.resultsFooter]), avec sa
/// marge et son filet. Boutons en [AppColors.accentDeep], la couleur active
/// du sélecteur.
class AppCardActions extends StatelessWidget {
  const AppCardActions({required this.actions, super.key});

  final List<CardAction> actions;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            for (final (i, action) in actions.indexed) ...[
              if (i > 0) const SizedBox(width: AppSpacing.sm),
              Expanded(child: _ActionButton(action: action)),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action});

  final CardAction action;

  static const double _iconSize = 20;

  /// Marge intérieure minimale de part et d'autre du contenu.
  static const double _inset = AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    final onTap = action.busy ? null : action.onTap;
    // En cours, le fond reste plein : le témoin est blanc.
    final isFilled = action.onTap != null;
    final style = controlTextStyle(context)
        ?.copyWith(color: isFilled ? AppColors.onAccent : AppColors.label);

    return SizedBox(
      height: kFieldHeight,
      child: Material(
        color: isFilled ? AppColors.accentDeep : AppColors.field,
        borderRadius: BorderRadius.circular(AppRadii.field),
        child: InkWell(
          onTap: onTap == null
              ? null
              : () {
                  hapticSelection(context);
                  onTap();
                },
          borderRadius: BorderRadius.circular(AppRadii.field),
          child: action.busy
              ? Center(
                  child: SizedBox(
                    width: _iconSize,
                    height: _iconSize,
                    // Le bouton garde son nom pour un lecteur d'écran.
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.onAccent,
                      semanticsLabel: action.label,
                    ),
                  ),
                )
              : _Content(action: action, style: style),
        ),
      ),
    );
  }
}

/// L'icône et le libellé, l'icône n'apparaissant que si elle tient.
///
/// Mesuré : sur un téléphone étroit ou en grand texte, l'icône cède la place
/// au libellé, jamais tronqué.
class _Content extends StatelessWidget {
  const _Content({required this.action, required this.style});

  final CardAction action;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mesuré à l'échelle du texte système.
        final text = TextPainter(
          text: TextSpan(text: action.label, style: style),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
          maxLines: 1,
        )..layout();
        final needed =
            text.width +
            _ActionButton._iconSize +
            AppSpacing.sm +
            2 * _ActionButton._inset;
        text.dispose();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (needed <= constraints.maxWidth) ...[
              Icon(
                action.icon,
                size: _ActionButton._iconSize,
                color: style?.color,
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Flexible(child: Text(action.label, style: style, maxLines: 1)),
          ],
        );
      },
    );
  }
}
