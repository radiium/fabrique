import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';

/// Panneau repliable : un en-tête cliquable, un contenu qui se déplie.
///
/// Ce n'est pas un raffinement cosmétique. La visualisation ne doit jamais
/// passer sous la ligne de flottaison sur mobile, et trois contrôles de plus
/// dans une carte de saisie suffisent à l'y envoyer — c'est le problème connu
/// du calepinage.
///
/// Règle d'emploi : **ce qui est replié doit être sans effet par défaut.**
/// Sinon on cache à l'utilisateur la raison d'un résultat qui le surprend, et
/// le repli devient un piège au lieu d'un rangement.
///
/// Se pose **en pied de carte** ([ToolScaffold.inputFooter]), de bord à bord :
/// aucune marge à gauche, à droite ni en bas, et un filet collé au-dessus de
/// l'en-tête. C'est ce qui le distingue d'un contrôle de plus dans la pile —
/// un panneau bordé et encore marginé ferait une carte dans la carte. Il porte
/// donc lui-même la marge horizontale de la carte, pour que son titre reste
/// aligné sur les libellés au-dessus.
class AppDisclosure extends StatefulWidget {
  const AppDisclosure({
    required this.title,
    required this.child,
    this.icon = Icons.tune,
    this.initiallyExpanded = false,
    this.haptics = true,
    super.key,
  });

  final String title;
  final Widget child;
  final IconData icon;
  final bool initiallyExpanded;

  /// TODO(ui): câbler sur le réglage global « retour haptique ».
  final bool haptics;

  static const Duration _duration = Duration(milliseconds: 180);

  /// Marge intérieure — celle de la carte qui le porte ([AppCard.padding]),
  /// puisqu'il en remplace le rembourrage sur toute sa hauteur.
  static const EdgeInsets _inset = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
  );

  @override
  State<AppDisclosure> createState() => _AppDisclosureState();
}

class _AppDisclosureState extends State<AppDisclosure> {
  late bool _expanded = widget.initiallyExpanded;

  void _toggle() {
    if (widget.haptics) unawaited(HapticFeedback.selectionClick());
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          expanded: _expanded,
          child: DecoratedBox(
            // Le filet de la carte, collé à l'en-tête : c'est lui qui dit que
            // ce qui suit est un pied, et non le contrôle suivant.
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            // Pas de `borderRadius` sur l'encre : l'en-tête va de bord à bord,
            // c'est la carte qui détoure ses coins.
            child: InkWell(
              onTap: _toggle,
              child: ConstrainedBox(
                // Cible tactile d'atelier, comme les champs et les segments.
                constraints: const BoxConstraints(minHeight: 48),
                child: Padding(
                  padding: AppDisclosure._inset,
                  child: Row(
                    children: [
                      Icon(widget.icon, size: 18, color: AppColors.label),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.label,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: AppDisclosure._duration,
                        curve: Curves.easeOutCubic,
                        child: const Icon(
                          Icons.expand_more,
                          color: AppColors.label,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // `AnimatedSize` et non `AnimatedCrossFade` : ce dernier garde les deux
        // enfants montés, donc le contenu replié resterait focusable au clavier
        // et lu par un lecteur d'écran — replié à l'œil seulement.
        AnimatedSize(
          duration: AppDisclosure._duration,
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: _expanded
              // Le bas est à la charge du panneau : la carte n'a plus de
              // rembourrage à lui prêter sous l'en-tête.
              ? Padding(
                  padding: AppDisclosure._inset.copyWith(bottom: AppSpacing.md),
                  child: widget.child,
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}
