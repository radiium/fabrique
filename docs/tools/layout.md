# Calepinage — outil signature

Poser des éléments rectangulaires identiques sur une surface rectangulaire : carrelage, lames, parquet, dalles, plaques. Le calcul est le même pour tous, c'est ce qui autorise **un seul outil, sans sélecteur de mode**.

- [Règles métier](#règles-métier)
- [Équilibrage des rangées](#équilibrage-des-rangées)
- [Liste de débit](#liste-de-débit)
- [Presets](#presets)
- [Schéma](#schéma)
- [Plan exporté](#plan-exporté)
- [Décidé / écarté](#décidé--écarté)

## Règles métier

- **Axes.** Les éléments s'alignent le long d'un **axe de pose**, les rangées s'empilent perpendiculairement. Le décalage de joints décale le départ de chaque rangée **le long de l'axe de pose**.
- **L'inversion pivote tout le motif d'un quart de tour, décalage compris.** Décaler les joints d'un bardage vertical n'a de sens que le long des lames.
- **Les jeux restent définis à l'écran** : horizontal et vertical, quelle que soit l'inversion.
- **Le jeu périphérique** se retire des quatre bords. La pose recule, la pièce ne rétrécit pas : la surface reste l'aire entière.
- **Pas de réemploi des chutes.** Chaque pièce coupée consomme un élément entier : le % de perte est **volontairement pessimiste**, et l'écran doit continuer à le dire.
- **Le volume est borné à 5000 éléments** : un élément de 1 mm saisi par mégarde demanderait des millions de rectangles. Le refus donne l'ordre de grandeur : sur une faute de frappe, il y a deux zéros d'écart, et c'est ça qui dit où chercher.

## Équilibrage des rangées

Ne jamais finir sur un filet : quand la dernière rangée tombe sous un demi-élément, on **sacrifie une rangée pleine** et on partage son épaisseur avec le reliquat entre la première et la dernière, qui deviennent identiques.

Sur un axe de portée `s`, élément `e`, jeu `g` :

1. `n = ⌊(s − e)/(e + g)⌋ + 1` rangées pleines, reliquat `r = s − n·(e + g)`.
2. On ne touche à rien si `r ≤ 0` (ça tombe juste), si `r ≥ e/2` (pas un filet) ou si `n < 2` (rien à sacrifier).
3. Sinon, les deux rangées de bord font `(e + r)/2`.

- **Invariant** : `e/2 ≤ (e + r)/2 < 3e/4`. Ça se vérifie à l'œil sur le schéma.
- **L'empilement s'équilibre toujours, l'axe de pose seulement en décalage droit.** Sous décalage, chaque rangée démarre ailleurs, donc il n'existe pas de pièce de bout commune.
- **Il ne consomme pas un élément de plus.** Même nombre de bandes, même aire couverte : total et perte inchangés, seul le nombre de coupes monte. D'où la tuile « Rangées de bord » : sans elle, l'option semblerait sans effet.
- **Ce n'est pas un recentrage.** Recentrer le motif ne sacrifie rien mais produit **deux** filets de `r/2`.

## Liste de débit

Les pièces coupées, groupées par cote et comptées : c'est ce qu'on emporte à la scie, deux à cinq cotes distinctes, pas une par pièce. Groupées **à l'arrondi d'affichage** (0,1 mm) : deux coupes que la feuille écrit pareil sont la même coupe.

## Presets

Un preset **pré-remplit** l'élément, les jeux, le jeu périphérique et le décalage. Il ne branche aucun calcul.

- **Il se pose entre ce qu'il ne touche pas et ce qu'il remplit.** La surface vient de la pièce, donc elle a son groupe, avant. Un contrôle qui réécrirait des champs situés au-dessus de lui se lirait comme un bug.
- **Sa valeur se dérive de la saisie** : rien à persister, aucune désynchronisation possible. Aucun preset ne correspond → `Personnalisé`.
- **Les jeux d'un preset s'expriment en termes de pose** (en bout, entre lames) et se traduisent en horizontal / vertical selon l'inversion en cours.
- **Un preset n'entre que s'il porte au moins une règle hors défaut.** Un format seul se tape en quatre secondes. Un format absent se tape par-dessus le preset le plus proche, qui garde ses règles.
- **Le carrelage est doublé** parce qu'au-delà de ~60 cm, le décalage ½ fait tuiler le carreau et la règle passe au ⅓. C'est exactement le savoir qu'un preset doit transmettre.
- **Le libellé porte le produit et le format, rien d'autre** : la valeur fermée du dropdown tronque en silence.

## Schéma

- **Un seul trait de joint, quel que soit le remplissage.** Cerner les coupes en orange sur fond orange effaçait la trame d'une rangée entièrement rabotée, et avec elle le décalage. C'est le remplissage qui dit « à couper ».
- **Au-delà de 1500 éléments, on cesse de cerner** : les filets se touchent et forment un aplat.
- **En vignette, les deux cotes de surface tombent** : la surface récupère environ un quart de la hauteur, et les cotes sont dans les champs juste au-dessus.

## Plan exporté

- **Les jeux vont dans les cases** : ils ne se mesurent pas à l'œil sur une trame.
- **Pas de case pour les rangées de bord** : leur cote est déjà une ligne de la liste de débit.
- **La note rappelle que la perte est estimée sans réemploi des chutes.**

## Décidé / écarté

- **Pas de sélecteur de mode ni de calcul par matériau** : le preset ne fait que remplir.
- **Reporté en v3 : réemploi des chutes et trait de scie**, pour une perte juste. Sur une surface rectangulaire sans ouvertures, la perte est déjà approchée en amont, et le réemploi ne se voit pas sur le dessin : son honnêteté reposerait sur la liste de débit.
- **Hors périmètre** :
  - déduction d'ouvertures (il faudrait un éditeur de liste de rectangles, que l'app n'a nulle part)
  - pose en diagonale ou en chevrons (l'algorithme repose sur des rectangles alignés aux axes)
  - barres d'approvisionnement distinctes de l'élément posé (ce serait un outil de débit)
  - **bardage à clin**, impossible par construction : un clin se recouvre, son jeu serait négatif et le recouvrement compté deux fois. Seule la claire-voie est représentable.
