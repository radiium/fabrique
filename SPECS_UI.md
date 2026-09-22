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

### 3. Répartition de points
Outil de **calcul** avant tout : répartir des points équidistants sur une longueur.

- **Règle de calcul :** N points → **N+1 espaces**. Les extrémités (0 % et 100 %) ne sont jamais des points ; seuls les points intermédiaires comptent. Ex. : 1 point = 2 espaces = longueur ÷ 2 (point au milieu) ; 3 points sur 100 = points à 25, 50, 75.
- **Saisie :** longueur totale (num) · nombre de points **⇔** nombre d'espaces (deux champs **liés** : espaces = points + 1 ; le champ en cours d'édition pilote l'autre).
- **Visu :** barre horizontale, points cotés, espaces égaux affichés (le visuel porte l'explication du modèle « pas de point aux extrémités »).
- **Résultats :** entraxe (longueur d'un espace) · positions cumulées de chaque point depuis l'origine.

> Hors périmètre : éléments avec largeur, toggle extrémités, gestion des bords. On reste sur des points purs.

### 4. Calepinage — *outil signature*
Un seul outil unifié, pas de sélecteur de mode. Surface rectangulaire, éléments rectangulaires identiques.

- **Saisie :**
  - Surface : largeur × longueur (num).
  - Élément : largeur × longueur (num).
  - Espacement entre éléments : X, Y, ou X et Y (num, optionnel, défaut 0 = jointif).
  - Inversion d'orientation de l'élément (toggle).
  - **Décalage des joints** (segmented : **Droit · ½ · ⅓**, défaut ½) — décale le début de chaque rangée par rapport à la précédente.
- **Visu :** vue de dessus, grille d'éléments identiques, décalage des joints visible d'une rangée à l'autre, **éléments de bord incomplets dessinés comme des coupes** (surlignés orange). Zoom/pan.
- **Résultats :** nombre d'éléments entiers · nombre d'éléments à couper · total · surface · **% de perte**.

> **Décalage — v1 (honnête simple) :** le décalage est dessiné correctement et chaque début de rangée décalé est compté comme une coupe, **sans réemploi des chutes**. Le % de perte est donc légèrement pessimiste — à indiquer clairement dans les résultats.
> **v2 (raffinement) :** réemploi de la chute de début de rangée pour un % de perte juste (suivi des chutes rangée par rangée).
> Le décalage n'a d'effet visible que pour des éléments allongés (lames) ; pour des éléments ~carrés ou du placo pleine plaque, l'option reste dispo mais son effet est marginal.

> Hors périmètre : jeu périphérique, équilibrage des rangées, déduction d'ouvertures, matériaux nommés (parquet/placo). Le calcul est identique quel que soit le matériau → un seul outil.

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