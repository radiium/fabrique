# Calepinage — outil signature

Poser des éléments rectangulaires identiques sur une surface rectangulaire : carrelage, lames, parquet, dalles, plaques. Le calcul est le même pour tous, c'est ce qui autorise **un seul outil, sans sélecteur de mode**.

| Couche | Fichiers |
|---|---|
| Calcul | `lib/core/calc/layout.dart` · `test/core/calc/layout_test.dart` |
| Écran | `lib/features/layout/` : `_screen`, `_controller`, `_help`, `_presets` |
| Schéma | `_schema`, `_painter` |
| Plan | `_plan` · `test/features/layout/layout_plan_test.dart` |

---

## Règles métier

- **Axes.** Les éléments s'alignent le long d'un **axe de pose**, les rangées s'empilent perpendiculairement. Le décalage de joints décale le départ de chaque rangée **le long de l'axe de pose**. Sans inversion, l'axe de pose est X.
- **L'inversion pivote tout le motif d'un quart de tour, décalage compris.** Décaler les joints d'un bardage vertical n'a de sens que le long des lames.
- **Les jeux restent définis à l'écran** : `gapX` horizontal, `gapY` vertical, quelle que soit l'inversion.
- **Le jeu périphérique** se retire des quatre bords. La pose recule, la pièce ne rétrécit pas : `surfaceArea` reste l'aire entière.
- **Pas de réemploi des chutes.** Chaque pièce coupée consomme un élément entier : le % de perte est **volontairement pessimiste**, et l'écran doit continuer à le dire.
- **`kMaxLayoutElements` (5000)** borne le volume : un élément de 1 mm saisi par mégarde demanderait des millions de rectangles.

### Équilibrage : ne jamais finir sur un filet

Quand la dernière rangée tombe sous un demi-élément, on **sacrifie une rangée pleine** et on partage son épaisseur avec le reliquat entre la première et la dernière, qui deviennent identiques.

Sur un axe de portée `s`, élément `e`, jeu `g` :

1. `n = ⌊(s − e)/(e + g)⌋ + 1` rangées pleines, reliquat `r = s − n·(e + g)`.
2. On ne touche à rien si `r ≤ 0` (ça tombe juste), si `r ≥ e/2` (pas un filet) ou si `n < 2` (rien à sacrifier).
3. Sinon, les deux rangées de bord font `(e + r)/2`.

- **Invariant** : `e/2 ≤ (e + r)/2 < 3e/4`. Ça se vérifie à l'œil sur le schéma.
- **L'empilement s'équilibre toujours, l'axe de pose seulement en décalage droit.** Sous décalage, chaque rangée démarre ailleurs, donc il n'existe pas de pièce de bout commune. Et l'équilibrage s'exprime par le départ de rangée, que le décalage occupe déjà.
- ⚠️ **Il ne consomme pas un élément de plus.** Même nombre de bandes, même aire couverte : `totalCount` et `wastePercent` inchangés, seul `cutCount` monte. Contre-intuitif, épinglé par un test. D'où la tuile « Rangées de bord » : sans elle, l'option semblerait sans effet.
- **Ce n'est pas un recentrage.** Recentrer le motif ne sacrifie rien mais produit **deux** filets de `r/2`.

---

## Calcul

### Signatures

```dart
@freezed
class LayoutInput {
  const factory LayoutInput({
    required double surfaceX, required double surfaceY,   // mm
    required double elementX, required double elementY,   // mm
    @Default(0) double gapX, @Default(0) double gapY,
    @Default(0) double perimeterGap,        // retiré sur les 4 bords
    @Default(false) bool balanceRows,
    @Default(false) bool flip,
    @Default(JointOffset.half) JointOffset offset,       // straight · half · third
  }) = _LayoutInput;
}

@freezed
class PlacedElement {                        // coordonnées surface, mm
  const factory PlacedElement({
    required double x, required double y,  // coin haut-gauche
    required double w, required double h,  // dimensions réellement posées
    required bool isCut,
  }) = _PlacedElement;
}

@freezed
class LayoutResult {
  const factory LayoutResult({
    required List<PlacedElement> elements,
    required int fullCount, required int cutCount,
    required int totalCount,                 // fullCount + cutCount
    required double surfaceArea, required double coveredArea,
    required double wastePercent,
    double? balancedRow,                     // épaisseur des rangées de bord, si équilibrage
    double? balancedEnd,                     // longueur des pièces de bout, si équilibrage de l'axe de pose
  }) = _LayoutResult;
}

@freezed
class CutPiece {
  const factory CutPiece({required double w, required double h, required int count}) = _CutPiece;
}

LayoutResult computeLayout(LayoutInput input);
List<CutPiece> summarizeCuts(LayoutResult result);   // la liste de débit
const int kMaxLayoutElements = 5000;
```

### Algorithme

1. **Repère de pose** `(u, v)` : `u` = axe de pose, `v` = empilement. `flip` échange les dimensions de surface et les jeux, pas l'élément. Tout le reste travaille en `(u, v)` sans savoir qu'il y a eu inversion.
2. **Zone de pose** : surface moins `2 × perimeterGap`, origine en `(p, p)`.
3. **Garde de volume** : estimation haute, en `double` (un `ceil()` sur un quotient énorme déborderait l'entier 64 bits).
4. **Équilibrage** éventuel (voir plus haut), exprimé comme un départ en arrière du bord.
5. **Rangées** : bandes de `ev + gapV`. Une bande rabotée rend toutes ses pièces `isCut`.
6. **Départ de rangée** : `step = {straight: 0, half: eu/2, third: eu/3}`, `startU = base − (rowIndex × step) % eu`. Un départ négatif coupe la première pièce.
7. **Dans la rangée** : pièces de `eu + gapU`, clippées à la zone de pose. Clippée = `isCut`.
8. **Dérivés** : `coveredArea = Σ w·h`, `wastePercent = (totalCount·eu·ev − coveredArea) / (totalCount·eu·ev) × 100`.

**Liste de débit (`summarizeCuts`)** : les pièces coupées, groupées par cote et comptées, de la plus grande à la plus petite. C'est ce qu'on emporte à la scie : deux à cinq cotes distinctes, pas une par pièce. Groupées **à l'arrondi d'affichage** (0,1 mm) : deux coupes que la feuille écrit pareil sont la même coupe. Dans `core/calc` et pas dans l'écran, pour rester testable sans appareil.

### Refus (`CalcException`)

Les messages **nomment les cotes comme l'écran** et portent les chiffres :

- dimension nulle, négative ou non finie (« La largeur de surface doit être un nombre positif »)
- jeu négatif
- jeu périphérique qui ne laisse rien à couvrir (« … de 600 mm ne laisse rien à couvrir sur 1000 mm »)
- élément plus grand que la **zone à couvrir**, les deux cotes face à face (avec un jeu périphérique, la zone n'est plus la surface saisie)
- volume au-delà de `kMaxLayoutElements`, avec l'**ordre de grandeur** (sur une faute de frappe, il y a deux zéros d'écart, et c'est ça qui dit où chercher)

### Cas de test attendus

- **Pile-poil** : 1000×1000, élément 100×1000, droit → 10 pleines, 0 coupe, perte 0.
- **Coupe en X** : 1050×1000, élément 100×1000 → 10 pleines + 1 coupe de 50, perte ≈ 4,5 %.
- **Refente en Y** : 1000×250, élément 1000×100 → 2 rangées pleines + 1 rabotée, marquée coupe.
- **Décalage** : ½ coupe la rangée décalée, ⅓ se répète toutes les 3 rangées, et le décalage pivote avec l'inversion.
- **Jeux** : `gapX` réduit les pièces par rangée et sort les jeux de `coveredArea`.
- **Jeu périphérique** : 1020×1000, `perimeterGap: 10`, élément 100×980 → 10 pleines, 0 coupe, `surfaceArea` = 1 020 000 mm², premier élément en `(10, 10)`.
- **Équilibrage** : 1000×950, élément 1000×200 → reliquat 150 ≥ 100, rien ne bouge. 1000×1010 → 4 pleines + 2 de bord de 105. 1000×250 → `n = 1`, rien à sacrifier. Sous décalage, `balancedEnd` reste nul. Même `totalCount` et même perte qu'en non équilibré.
- **Liste de débit** : décalage ½ sur 1000×300, élément 200×100 → une seule cote (100×100) portée par 2 pièces. Rien à couper → liste vide.
- **Refus** : chaque cas ci-dessus, et un élément exactement à la dimension de la surface est accepté.

---

## Écran

### Saisie, dans cet ordre

1. `Surface — largeur` · `Surface — longueur` (paire)
2. `Matériau` : dropdown de presets, qui pré-remplit ce qui suit
3. `Élément — largeur` · `Élément — longueur` (paire)
4. `Décalage des joints` : `Droit` · `½` · `⅓` (défaut ½)

Repliés dans `Réglages avancés` : `Jeu horizontal` · `Jeu vertical` · `Jeu périphérique` · `Inverser l'orientation` · `Équilibrer les rangées`. Tous à 0 ou éteints par défaut.

- **Les cotes vont par paires** : six champs empilés pousseraient le schéma sous la ligne de flottaison.
- **`Inverser l'orientation` est replié faute de place** : la carte ne tient que quatre lignes visibles avant que le schéma passe sous la ligne de flottaison, et le sélecteur de matériau en prend une.
- **Pas de ⓘ sur les deux interrupteurs** : leur explication tient dans leur ligne `help`.

**Défauts** (`kLayoutDefaults`) : surface 3000 × 2000, élément 1200 × 200, décalage ½.

### Presets

Un preset **pré-remplit** l'élément, les jeux, le jeu périphérique et le décalage. Il ne branche aucun calcul, donc la table vit côté feature (`layout_presets.dart`).

- **Il se pose entre ce qu'il ne touche pas et ce qu'il remplit.** La surface vient de la pièce, donc elle passe avant. Un contrôle qui réécrirait des champs situés au-dessus de lui se lirait comme un bug.
- **Sa valeur se dérive de la saisie** (`matchLayoutPreset`) : rien à persister, aucune désynchronisation possible. Aucun preset ne correspond → `Personnalisé`, proposé seulement quand c'est la valeur courante.
- **Une seule affectation** (`applyPreset`), pas six appels de champ, sinon cinq reconstructions sur des états intermédiaires.
- **Les jeux d'un preset s'expriment en termes de pose** (`en bout`, `entre lames`) et se traduisent en `gapX` / `gapY` selon l'inversion en cours.
- **La pastille des réglages avancés** s'allume quand un preset y a rempli un champ.

| Libellé | Jeu | Périphérique | Décalage |
|---|---|---|---|
| `Placo 1200×2500` | 0 | 0 | droit |
| `Carrelage 600×600` | 2 | 5 | droit |
| `Carrelage 600×1200` | 2 | 5 | ⅓ |
| `Parquet 1285×192` | 0 | 10 | ⅓ |
| `Terrasse 4000×145` | 3 en bout, 5 entre lames | 10 | droit |
| `Panneau 2500×1250` | 1 | 10 | ½ |

- **Un preset n'entre que s'il porte au moins une règle hors défaut.** Un format seul se tape en quatre secondes. Un format absent se tape par-dessus le preset le plus proche, qui garde ses règles.
- **Le carrelage est doublé** parce qu'au-delà de ~60 cm, le décalage ½ fait tuiler le carreau et la règle passe au ⅓. C'est exactement le savoir qu'un preset doit transmettre.
- **Le libellé porte le produit et le format, rien d'autre** : la valeur fermée du dropdown tronque en silence à ~256 px.

### Refus affiché

Motif dans la carte de saisie (`ErrorBanner`), pas de tiret muet. Voir [ui/tool-screen.md](../ui/tool-screen.md).

### Résultats

- `Éléments entiers`
- `Éléments à couper` (« Surlignés en orange sur le schéma »)
- `Rangées de bord`, **seulement si l'équilibrage a joué**, avec la longueur des pièces de bout le cas échéant
- `Total à prévoir` (« Stock sans réemploi des chutes »)
- `Surface` en m², avec la surface couverte en note
- `Perte` en %, avec la mention de l'estimation pessimiste

---

## Schéma

Vue de dessus : les rectangles posés par le cœur, `isCut` compris. Le painter ne fait que mettre à l'échelle.

- **Échelle uniforme** : on doit juger la proportion des lames à l'œil.
- **Éléments en `field`, surface découverte en blanc.** Pièces à couper remplies en orange.
- **Un seul trait de joint, quel que soit le remplissage.** Cerner les coupes en orange sur fond orange effaçait la trame d'une rangée entièrement rabotée, et avec elle le décalage. C'est le remplissage qui dit « à couper ».
- **Au-delà de 1500 éléments, on cesse de cerner** : les filets se touchent et forment un aplat.
- **Jeu périphérique hachuré**, comme les marges de la Répartition.
- **Contour de la surface tracé en dernier**, pour rester net là où une pièce affleure.
- **Deux cotes de surface** (largeur au-dessus, longueur à gauche) et l'unité en bas. En vignette (`compact`), elles tombent : la surface récupère ~quart de la hauteur, et les cotes sont dans les champs juste au-dessus.

---

## Plan exporté

`buildLayoutPlan`. Mécanique générique : [drawing/export.md](../drawing/export.md).

**Cases** : `DATE` · `ÉLÉMENT` · `DÉCALAGE` · `JEU` (si non nul) · `JEU PÉRIPH.` (si non nul) · `ENTIERS` · `À COUPER` · `TOTAL` · `SURFACE` (couverte, en m²) · `PERTE`.

- La surface est cotée sur le dessin. L'élément est dessiné sans être coté, et les jeux ne se mesurent pas à l'œil sur une trame : ils vont dans les cases.
- Pas de case pour les rangées de bord : leur cote est déjà une ligne de la liste de débit.

**Table** `PIÈCES À COUPER` : `N°` · `LARG. (mm)` · `LONG. (mm)` · `NB`. Le compte va en dernière colonne, jamais dans la première (étroite). Repli : `Aucune coupe, tout tombe juste`, ou `N cotes de coupe — à lire dans l'app`.

**Note** : « Perte estimée sans réemploi des chutes. Chaque coupe consomme un élément entier. »

---

## Gardes de test

- le schéma reste au-dessus de la ligne de flottaison
- les réglages avancés sont repliés et sans effet, la pastille ne s'allume que sur un réglage replié modifié
- la tuile des rangées de bord n'apparaît qu'équilibrée
- le refus se lit dans la carte de saisie
- les presets remplissent tout d'un coup, leurs jeux suivent le sens de pose, la valeur se dérive, « Personnalisé » ne s'offre pas quand un preset est pris
- aucun libellé de preset ne déborde la valeur fermée : ⚠️ ce test garde **le rapport** et non le seuil, car un nom de produit et deux cotes ne peuvent pas tenir dans les 14 caractères de la police de test (voir [roadmap.md](../roadmap.md))
- le cartouche porte l'avertissement, toutes les cotes de coupe ou aucune, et ne répète pas ce que le dessin cote

---

## Décidé / écarté

- **Pas de sélecteur de mode ni de calcul par matériau** : le preset ne fait que remplir.
- **Reporté en v3 : réemploi des chutes et trait de scie**, pour une perte juste. Sur une surface rectangulaire sans ouvertures, la perte est déjà approchée en amont, et le réemploi ne se voit pas sur le dessin : son honnêteté reposerait sur la liste de débit.
- **Hors périmètre** :
  - déduction d'ouvertures (il faudrait un éditeur de liste de rectangles, que l'app n'a nulle part)
  - pose en diagonale ou en chevrons (l'algorithme repose sur des rectangles alignés aux axes)
  - barres d'approvisionnement distinctes de l'élément posé (ce serait un outil de débit)
  - **bardage à clin**, impossible par construction : un clin se recouvre, son jeu serait négatif et le recouvrement compté deux fois. Seule la claire-voie est représentable.
- **Le décalage n'a d'effet visible que sur des éléments allongés.** Sur un carré ou une plaque pleine, l'option reste mais son effet est marginal.
