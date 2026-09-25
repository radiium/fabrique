# Architecture

App portfolio de six outils : ni sur-ingénierie, ni tout dans les widgets. La vitrine technique est un **cœur de calcul en Dart pur, sans Flutter, couvert par des tests unitaires**. Les conventions de code sont dans `CLAUDE.md`, à la racine.

## Couches

```
lib/
├── main.dart            ouvre le stockage, puis runApp
├── app/                 app.dart · router.dart · routes.dart (les chemins) · theme.dart (design system)
├── core/
│   ├── calc/            ★ Dart pur, aucun import Flutter
│   │   ├── units/       longueurs, impérial composé, les cinq grandeurs
│   │   └── distribution.dart · layout.dart · fasteners.dart · tilt.dart
│   ├── models/          value objects partagés (LengthUnit, MeasureUnit, MaterialKind, JointOffset, Tool)
│   ├── format.dart      rendu des nombres (formatNumber, formatDegrees, kNoValue)
│   ├── painting.dart    primitives de cotation, SchemaViewport
│   ├── persistence/     PreferencesStore, PersistedForm, réglages
│   ├── export/          plan.dart (feuille + cartouche) · plan_export.dart (PNG, système) · plan_export_action.dart (boutons)
│   └── widgets/         ToolScaffold, NumberField, ResultTile, FieldPair…
├── features/            home, settings, schema, et un dossier par outil
└── l10n/                app_fr.arb → AppLocalizations

test/
├── core/                le cœur de calcul et les primitives de dessin, sans appareil ;
│                        les widgets partagés et l'export PNG, une fois pour tous
├── app/                 chaque route mène à son écran
├── features/            ce que ni analyze ni le cœur n'attrapent :
│                        un painter qui lève, un libellé tronqué en silence
└── support/             le téléphone de référence (usePhone), l'app sur une route (pumpApp)
```

**Routes** : `/` · `/settings` · `/tool/:id` · `/tool/:id/schema`, construites par `AppRoutes` (`app/routes.dart`), jamais en dur. Ce fichier est à part de `router.dart`, qui importe tous les écrans, pour qu'un widget de `core/` puisse construire un chemin. La page du schéma s'empile sur l'outil, pour que la saisie reste intacte derrière. `id` vient de l'enum `Tool`, dont l'ordre est celui de l'accueil : le Calepinage ouvre la liste (outil signature), le Convertisseur la ferme (un service, pas une destination).

## Une feature-outil

| Fichier | Rôle |
|---|---|
| `*_screen.dart` | la vue |
| `*_controller.dart` | le notifier de saisie et le provider dérivé du résultat |
| `*_schema.dart` | point de construction **unique** du painter : la vignette et le plein écran le traversent tous deux |
| `*_painter.dart` | le dessin |

S'y ajoutent, seulement si l'outil en a besoin :
- `*_help.dart` : les contenus des ⓘ, groupés pour se relire comme un texte
- `*_plan.dart` : le cartouche du plan exporté
- `*_presets.dart` : une table de pré-remplissage
- `*_form.dart` : un état d'écran plus large que la saisie de calcul
- un fichier par composant, quand l'écran dépasse ~400 lignes (`distribution_positions_table.dart`)

## Flux de données

1. **Saisie** : modèle `@freezed` immuable, avec `fromJson` / `toJson` pour la persistance.
2. **Notifier** `@riverpod` : tient la saisie, une méthode par champ qui fait `copyWith`, et `reset()`.
3. **Résultat dérivé** : un provider `watch` la saisie et appelle la fonction pure. Il attrape `CalcException` et rend `null`, que l'écran affiche `—`. Exception : Répartition et Calepinage rendent un type scellé `…Ready` / `…Failure(message)`, pour afficher le motif du refus (voir [ui/tool-screen.md](ui/tool-screen.md)).
4. **Écran** : `watch` le résultat. Pas de bouton « calculer » : le calcul temps réel est une exigence.
5. **Painter** : reçoit le résultat et dessine. Il ne calcule rien.

## Persistance

`shared_preferences` : une clé par outil (la dernière saisie, en JSON), plus le réglage haptique.

`PersistedForm<T>` branche un notifier sur le disque sans toucher à ses méthodes de champ. Le notifier déclare `tool`, `defaults`, `decode`, `encode`, et son `build()` rend `restore()`. Le mixin fait le reste : relecture, écriture différée de 400 ms, écriture finale au dispose. Le Niveau n'a rien à persister.

À ne pas défaire :

- **`main()` ouvre le stockage avant `runApp`** et surcharge `preferencesStoreProvider`. Il est ainsi lisible en synchrone, comme l'exige le `build()` d'un notifier. Le rendre `async` ferait remonter un `AsyncValue` dans tous les écrans. Un test épingle cette lecture synchrone.
- **`restore()` fait `ref.read` du stockage, jamais `ref.watch`.** Un stockage arrivé après coup rebâtirait un formulaire déjà rempli, sous les doigts. S'il manque (tests, échec d'ouverture), l'outil part de ses défauts.
- **Une saisie illisible s'efface.** JSON tronqué ou d'un ancien modèle : on repart des défauts **et** on supprime la clé, sinon l'échec se rejoue à chaque lancement.
- **Pas de fenêtre de fraîcheur.** La restauration est inconditionnelle. La porte de sortie, c'est « réinitialiser », qui doit donc rester visible.

## Dépendances

Les versions font foi dans `pubspec.yaml`.

| Paquet | Pour |
|---|---|
| `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator` | état et DI, sans `BuildContext`, testables par override |
| `go_router` | navigation, URL sur le web |
| `sensors_plus` | accéléromètre |
| `shared_preferences` | persistance |
| `share_plus` · `gal` | partager, enregistrer dans les photos |
| `freezed`, `json_serializable` | modèles immuables |
| `flutter_localizations`, `intl` | i18n câblée, publiée en FR seulement |

**Écartés** : toute base locale (Isar, Drift) tant qu'il n'y a pas de « projets », toute DI tierce.

**i18n** : en pratique, seuls l'accueil et les Réglages passent par `AppLocalizations`. Les écrans-outils ont leurs libellés en dur.

## Ce que démontrent les tests du cœur

| Module | Fonction | Démontre |
|---|---|---|
| units | `mmToImperial`, `convert` | arrondi, fractions, allers-retours |
| distribution | `computeDistribution`, `computeDistributionForSpacing` | logique métier, mode inverse |
| layout | `computeLayout`, `summarizeCuts` | algorithme non trivial, géométrie testable |
| fasteners | `computeFastener` | table de règles appliquée proprement |
| tilt | `computeTilt` | math de capteur isolée |
