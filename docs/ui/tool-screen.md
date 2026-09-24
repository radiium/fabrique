# L'écran d'un outil

Tous les outils passent par `ToolScaffold` (`lib/core/widgets/tool_scaffold.dart`).

## Disposition

- **Mobile** : saisie, schéma, résultats, empilés. Le schéma reste visible sans scroll.
- **Au-delà de `kWideBreakpoint` (800 px)** : deux colonnes, saisie et résultats à gauche, schéma fixe à droite.
- **Vignette** en 16/10 par défaut. Un outil ne la relève que s'il a de quoi remplir la hauteur : ce qu'il prend, il le prend à la ligne de flottaison (la Répartition est à 5/4).

Les écrans passent leur contenu nu, c'est `ToolScaffold` qui pose les cartes.

## Pieds de carte

**`inputFooter`**, pied de la carte de saisie, posé **hors** du rembourrage : la carte passe en `padding: zero` + `Clip.antiAlias`, le corps reprend ses 16 px, et le pied touche les bords gauche, droit et bas. C'est la place d'`AppDisclosure`, qui porte lui-même la marge horizontale et le filet au-dessus de son en-tête. Un panneau bordé *et* marginé ferait une carte dans la carte.

**`resultsFooter`**, son symétrique en bas de la carte de résultats, pour ce qu'on fait des résultats une fois lus. C'est la place d'`AppCardActions` : boutons pleins à parts égales, hauts de `kFieldHeight`, en `accentDeep` sur texte blanc (la seule couleur qui dise déjà « actif »). **L'icône ne s'affiche que si elle tient**, mesurée au rendu : le libellé passe d'abord, il ne tronque jamais. Aucun `Divider` en plus : le pied porte son propre filet.

## Réglages avancés (`AppDisclosure`)

Un panneau replié en pied de carte, pour ce qu'on règle une fois sur dix.

- **Règle d'emploi : ce qui est replié est sans effet par défaut.** Sinon on cache la raison d'un résultat surprenant.
- **Pastille d'accent** dès qu'une valeur repliée n'est plus à son défaut. C'est l'autre moitié de la règle : un preset peut remplir un champ replié à la place du doigt. Elle ne change pas la largeur du titre et ne force pas l'ouverture.

## Résultats

- `results` prend une **liste** : c'est la carte qui intercale les filets, de bord à bord, jamais avant le premier ni après le dernier.
- `ResultTile` : valeur copiable d'un tap sur toute la ligne. **L'unité se rend après le chiffre** (`unit`), plus petite et grise, jamais entre parenthèses dans le libellé : une cote se lit d'un bloc et les chiffres restent alignés d'une tuile à l'autre. Dans une table, l'unité va en en-tête de colonne.
- `note` : une courte justification (règle appliquée, précision).

## Refus affiché (`ErrorBanner`)

Répartition et Calepinage affichent le **motif** d'un refus au lieu d'un tiret : leurs refus sont métier (« les 11 éléments occupent 110 mm pour 100 disponibles ») et, sur huit contrôles, un tiret muet laisserait chercher. Le bandeau se pose **dans la carte de saisie** : sur mobile les résultats sont sous le schéma, deux écrans plus bas que le champ fautif.

## Réinitialiser

`onReset` (absent = pas d'action, cas du Niveau) et `canReset`.

- **Dans l'`AppBar`, pas dans une barre basse.** Une barre fixe coûterait ~75 px sur chaque écran pour une action utilisée une fois par chantier, et il n'y a aucune action principale pour lui tenir compagnie. Le coin opposé au pouce rend l'appui délibéré.
- **Pas de confirmation, pas de SnackBar « Annuler ».** Les cotes viennent du mètre : un reset accidentel fait retaper ce qui se remesure à un mètre de là. Le retour haptique est le seul accusé de réception.
- **`canReset: false` grise, ne masque pas.** Icône éteinte = saisie aux défauts, rien n'a été restauré. Chaque outil compare sa saisie à sa constante `kXDefaults`.

## Aide de champ (ⓘ)

`LabeledField.about` prend un `FieldHelp` (titre, corps, points) et pose un ⓘ **après** le libellé. Toute la ligne de libellé ouvre une **feuille basse**. `NumberField` le relaie. Les contenus d'un outil vivent dans son `*_help.dart`.

- **Pas de dépliant en place** : sur une ligne de deux champs, il ferait grandir la ligne sous un seul des deux.
- **Pas de tooltip ni de popover** : le premier demande un appui long (indécouvrable), le second se ferme en visant à côté, et avec un gant ce tap atterrit sur un contrôle.
- **La ligne de libellé passe de 20 à 32 px, seulement si elle porte un ⓘ.** Sous `kFieldHeight`, assumé : elle fait toute la largeur, et rater un ⓘ n'abîme rien.
- `help` (sous le contrôle, toujours affiché) énonce une contrainte. `about` explique, à la demande. Les deux coexistent.

## Retour haptique

`HapticsScope` (`core/widgets/haptics.dart`) descend le réglage depuis la racine. Les contrôles appellent `hapticSelection(context)` ou `hapticImpact(context)` (réservé au reset). `FabriqueApp` est le **seul** endroit qui lit `hapticsEnabledProvider`.

- **Une portée, pas un paramètre** : cinq widgets vibrent, appelés une trentaine de fois. Un paramètre oublié une fois ferait vibrer un contrôle contre le réglage.
- **Pas Riverpod** : `core/widgets` reste du Flutter nu, montable dans un test sans `ProviderScope`.
- **Hors portée, ça vibre** : un câblage oublié vibre de trop, jamais ne reste muet.
- **Lecture sans dépendance** : l'appelant est un gestionnaire de geste, changer le réglage ne reconstruit rien.

`test/features/haptics_test.dart` tient les deux bouts.
