# CLAUDE.md

`fabrique` est l'app **« Menuiserie »** : cinq outils de calcul pour l'atelier (Calepinage, Répartition, Avant-trous & vis, Niveau, Convertisseur), sur iOS, Android et Web. Les six écrans (cinq outils et Réglages) sont câblés, et le cœur de calcul est couvert par les tests.

## Documentation

**`docs/` est la référence.** Lire [`docs/README.md`](docs/README.md) pour savoir quoi lire avant de toucher à quoi. En bref :

- un outil → `docs/tools/<outil>.md` (même nom que `lib/features/<outil>/`)
- un painter, une cote → `docs/drawing/conventions.md`
- l'export PNG → `docs/drawing/export.md`
- un contrôle, un écran, un texte → `docs/ui/`
- la structure, la persistance → `docs/architecture.md`

Suivre la doc plutôt qu'inventer une structure. Quand une décision change, mettre à jour la doc dans le même commit.

## Commandes

```bash
flutter pub get
flutter run                          # appareil / simulateur
flutter run -d chrome                # web
flutter analyze                      # doit rester propre
dart format lib
flutter test                         # cœur de calcul et écrans, sans appareil

dart run build_runner build          # obligatoire après toute modif @freezed / @riverpod
dart run build_runner watch
flutter gen-l10n                     # après édition de lib/l10n/app_fr.arb
```

Toolchain : Flutter 3.47 stable / Dart 3.13.

**Code généré** — `*.freezed.dart`, `*.g.dart`, `lib/l10n/app_localizations*.dart` : ne jamais les éditer à la main.

## Pièges connus

- **`riverpod_lint` / `custom_lint` sont volontairement absents** : leurs versions actuelles ne résolvent pas avec Riverpod 3.4 + `freezed_annotation` 3.x. Ne pas les rajouter à l'aveugle.
- **Riverpod 3** : les providers-fonctions générés prennent un `Ref` simple. `AsyncValue` expose `.value` nullable (`valueOrNull` n'existe plus).
- **Nommage** : l'enum matériau s'appelle `MaterialKind`, pour éviter la collision avec le widget `Material`.

## Conventions non négociables

- **Le painter peint, le core calcule.** Aucune math dupliquée dans le rendu.
- **`lib/core/calc` n'importe jamais Flutter** : c'est ce qui le rend testable sans appareil.
- **L'unité interne est le millimètre** (`double`). Conversions aux frontières UI seulement.
- **Une saisie invalide lève `CalcException`**, jamais une valeur fausse silencieuse.
- **Modèles `@freezed` immuables** ; les saisies ont `fromJson` / `toJson` (persistance).
- **Codegen `@riverpod` partout.** Le résultat d'un outil est un provider **dérivé** de la saisie : zéro `setState`, zéro bouton « calculer ». Seul `/playground` (page de référence hors produit) utilise `setState`.
- **Chaque feature-outil** : `*_screen` · `*_controller` · `*_schema` (point de construction unique du painter) · `*_painter`, plus `*_help`, `*_plan`, `*_presets` seulement si besoin.
- **Contexte atelier** : cibles ≥ 48 px (`kFieldHeight`), le schéma ne passe jamais sous la ligne de flottaison sur mobile. Un libellé de contrôle ne doit jamais tronquer en silence : voir `docs/ui/writing.md`.

## Commentaires

En **français**. Ils documentent le *pourquoi* du code tel qu'il est, jamais son évolution (c'est le rôle de git).

### Forme

- **`///` (dartdoc)** sur tout ce qui est déclaré : types, membres, constantes, champs `@freezed`. **`//`** uniquement pour une subtilité dans un corps.
- Première ligne : une phrase courte qui se suffit, terminée par un point. Puis une ligne `///` vide, puis l'explication.
- Commencer par un verbe (« Répartit… ») ou un groupe nominal (« Vue de dessus : … »). Jamais « Cette fonction… ».
- Référencer les symboles entre crochets : `[computeDistribution]`.
- `// TODO(scope):` seulement pour ce qui figure dans `docs/roadmap.md`.
- Tiret cadratin et point-virgule autorisés ici (la règle de ponctuation ne vise que les textes lus dans l'app).

### À supprimer

- La paraphrase du code, le découpage narratif d'un `build()`.
- Le code commenté, les TODO périmés, les commentaires devenus faux.
- Toute référence à un document de travail (notes, plans, specs) : on énonce la contrainte, pas où elle est écrite.
- Tout historique (« avant on faisait X »), les en-têtes décoratifs, les séparateurs `// ====`.

### À garder

Une **contrainte métier**, une **mesure** (les 198 px de la police de test), une **unité ou un invariant**, un **choix non trivial** (`ref.read` et pas `ref.watch`), une **décision à ne pas défaire**. Ces derniers ont le droit d'être longs. On les resserre, on ne les tronque pas. Le reste tient en une ou deux lignes.

### Par couche

- **`core/calc/`** : l'unité, les bornes, ce qui lève `CalcException`. Ce dartdoc est ce que lisent les écrans.
- **Painters** : aucun commentaire de géométrie (la math est dans `core`). Un ordre de tracé ou un seuil de densité, rien d'autre.
- **Widgets partagés** : justifier les valeurs de thème et les hauteurs, surtout les pièges vérifiés à la mesure.
- **Tests** : le nom du `test()` est le commentaire. On ne commente qu'un nombre magique ou la raison d'un garde-fou.

### Passe de commentaires

Ne modifier que les commentaires, jamais la logique. Dans le doute, garder. `dart format lib` et `flutter analyze` doivent rester propres.
