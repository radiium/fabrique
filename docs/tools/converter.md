# Convertisseur

Une valeur, convertie dans toutes les unités de sa grandeur à la fois.

| Couche | Fichiers |
|---|---|
| Calcul | `lib/core/calc/units/` (`measures.dart`, `imperial.dart`, `units.dart`) · `test/core/calc/units_test.dart`, `measures_test.dart` |
| Modèles | `lib/core/models/measure_unit.dart`, `length_unit.dart` |
| Écran | `lib/features/converter/` : `_screen`, `_controller` |
| Schéma | `_schema`, `converter_painter.dart` (`RulerPainter`), `comparison_painter.dart` |

---

## Règles métier

- **Le tri des unités fait la valeur de l'outil.** Une unité n'entre que si on la croise sur un chantier **et** qu'elle est pénible sans outil. Sans ce tri, l'écran redevient un convertisseur générique, que le téléphone fait déjà mieux.
  - D'où le **pied-planche** (`pmp`, 144 po³), l'unité d'achat du bois dur, absente des convertisseurs génériques.
  - D'où **aucun préfixe SI pur** (mg, dL, hPa…) : un décalage de virgule se fait de tête.
- **Cinq unités au plus par grandeur**, symboles courts : c'est ce que tient un `AppSegmentedButton` sur un téléphone. Le millibar a été retiré pour cette seule raison (72 px mesurés pour 65,6 disponibles sur un écran de 400 px).
- **On ne convertit jamais d'une grandeur à l'autre** : `convert` lève.

| Grandeur | Pivot | Unités |
|---|---|---|
| Longueur | mm | mm · cm · m · po · pi |
| Surface | mm² | mm² · cm² · m² · po² · pi² |
| Volume | mm³ | cm³ · L · m³ · po³ · pmp |
| Masse | g | g · kg · t · oz · lb |
| Pression | Pa | bar · kPa · MPa · PSI |

Les pivots de surface et de volume ne sont pas proposés à l'écran (personne ne commande du bois en mm³). Les facteurs impériaux sont **exacts** (le pouce vaut 25,4 mm par définition).

## Calcul

- `convertAll(value, unit)` : la valeur dans toutes les unités de sa grandeur. C'est ce que l'écran affiche.
- `convert(value, from, to)` : une conversion, qui lève entre deux grandeurs.
- `toBase` / `fromBase` et `baseFactor(unit)` : le passage par le pivot.
- `toMm` / `fromMm` et `mmPerUnit(unit)` (`units.dart`, enum `LengthUnit`) : la même chose pour les seules longueurs. Aucun écran ne s'en sert aujourd'hui : il est gardé pour le réglage métrique / impérial (voir [roadmap.md](../roadmap.md)), et un test garde ses facteurs alignés sur `baseFactor`.
- `mmToImperial`, `imperialToMm`, `formatImperial` : l'impérial composé (`ImperialParts` : pieds, pouces, fraction), écrit `2' 6 3/8"`.

**Impérial composé** : arrondi au 1/`denominator` de pouce le plus proche, **retenues propagées** (16/16 → +1 po, 12 po → +1 pi), **fraction réduite** (6/16 → 3/8). Une valeur entière rend `num: 0, den: 1`.

**Refus** : valeur non finie, longueur négative, dénominateur invalide, conversion entre grandeurs.

### Exemples

- `toMm(1, inch)` → 25,4 · `toMm(1, foot)` → 304,8.
- Aller-retour exact (1e-9) pour chaque unité.
- `mmToImperial(304.8)` → 1' 0" · `mmToImperial(15.875)` → 5/8".
- Retenue : proche de 25,4 → 1" pile, jamais 16/16.
- Réduction : 6/16 → 3/8, 8/16 → 1/2.

## Écran

- **Saisie** :
  - `Grandeur` en **dropdown** : elle commande tout le reste, donc elle vient en premier. Pas en segments, « Pression » ne tient pas.
  - `Valeur`, dont le suffixe suit l'unité source.
  - `Unité source` en segments.
  - `Impérial composé` (interrupteur), **longueurs seulement** : masqué ailleurs plutôt que grisé, puisqu'il n'y aurait aucun sens.
- **Changer de grandeur garde la valeur** et retombe sur l'unité courante de la famille (mm, m², L, kg, bar) : on convertit souvent le même nombre d'une grandeur à l'autre.
- **La grandeur se déduit de l'unité**, elle n'est pas stockée : deux champs pourraient se contredire.
- **Défauts** : 100 mm, impérial composé actif.
- **Résultats** : une tuile par unité de la grandeur, plus `Impérial` (« Arrondi au 1/16 de pouce ») si actif. Le pied-planche porte « L'unité d'achat du bois dur — 144 po³ ».

## Schéma

- **Longueur : double règle** (`RulerPainter`). Métrique en haut, impérial en bas, **à la même échelle physique**. Un curseur les traverse d'un seul trait : une position, deux lectures. Les graduations impériales sont écrites par `formatImperial`, pas par un formatage maison.
- **Autres grandeurs : comparaison à un repère rond** (`ComparisonPainter`) : 1 m², 1 L, 1 kg, 1 bar. Carrés pour une surface, cubes pour un volume (un facteur 1000 ne fait que 10 sur l'arête), barres pour ce qui n'a pas de forme. La valeur en accent, le repère en gris. Une forme trop petite est relevée à une taille minimale, et le dessin le signale.
- **Pas de `compact`** : les deux painters se régulent seuls (graduations secondaires au-dessus de 5 px, libellé qui chevaucherait sauté). Vignette et plein écran sont identiques à l'échelle près.
- Les règles détourent leurs chiffres (`drawSchemaLabel`) par-dessus les graduations.

## Décidé / écarté

- **La visu est pauvre hors longueur**, assumé : une masse ou une pression n'ont pas de forme, leur en inventer une mentirait. À reprendre si l'outil se révèle utilisé.
- **Pas de plan exporté pour l'instant** (voir [roadmap.md](../roadmap.md)).
