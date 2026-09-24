# Architecture

App portfolio de cinq outils : ni sur-ingénierie, ni tout dans les widgets. La vitrine technique est un **cœur de calcul en Dart pur, sans Flutter, couvert par des tests unitaires**.

## Couches

```
lib/
├── main.dart            ouvre le store, puis runApp
├── app/                 app.dart · router.dart · theme.dart (design system)
├── core/
│   ├── calc/            ★ Dart pur, ZÉRO import Flutter
│   │   ├── units/       longueurs, impérial composé, les cinq grandeurs
│   │   ├── distribution.dart · layout.dart · fasteners.dart · tilt.dart
│   ├── models/          value objects partagés (LengthUnit, MeasureUnit, MaterialKind, JointOffset, Tool)
│   ├── format.dart      formatNumber(), formatDegrees(), kNoValue
│   ├── painting.dart    primitives de cotation, SchemaViewport
│   ├── persistence/     PreferencesStore, PersistedForm, réglages
│   ├── export/          plan.dart (feuille + cartouche) · plan_export.dart (PNG, système)
│   └── widgets/         ToolScaffold, AppCard, NumberField, ResultTile…
├── features/            home, settings, schema, playground, et un dossier par outil
└── l10n/                app_fr.arb → AppLocalizations

test/
├── core/calc/           le cœur, sans appareil
└── features/            ce que ni analyze ni le cœur n'attrapent :
                         un painter qui lève, un libellé tronqué en silence
```

**Routes** : `/` · `/settings` · `/tool/:id` · `/tool/:id/schema` (empilée sur l'outil, pour que la saisie reste intacte derrière). `id` vient de l'enum `Tool`, dont l'ordre est celui de l'accueil : le Calepinage ouvre la liste (outil signature), le Convertisseur la ferme (un service, pas une destination).

**`/playground`** : inventaire des widgets Material pour vérifier le thème. Hors produit, visible en debug. Seul écran autorisé à utiliser `setState`.

## Le quatuor d'une feature

| Fichier | Rôle |
|---|---|
| `*_screen.dart` | la vue |
| `*_controller.dart` | le notifier de saisie et le provider dérivé du résultat |
| `*_schema.dart` | point de construction **unique** du painter, branché sur les providers (vignette et plein écran le traversent tous deux) |
| `*_painter.dart` | le dessin |

S'y ajoutent, seulement si l'outil en a besoin : un fichier par composant quand l'écran dépasse ~400 lignes (`distribution_positions_table.dart`), `*_help.dart` (contenus des ⓘ, groupés pour se relire comme un texte), `*_plan.dart` (le cartouche), `*_presets.dart` (table de pré-remplissage), `*_form.dart` (état d'écran plus large que la saisie de calcul).

## Flux de données

1. **Saisie** : modèle `@freezed` immuable, avec `fromJson` / `toJson`.
2. **Notifier** `@riverpod` : tient la saisie, une méthode par champ qui fait `copyWith`, et `reset()`.
3. **Résultat dérivé** : un provider `watch` la saisie et appelle la fonction pure. Le résultat est une dérivation, jamais de l'état. Il attrape `CalcException` et rend `null`, que l'écran affiche `—`.
   - *Exception* : Répartition et Calepinage rendent un type scellé `…Ready` / `…Failure(message)`, pour afficher le motif du refus (voir [ui/tool-screen.md](ui/tool-screen.md)).
4. **Écran** : `watch` le résultat. Zéro `setState`, zéro bouton « calculer » : le calcul temps réel est une exigence.
5. **Painter** : reçoit le résultat et dessine. Il ne calcule rien.

## Conventions non négociables

- **Le painter peint, le core calcule.** Aucune math dupliquée dans le rendu.
- **`core/calc` n'importe jamais Flutter.** C'est ce qui le rend testable sans appareil.
- **L'unité interne est le millimètre** (`double`). Conversions aux frontières UI seulement.
- **Une saisie invalide lève `CalcException`**, jamais une valeur fausse silencieuse. Les messages sont écrits pour être affichés tels quels.
- **Modèles `@freezed` immuables**, codegen `@riverpod` partout.
- **Nommage** : l'enum matériau s'appelle `MaterialKind`, pour ne pas entrer en collision avec le widget `Material`.

## Riverpod 3

- Choisi pour la DI sans `BuildContext`, testable par override, et le codegen.
- Les providers-fonctions générés prennent un `Ref` simple.
- `AsyncValue` expose `.value` nullable (`valueOrNull` n'existe plus).
- Relancer `build_runner` après toute modification d'une déclaration `@freezed` ou `@riverpod`.

## Persistance

`shared_preferences`, une clé par outil, JSON produit par les modèles freezed. Plus le réglage haptique.

`PersistedForm<T>` branche un notifier sur le disque sans toucher à ses méthodes de champ. Le notifier déclare `tool`, `defaults`, `decode`, `encode`, et son `build()` rend `restore()`. Le mixin fait le reste : relecture, écriture débattue à 400 ms, vidage au dispose. Le Niveau n'a rien à persister.

À ne pas défaire :

- **`main()` ouvre le store avant `runApp`** et surcharge `preferencesStoreProvider`. Il est ainsi lisible en synchrone, et les `build()` de notifiers sont synchrones. Les rendre `async` ferait remonter un `AsyncValue` dans tous les écrans. Un test épingle cette lecture synchrone.
- **`restore()` fait `ref.read` du store, jamais `ref.watch`.** Un store arrivé après coup rebâtirait un formulaire déjà rempli, sous les doigts. S'il manque (tests, échec d'ouverture), l'outil part de ses défauts.
- **Une saisie illisible s'efface.** JSON tronqué ou d'un ancien modèle : on repart des défauts **et** on supprime la clé, sinon l'échec se rejoue à chaque lancement.
- **Pas de fenêtre de fraîcheur.** La restauration est inconditionnelle. La porte de sortie, c'est « réinitialiser », qui doit donc rester visible.

## Dépendances

| Paquet | Pour |
|---|---|
| `flutter_riverpod` 3.4, `riverpod_annotation` / `riverpod_generator` 4.x | état, DI |
| `go_router` 18 | navigation, URL web |
| `sensors_plus` 7 | accéléromètre |
| `shared_preferences` 2.5 | persistance |
| `share_plus` 13 · `gal` 2.3 | partager, enregistrer dans les photos |
| `freezed` 4, `json_serializable` | modèles immuables |
| `flutter_localizations`, `intl` | i18n câblée, publiée en FR seulement |

- **`riverpod_lint` / `custom_lint` sont volontairement absents** : leurs versions actuelles ne résolvent pas avec Riverpod 3.4 + `freezed_annotation` 3.x.
- **Écartés** : toute base locale (Isar, Drift) tant qu'il n'y a pas de « projets », toute DI tierce.

## i18n

Câblée via `lib/l10n/app_fr.arb`. En pratique, seul l'écran Réglages passe par `AppLocalizations` : les écrans-outils ont leurs libellés en dur.

## Ce que démontrent les tests du cœur

| Module | Fonction | Démontre |
|---|---|---|
| units | `mmToImperial`, `convert` | arrondi, fractions, allers-retours |
| distribution | `computeDistribution`, `computeDistributionForSpacing` | logique métier, mode inverse |
| layout | `computeLayout`, `summarizeCuts` | algorithme non trivial, géométrie testable |
| fasteners | `computeFastener` | table de règles appliquée proprement |
| tilt | `computeTilt` | math de capteur isolée |
