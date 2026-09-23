/// Les explications des champs du Calepinage, groupées pour se relire d'un
/// bloc — c'est un texte, il se corrige comme un texte.
///
/// Deux entrées seulement : ce sont les deux notions que le libellé ne peut
/// pas porter. Le reste de l'écran demande des cotes, et une cote s'explique
/// toute seule.
library;

import '../../core/widgets/field_help.dart';

const kAboutPerimeterGap = FieldHelp(
  title: 'Jeu périphérique',
  body:
      'Le retrait laissé tout autour de la pose, contre les quatre bords. '
      'La pièce ne rétrécit pas : c’est la pose qui recule, donc la '
      'surface annoncée reste celle du sol ou du mur.',
  bullets: [
    'Parquet et stratifié : le joint de dilatation, autour de 10 mm.',
    'Carrelage : le joint au mur, autour de 5 mm.',
    'Plaque de plâtre : le jeu au sol, autour de 10 mm.',
    'Une pose jointive contre les murs se laisse à 0.',
  ],
);

const kAboutOffset = FieldHelp(
  title: 'Décalage des joints',
  body:
      'De combien chaque rangée démarre en retrait de la précédente. Le '
      'décalage suit le sens de pose : inverser l’orientation le fait '
      'pivoter avec le reste du motif.',
  bullets: [
    'Droit : toutes les rangées démarrent au même endroit, les joints '
        's’alignent en croix.',
    '½ : le décalage classique des lames courtes et des plaques.',
    '⅓ : la règle des carreaux et des lames de plus de 60 cm, où un demi '
        'décalage fait tuiler le milieu de l’élément.',
    'Sur un élément carré ou une plaque pleine, l’effet reste marginal.',
  ],
);
