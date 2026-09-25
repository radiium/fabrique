import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/distribution.dart';
import '../../core/format.dart';
import '../../core/widgets/haptics.dart';

/// Ce que l'écart demandé donne vraiment, et l'autre borne s'il y en a une.
///
/// **Toujours présent en mode « Calcul nombre »**, seul son costume change :
/// teinté et brun quand il porte une action, vide et gris quand il ne fait que
/// confirmer. Le beige ne veut dire qu'une chose dans cet écran — il y a
/// quelque chose à faire ici — et un encart rempli en permanence le dirait
/// pour rien neuf fois sur dix. Le filet, lui, reste dans les deux états :
/// c'est lui qui tient le cadre à sa place, et sans lui la confirmation
/// flotterait au milieu de la carte.
///
/// Il porte la borne **écartée**, jamais celle que l'outil a retenue : cette
/// dernière remplit déjà le schéma, la tuile « Écart obtenu » et la table des
/// positions. Celui qui a un maximum à ne pas dépasser — un barreaudage à
/// 110 mm — veut justement la plus serrée, et le tri du cœur ne connaît que la
/// distance à la cible, pas sa contrainte.
///
/// **Toute la surface est la cible**, le bouton n'est qu'un repère visuel :
/// viser 90 px de large avec un gant, c'est rater. D'où un `Container` et non
/// un `FilledButton`, qui mettrait deux détecteurs de gestes en concurrence.
class TargetCallout extends StatelessWidget {
  const TargetCallout({
    required this.best,
    required this.other,
    required this.onAdopt,
    super.key,
  });

  final DistributionResult best;

  /// L'autre solution entière, ou `null` quand la cible tombe juste.
  final DistributionResult? other;

  final void Function(int count) onAdopt;

  @override
  Widget build(BuildContext context) {
    final shown = other ?? best;
    final exact = other == null;
    final label =
        '${shown.count} élément${pluralS(shown.count)} '
        '${exact ? '·' : '→'} ${formatNumber(shown.spacing)} mm '
        '${exact ? 'exact' : 'réel'}';

    // Le beige ne veut dire qu'une chose : il y a quelque chose à faire ici.
    // Teinté en permanence, on cesserait de le voir, et l'offre passerait
    // inaperçue le jour où elle arrive. Même grammaire que le bandeau
    // d'erreur, coloré parce qu'il appelle une correction.
    final tint = exact ? Colors.transparent : AppColors.callout;
    final ink = exact ? AppColors.label : AppColors.accentDeep;

    final content = Container(
      constraints: const BoxConstraints(minHeight: kFieldHeight),
      decoration: BoxDecoration(
        color: tint,
        border: Border.all(color: AppColors.calloutBorder),
        borderRadius: BorderRadius.circular(AppRadii.field),
      ),
      // Rembourrage identique dans les deux états : la ligne garde sa place
      // dans le rythme vertical de la carte quand le fond s'en va.
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          Icon(
            exact ? Icons.check_rounded : Icons.swap_horiz,
            size: 20,
            color: ink,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ink,
                fontWeight: exact ? FontWeight.w500 : FontWeight.w600,
              ),
            ),
          ),
          if (!exact) ...[
            const SizedBox(width: AppSpacing.sm),
            const _AdoptButton(),
          ],
        ],
      ),
    );

    if (exact) return Semantics(container: true, child: content);

    return Semantics(
      button: true,
      label:
          'Prendre ${shown.count} éléments, écart de '
          '${formatNumber(shown.spacing)} millimètres',
      child: InkWell(
        onTap: () {
          hapticSelection(context);
          onAdopt(shown.count);
        },
        borderRadius: BorderRadius.circular(AppRadii.field),
        child: content,
      ),
    );
  }
}

/// Le repère d'action de [TargetCallout] — pastille brune, texte blanc.
///
/// Muet par construction : c'est l'encart entier qui reçoit le tap, et un
/// bouton qui en capterait sa part laisserait au doigt une cible de 90 px là
/// où l'encart en offre 300.
class _AdoptButton extends StatelessWidget {
  const _AdoptButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accentDeep,
        borderRadius: BorderRadius.circular(AppRadii.field),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        'Prendre',
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: AppColors.onAccent, fontWeight: FontWeight.w600),
      ),
    );
  }
}
