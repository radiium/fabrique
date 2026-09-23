# Menuiserie — Brief UI

**Tech :** Flutter (iOS + Android + Web, pas de desktop dédié → web = mobile élargi).
**Thème :** clair uniquement.
**Ton :** sobre, fonctionnel, pensé atelier. Pas de fioritures, priorité à la lisibilité.

## Principes UX (contexte atelier)
- Lisible à bout de bras, en pleine lumière : **fort contraste**, gros texte, cibles tactiles ≥ 48 px.
- **Une seule main** : actions principales en bas de l'écran, dans le pouce.
- **Calcul en temps réel** : pas de bouton « calculer », le résultat et le schéma se mettent à jour à la saisie.
- Clavier numérique par défaut, résultats **copiables** d'un tap.

## Design system
- **Fond :** blanc cassé / gris très clair. **Cartes :** blanches, coins arrondis doux, ombre légère.
- **Accent :** une seule couleur chaude type bois/ambre pour les actions et surlignages ; le reste en gris neutre.
- **Surlignage « coupe » :** une couleur d'alerte discrète (orange) réservée aux pièces à découper dans les schémas.
- **Typo :** sans-serif géométrique, chiffres tabulaires pour les résultats.
- **Espacement :** généreux, aéré. Composants Material 3 de base, peu customisés.

## Écriture des textes
- **Vocabulaire d'atelier, un seul mot par chose.** Une cote qui s'appelle « largeur totale » à l'écran ne s'appelle pas « longueur » dans son aide ni dans un message d'erreur.
- **Ni tiret cadratin ni point-virgule dans un texte explicatif** (corps et points d'un `FieldHelp`, message d'erreur, toute prose de plus d'une ligne) : deux phrases, un deux-points ou une parenthèse. Un lecteur debout, en atelier, ne démêle pas une incise.
- **Le tiret reste où il sépare visuellement** : libellés à deux étages (`Surface — largeur`), notes de tuile, lignes `help` d'une ligne, légendes de schéma. Test : remplaçable par un saut de ligne, il reste ; incise au milieu d'une phrase, il part.
- **`help` énonce une contrainte, `about` explique.** Le premier reste affiché sous le champ, le second n'ouvre sa feuille qu'à la demande.

## Écran 1 — Accueil
- Titre + bouton **Réglages** (icône, haut droite).
- **Grille de cartes** d'outils : 2 colonnes mobile, 3–4 en web large (largeur de carte cible, pas un nombre fixe).
- Carte = icône ligne + nom + sous-titre 1 ligne.

## Écran 2 — Template outil (squelette commun)
Trois zones empilées sur mobile ; **2 colonnes en web large** (saisie+résultats à gauche, visualisation à droite fixe). Rupture ~800 px.
1. **Saisie** — champs de l'outil, en haut.
2. **Visualisation** — schéma central (le cœur, `CustomPaint`), zoom/déplacement au doigt.
3. **Résultats** — valeurs calculées, chacune avec bouton copier.

## Écran 3 — Réglages (liste courte)
Thème (clair, verrouillé) · Retour haptique (on/off) · Langue (FR).

---

## Périmètre MVP — 5 outils

1. Convertisseur d'unités
2. Avant-trous, vis & chevilles
3. Répartition de points
4. Calepinage *(outil signature)*
5. Niveau + inclinomètre *(capteurs)*

*Équerrage de caisson : gardé en réserve, hors MVP.*

---

## Outils

### 1. Convertisseur d'unités
- **Saisie :** valeur (num) · unité source (segmented mm/cm/m/pouce/pied) · toggle impérial composé (pied+pouce+fraction).
- **Visu :** double règle graduée (métrique / impérial) avec curseur.
- **Résultats :** la valeur dans toutes les unités à la fois, copiables.

### 2. Avant-trous, vis & chevilles
- **Saisie :** matériau (dropdown) · Ø vis (dropdown) · épaisseur pièce à fixer (num).
- **Visu :** coupe des 2 pièces vissées (trou de passage, guidage, lamage, pénétration).
- **Résultats :** Ø passage · Ø guidage · lamage · longueur de vis, avec courte justification.

### 3. Répartition
Outil de **calcul** avant tout : répartir des éléments identiques sur une largeur.

- **Règle de calcul :** on répartit des **éléments de largeur**, les points purs n'étant que le cas `largeur = 0`. Le nombre de jeux dépend des bords : `N + 1` bordé de deux écarts, `N − 1` bordé de deux éléments, `N` en mixte. Ex. : 3 points sur 100, bordés d'écarts → 25, 50, 75.
- **Deux modes** (segmented, `Calcul écart` · `Calcul nombre`) : nombre d'éléments connu → écart, ou écart souhaité → les deux nombres entiers qui encadrent la cible.
- **Saisie :** `Largeur totale` (num) · `Largeur d'un élément` (num, 0 = repères sans épaisseur) · selon le mode, `Nombre d'éléments` ou `Écart souhaité`.
- **Réglages avancés** (repliés, sans effet par défaut) : `Type de répartition` (les quatre dispositions de bords, en tuiles pictogramme + texte) · `Marges` (symétriques ⇒ un champ `Marge`, asymétriques ⇒ `Marge début` et `Marge fin`), retirées de la largeur totale avant le calcul.
- **Visu :** rangée cotée, largeur totale au-dessus, chaîne des jeux en dessous, marges hachurées. Zoom/pan.
- **Résultats :** écart · entraxe (si l'élément a une largeur) · l'autre borne entière en mode `Calcul nombre` · table des positions.

> Chaque champ porte un ⓘ qui ouvre son explication en feuille basse ; les contenus vivent dans `distribution_help.dart`.

### 4. Calepinage — *outil signature*
Un seul outil unifié, pas de sélecteur de mode. Surface rectangulaire, éléments rectangulaires identiques. Le calcul est le même pour du carrelage, une lame, une dalle, un parquet ou une plaque de plâtre : c'est ce qui autorise un outil unique, et le sélecteur de matériau ci-dessous ne le remet pas en cause.

- **Saisie**, dans cet ordre :
  1. `Surface` — largeur × longueur (num, appariés).
  2. `Matériau` (dropdown) — **preset** qui pré-remplit ce qui suit.
  3. `Élément` — largeur × longueur (num, appariés).
  4. `Décalage des joints` (segmented : **Droit · ½ · ⅓**, défaut ½) — décale le début de chaque rangée par rapport à la précédente.
- **Réglages avancés** (repliés en pied de carte, sans effet par défaut) : `Jeu horizontal` × `Jeu vertical` (num, défaut 0 = jointif) · `Jeu périphérique` (num, défaut 0) · `Inverser l'orientation` (toggle, défaut off) · `Équilibrer les rangées` (toggle, défaut off).
- **Visu :** vue de dessus, grille d'éléments identiques, décalage des joints visible d'une rangée à l'autre, **éléments de bord incomplets dessinés comme des coupes** (surlignés orange), jeu périphérique hachuré comme les marges de la Répartition. Zoom/pan.
- **Résultats :** nombre d'éléments entiers · nombre d'éléments à couper · total · surface · **% de perte** · rangées de bord équilibrées, quand la règle a joué.
- **Refus :** une saisie refusée par le cœur affiche son motif dans la carte de saisie, et non un tiret muet. Même écart assumé que la Répartition, et pour la même raison en plus forte : l'outil a huit contrôles, et le jeu périphérique rend l'écart invisible puisque la zone à couvrir n'est plus la surface saisie. Le message porte les deux cotes.

> **Le preset se pose à la frontière entre ce qu'il ne touche pas et ce qu'il remplit.** La surface vient de la pièce et lui échappe, donc elle passe avant ; l'élément, le décalage et les deux jeux sont à lui, donc ils suivent. Un contrôle qui réécrirait des champs situés au-dessus de lui se lirait comme un bug. Il ne fait que **pré-remplir** : tout reste modifiable, et la valeur affichée se **dérive** de la saisie courante (aucun preset ne correspond → `Personnalisé`), donc rien de neuf à persister et aucune désynchronisation possible.

> **Un preset n'entre que s'il porte au moins une règle hors défaut.** Celui qui ne transporterait qu'un format remplit deux champs qu'on tape en quatre secondes — c'est le même tri sévère que les unités du Convertisseur. Un format absent se tape à la main par-dessus le preset le plus proche, qui garde ses jeux et son décalage.

| Entrée | Jeu | Périphérique | Décalage |
|---|---|---|---|
| `Placo 1200×2500` | 0 | 0 | droit |
| `Carrelage 600×600` | 2 | 5 | droit |
| `Carrelage 600×1200` | 2 | 5 | ⅓ |
| `Parquet 1285×192` | 0 | 10 | ⅓ |
| `Terrasse 4000×145` | 3 en bout, 5 entre lames | 10 | droit |
| `Panneau 2500×1250` | 1 | 10 | ½ |

> **Le libellé porte le produit et le format, et rien d'autre.** La valeur fermée d'un `DropdownMenu` tronque en silence, comme un segment, et il ne reste que ~256 px après le rembourrage et le chevron. ⚠️ Un nom de produit suivi de deux cotes ne tient pas dans les 14 caractères qu'autorise la police des tests : ce contrôle ne peut **pas** passer la mesure pessimiste, et son test garde le rapport plutôt que le seuil. À vérifier sur appareil.

> **`Inverser l'orientation` a rejoint le panneau replié**, faute de place : la carte ne tient que quatre lignes visibles avant que le schéma ne passe sous la ligne de flottaison, et le sélecteur de matériau en prend une. L'inversion vaut `false` par défaut, donc la règle du repli tient, et la pastille de l'en-tête s'allume quand elle est active — c'est ce qui rattrape sa perte de visibilité.

> Le carrelage est le seul produit doublé, et il le mérite : au-delà de ~60 cm de long côté, le décalage ½ fait tuiler les carreaux et la règle passe au ⅓. C'est le genre de savoir qu'un preset a vocation à transmettre. Les jeux d'un preset s'expriment en termes de pose (`en bout` le long des éléments, `entre lames` en travers) et se traduisent en `Jeu horizontal`/`Jeu vertical` au moment du remplissage, selon l'inversion en cours — la convention « les jeux restent définis à l'écran » ne bouge pas.

> **Le dépliant porte une pastille d'accent dès qu'une valeur repliée n'est plus à son défaut.** Sans elle, un preset amènerait le jeu périphérique à 10 mm derrière un panneau fermé, et on cacherait la raison d'un résultat surprenant — exactement ce que la règle du repli interdit. La pastille ne change pas la largeur du titre et ne force pas l'ouverture. Elle vaut pour tous les outils à dépliant.

> **Équilibrage — ne jamais finir sur un filet.** Quand la dernière rangée tombe sous un demi-élément, on sacrifie une rangée pleine et on partage son épaisseur avec le reliquat entre la première et la dernière, qui deviennent identiques. Règle universelle (carrelage d'abord, mais aussi lames, plaques et dalles), visible sur le schéma, et valable quelle que soit la surface. Elle s'applique toujours sur l'empilement des rangées, et sur l'axe de pose **seulement en décalage droit** : avec un décalage, il n'existe plus de pièce de bout commune à équilibrer. ⚠️ **Elle ne change aucun chiffre** : même nombre d'éléments, même perte — elle déplace une rangée du plein vers la coupe, donc seul le nombre d'éléments à couper monte. Conséquence pour l'écran : la seule preuve qu'elle a joué, c'est le schéma et la tuile qui donne l'épaisseur des rangées de bord. Sans cette tuile, l'option semblerait sans effet.

> **Décalage — v2 (honnête simple) :** le décalage est dessiné correctement et chaque début de rangée décalé est compté comme une coupe, **sans réemploi des chutes**. Le % de perte est donc légèrement pessimiste — à indiquer clairement dans les résultats.
> **v3 (raffinement) :** réemploi de la chute de début de rangée et trait de scie, pour un % de perte juste et une liste de débit. Reporté : sur une surface forcément rectangulaire et sans ouvertures, la perte est déjà approchée en amont, et le réemploi ne se voit pas sur le dessin.
> Le décalage n'a d'effet visible que pour des éléments allongés (lames) ; pour des éléments ~carrés ou du placo pleine plaque, l'option reste dispo mais son effet est marginal.

> Hors périmètre : déduction d'ouvertures (il faudrait un éditeur de liste de rectangles, motif d'UI que l'app n'a nulle part) · pose en diagonale ou en chevrons (tout l'algorithme repose sur des rectangles alignés aux axes) · barres d'approvisionnement distinctes de l'élément posé (ce serait un outil de débit, pas le calepinage) · **bardage à clin**, structurellement impossible : un clin se recouvre, donc son jeu serait négatif et la zone de recouvrement se compterait deux fois. Seule la claire-voie est représentable.

### 5. Niveau + inclinomètre — *capteurs*
Accès à l'accéléromètre (`sensors_plus`). Deux fonctions dans un même écran.

- **Fonctions :**
  - **Niveau à bulle :** bulle mobile, indication à plat / d'aplomb, angle en degrés temps réel.
  - **Inclinomètre / rapporteur :** inclinaison d'une surface en y posant le téléphone.
- **Saisie :** aucune (lecture capteur). Bouton **« mettre à zéro »** (calibrage sur surface de référence).
- **Visu :** la vedette de l'écran — niveau à bulle dessiné (`CustomPaint`), valeur d'angle large et lisible.
- **Résultats :** angle courant (degrés) · état à plat / d'aplomb.

> Note : la précision dépend du capteur du téléphone → le calibrage « zéro » est important pour la crédibilité.

---

**Notes designer :** cohérence maximale entre outils (même template, mêmes composants) ; la zone visualisation est la vedette de chaque écran, elle ne doit jamais être reléguée sous la ligne de flottaison sur mobile (schéma compact visible sans scroll, extensible au tap).