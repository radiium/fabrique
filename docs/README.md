# Menuiserie — documentation

Cinq outils de calcul pour l'atelier, sur Android et Web. Le cœur de calcul est en Dart pur, testé sans appareil. Les écrans le branchent en temps réel.

## Quoi lire, et quand

| Avant de toucher… | Lire |
|---|---|
| la structure, un provider, la persistance | [architecture.md](architecture.md) |
| un outil (calcul, écran, schéma, plan) | [tools/](tools/), un fichier par outil |
| un painter ou une cote | [drawing/conventions.md](drawing/conventions.md) |
| la vignette ou la page plein écran | [drawing/schema-viewer.md](drawing/schema-viewer.md) |
| l'export PNG ou un cartouche | [drawing/export.md](drawing/export.md) |
| un choix d'ergonomie | [ui/principles.md](ui/principles.md) |
| un contrôle, une couleur, une hauteur | [ui/design-system.md](ui/design-system.md) |
| la structure d'un écran-outil | [ui/tool-screen.md](ui/tool-screen.md) |
| un libellé, une aide, un message d'erreur | [ui/writing.md](ui/writing.md) |
| une idée de fonctionnalité | [roadmap.md](roadmap.md) |

Les fiches d'outils portent le nom de leur dossier : `tools/layout.md` ↔ `lib/features/layout/` ↔ `lib/core/calc/layout.dart`. Elles suivent toutes le même ordre : règles métier, calcul, écran, schéma, plan exporté, décidé / écarté. Une section vide saute.

## Écrire ici

- On documente **la décision et sa raison**. Ce que le code dit déjà (signatures, champs, noms des tests) reste dans le code.
- Un chiffre recopié d'une constante se vérifie contre le code avant d'être écrit.
- Pas d'historique (« avant on faisait… ») : c'est le rôle de git.
