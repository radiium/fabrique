# Menuiserie — Spec technique (architecture + `core/calc`)

> Fait suite au brief UI. Couvre l'architecture applicative et la couche de calcul pur.
> Stack vérifiée à jour début 2026 (Riverpod 3 stable, `riverpod_annotation`/`generator` 4.x, go_router recommandé). Épingler les versions courantes sur pub.dev au démarrage.

---

# Partie 1 — Architecture

## Philosophie
App portfolio de 5 outils → **ni sur-ingénierie, ni tout dans les widgets**. Le bon niveau : séparation nette **calcul pur (testé) ↔ UI**, organisation *feature-first*, state management propre. La vitrine technique = un **cœur de calcul en Dart pur, sans dépendance Flutter, couvert par des tests unitaires**.

## Gestion d'état — Riverpod 3 (codegen)
- Choix par défaut moderne. Parallèle Angular : **providers ≈ services injectables**, résolus par DI, observables par l'UI — mais compile-time safe, sans `BuildContext`, testables en isolation (override d'un provider ≈ mock d'un service).
- **Un provider par écran-outil** tient l'état de saisie (formulaire) et expose le résultat.
- **Providers globaux** pour réglages (thème, haptique) et flux capteur du niveau.
- Le **résultat est une dérivation**, pas de l'état : un provider dérivé `watch` la saisie et appelle le cœur de calcul pur → colle au « calcul temps réel, pas de bouton calculer ».
- Adopter le **code generation** (`@riverpod`) dès le début → implique `build_runner`.

## Librairies externes (resserré)
- `flutter_riverpod` + `riverpod_annotation` + `riverpod_generator` — état/DI.
- `go_router` — navigation déclarative, deep-linking web-ready (2 routes suffisent).
- `sensors_plus` — accéléromètre (niveau/inclinomètre).
- `shared_preferences` — persistance légère.
- `freezed` + `json_serializable` — modèles immuables, `copyWith`, pattern matching.
- `flutter_localizations` + `intl` — i18n câblé, publié FR seulement.
- `build_runner` — dev dependency, moteur du codegen.

**Écartés au MVP :** pas de base de données (Isar/Drift) tant que les « projets » ne sont pas au programme ; pas de DI tierce (Riverpod suffit).

## Persistance
- **Réglages** (thème, haptique) → `shared_preferences`.
- **Dernières valeurs saisies par outil** (rouvrir l'app = tout est là) → `shared_preferences`, une clé/outil, JSON via modèles freezed.
- Plus tard, fonctionnalité « projets » → vraie base locale (**Drift** pour du SQL typé, **Isar/ObjectBox** pour de l'objet rapide), isolée derrière un repository à ce moment-là seulement.

## Structure de dossiers
*Feature-first* ; le partagé vit dans `core` ; le cœur de calcul est isolé de l'UI.

```
lib/
├── main.dart
├── app/
│   ├── app.dart              # MaterialApp.router, thème clair, localizations
│   ├── router.dart           # go_router : accueil + /tool/:id
│   └── theme.dart            # design system (bois/ambre, typo tabulaire)
│
├── core/
│   ├── calc/                 # ★ CŒUR DE CALCUL — Dart pur, ZÉRO import Flutter
│   │   ├── units/            # conversions, fractions impériales
│   │   ├── distribution.dart # répartition de points
│   │   ├── layout.dart       # calepinage
│   │   ├── fasteners.dart    # avant-trous / vis
│   │   └── tilt.dart         # angles depuis l'accéléromètre
│   ├── models/               # value objects freezed partagés (enums…)
│   ├── persistence/          # wrapper shared_preferences
│   └── widgets/              # UI réutilisée (ToolScaffold, ResultTile,
│                             #   NumberField, ZoomableCanvas…)
│
├── features/
│   ├── home/                 # home_screen, tool_card
│   ├── converter/            # _screen, _controller, _painter
│   ├── distribution/         # _screen, _controller, _painter
│   ├── layout/               # _screen, _controller, _painter (★ pièce visuelle)
│   ├── fasteners/            # _screen, _controller, _painter
│   └── level/                # _screen, _controller (sensors_plus), _painter
│
└── l10n/                     # .arb (fr) → AppLocalizations

test/
└── core/calc/                # ★ tests unitaires du cœur
    ├── units_test.dart
    ├── distribution_test.dart
    ├── layout_test.dart
    ├── fasteners_test.dart
    └── tilt_test.dart
```

Chaque feature suit le **même trio** : `_screen` (vue) · `_controller` (provider qui tient la saisie et dérive le résultat) · `_painter` (`CustomPaint`). Régularité = code parcourable, « app pensée ».

## Pattern d'un outil (flux de données)
1. **Modèle de saisie** freezed immuable (ex. `DistributionInput`).
2. **Controller** `@riverpod` tient l'input, une méthode par champ (`setLength`…) qui fait `copyWith`.
3. **Provider dérivé** `watch` l'input → appelle la fonction pure du `core/calc` → renvoie le résultat.
4. **Écran** `watch` le résultat : champs, painter, tuiles se reconstruisent seuls. Zéro `setState`, zéro bouton calculer.
5. **Painter** reçoit le résultat et dessine — il ne calcule rien.

Discipline **« le painter peint, le core calcule »** : logique testable sans widget, pas de maths dupliquées dans le rendu.

---

# Partie 2 — Couche `core/calc`

Dart pur, **zéro import Flutter**, aucune I/O. Fonctions déterministes, testables sans widget. Les painters consomment ces sorties sans recalculer.

**Conventions transverses**
- Unité interne unique : le **millimètre** (`double`). Conversions aux frontières (UI).
- Entrées invalides → `CalcException` ; jamais de valeur silencieuse fausse.
- Modèles `@freezed`, immuables.

## 0. Modèles partagés — `core/models`
```dart
enum LengthUnit { mm, cm, m, inch, foot }

enum Material { softwood, hardwood, chipboard, plywood }
enum JointOffset { straight, half, third }
```

## 1. Units — `units/`
**But :** convertir entre unités, gérer l'impérial composé (pied + pouce + fraction).
```dart
double toMm(double value, LengthUnit unit);
double fromMm(double mm, LengthUnit unit);

@freezed
class ImperialParts {
  const factory ImperialParts({
    required int feet, required int inches,
    required int num,  // numérateur (0 si entier)
    required int den,  // dénominateur (16, 32…)
  }) = _ImperialParts;
}

ImperialParts mmToImperial(double mm, {int denominator = 16});
double imperialToMm(ImperialParts p);
String formatImperial(ImperialParts p); // ex. 2' 6 3/8"
```
**Notes** — arrondi au 1/`denominator` de pouce le plus proche, **propagation des retenues** (16/16 → +1 po ; 12 po → +1 pi) ; fraction **réduite** (6/16 → 3/8).

**Cas de test**
- `toMm(1,'inch')` → 25.4 ; `toMm(1,'foot')` → 304.8.
- Round-trip `fromMm(toMm(x,u),u) == x` (tol. 1e-9) pour chaque unité.
- `mmToImperial(304.8)` → 1'0" ; `mmToImperial(15.875,den:16)` → 5/8".
- Retenue : proche de 25.4 → 1" pile, pas 16/16.
- Réduction : 6/16 → 3/8 ; 8/16 → 1/2.

## 2. Distribution — `distribution.dart`
**But :** répartir N éléments identiques sur une largeur. Les points purs sont le cas `elementWidth = 0`. Le nombre de jeux est une conséquence des bords, pas une constante.
```dart
enum DistributionEdge { gap, element }   // ce qui borde chaque extrémité

@freezed
class DistributionInput {
  const factory DistributionInput({
    required double length,        // largeur totale, mm
    required int count,            // >= 0
    @Default(0) double elementWidth,
    @Default(DistributionEdge.gap) DistributionEdge startEdge,
    @Default(DistributionEdge.gap) DistributionEdge endEdge,
    @Default(0) double startOffset,  // marge de début, mm
    @Default(0) double endOffset,    // marge de fin, mm
  }) = _DistributionInput;
}

/// Même géométrie, mais c'est le nombre que l'on cherche.
@freezed
class DistributionTargetInput {
  const factory DistributionTargetInput({
    required double length,
    required double targetSpacing,
    // … mêmes champs optionnels que ci-dessus
  }) = _DistributionTargetInput;
}

@freezed
class DistributionResult {
  const factory DistributionResult({
    required int count,
    required int gapCount,            // N+1, N−1 ou N selon les bords
    required double spacing,          // jeu libre entre deux éléments
    required double pitch,            // entraxe = spacing + elementWidth
    required double span,             // length moins les deux marges
    required List<double> positions,  // bord d'attaque de chaque élément
    required List<double> centers,
  }) = _DistributionResult;
}

/// Les deux réponses entières qui encadrent un écart visé.
@freezed
class DistributionTargetResult {
  const factory DistributionTargetResult({
    required DistributionResult best,   // écart réel le plus proche
    required DistributionResult? other, // l'autre borne, si réalisable
  }) = _DistributionTargetResult;
}

DistributionResult computeDistribution(DistributionInput input);
DistributionTargetResult computeDistributionForSpacing(DistributionTargetInput input);
int minDistributionCount(DistributionEdge start, DistributionEdge end);
const int kMaxDistributionCount = 500;
```
**Algo** — `utile = length − startOffset − endOffset` ; `gapCount = count + 1 −` (nombre d'extrémités occupées par un élément) ; `spacing = (utile − count × elementWidth) / gapCount` ; les positions se déduisent par addition de l'entraxe depuis la marge de début. Le mode inverse résout `utile = N × largeur + (N + c) × écart` en N, puis rend les deux entiers voisins. **Pas de réglage d'arrondi** : qui a une contrainte de maximum lit la solution la plus serrée.

**Invalides → `CalcException`** : largeur totale ≤ 0, largeur d'élément négative, marge négative, marges qui occupent toute la largeur, un seul élément bordant les deux côtés. Les messages sont rédigés pour être affichés tels quels.

**Cas de test**
- Points purs : `(100,1)` → 50, `[50]` · `(100,3)` → 25, `[25,50,75]` · `(100,0)` → 100, `[]` · `(90,2)` → 30, `[30,60]`.
- Largeur : 2 éléments de 20 sur 100, bordés de jeux → écart 20, entraxe 40, positions `[20,60]`.
- Bords : pour 4 éléments, `gapCount` vaut 5 / 3 / 4 / 4 selon les quatre combinaisons.
- Marges : `(1000, 3, start:100, end:100)` → span 800, écart 200, `[300,500,700]`.
- `kMaxDistributionCount` borne les deux modes.

## 3. Layout (calepinage) — `layout.dart`
**But :** poser des éléments rectangulaires identiques sur une surface rectangulaire (espacement optionnel, inversion d'orientation, décalage de joints). Produit la **géométrie complète**.

**Convention d'axes** — surface `sx`(X)/`sy`(Y). Les éléments s'alignent le long d'un **axe de pose**, les rangées s'empilent perpendiculairement, et le décalage décale le **départ de rangée le long de l'axe de pose**. Sans `flip`, l'axe de pose est **X** et les rangées montent selon **Y** ; avec `flip`, tout le motif pivote d'un quart de tour — décalage compris.
```dart
@freezed
class LayoutInput {
  const factory LayoutInput({
    required double surfaceX, required double surfaceY,
    required double elementX, required double elementY,
    @Default(0) double gapX, @Default(0) double gapY,
    @Default(false) bool flip,               // pivote le motif d'un quart de tour
    @Default(JointOffset.half) JointOffset offset,
  }) = _LayoutInput;
}

@freezed
class PlacedElement {
  const factory PlacedElement({
    required double x, required double y,  // coin haut-gauche, mm
    required double w, required double h,  // dims réelles posées
    required bool isCut,                    // pièce partielle
  }) = _PlacedElement;
}

@freezed
class LayoutResult {
  const factory LayoutResult({
    required List<PlacedElement> elements,
    required int fullCount, required int cutCount,
    required int totalCount,      // fullCount + cutCount (stock v1, sans réemploi)
    required double surfaceArea, required double coveredArea,
    required double wastePercent,
  }) = _LayoutResult;
}

LayoutResult computeLayout(LayoutInput input);
```
**Algo (v1 — honnête simple, sans réemploi des chutes)**
1. Repère de pose : `u` = axe d'alignement des éléments (et du décalage), `v` = axe d'empilement des rangées. `su,sv = flip ? (sy,sx) : (sx,sy)` ; `eu,ev = elementX,elementY` ; `gapU,gapV = flip ? (gapY,gapX) : (gapX,gapY)` — les jeux restent définis à l'écran. Les étapes suivantes travaillent en `(u,v)` puis reviennent au repère surface.
2. **Rangées (v)** : bandes d'épaisseur `ev` + `gapV`, de 0 à `sv`. Dernière possiblement rabotée (`ev'<ev`) → tous ses éléments `isCut`.
3. **Départ de rangée** : `step = {straight:0, half:eu/2, third:eu/3}` ; `startU = -((rowIndex*step) % eu)`. Si `startU<0`, 1re pièce coupée.
4. **Dans la rangée (u)** : éléments de longueur `eu` + `gapU` depuis `startU`, **clippés** à `[0,su]`. Pièce clippée → `isCut`.
5. Dériver : `fullCount`/`cutCount`/`totalCount` ; `coveredArea = Σ(w*h)` ; `surfaceArea = sx*sy` ; `elementArea = eu*ev` ; `wastePercent = (totalCount*elementArea - coveredArea)/(totalCount*elementArea)*100`.
- **v2** : réemploi de la chute de début de rangée → recalcule `totalCount`/`waste`.
- Élément ≥ surface, dims ≤ 0 → exception.

**Cas de test**
- Pile-poil : 1000×1000, élém 100×1000, straight → 10 pleines, 0 coupe, waste 0.
- Coupe X : 1050×1000, élém 100×1000 → 10 pleines + 1 coupe (50), waste ≈ 4.5 %.
- Refente Y : 1000×250, élém 1000×100 → 2 rangées pleines + 1 rabotée (50) `isCut`.
- Décalage ½ : rangées décalées → 2 coupes/rangée.
- Flip : `flip:true` pivote le motif — les rangées s'empilent selon X, et le décalage joue le long de Y.
- Espacement : `gapX:5` réduit les éléments/rangée ; `coveredArea` exclut les jeux.
- Invalides : élément 0, surface négative → exception.

## 4. Fasteners (avant-trous / vis) — `fasteners.dart`
**But :** depuis matériau + Ø vis + épaisseur pièce à fixer, proposer avant-trous, lamage, longueur de vis.
> ⚠️ Coefficients = **règles de l'art indicatives**, centralisés dans une table à ajuster/valider à part. Le calc applique la table.
```dart
@freezed
class FastenerInput {
  const factory FastenerInput({
    required Material material,
    required double screwDiameter,   // Ø nominal, mm
    required double fixedThickness,  // épaisseur pièce traversée, mm
  }) = _FastenerInput;
}

@freezed
class FastenerResult {
  const factory FastenerResult({
    required double clearanceHole,   // Ø passage
    required double pilotHole,       // Ø guidage
    required double counterboreDia, required double counterboreDepth, // lamage
    required double screwLength, required double penetration,
  }) = _FastenerResult;
}

FastenerResult computeFastener(FastenerInput input);
```
**Table indicative (à ajuster)**
- `clearanceHole ≈ screwDiameter + 0.5`.
- `pilotHole = k * screwDiameter` : softwood 0.55, hardwood 0.70, chipboard 0.60, plywood 0.65.
- `counterboreDia ≈ 2*screwDiameter` ; `counterboreDepth` ≈ hauteur de tête.
- `penetration = min(2*fixedThickness, plafond)` ; `screwLength ≈ fixedThickness + penetration`.

**Cas de test**
- Softwood Ø4 ép.18 → pilot ≈ 2.2, clearance ≈ 4.5, penetration ≈ 36, length ≈ 54.
- Hardwood vs softwood → pilot plus grand (0.70 vs 0.55).
- Monotonicité : pilotHole croît avec screwDiameter.
- Cohérence : `pilotHole < clearanceHole < counterboreDia` toujours.
- Invalides : Ø ≤ 0, épaisseur ≤ 0 → exception.

## 5. Tilt (niveau / inclinomètre) — `tilt.dart`
**But :** dériver les angles d'un vecteur accéléromètre, avec offset de calibrage. Seule la **math** est ici ; la lecture `sensors_plus` reste dans le controller.
```dart
@freezed
class AccelReading {
  const factory AccelReading(double x, double y, double z) = _AccelReading;
}

@freezed
class TiltResult {
  const factory TiltResult({
    required double pitchDeg, required double rollDeg,
    required bool isLevel,
  }) = _TiltResult;
}

TiltResult computeTilt(AccelReading r, {
  AccelReading? zero,             // calibrage
  double levelThresholdDeg = 0.5,
});
```
**Algo** — `pitch = atan2(y, sqrt(x²+z²))` ; `roll = atan2(x, sqrt(y²+z²))` (degrés). Si `zero`, soustraire ses angles. `isLevel = |pitch|<seuil && |roll|<seuil`.

**Cas de test**
- À plat `(0,0,9.81)` → 0/0, level vrai.
- Côté `(9.81,0,0)` → roll ≈ 90°.
- Avant `(0,9.81,0)` → pitch ≈ 90°.
- Calibrage : lecture == zero → 0/0 après correction.
- Seuil : 0.4° < 0.5 → level vrai ; 0.6° → faux.

---

## Récap testabilité (angle portfolio)
| Module | Fonction pure | Démontre |
|---|---|---|
| units | `mmToImperial`, `toMm` | arrondi/fractions, round-trips |
| distribution | `computeDistribution` | logique métier simple, bien couverte |
| layout | `computeLayout` | algo non trivial + géométrie testable |
| fasteners | `computeFastener` | table de règles appliquée proprement |
| tilt | `computeTilt` | math de capteur isolée |

Chaque fonction est appelée par un provider Riverpod dérivé ; aucune ne dépend de Flutter. Tests dans `test/core/calc/`, lancés sans device.