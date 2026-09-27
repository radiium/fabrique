# Fabrique

Cinq outils de calcul pour l'atelier de menuiserie, sur Android et le web. Les résultats se mettent à jour pendant la saisie, avec un schéma coté exportable en image.

- **Calepinage** : poser des éléments identiques sur une surface, coupes et % de perte.
- **Répartition** : répartir des éléments sur une largeur, par nombre ou par écart.
- **Tiroirs** : fiche de débit des caisses et des façades, pose des glissières.
- **Niveau** : niveau à bulle et inclinomètre.
- **Convertisseur** : longueurs, surfaces, volumes, masses et pressions, en unités d'atelier.

Tout est en millimètres. Pas de publicité, pas de compte, aucun accès à Internet.

## Commandes

```bash
flutter run                   # -d chrome pour le web
flutter test
flutter analyze
dart run build_runner build   # après une modif @freezed / @riverpod
flutter gen-l10n              # après une modif de lib/l10n/app_fr.arb
flutter build apk --release   # signé si android/key.properties existe
flutter build web
```

La documentation est dans [`docs/`](docs/README.md), la publication dans [`docs/release.md`](docs/release.md).

## Licence

Distribué sous licence [GNU GPL v3 ou ultérieure](LICENSE) (`GPL-3.0-or-later`).
