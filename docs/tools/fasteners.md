# Avant-trous & vis

Depuis un matériau, un Ø de vis et l'épaisseur de la pièce à fixer : trou de passage, avant-trou de guidage, lamage, longueur de vis.

| Couche | Fichiers |
|---|---|
| Calcul | `lib/core/calc/fasteners.dart` · `test/core/calc/fasteners_test.dart` |
| Écran | `lib/features/fasteners/` : `_screen`, `_controller` |
| Schéma | `_schema`, `_painter` |

---

## Règles métier

- ⚠️ **Les coefficients sont des règles de l'art indicatives**, à valider à part. Ils vivent dans **une seule table** en tête de `fasteners.dart`, et le calcul ne fait que l'appliquer. L'écran le dit dans la note de l'avant-trou.
- **Invariant** : `pilotHole < clearanceHole < counterboreDia`, toujours. C'est lui qui rend le schéma cohérent. `minScrewDiameter` (1 mm) le protège : en dessous, `Ø + 0,5` rattraperait `2 × Ø`.

## Calcul

```dart
@freezed
class FastenerInput {
  const factory FastenerInput({
    required MaterialKind material,     // softwood · hardwood · chipboard · plywood
    required double screwDiameter,      // Ø nominal, mm
    required double fixedThickness,     // épaisseur traversée, mm
  }) = _FastenerInput;
}

@freezed
class FastenerResult {
  const factory FastenerResult({
    required double clearanceHole,      // Ø passage
    required double pilotHole,          // Ø guidage
    required double counterboreDia, required double counterboreDepth,
    required double screwLength, required double penetration,
  }) = _FastenerResult;
}

FastenerResult computeFastener(FastenerInput input);
```

### La table

| Grandeur | Règle |
|---|---|
| Ø passage | `Ø + 0,5` |
| Ø guidage | `k × Ø` : résineux 0,55 · feuillu 0,70 · aggloméré 0,60 · contreplaqué 0,65 |
| Ø lamage | `2 × Ø` (Ø de tête courant) |
| Profondeur de lamage | `0,6 × Ø` (hauteur de tête) |
| Pénétration | `min(2 × épaisseur, 60)` |
| Longueur de vis | `épaisseur + pénétration` |

### Refus

Cote non finie, Ø ≤ 0, Ø sous `minScrewDiameter`, épaisseur ≤ 0.

### Cas de test attendus

- Résineux, Ø 4, épaisseur 18 → guidage 2,2, passage 4,5, pénétration 36, longueur 54.
- Feuillu contre résineux → guidage plus grand.
- Le guidage croît avec le Ø.
- L'invariant tient sur toute la plage.
- Refus sur Ø ou épaisseur nuls.

## Écran

- **Saisie** : `Matériau` (dropdown) · `Ø de vis` (dropdown : 3, 3,5, 4, 4,5, 5, 6) · `Épaisseur pièce à fixer`.
- **Défauts** : résineux, Ø 4, 18 mm.
- **Résultats**, chacun avec sa justification en note :
  - `Ø trou de passage` : « Ø vis + 0,5 mm »
  - `Ø avant-trou de guidage` : cite le coefficient **réellement appliqué**, lu dans la table (si la table bouge, la note suit), et « règle de l'art indicative »
  - `Lamage — Ø × profondeur`
  - `Longueur de vis` : la pénétration, et le plafond quand il mord (sinon la longueur semble décrocher de l'épaisseur sans raison)

## Schéma

Coupe des deux pièces vissées : pièce à fixer au-dessus, support en dessous, lamage, passage, guidage, vis.

- **Échelle uniforme** : sinon la profondeur de pénétration induirait en erreur.
- **Pièces en `field`, perçages en blanc** : ce sont des vides.
- **La vis en trait d'accent et remplissage léger** : on doit voir à travers le jeu entre le fût et le trou de passage, c'est tout l'intérêt d'un trou de passage.
- **Les trois Ø s'empilent au-dessus**, du plus large au plus étroit : l'emboîtement se lit dans les largeurs, sans attache. Ces cotes gardent leur tiret d'extrémité. Un chiffre trop large pour sa cote se pose à droite plutôt que de disparaître.
- **Épaisseur, pénétration et longueur en colonne à droite.**
- **En vignette (`compact`)**, les trois Ø et la colonne tombent : ils prennent plus de la moitié de la largeur, et ils sont déjà dans les tuiles.

## Plan exporté

Pas encore. Voir [roadmap.md](../roadmap.md) : le cartouche devra porter l'avertissement « indicatif ».
