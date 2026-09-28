# Architecture

La structure, les couches et le flux saisie → résultat → painter sont dans `CLAUDE.md`. Ce fichier garde ce qui ne se déduit pas du code.

- [Persistance](#persistance)
- [Langue](#langue)
- [Dépendances](#dépendances)

## Persistance

`shared_preferences` : une clé par outil (la dernière saisie, en JSON), plus les réglages et le calibrage du Niveau, propre au téléphone et non à une saisie. `PersistedForm<T>` branche un notifier sur le disque sans toucher à ses méthodes de champ.

À ne pas défaire :

- **`main()` ouvre le stockage avant `runApp`** et surcharge `preferencesStoreProvider`. Il est ainsi lisible en synchrone, comme l'exige le `build()` d'un notifier. Le rendre `async` ferait remonter un `AsyncValue` dans tous les écrans. Un test épingle cette lecture synchrone.
- **`restore()` fait `ref.read` du stockage, jamais `ref.watch`.** Un stockage arrivé après coup rebâtirait un formulaire déjà rempli, sous les doigts. S'il manque (tests, échec d'ouverture), l'outil part de ses défauts.
- **Une saisie illisible s'efface.** JSON tronqué ou d'un ancien modèle : on repart des défauts **et** on supprime la clé, sinon l'échec se rejoue à chaque lancement.
- **Pas de fenêtre de fraîcheur.** La restauration est inconditionnelle. La porte de sortie, c'est « réinitialiser », qui doit donc rester visible.

## Langue

Français et anglais, le français sert de gabarit (`app_fr.arb`).

- **Par défaut, l'app suit le téléphone** : sa première langue prise en charge l'emporte, région ignorée, et le français sert de repli pour toute autre langue. Le réglage Langue peut imposer l'une ou l'autre.
- **Tant que les réglages chargent, l'app suit le téléphone** plutôt que d'attendre le disque.
- **Sur Android 13 et plus**, la langue se choisit aussi dans les réglages système de l'app (`res/xml/locales_config.xml`, même liste que les ARB) : l'app la reçoit comme langue du téléphone.
- **Les cotes restent en millimètres dans les deux langues** : seuls le séparateur décimal et les symboles impériaux changent.

## Dépendances

Les versions font foi dans `pubspec.yaml`.

| Paquet | Pour | Pourquoi pas le SDK |
|---|---|---|
| `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator` | état et DI | résultats dérivés de la saisie, sans `BuildContext`, surchargeables dans un test |
| `go_router` | navigation | une URL par outil et par schéma sur le web, sans écrire le `RouterDelegate` |
| `sensors_plus` | accéléromètre du Niveau | le SDK n'expose aucun capteur |
| `shared_preferences` | persistance | le SDK n'a pas de stockage durable |
| `share_plus` | partager le plan | la feuille de partage du système est native |
| `gal` | enregistrer le plan dans les photos | l'écriture dans la galerie est native |
| `web` | télécharger le plan sur le web | accès au DOM, qui remplace `dart:html` |
| `freezed`, `json_serializable` | modèles immuables et leur JSON | `copyWith`, égalité et sérialisation écrits à la main pour chaque saisie |
| `flutter_localizations`, `intl` | i18n | livrés avec Flutter, requis par `gen-l10n` |
| `flutter_launcher_icons` (dev) | icônes Android et web depuis `assets/icon/` | le SDK ne produit ni les `mipmap` ni l'icône adaptative : `dart run flutter_launcher_icons` après toute retouche de l'image |

**Écartés** : toute base locale (Isar, Drift) tant qu'il n'y a pas de « projets », toute DI tierce.
