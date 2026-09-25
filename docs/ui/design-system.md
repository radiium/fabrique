# Design system

Tout vit dans `lib/app/theme.dart`. Composants Material 3, peu customisés.

## Couleurs (`AppColors`)

- **Thème clair uniquement.** Fond blanc cassé, cartes blanches sans élévation, cernées d'un seul filet (`cardBorder`).
- **Un seul accent**, chaud, bois/ambre (`accent`). `accentDeep` (brun profond, texte blanc) marque ce qui est **actif** : pastille du sélecteur, piste de switch, boutons de pied de carte.
- **Orange (`cut`) réservé aux pièces à couper** dans les schémas.
- **Deux cartes** : claire pour la saisie et les résultats, teintée (`cardTinted`) pour le schéma.
- `field` : fond beige des champs, et couleur de la **matière** sur la feuille des schémas.
- `accentWash` : fond d'une option retenue qui porte un dessin (`ChoiceTiles` : bords de la Répartition, assemblage et fond des Tiroirs), où la pastille brune noierait le pictogramme.
- `callout` : encart posé *sur* une carte blanche (l'autre borne de la Répartition). Seul filet de l'app qui ne soit pas `border`.

## Typographie

- Sans-serif, **chiffres tabulaires** pour tout résultat.
- **`controlTextStyle`** (18 px, w600) est la fonction unique pour tout ce qui se saisit ou se choisit : champ numérique, valeur fermée d'un dropdown, segment, entrée de menu. `emphasized` passe en w700 pour l'option retenue, en appui de la pastille. Toujours passer par la fonction : c'est en recopiant un style que le dropdown avait dérivé du champ.
- Le libellé d'un champ vit **au-dessus** (`LabeledField`), jamais flottant : il doit rester lisible une fois la saisie commencée.

## Hauteurs

`kFieldHeight` = 48 px, la cible tactile minimale. Champ, segments, dropdown, ligne de switch, boutons − / + la tiennent tous, chacun par un chemin différent :

| Contrôle | Comment |
|---|---|
| `NumberField` | `SizedBox` de hauteur fixe |
| `AppDropdown` | `contentPadding` dérivé de `_controlLineHeight` |
| `AppSwitchField` | cible dégonflée (`shrinkWrap`) plus 4 px de marge |

Rien dans le code ne les relie : `test/core/widgets/control_metrics_test.dart` les mesure au rendu.

⚠️ Deux pièges vérifiés à la mesure :

- **`DropdownMenu` ne relaie du `menuButtonTheme` que** `foregroundColor`, `backgroundColor`, `overlayColor` et `shape`. Un `textStyle` posé là est ignoré : la taille des entrées se règle entrée par entrée (`DropdownMenuEntry.style`).
- **La hauteur du `DropdownMenu` vient de son padding**, dérivé de `_controlLineHeight` = 23 px. C'est une **mesure** : le moteur arrondit la boîte de ligne (18 × 1,3 = 23,4 → 23). À revérifier si la taille de police change.

## Contrôles

- **`AppSegmentedButton`** : écrit à la main (Material ne permet pas une pastille arrondie dans la piste). Tronque en silence : voir [writing.md](writing.md).
- **`AppDropdown`** : `DropdownMenu` non éditable, pleine largeur. Pour une liste qui ne tient pas en segments.
- **`AppSwitchField`** : **toute la ligne bascule**, libellé compris. ⚠️ Donc jamais de ⓘ dedans : une cible d'aide posée là changerait le réglage une fois sur deux. Ce qu'un switch a à expliquer tient dans sa ligne `help`.
- **`NumberField`** : clavier numérique, notifie à chaque frappe. Avec `step`, boutons − / + (appui maintenu = défilement).
- **`FieldPair`** : deux champs de même famille côte à côte (largeur × longueur). Jamais de boutons − / + dedans : illisible sur téléphone.

## Espacements et rayons

`AppSpacing` : 4 · 8 · 16 · 24 · 32. `AppRadii` : carte 10, champ 9, feuille de schéma 8 (juste sous la carte qui la porte). La pastille du sélecteur prend le rayon de la piste moins son jeu, pour rester concentrique.
