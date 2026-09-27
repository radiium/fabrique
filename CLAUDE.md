# CLAUDE.md

`fabrique` est l'app **« Menuiserie »** : cinq outils de calcul pour l'atelier (Calepinage, Répartition, Tiroirs, Niveau, Convertisseur), sur iOS, Android et Web.

## Documentation

`docs/` est la référence : la suivre plutôt qu'inventer une structure, et la mettre à jour dans le même commit qu'une décision qui change. [`docs/README.md`](docs/README.md) dit quoi lire avant de toucher à quoi. En bref :

- un outil → `docs/tools/<outil>.md` (même nom que `lib/features/<outil>/`)
- un painter, une cote → `docs/drawing/conventions.md`
- l'export PNG → `docs/drawing/export.md`
- un contrôle, un écran → `docs/ui/`
- un texte lu dans l'app (libellé, aide, message d'erreur) → `docs/ui/writing.md`
- la structure, la persistance → `docs/architecture.md`

## Commandes

```bash
flutter run                  # -d chrome pour le web
flutter test
dart run build_runner build  # après toute modif @freezed / @riverpod
flutter gen-l10n             # après édition de lib/l10n/app_fr.arb
```

Avant de rendre la main : `dart fix --apply`, `dart format lib test`, `flutter analyze` propre, `flutter test` vert.

Flutter 3.47 / Dart 3.13. Le code généré (`*.g.dart`, `*.freezed.dart`, `lib/l10n/app_localizations*.dart`) ne s'édite jamais à la main.

## Pièges connus

- `riverpod_lint` / `custom_lint` sont absents exprès : ils ne résolvent pas avec Riverpod 3.4 + `freezed_annotation` 3.x.
- Riverpod 3 : un provider-fonction généré prend un `Ref` simple, et `AsyncValue` expose `.value` (plus de `valueOrNull`).

## Conventions non négociables

- **Le painter peint, le core calcule.** Aucune math dans le rendu.
- **`lib/core/calc` n'importe jamais Flutter** : c'est ce qui le rend testable sans appareil.
- **Tout est en millimètres** (`double`). Conversions aux frontières de l'UI seulement.
- **Une saisie invalide lève `CalcException`**, jamais une valeur fausse. Son message s'affiche tel quel.
- **Modèles `@freezed`, providers `@riverpod`.** Le résultat d'un outil est un provider dérivé de sa saisie : ni `setState` dans le calcul, ni bouton « calculer ». `setState` reste permis pour un état d'interface local (rotation, export en cours).
- **Une feature-outil** : `*_screen`, `*_controller`, `*_schema` (seul point de construction du painter), `*_painter`. Le reste seulement si besoin.
- **Atelier** : cibles ≥ 48 px (`kFieldHeight`), aucun libellé tronqué en silence. Le schéma peut passer sous la ligne de flottaison : un outil riche ne tient pas dans un écran.
- **Textes en français**, en dur dans les écrans-outils. Seuls l'accueil et les Réglages passent par `AppLocalizations`.

## Règles de code

`analysis_options.yaml` impose le mode strict et des lints en plus de `flutter_lints`. Ce qui suit, l'analyseur ne le vérifie pas.

### Dart

- **Pas de joker `_` dans un `switch` sur un enum ou une classe scellée.** Un cas ajouté doit casser la compilation, pas passer en silence. Le joker reste permis sur des plages de valeurs (`>= 100 =>`).
- **Une table qui doit couvrir tout un enum est un `switch`, pas une `Map`**, pour la même raison.
- **Pas de `!` sans garantie.** Préférer un motif (`if (x case final v?)`, `AsyncData(:final value)`). Un `!` qui reste dit pourquoi il est sûr.
- **`catch` typé.** Un `catch` large seulement à une frontière système (export, stockage), et l'échec ne se tait pas : `debugPrint` ou message à l'écran.
- **Nommage** : un booléen se lit comme une question (`isCut`), une constante de module prend le préfixe `k`, une privée `_`.

### Flutter

- **Des classes de widget, pas de méthodes `_buildX()`** : c'est ce qui permet `const` et une reconstruction ciblée.
- **Un écran de plus de ~400 lignes se découpe**, un fichier par composant (`distribution_positions_table.dart`).
- **Un widget dupliqué entre deux features monte dans `core/widgets`.**
- **Tokens de thème uniquement** (`AppColors`, `AppSpacing`, `AppRadii`) : une couleur en dur finit par dériver du thème. Un nombre qui porte une décision (marge, seuil, taille) est une constante nommée. Un `2` évident reste en ligne.
- **`ref.watch` dans `build`, `ref.read` dans les callbacks** : un `read` dans `build` rate les mises à jour, et Riverpod ne prend pas en charge un `watch` hors de `build`. Exception : `ref.read(….notifier)` dans `build`, pour brancher les méthodes de champ.
- **Tout contrôleur ou `Timer` créé est libéré** (`dispose`, `ref.onDispose`).
- **Tout `IconButton` a un `tooltip`** : c'est son libellé pour un lecteur d'écran, et son infobulle sur le web.

### Architecture

- **Une feature n'importe jamais une autre feature**, seulement `core/` et `app/`. Exception : `features/schema/`, qui aiguille vers le schéma de chaque outil.
- **Un chemin se construit par `AppRoutes`** (`app/routes.dart`), jamais en dur : une faute de frappe dans une route ne casse qu'à l'exécution.
- **Pas de nouvelle dépendance sans sa justification dans `docs/architecture.md`** : pourquoi elle, et pourquoi pas le SDK.

### Tests

- **Un test reproduit le chemin du fichier testé** (`lib/core/calc/layout.dart` → `test/core/calc/layout_test.dart`). Les tests transversaux (reset, persistance, haptique) vivent à la racine de `test/features/`.
- **Chaque painter a un test « se rend sans lever »** : trois tailles (vignette, plein écran, canvas dégénéré) et une saisie refusée. Un painter qui lève ne se voit qu'au rendu.
- **Un test d'écran se monte sur le téléphone de référence** (`usePhone`, `test/support/phone.dart`) : c'est sur lui que se mesurent les libellés tronqués.
- **Le nom d'un test décrit un comportement**, en français. C'est son commentaire.

### Commits

En français, au format `Portée : description` (`Calepinage : …`, `Docs : …`).

## Commentaires

En français. Ils disent **pourquoi** le code est ainsi, jamais comment il a évolué (c'est le rôle de git).

**Forme**
- `///` sur les types, les API publiques et tout ce qui porte une décision. Pas sur un champ dont le nom dit tout (`final Widget child;`). `//` pour une subtilité dans un corps.
- Première ligne : une phrase qui se suffit, commençant par un verbe (« Répartit… ») ou un nom (« Vue de dessus : … »). Puis une ligne vide, puis l'explication.
- Symboles entre crochets : `[computeDistribution]`.
- `// TODO(scope):` seulement pour ce qui figure dans `docs/roadmap.md`.
- Tiret cadratin et point-virgule sont permis ici : la règle de ponctuation vise les textes de l'app.

**À garder** : une contrainte métier, une mesure (les 198 px de la police de test), une unité ou un invariant, un choix non trivial, une décision à ne pas défaire. Une décision a le droit d'être longue : on la resserre, on ne la tronque pas. Le reste tient en une ou deux lignes.

**Par couche**
- `core/calc` : l'unité, les bornes, ce qui lève `CalcException`. C'est ce dartdoc que lisent les écrans.
- Painters : un ordre de tracé ou un seuil, jamais de géométrie (elle est dans `core`).
- Widgets partagés : les hauteurs et les valeurs de thème, surtout les pièges vérifiés à la mesure.
- Tests : un nombre magique ou la raison d'un garde-fou, rien d'autre.

**À supprimer** : la paraphrase du code, le code commenté, l'historique (« avant on faisait… »), les commentaires devenus faux, les séparateurs décoratifs, et toute référence à un document, `docs/` compris : un document bouge, le commentaire reste et ment.

Une passe de commentaires ne touche jamais la logique. Dans le doute, garder.
