# Répartition

Répartir des éléments identiques sur une largeur : barreaudage, lames, étagères, axes de perçage.

| Couche | Fichiers |
|---|---|
| Calcul | `lib/core/calc/distribution.dart` · `test/core/calc/distribution_test.dart` |
| Écran | `lib/features/distribution/` : `_screen`, `_controller`, `_form`, `_help`, et ses composants `_edge_grid` (tuiles des bords), `_target_callout` (l'autre borne), `_positions_table` |
| Schéma | `_schema`, `_painter` (dont `EdgePreviewPainter`, le pictogramme des bords) |
| Plan | `_plan` · `test/features/distribution/distribution_plan_test.dart` |

---

## Règles métier

- **Vocabulaire** : la cote totale est la **largeur**, les bandes réservées aux extrémités sont des **marges**. Jamais « longueur » ni « décalage » (réservé au Calepinage). Les champs `length`, `startOffset` et `endOffset` gardent leur nom de code : les renommer changerait les clés JSON persistées.
- **On répartit des éléments de largeur.** Les points purs sont le cas `elementWidth = 0`.
- **Le nombre de jeux découle des bords** :

  | Bords | Jeux |
  |---|---|
  | Écart – Écart | `N + 1` |
  | Élément – Élément | `N − 1` |
  | mixte | `N` |

  `DistributionResult.gapCount` le rend explicite, pour que l'écran n'ait pas à le redéduire.
- **Une disposition impose un minimum** : un élément par bord occupé (`minDistributionCount`).
- **Les marges sont retirées de la largeur avant le calcul.** Elles réservent un chant, un tasseau existant.
- **On reporte l'entraxe**, pas le jeu. Le centre donne l'axe de perçage.
- **`kMaxDistributionCount` (500) borne les deux modes.** Un écart de 0,001 saisi par mégarde produirait sinon un million de positions.

---

## Calcul

### Signatures

```dart
enum DistributionEdge { gap, element }

@freezed
class DistributionInput {                // nombre connu → écart
  const factory DistributionInput({
    required double length,              // largeur totale, mm
    required int count,
    @Default(0) double elementWidth,     // 0 = points purs
    @Default(DistributionEdge.gap) DistributionEdge startEdge,
    @Default(DistributionEdge.gap) DistributionEdge endEdge,
    @Default(0) double startOffset,      // marge de début
    @Default(0) double endOffset,        // marge de fin
  }) = _DistributionInput;
}

@freezed
class DistributionTargetInput {          // écart voulu → nombre
  const factory DistributionTargetInput({
    required double length,
    required double targetSpacing,
    // … mêmes champs optionnels
  }) = _DistributionTargetInput;
}

@freezed
class DistributionResult {
  const factory DistributionResult({
    required int count,
    required int gapCount,
    required double spacing,             // jeu libre
    required double pitch,               // entraxe = spacing + elementWidth
    required double span,                // largeur moins les marges
    required List<double> positions,     // bord d'attaque de chaque élément
    required List<double> centers,
  }) = _DistributionResult;
}

@freezed
class DistributionTargetResult {
  const factory DistributionTargetResult({
    required DistributionResult best,    // écart le plus proche de la cible
    required DistributionResult? other,  // l'autre borne, si réalisable
  }) = _DistributionTargetResult;
}

DistributionResult computeDistribution(DistributionInput input);
DistributionTargetResult computeDistributionForSpacing(DistributionTargetInput input);
int minDistributionCount(DistributionEdge start, DistributionEdge end);
const int kMaxDistributionCount = 500;
```

### Algorithme

- `utile = largeur − marges`
- `gapCount = count + 1 − (bords occupés par un élément)`
- `spacing = (utile − count × elementWidth) / gapCount`
- Premier élément collé à la marge de début, ou repoussé d'un jeu. Les suivants à un entraxe l'un de l'autre.

**Mode inverse** : on résout `utile = N × largeur + (N + c) × écart` en N, avec `c = 1 − (bords occupés)`. On évalue les deux entiers qui encadrent le N fractionnaire, et `best` est le plus proche de la cible. **Pas de réglage d'arrondi** : on rend les deux. Une cible exacte ne rend qu'une réponse. Une borne irréalisable est écartée.

### Refus

Messages affichés tels quels :

- **les deux modes** : saisie incomplète, largeur ≤ 0, largeur d'élément ou marge négative, marges qui occupent toute la largeur
- **nombre connu** : nombre négatif, sous le minimum de la disposition, au-dessus de 500, éléments trop larges (« Les 11 éléments occupent 110 mm pour 100 mm disponibles »)
- **écart voulu** : écart négatif, largeur et écart nuls, écart trop petit pour rester sous 500 (dit franchement), aucune borne réalisable

### Cas de test attendus

- **Points purs** : `(100, 1)` → `[50]` · `(100, 3)` → `[25, 50, 75]` · `(100, 0)` → `[]` · `(90, 2)` → `[30, 60]`.
- **Largeur** : 2 éléments de 20 sur 100, bordés de jeux → écart 20, entraxe 40, `[20, 60]`.
- **Bords** : 4 éléments → 5 / 3 / 4 / 4 jeux, et la rangée remplit exactement la largeur.
- **Marges** : `(1000, 3, 100, 100)` → span 800, écart 200, `[300, 500, 700]`.
- **Mode inverse** : les bornes encadrent la cible, `best` est la plus proche, une cible exacte ne rend qu'une réponse.
- **Borne** : 500 limite les deux modes.

---

## Écran

### Saisie

- `Mode de calcul` : `Calcul écart` · `Calcul nombre`. Nommé par **ce qu'on cherche**.
- `Largeur totale` · `Largeur d'un élément` (0 = repères)
- selon le mode, `Nombre d'éléments` (borné par le minimum et par 500) ou `Écart souhaité`

Repliés dans `Réglages avancés` :

- `Type de répartition` : les quatre dispositions en **grille 2 × 2 de tuiles pictogramme + texte**. En segments, « Élément – Élément » serait tronqué, et le dessin distingue « Écart – Élément » de « Élément – Écart » mieux que la phrase.
- `Marges` : `Symétriques` (un champ) ou `Asymétriques` (début et fin). Repasser en symétrique réaligne la fin sur le début, sinon le schéma mentirait.

**Défauts** (`kDistributionDefaults`) : largeur 1800, élément 18, 5 éléments, écart souhaité 150, Élément – Élément, marges nulles. Ne pas confondre avec les défauts du modèle de calcul (bords aux écarts, largeur nulle).

`DistributionFormState` porte à la fois le nombre et l'écart visé : changer de mode n'efface pas la valeur de l'autre.

### Refus affiché

Motif dans la carte de saisie (`ErrorBanner`), via un `DistributionOutcome` scellé. Voir [ui/tool-screen.md](../ui/tool-screen.md).

### L'autre borne (mode « Calcul nombre »)

Un encart sous `Écart souhaité` propose la borne **écartée**. Celle que l'outil a retenue remplit déjà le schéma, les tuiles et la table. Qui a un maximum à ne pas dépasser (un barreaudage à 110 mm) veut la plus serrée, et le cœur ne connaît que la distance à la cible.

- **Toute la surface de l'encart est la cible.**
- **L'adopter fait passer en « Calcul écart »** avec ce nombre. Recopier l'écart obtenu reposerait la même question, sans fin.

### Résultats

- `Nombre d'éléments` (mode « Calcul nombre »), avec l'écart visé en note
- `Écart` / `Écart obtenu`, avec la règle en note (« 5 éléments → 4 écarts »)
- `Entraxe`, **seulement si l'élément a une largeur** (sinon c'est l'écart)
- la table des positions : bord et centre, ou position seule

---

## Schéma

**Une vue d'ensemble ne peut pas coter ce qu'elle montre** : sur 1800 mm, une marge de 40 fait deux pixels. Le schéma a donc trois bandes : la pièce entière avec sa **seule cote totale**, puis deux panneaux `Début` et `Fin` agrandis, chacun terminé par un trait de rupture.

- **Agrandissement rond et écrit** (`Cotes en mm — Détails ×1,5`), pris au plus grand rang de `_zoomLadder` qui laisse tenir marge + élément + écart. Les demis jusqu'à 3 existent parce que le cas courant (cinq éléments, rapport ~1,8) retomberait sinon à ×1.
- **Trois étages de cote fixes** : marge, élément, écart, présents ou non. Attribués au fil des cotes, ils remonteraient d'un cran dès qu'on remet une marge à zéro. Espacés régulièrement, pour se lire comme un seul peigne.
- **L'écart coté est le premier qui se présente** : avant le premier élément si le bord est un écart, après sinon.
- **Proportions** : les panneaux couvrent 83 % de la largeur de la vue d'ensemble (sinon deux bouts se lisent aussi longs que la pièce), et leur barre est deux fois plus épaisse (sinon le détail se lit comme un étirement).
- **Cotes serrées** : chiffre sorti **hors de la pièce**, vers la marge de la feuille. Vers l'intérieur, il tomberait au-delà des attaches de l'étage voisin.
- **Une seule grammaire** : des rectangles à l'échelle, qu'une largeur nulle réduit à un trait de 2 px. Basculer vers des disques ferait sauter le dessin à chaque passage par zéro.
- **Marges hachurées** : la zone existe, rien n'y est réparti.
- **Boîte de référence 336 × 255**, mise à l'échelle uniformément. **Vignette en 5/4**, plus haute que le 16/10 commun : les trois bandes s'empilent en hauteur de texte.
- **Pas de `compact`** : la vue d'ensemble ne porte qu'un chiffre, les panneaux portent tout le reste.
- **Pas de numérotation des éléments** : elle se tassait exactement là où la table devient utile.

---

## Plan exporté

`buildDistributionPlan`. Mécanique générique : [drawing/export.md](../drawing/export.md).

**Cases** : `DATE` · `ÉLÉMENTS` · `ÉCART SOUHAITÉ` (mode « Calcul nombre ») · `ÉCART` / `ÉCART OBTENU` · `ENTRAXE` (si largeur) · `ÉCARTS`.

Largeur, élément et marges sont cotés sur le dessin, donc absents. **Exception, l'écart souhaité** : le dessin ne porte que l'écart obtenu, et sans la cible rien n'explique le nombre trouvé.

**Table** `POSITIONS DEPUIS L'ORIGINE` : `N°` · `BORD (mm)` · `CENTRE (mm)`, ou `N°` · `POSITION (mm)` sans largeur. Repli : `N positions — à copier depuis l'app`. ⚠️ La colonne `N°` doit tenir trois chiffres (jusqu'à 500), sinon elle se vide en silence à partir de 10.

Pas de note.

---

## Gardes de test

- chaque combinaison de bords et chaque mode se rend sans lever, écran comme plan
- une largeur nulle donne un trait et retire l'entraxe et la colonne des centres
- le schéma reste au-dessus de la ligne de flottaison
- le pied « Réglages avancés » touche les bords de la carte
- aucun libellé de contrôle ni d'action n'est tronqué
- le cartouche reprend toutes les positions ou aucune, et ne répète pas le dessin

**Libellés retenus malgré la police de test**, vérifiés sur appareil (Pixel 5, 22/09/2026) : `Symétriques` / `Asymétriques`, `Calcul écart` / `Calcul nombre`. Épinglés dans `knownWiderThanTestFont`.

---

## Décidé / écarté

- **Pas de réglage d'arrondi en mode inverse** : on rend les deux bornes.
- **Pas de numérotation sur le schéma.**
- **Reporté : répartition avec trait de scie** (voir [roadmap.md](../roadmap.md)).
