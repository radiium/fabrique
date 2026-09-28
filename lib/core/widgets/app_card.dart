import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// La carte de l'app — sans élévation, cernée de [AppColors.cardBorder].
///
/// Deux variantes seulement :
/// - claire ([AppColors.cardSurface]) : saisie et résultats ;
/// - teintée ([AppColors.cardTinted], `tinted: true`) : schémas.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.tinted = false,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.clipBehavior = Clip.none,
    super.key,
  });

  final Widget child;

  /// `true` = fond teinté, réservé aux visualisations.
  final bool tinted;

  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Clip clipBehavior;

  static const BorderRadius _radius = BorderRadius.all(
    Radius.circular(AppRadii.card),
  );

  @override
  Widget build(BuildContext context) {
    final body = Padding(padding: padding, child: child);
    return Card(
      color: tinted ? AppColors.cardTinted : AppColors.cardSurface,
      clipBehavior: clipBehavior == Clip.none && onTap != null
          ? Clip.antiAlias
          : clipBehavior,
      child: onTap == null
          ? body
          : InkWell(onTap: onTap, borderRadius: _radius, child: body),
    );
  }
}
