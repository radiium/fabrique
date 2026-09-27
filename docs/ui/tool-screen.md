# L'écran d'un outil

Tous les outils passent par `ToolScaffold` (`lib/core/widgets/tool_scaffold.dart`).

## Disposition

- **Mobile** : saisie, schéma, résultats, empilés. Le schéma peut demander un scroll.
- **Au-delà de `kWideBreakpoint` (800 px)** : deux colonnes, saisie et résultats à gauche, schéma fixe à droite.
- **Vignette** en 16/10 par défaut. Un outil ne la relève que s'il a de quoi remplir la hauteur (la Répartition est à 5/4).

Les écrans passent leur contenu nu, c'est `ToolScaffold` qui pose les cartes.

## Pied de carte

**`resultsFooter`**, en bas de la carte de résultats, pour ce qu'on fait des résultats une fois lus. Posé **hors** du rembourrage, il touche les bords gauche, droit et bas. C'est la place d'`AppCardActions` : boutons pleins à parts égales, hauts de `kFieldHeight`, en `accentDeep` sur texte blanc (la seule couleur qui dise déjà « actif »). **L'icône ne s'affiche que si elle tient**, mesurée au rendu : le libellé passe d'abord, il ne tronque jamais. Aucun `Divider` en plus : le pied porte son propre filet.

## Saisie en groupes (`AppDisclosure`)

Un outil dont la saisie ne tient pas sur un écran (Calepinage, Répartition, Tiroirs) la découpe en groupes repliables : `inputGroups`, à la place d'`input`. Le Convertisseur et le Niveau gardent un seul bloc.

- La carte passe en `padding: zero` + `Clip.antiAlias`, et les groupes s'empilent **de bord à bord**. Chacun porte lui-même la marge horizontale et le filet au-dessus de son en-tête. Celui du premier se confond avec le bord de la carte. Un panneau bordé *et* marginé ferait une carte dans la carte.
- **Seul le premier groupe est déplié à l'arrivée** : celui de ce qu'on vient de mesurer (la surface, la largeur, l'ouverture).
- **Un seul groupe ouvert à la fois** (`AppDisclosureGroup`, posé par `ToolScaffold`) : en ouvrir un referme les autres. La saisie reste courte et le schéma reste à portée. On peut aussi tout refermer.
- **Chaque groupe a un résumé** : c'est lui qui permet de fermer un groupe sans cacher ses valeurs. Ce qui est replié garde tout de même par défaut une valeur qui ne surprend pas : neutre (jeu nul, marge nulle) ou le cas le plus courant (bords Élément – Élément).
- Un refus (`ErrorBanner`) se pose **après le dernier groupe**, marginé : il reste dans la carte de saisie, au-dessus du schéma.

Le panneau :

- **En-tête** : icône (24 px) et titre (18 px, `kControlFontSize`, semi-gras) en encre foncée, chevron. Pas de pastille « modifié » : ce qu'on vérifie avant d'exporter et de réaliser, ce sont le schéma et les résultats, pas l'état des panneaux. L'encre, et non la taille, détache le groupe des libellés gris de ses champs : en `titleLarge` (22 px), le titre parlerait plus fort que les valeurs et égalerait les résultats. Le tout sur une ligne à part du résumé, pour que le titre reste en face de ses icônes. Seule, cette ligne fait 48 px. Avec un résumé, l'en-tête prend une **même marge de 12 px au-dessus du titre et sous le résumé**, séparés de 4 px, et dépasse ainsi les 48 px à lui seul. Son filet est peint **devant** le fond de l'en-tête : derrière, le fond opaque le recouvre, et les panneaux empilés perdent leur séparation.
- **Résumé** (`summary`) : les valeurs du contenu, séparées par ` · `, l'unité en fin de groupe de valeurs (`côtés 15, fond 8 mm`). Un choix s'y écrit en minuscules (`applique`), sauf en tête. Il se place sous l'en-tête, aligné sur l'icône, **groupe fermé seulement** : ouvert, les champs disent déjà ces valeurs, et les répéter au-dessus d'eux alourdit la carte. Il se replie à l'ouverture, au rythme du contenu. Les marges de l'en-tête restent, et l'en-tête ouvert garde ses 48 px. Il passe à la ligne plutôt que de tronquer.
- **Pas de fond teinté** quand le panneau est ouvert : sur la carte blanche, `field` ne se distingue pas du fond de page, et une teinte plus marquée (`cardTinted`, `callout`) ferait une carte dans la carte. Le contenu déplié et le chevron retourné disent assez « ouvert ».
- **Une seule animation, la hauteur**, 180 ms, courbe standard : le contenu apparaît ou disparaît sous l'en-tête. Le résumé se replie ou se déplie dans l'en-tête au même rythme. Les marges de l'en-tête ne changent pas : un en-tête qui raccourcit d'un coup pendant que le contenu glisse fait un saut. Pas de fondu. Le chevron suit la même durée.
- Le contenu est démonté une fois replié : un lecteur d'écran ne lit pas des champs cachés.
- **L'état ouvert survit à un changement de mise en page** (rotation, fenêtre élargie au-delà de `kWideBreakpoint`), où `ToolScaffold` reconstruit la carte dans un autre sous-arbre. Il est rangé dans le `PageStorage` de la route, sous le titre du panneau : deux panneaux d'un même écran ont donc des titres distincts.

## Résultats

- `results` prend une **liste** : c'est la carte qui intercale les filets, de bord à bord, jamais avant le premier ni après le dernier.
- `ResultTile` : valeur copiable d'un tap sur toute la ligne. **L'unité se rend après le chiffre** (`unit`), plus petite et grise, jamais entre parenthèses dans le libellé : une cote se lit d'un bloc et les chiffres restent alignés d'une tuile à l'autre. Dans une table, l'unité va en en-tête de colonne.
- `note` : une courte justification (règle appliquée, précision).

## Refus affiché (`ErrorBanner`)

Répartition, Calepinage et Tiroirs affichent le **motif** d'un refus au lieu d'un tiret : leurs refus sont métier (« les 11 éléments occupent 110 mm pour 100 disponibles ») et, sur tant de contrôles, un tiret muet laisserait chercher. Le bandeau se pose **dans la carte de saisie** : sur mobile les résultats sont sous le schéma, deux écrans plus bas que le champ fautif.

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

`HapticsScope` (`core/widgets/haptics.dart`) descend le réglage depuis la racine. Les contrôles appellent `hapticSelection(context)` ou `hapticImpact(context)` (réservé au reset). **Tout contrôle partagé qui change une valeur ou déclenche une action vibre** (segment, tuile, dropdown, switch, − / +, copie, agrandissement, ⓘ), et seulement si la valeur change : reprendre l'option déjà choisie ne vibre pas. `FabriqueApp` est le **seul** endroit qui lit `hapticsEnabledProvider`.

- **Une portée, pas un paramètre** : chaque contrôle partagé vibre à un seul endroit, mais il est appelé une trentaine de fois. Un paramètre oublié une fois ferait vibrer un contrôle contre le réglage.
- **Pas Riverpod** : `core/widgets` reste du Flutter nu, montable dans un test sans `ProviderScope`.
- **Hors portée, ça vibre** : un câblage oublié vibre de trop, jamais ne reste muet.
- **Lecture sans dépendance** : l'appelant est un gestionnaire de geste, changer le réglage ne reconstruit rien.

`test/features/haptics_test.dart` tient les deux bouts.
