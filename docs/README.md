# Menuiserie — documentation

Cinq outils de calcul pour l'atelier, sur iOS, Android et Web. Le cœur de calcul est en Dart pur, testé sans appareil. Les écrans le branchent en temps réel.

## Quoi lire, et quand

| Avant de toucher… | Lire |
|---|---|
| la structure, un provider, la persistance | [architecture.md](architecture.md) |
| un outil (calcul, écran, schéma, plan) | [tools/](tools/) — un fichier par outil |
| un painter ou une cote | [drawing/conventions.md](drawing/conventions.md) |
| la vignette ou la page plein écran | [drawing/schema-viewer.md](drawing/schema-viewer.md) |
| l'export PNG ou un cartouche | [drawing/export.md](drawing/export.md) |
| un contrôle, une couleur, une hauteur | [ui/design-system.md](ui/design-system.md) |
| la structure d'un écran-outil | [ui/tool-screen.md](ui/tool-screen.md) |
| un libellé, une aide, un message d'erreur | [ui/writing.md](ui/writing.md) |
| une idée de fonctionnalité | [roadmap.md](roadmap.md) |

## Arborescence

```
docs/
├── README.md          ce fichier
├── architecture.md    couches, flux de données, persistance, dépendances
├── roadmap.md         reste à faire, et ce qui a été reporté
├── ui/
│   ├── principles.md      contexte atelier
│   ├── design-system.md   couleurs, typo, contrôles
│   ├── tool-screen.md     squelette d'écran, pieds de carte, reset, haptique, aide
│   └── writing.md         vocabulaire, ponctuation, longueur des libellés
├── drawing/
│   ├── conventions.md     traits, encre, cotes
│   ├── schema-viewer.md   vignette et plein écran
│   └── export.md          plan A4, cartouche, enregistrer / partager
└── tools/
    ├── layout.md          Calepinage (outil signature)
    ├── distribution.md    Répartition
    ├── fasteners.md       Avant-trous & vis
    ├── level.md           Niveau
    └── converter.md       Convertisseur
```

Les noms de fichiers suivent `lib/features/` : `tools/layout.md` ↔ `lib/features/layout/` ↔ `lib/core/calc/layout.dart`.

## Gabarit d'un fichier d'outil

Règles métier · Calcul (signatures, algorithme, refus, cas de test) · Écran · Schéma · Plan exporté · Gardes de test · Décidé / écarté. Une section vide saute.

## Écrire ici

- On documente **la décision et sa raison**, pas le code : le code se lit tout seul.
- Un chiffre recopié d'une constante se vérifie contre le code avant d'être écrit.
- Pas d'historique (« avant on faisait… ») : c'est le rôle de git.
