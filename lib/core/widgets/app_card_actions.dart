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

  /// Un verbe, court : le libellé partage la largeur de la carte avec ses
  /// voisins, et il n'a pas le droit d'être tronqué.
  final String label;

  /// `null` = rien à faire, le bouton s'éteint sans disparaître. Une chrome qui
  /// s'efface se cherche.
  final VoidCallback? onTap;

  /// L'action est en cours : le bouton ne répond plus et son contenu cède la
  /// place au témoin. Un export se compte en dixièmes de seconde, mais deux
  /// appuis ouvriraient deux feuilles de partage.
  final bool busy;
}

/// Le pied d'une carte : une rangée de boutons pleins, à parts égales.
///
/// Se pose **hors** du rembourrage de la carte ([ToolScaffold.resultsFooter]),
/// de bord à bord, et porte lui-même la marge et le filet qui le séparent du
/// contenu — un pied bordé *et* marginé ferait une carte dans la carte.
///
/// Boutons pleins, en [AppColors.accentDeep] sur texte blanc : c'est la
/// pastille du sélecteur segmenté, donc la seule couleur de l'app qui dise
/// déjà « ceci est actif ». Une ligne de texte discrète, à cette place, se
/// lirait comme une note de bas de carte.
///
/// Le bas d'une carte de résultats plutôt que l'`AppBar` : on exporte après
/// avoir lu ses résultats, jamais avant, et c'est là qu'on arrive en fin de
/// lecture. L'`AppBar` reste à « réinitialiser », l'action à rendre difficile.
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
    // En cours, le bouton garde son fond plein : le témoin est blanc, et un
    // fond éteint le rendrait invisible.
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
                    // Le témoin remplace le libellé à l'écran, pas pour un
                    // lecteur d'écran : le bouton garde son nom.
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
/// **Mesuré, pas supposé.** Deux boutons se partagent la largeur de la carte :
/// sur un téléphone étroit, ou avec un texte système agrandi, le libellé prend
/// tout. Le libellé passe alors d'abord — c'est lui qui nomme l'action, l'icône
/// ne fait que l'illustrer — et il n'est jamais tronqué, ce qu'une simple
/// `Row` avec `overflow: ellipsis` aurait fait en silence.
class _Content extends StatelessWidget {
  const _Content({required this.action, required this.style});

  final CardAction action;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mesuré à l'échelle du texte système : c'est elle qui fait déborder.
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
