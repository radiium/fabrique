import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../models/tool.dart';
import 'app_card.dart';
import 'haptics.dart';

/// La feuille blanche sur laquelle se dessine un schéma.
///
/// Blanche partout : les libellés de cote se détourent sur cette couleur
/// ([drawSchemaLabel]).
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
/// Sans zoom, coincé entre deux zones de scroll : toute la carte ouvre le plein
/// écran. [expandFor] `null` rend la carte inerte (Niveau, Convertisseur).
class SchemaCard extends StatelessWidget {
  const SchemaCard({required this.child, this.expandFor, super.key});

  /// Le schéma, un `CustomPaint` branché sur les providers de l'outil.
  final Widget child;

  /// L'outil dont la page plein écran s'ouvre au tap.
  final Tool? expandFor;

  /// La largeur d'un rembourrage de carte, pour que la teinte se lise comme un
  /// cadre.
  static const EdgeInsets _padding = EdgeInsets.all(AppSpacing.md);

  @override
  Widget build(BuildContext context) {
    final tool = expandFor;
    if (tool == null) {
      return AppCard(
        tinted: true,
        padding: _padding,
        child: SchemaSheet(child: child),
      );
    }
    return AppCard(
      tinted: true,
      padding: _padding,
      onTap: () {
        hapticSelection(context);
        unawaited(context.push(AppRoutes.schema(tool)));
      },
      // Le nom de la cible pour un lecteur d'écran.
      child: Semantics(
        button: true,
        label: AppLocalizations.of(context).commonExpandSchema,
        child: SchemaSheet(
          child: Stack(
            fit: StackFit.expand,
            children: [
              child,
              const Positioned(
                right: _ExpandHint.margin,
                bottom: _ExpandHint.margin,
                child: _ExpandHint(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// L'indice d'agrandissement, en bas à droite de la feuille.
///
/// En bas, le coin que les cotes laissent libre.
class _ExpandHint extends StatelessWidget {
  const _ExpandHint();

  /// Écart au coin de la feuille.
  static const double margin = 4;

  /// Petite : elle signale la cible sans l'être.
  static const double _iconSize = 16;
  static const double _padding = 3;

  /// Presque opaque, pour que les traits de cote ne brouillent pas l'icône.
  static const double _backdropOpacity = 0.9;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.cardSurface.withValues(alpha: _backdropOpacity),
        borderRadius: BorderRadius.circular(AppRadii.schemaSheet),
      ),
      child: const Padding(
        padding: EdgeInsets.all(_padding),
        child: Icon(
          Icons.open_in_full,
          size: _iconSize,
          color: AppColors.label,
        ),
      ),
    );
  }
}
