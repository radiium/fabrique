import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../models/tool.dart';
import 'app_card.dart';
import 'haptics.dart';

/// La feuille blanche sur laquelle se dessine un schéma.
///
/// Le fond d'un schéma ne suit pas la carte qui le porte : il est blanc dans
/// la vignette comme en plein écran. Deux raisons de ne pas le laisser
/// prendre la teinte de la carte : un même dessin changerait de fond d'un
/// contexte à l'autre, et les libellés de cote se détourent sur une couleur
/// fixée à la compilation ([drawSchemaLabel]) — un fond teinté leur ferait un
/// pavé blanc autour du chiffre.
class SchemaSheet extends StatelessWidget {
  const SchemaSheet({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.all(Radius.circular(AppRadii.schemaSheet)),
      ),
      child: child,
    );
  }
}

/// Le schéma d'un outil sur son écran : une vignette, tapable pour l'agrandir.
///
/// Ni zoom ni déplacement ici — le geste à deux doigts vivrait dans une carte
/// haute de 200 px, coincé entre deux zones de scroll. La vignette ne fait que
/// montrer, et tout le tap l'ouvre en plein écran, là où il y a de quoi
/// vraiment déplacer le dessin. La carte entière est la cible : un bouton
/// d'agrandissement se viserait, et c'est le geste qu'on fait avec un gant.
///
/// [expandFor] `null` = rien à agrandir, la carte n'est pas tapable. C'est le
/// cas du Niveau : sa bulle n'a pas de détail à aller chercher, et une page
/// par-dessus couperait des yeux le flux du capteur.
class SchemaCard extends StatelessWidget {
  const SchemaCard({required this.child, this.expandFor, super.key});

  /// Le schéma lui-même — un `CustomPaint` branché sur les providers de
  /// l'outil.
  final Widget child;

  /// L'outil dont la page plein écran s'ouvre au tap.
  final Tool? expandFor;

  @override
  Widget build(BuildContext context) {
    final tool = expandFor;
    return AppCard(
      tinted: true,
      // La teinte n'est plus qu'un encadrement, mais il lui faut la largeur
      // d'un rembourrage de carte pour se lire comme tel plutôt que comme un
      // filet de travers.
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: tool == null
          ? null
          : () {
              hapticSelection(context);
              unawaited(context.push('/tool/${tool.id}/schema'));
            },
      child: SchemaSheet(
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,
            if (tool != null)
              const Positioned(right: 4, bottom: 4, child: _ExpandHint()),
          ],
        ),
      ),
    );
  }
}

/// L'indice d'agrandissement, en bas à droite de la feuille.
///
/// Sans lui, rien ne dit qu'une carte est tapable — un schéma ressemble à une
/// image. En bas plutôt qu'en haut : c'est le coin que les schémas laissent
/// libre, les cotes s'empilant au-dessus et à droite du dessin.
class _ExpandHint extends StatelessWidget {
  const _ExpandHint();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.cardSurface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppRadii.schemaSheet),
      ),
      child: const Padding(
        padding: EdgeInsets.all(3),
        child: Icon(Icons.open_in_full, size: 16, color: AppColors.label),
      ),
    );
  }
}
