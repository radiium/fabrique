/// Les explications des champs de la Répartition, groupées pour se relire
/// d'un bloc — c'est un texte, il se corrige comme un texte.
///
/// Ce qu'elles disent et ce qu'elles taisent :
/// - jamais la paraphrase du libellé (« entrez le nombre d'éléments ») ;
/// - la conséquence sur le résultat quand il y en a une (le nombre de jeux,
///   les deux bornes entières) ;
/// - le vocabulaire de l'atelier, pas celui du code.
library;

import '../../core/widgets/field_help.dart';

const kAboutMode = FieldHelp(
  title: 'Mode de calcul',
  body:
      'Détermine si l’écart entre les éléments ou leur nombre doit être '
      'calculé à partir des autres valeurs.',
  bullets: [
    'Calcul écart : vous donnez le nombre d’éléments, l’outil rend l’écart '
        'entre eux.',
    'Calcul nombre : vous donnez l’écart voulu, l’outil rend le nombre '
        'd’éléments qui s’en approche le plus.',
  ],
);

const kAboutLength = FieldHelp(
  title: 'Largeur totale',
  body:
      'Largeur totale disponible pour répartir les éléments : l’intérieur du '
      'cadre, l’entre-deux poteaux.',
);

const kAboutElementWidth = FieldHelp(
  title: 'Largeur d’un élément',
  body:
      'Largeur occupée par chaque élément (barreau, lame, étagère). '
      'Saisissez 0 pour positionner des repères, traçages ou axes de perçage.',
);

const kAboutCount = FieldHelp(
  title: 'Nombre d’éléments',
  body:
      'Nombre d’éléments à répartir dans la largeur disponible.\n\n'
      'Une disposition qui démarre ou finit par un élément en exige au moins '
      'un. Deux si elle fait les deux. Le champ ne descend pas en dessous, et '
      'plafonne à 500.',
);

const kAboutTargetSpacing = FieldHelp(
  title: 'Écart souhaité',
  body:
      'Distance souhaitée entre deux éléments consécutifs. Ne tombe presque '
      'jamais juste : le nombre d’éléments est entier, l’écart ne l’est pas. '
      'L’outil rend donc les deux répartitions entières qui encadrent votre '
      'cible, la plus proche en premier. Si vous avez un maximum à ne pas '
      'dépasser (un barreaudage à 110 mm) lisez la plus serrée des deux.',
);

const kAboutEdges = FieldHelp(
  title: 'Type de répartition',
  body:
      'Définit par quoi la rangée commence et finit : un élément collé au '
      'bord, ou un écart. Chaque combinaison change le nombre d’écarts, donc '
      'le résultat. Le schéma de chaque tuile le montre.',
);

const kAboutOffsetMode = FieldHelp(
  title: 'Marges',
  body:
      'Définit si les deux marges se règlent ensemble ou séparément. Une '
      'marge réserve une bande à une extrémité (un chant, un tasseau déjà '
      'en place), retirée de la largeur totale avant le calcul.',
  bullets: [
    'Symétriques : une seule marge, reprise à l’identique des deux côtés.',
    'Asymétriques : une marge par côté. C’est le cas dès qu’une extrémité '
        'est contrainte et pas l’autre.',
  ],
);

const kAboutOffset = FieldHelp(
  title: 'Marge',
  body:
      'Marge identique au début et à la fin. Sa valeur est retirée de la '
      'largeur totale avant le calcul de la répartition.',
);

const kAboutOffsetStart = FieldHelp(
  title: 'Marge début',
  body:
      'Marge appliquée au début, côté gauche du schéma. Sa valeur est '
      'retirée de la largeur totale avant le calcul de la répartition.',
);

const kAboutOffsetEnd = FieldHelp(
  title: 'Marge fin',
  body:
      'Marge appliquée à la fin, côté droit du schéma. Sa valeur est '
      'retirée de la largeur totale avant le calcul de la répartition.',
);
