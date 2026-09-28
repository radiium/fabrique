# Fabrique — documentation

Cinq outils de calcul pour l'atelier, sur Android et Web. Les conventions de code sont dans `CLAUDE.md`, à la racine.

- [Quoi lire, et quand](#quoi-lire-et-quand)
- [Écrire ici](#écrire-ici)

## Quoi lire, et quand

| Avant de toucher… | Lire |
|---|---|
| la persistance, une dépendance, la langue | [architecture.md](architecture.md) |
| un outil (règles métier, calcul, schéma) | [tools/](tools/), un fichier par outil |
| un écran, un contrôle, la page du schéma | [ui.md](ui.md) |
| un painter, l'export du plan | [drawing.md](drawing.md) |
| la version, la signature, la publication | [release.md](release.md) |
| une idée de fonctionnalité | [roadmap.md](roadmap.md) |

Les fiches d'outils portent le nom de leur dossier : `tools/layout.md` ↔ `lib/features/layout/` ↔ `lib/core/calc/layout.dart`.

## Écrire ici

`docs/` ne garde que ce que le code ne peut pas dire : une règle métier, un algorithme non trivial, un choix écarté et sa raison, une procédure hors code.

- **Pas ce qui se lit dans le code** : fichiers, signatures, champs, défauts, libellés, exemples de tests. Un piège vérifié va en commentaire, à côté du code qu'il protège.
- **Pas ce qui s'applique à toute l'app** : une règle générale va dans `CLAUDE.md`, ou dans le widget partagé qui l'impose.
- **Un sommaire en tête de chaque fichier**, une ligne par section.
- Un chiffre recopié d'une constante se vérifie contre le code avant d'être écrit.
- Pas d'historique (« avant on faisait… ») : c'est le rôle de git.
