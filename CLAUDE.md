# CLAUDE.md

Ce fichier guide Claude Code (claude.ai/code) lorsqu'il travaille sur ce dépôt.

## État du projet

`fabrique` est l'app **« Menuiserie »** — une app portfolio de 5 outils de calcul pour l'atelier, sur iOS, Android et Web.

Le cœur de calcul est **entièrement implémenté et couvert** (166 tests : `test/core/calc/` pour le cœur, `test/features/` pour ce qui ne se vérifie qu'au rendu). Les **six écrans sont câblés** — les 5 outils plus les Réglages — les **six painters sont écrits**, et l'app est utilisable de bout en bout.

La référence, ce sont les deux documents de spec :
- **`SPECS.md`** — architecture + couche `core/calc` : signatures exactes, algorithmes et cas de test attendus pour chaque fonction pure. À lire avant d'implémenter un calcul.
- **`SPECS_UI.md`** — principes UX, design system et brief par outil.

Suivre ces specs plutôt que d'inventer une structure.

## Commandes

```bash
flutter pub get
flutter run                          # appareil / simulateur
flutter run -d chrome                # web
flutter analyze                      # doit rester propre
dart format lib
flutter test                         # 166 tests — cœur de calcul et écrans, sans appareil

# codegen — obligatoire après toute modif d'une déclaration @freezed / @riverpod
dart run build_runner build
dart run build_runner watch          # pendant l'itération

flutter gen-l10n                     # après édition de lib/l10n/app_fr.arb
```

Toolchain : Flutter 3.47 stable / Dart 3.13.

### Code généré

`*.freezed.dart`, `*.g.dart` et `lib/l10n/app_localizations*.dart` sont générés — ne jamais les éditer à la main. `generate: true` dans `pubspec.yaml` déclenche aussi `gen-l10n` lors d'un build normal.

## Dépendances

Installées conformément à `SPECS.md` §« Librairies externes » : `flutter_riverpod` 3.4 + `riverpod_annotation`/`riverpod_generator` 4.x, `go_router` 18, `sensors_plus` 7, `shared_preferences` 2.5, `freezed` 4 + `json_serializable`, `flutter_localizations` + `intl`, `build_runner`.

- **`riverpod_lint` / `custom_lint` sont volontairement absents** — leurs versions actuelles ne résolvent pas avec Riverpod 3.4 + `freezed_annotation` 3.x. À retenter plus tard ; ne pas les rajouter à l'aveugle.
- Écartés au MVP : toute base locale (Isar/Drift) et toute DI tierce.

### Particularités de l'API Riverpod 3

- Les providers-fonctions générés prennent un `Ref` simple (et non `SomethingRef`).
- `AsyncValue` expose **`.value`** nullable ; `valueOrNull` n'existe plus.

## Architecture

*Feature-first*, avec une frontière stricte autour du cœur de calcul.

```
lib/app/         app.dart (MaterialApp.router) · router.dart (go_router) · theme.dart (design system)
lib/core/calc/   ★ Dart pur, ZÉRO import Flutter — units/, distribution, layout, fasteners, tilt
lib/core/models/ value objects partagés (LengthUnit, MaterialKind, JointOffset, Tool)
lib/core/format.dart   formatNumber() + kNoValue — rendu des nombres, partagé par tous les écrans
lib/core/persistence/  PreferencesStore + SettingsController global
lib/core/widgets/      AppCard, ToolScaffold, ResultTile, NumberField, LabeledField,
                       AppSegmentedButton, AppSwitchField, AppDropdown, SchemaCard,
                       SchemaSheet, AppDisclosure, FieldHelp
lib/features/    home, settings, converter, distribution, layout, fasteners, level,
                 schema (le schéma d'un outil en plein écran), playground
lib/l10n/        app_fr.arb → AppLocalizations générée
test/core/calc/  tests unitaires du cœur — tournent sans appareil
test/features/   tests d'écran, pour ce que ni `analyze` ni le cœur ne peuvent
                 attraper : un painter qui lève, un libellé tronqué en silence
```

Routes : `/` (accueil) · `/settings` · `/tool/:id` · `/tool/:id/schema`, où `id` vient de l'enum `Tool`.

`/playground` est une **page de référence hors périmètre produit** : l'inventaire des widgets Material, pour vérifier d'un coup d'œil que le thème tient et trancher un choix de contrôle avant de l'implémenter. Accessible depuis l'accueil en debug. C'est le seul écran qui utilise `setState` — la règle « zéro setState » vaut pour le flux de calcul des outils, pas pour un état local jetable.

Chaque feature-outil suit le même quatuor : `*_screen.dart` (vue) · `*_controller.dart` (notifier de saisie + provider dérivé du résultat) · `*_schema.dart` (le `CustomPaint` branché sur les providers) · `*_painter.dart` (le dessin).

### Le schéma : une vignette qui s'ouvre en plein écran

`SchemaCard` (carte teintée, tapable) porte le schéma sur l'écran de l'outil ; `SchemaScreen` (`/tool/:id/schema`) le montre seul, zoomable. Trois décisions :

- **Le zoom ne vit qu'en plein écran.** Un geste à deux doigts dans une carte de 200 px, coincée entre deux zones de scroll, se déclenche de travers. La vignette ne fait que montrer, et *toute* la carte est la cible du tap — un bouton d'agrandissement se viserait, et viser avec un gant, c'est rater. L'indice ⤢ en bas à droite est là parce que sans lui un schéma ressemble à une image.
- **Une page, pas une boîte de dialogue.** Le geste de retour du système la ferme, la rotation en paysage donne au Calepinage la largeur qui lui manque, et le web y gagne une URL. Une boîte de dialogue n'offre aucun des trois.
- **La réduction descend à un tiers de l'ajustement, et « ajuster » la rattrape.** `InteractiveViewer` plafonne la réduction à `viewport / cadre` : tant que le cadre est le dessin, ce plancher vaut 1 et `minScale` n'a jamais la parole — d'où le `boundaryMargin` infini, qui rend la main à `minScale` mais déborne du même coup le déplacement. Le bouton « ajuster à l'écran » est donc le seul retour d'un schéma réduit ou poussé hors cadre : grisé tant que rien n'a bougé, jamais masqué. Sous garde de test (un vrai pincement : rien dans le code ne montre ce plancher).
- **Un bouton « pivoter » dans l'`AppBar`, pour le téléphone verrouillé en portrait.** Sans verrou, tourner l'appareil fait mieux — la barre suit, les cotes restent droites. Avec verrou, c'est le seul moyen de donner sa longue dimension à un schéma large. Le `RotatedBox` pivote les contraintes, donc le painter redessine dans la nouvelle boîte au lieu d'y être posé en biais, et le zoom est remis à plat au passage. Les libellés partent à 90° et **doivent y rester** : ils se redressent quand la main tourne le téléphone, ce qui est tout le geste visé — les contre-pivoter dans les painters les mettrait de travers dans le seul cas où le bouton sert.
- **Une feuille blanche dans la carte teintée** (`SchemaSheet`) : sur l'écran de l'outil, la teinte n'est plus qu'un encadrement et le dessin récupère le reste ; en plein écran, la feuille *est* l'écran — ni rembourrage ni coin arrondi autour de la zone déplaçable. La couleur de cette feuille est aussi celle du détourage des libellés de cote (`drawSchemaLabel`) — les deux doivent bouger ensemble, sinon chaque chiffre traîne un pavé de la mauvaise teinte. Conséquence directe : sur cette feuille, **la matière se dessine en `AppColors.field` et le vide en blanc** (pièce, fiole, surface découverte). Une pièce blanche sur une feuille blanche ne tiendrait que par son filet.

`*_schema.dart` est le point de construction unique du painter : la vignette et la page plein écran le traversent tous les deux, et son paramètre `compact` fait tomber les annotations secondaires dans la vignette (les deux cotes du Calepinage, les trois Ø et la colonne de hauteurs des Avant-trous, la numérotation de la Répartition — toutes reprises dans les tuiles de résultat juste en dessous). Le Convertisseur et le Niveau n'en ont pas : leurs painters se régulent déjà seuls, et une bulle n'a pas de détail à aller chercher — le Niveau est le seul outil dont la carte n'est pas tapable.

### Flux de données d'un outil

1. Modèle de saisie `@freezed` immuable (ex. `DistributionInput`), déclaré à côté de sa fonction de calcul.
2. Le notifier `@riverpod` tient la saisie ; une méthode par champ, qui fait `copyWith`.
3. Un provider **dérivé** `watch` la saisie et appelle la fonction pure de `core/calc` — le résultat est une dérivation, jamais de l'état. Il attrape `CalcException` et renvoie `null` ; l'écran affiche alors `—`.
4. L'écran `watch` le résultat : champs, painter et tuiles se reconstruisent seuls. Zéro `setState`, zéro bouton « calculer » (le calcul temps réel est une exigence UX).
5. Le painter reçoit le résultat et se contente de dessiner.
6. Le notifier mêle `PersistedForm` : sa dernière saisie se restaure à l'ouverture et s'enregistre toute seule.

### Persistance de la saisie

`PersistedForm<T>` (`core/persistence/persisted_form.dart`) branche un notifier de saisie sur le disque sans toucher à ses méthodes de champ : le notifier déclare `tool`, `defaults`, `decode`, `encode`, et son `build()` rend `restore()`. Le reste — relecture, écriture débattue à 400 ms, vidage au dispose — est dans le mixin. Les quatre outils à saisie l'utilisent ; le Niveau n'a rien à persister.

Trois points à ne pas défaire :

- **`main()` ouvre le store *avant* `runApp`** et surcharge `preferencesStoreProvider`. C'est ce qui le rend lisible en synchrone, et les `build()` de notifiers sont synchrones — les rendre `async` ferait remonter un `AsyncValue` dans les cinq écrans et leurs providers dérivés. Un test épingle cette lecture synchrone : c'est la clé de voûte du design.
- **`restore()` fait `ref.read` du store, jamais `ref.watch`.** Un store qui arriverait après coup rebâtirait un formulaire déjà rempli, sous les doigts. Il n'a pas à arriver après coup, et s'il manque (tests d'écran, `shared_preferences` indisponible) l'outil part de ses défauts sans jamais se faire reconstruire.
- **Une saisie illisible s'efface.** JSON tronqué ou écrit par une version précédente du modèle : on repart des défauts *et* on supprime la clé, sinon l'échec se rejoue à chaque lancement. Un outil qui refuse de s'ouvrir est pire que la perte d'une saisie.

**Pas de fenêtre de fraîcheur** — décidé : la restauration est inconditionnelle, ce qu'on a laissé se retrouve tel quel. C'est le bouton « réinitialiser » qui sert de porte de sortie, et c'est pour ça qu'il doit rester visible en permanence.

### Conventions non négociables

- **« Le painter peint, le core calcule. »** Aucune math dupliquée dans le rendu.
- `core/calc` ne doit jamais importer Flutter — c'est ce qui le rend testable sans appareil, et c'est tout l'intérêt de l'architecture.
- **L'unité interne est toujours le millimètre** (`double`). Conversions uniquement aux frontières UI.
- Une saisie invalide lève `CalcException` — jamais de valeur silencieuse fausse.
- Les modèles sont `@freezed` et immuables ; les modèles de saisie ont aussi `fromJson`/`toJson` pour pouvoir persister la dernière saisie de chaque outil.
- Code generation Riverpod (`@riverpod`) partout : relancer `build_runner` après toute modif de déclaration.

### Écart de nommage par rapport à la spec

`SPECS.md` nomme l'enum matériau `Material` ; le code utilise **`MaterialKind`** pour éviter la collision avec le widget `Material` de Flutter dans les écrans.

### Règles métier à connaître

- **Répartition :** la cote totale s'appelle **largeur** partout (écran, aides, messages d'erreur), et les bandes réservées aux extrémités des **marges** — jamais « longueur » ni « décalage », ce dernier étant réservé au décalage de joints du Calepinage. Les champs `startOffset` / `endOffset` gardent leur nom de code : les renommer toucherait les clés JSON persistées. On répartit des **éléments de largeur**, les points purs n'étant que le cas `elementWidth = 0` (les défauts d'origine — largeur nulle, bords aux écarts, marges nulles — redonnent exactement 3 points sur 100 → 25, 50, 75). Le nombre de jeux n'est pas une constante mais une conséquence des bords : `N + 1` bordé de deux écarts, `N − 1` bordé de deux éléments, `N` en mixte — `DistributionResult.gapCount` le rend explicite pour que l'UI n'ait pas à le redéduire. Deux modes symétriques, `computeDistribution` (nombre connu → écart) et `computeDistributionForSpacing` (écart voulu → nombre) ; le second **ne prend pas de réglage d'arrondi** : il rend les deux solutions entières qui encadrent la cible, `best` (la plus proche) et `other`, et qui a une contrainte de maximum — un barreaudage à 110 mm — lit la plus serrée. `kMaxDistributionCount` (500) borne les deux : sans lui, un écart de 0,001 mm produirait un million de positions.
- **Calepinage (outil signature) :** les éléments s'alignent le long d'un **axe de pose**, les rangées s'empilent perpendiculairement, et le décalage de joints décale le départ de chaque rangée le long de l'axe de pose. Sans inversion l'axe de pose est X ; **l'inversion pivote tout le motif d'un quart de tour, décalage compris** — décaler les joints d'un bardage vertical n'a de sens que le long des lames. Seuls les jeux restent définis à l'écran (`gapX` horizontal, `gapY` vertical). En v1, chaque départ de rangée décalé compte comme une coupe **sans réemploi des chutes** : le % de perte est donc volontairement pessimiste — la tuile de résultat le dit et doit continuer à le dire.
- **Avant-trous :** les coefficients vivent dans une table unique en tête de `fasteners.dart` (règles de l'art indicatives, à valider à part) ; le calcul ne fait que l'appliquer. L'invariant `pilotHole < clearanceHole < counterboreDia` doit toujours tenir.
- **Niveau :** seule la math vit dans `core/calc/tilt.dart` ; le flux `sensors_plus` reste dans `level_controller.dart`.
- **Convertisseur :** cinq grandeurs (longueur, surface, volume, masse, pression), une table par grandeur dans `core/calc/units/measures.dart`, pivots mm / mm² / mm³ / g / Pa. **Le tri des unités fait la valeur de l'outil** : une unité n'entre que si on la croise sur un chantier *et* qu'elle est pénible sans outil — d'où le pied-planche (`pmp`, 144 po³, l'unité d'achat du bois dur), et d'où l'absence de tout préfixe SI pur, qui n'est qu'un décalage de virgule. Sans ce tri, l'écran redevient un convertisseur générique, que le téléphone fait déjà mieux.
- **Cinq segments et pas un de plus** par grandeur, et des symboles courts : `AppSegmentedButton` tronque en silence (`overflow: ellipsis`). Le millibar a été retiré pour cette seule raison — mesuré à 72 px pour 65,6 disponibles sur un écran de 400 px. `test/features/converter/converter_screen_test.dart` garde le contrôle.

## Contraintes UI (issues de SPECS_UI.md)

Contexte atelier : fort contraste, gros texte, cibles tactiles ≥ 48 px — champs, sélecteurs, dropdowns, lignes de switch et boutons − / + font tous `kFieldHeight` (48 px, soit exactement la cible tactile minimale) et écrivent en `kControlFontSize` (18 px), actions principales atteignables d'une main en bas d'écran. Thème clair uniquement, un seul accent chaud bois/ambre (`AppColors.accent`), orange (`AppColors.cut`) réservé aux pièces à couper dans les schémas, chiffres tabulaires pour les résultats, résultats copiables d'un tap. `ToolScaffold` porte la règle de layout : saisie / visualisation / résultats empilés sur mobile, deux colonnes au-delà de `kWideBreakpoint` (800 px). La visualisation est la vedette de chaque écran et ne doit jamais passer sous la ligne de flottaison sur mobile.

`ToolScaffold.inputFooter` est le pied de la carte de saisie, posé **hors** de son rembourrage : la carte passe alors en `padding: zero` + `Clip.antiAlias`, le corps reprend les 16 px, et le pied touche les bords gauche, droit et bas. C'est la place d'`AppDisclosure`, qui porte lui-même la marge horizontale de la carte et le filet (`AppColors.cardBorder`) collé au-dessus de son en-tête — un panneau bordé *et* marginé ferait une carte dans la carte. Sous garde de test (`distribution_screen_test.dart`).

### « Réinitialiser » vit dans l'`AppBar`, pas dans une barre basse

`ToolScaffold` prend `onReset` (absent = pas d'action, cas du Niveau) et `canReset`. Trois décisions à ne pas défaire sans raison :

- **Pas de barre basse fixe.** Elle retrancherait ~75 px à *chaque* écran en permanence — la ressource même pour laquelle le Calepinage se bat — pour une action utilisée une fois par chantier. Et comme le calcul est temps réel, il n'y a aucune action principale à lui tenir compagnie : la barre n'existerait que pour le reset. L'`AppBar` existe déjà : coût vertical nul, et le coin opposé au pouce rend l'appui délibéré.
- **Pas de confirmation, pas de SnackBar « Annuler ».** Les cotes ne vivent pas dans l'app — elles viennent du mètre. Un reset accidentel fait retaper ce qui est encore mesurable à un mètre de là ; confirmer punirait les appuis voulus pour couvrir une erreur rare et bon marché. Le retour haptique est le seul accusé de réception.
- **`canReset: false` grise, ne masque pas.** Icône éteinte = la saisie est aux défauts, rien n'a été restauré. C'est le signal qui remplace la fenêtre de fraîcheur écartée, donc il doit rester visible — jamais dans un menu déroulant ni renvoyé aux Réglages. Chaque outil compare sa saisie à sa constante `kXDefaults`, déclarée à côté de son `build()`. FR uniquement au lancement, i18n câblée via `flutter_localizations` + `lib/l10n/app_fr.arb` — en pratique seul l'écran Réglages passe par `AppLocalizations`, les écrans-outils ont leurs libellés en dur.

### Typographie des contrôles

**Une seule fonction**, `controlTextStyle` dans `theme.dart` (18 px, w600) : champ numérique, valeur fermée d'un `DropdownMenu`, libellé d'`AppSegmentedButton`, entrée de panneau déroulant. `emphasized` ne joue que sur la graisse (w700), pour l'option retenue d'une liste — en appui de la pastille brune, qui reste le vrai indicateur.

Passer par la fonction plutôt que recopier un style : c'est exactement comme ça que le dropdown avait dérivé du champ, puis les entrées de menu des segments.

Chaque contrôle atteint `kFieldHeight` par un chemin différent — `SizedBox` pour le champ, `contentPadding` dérivé pour le `DropdownMenu`, cible tactile dégonflée (`MaterialTapTargetSize.shrinkWrap`) plus marge de 4 px pour la ligne de switch. Rien dans le code ne les relie : `test/features/control_metrics_test.dart` mesure les cinq au rendu.

⚠️ Deux pièges vérifiés à la mesure, tous deux invisibles à la lecture du code :
- `DropdownMenu` ne relaie du `menuButtonTheme` que `foregroundColor`, `backgroundColor`, `overlayColor` et `shape`. Un `textStyle` posé là n'a **aucun effet** — la taille des entrées se règle entrée par entrée, via `DropdownMenuEntry.style`.
- La hauteur du `DropdownMenu` vient de son `contentPadding` (son champ n'est pas le nôtre, on ne peut pas lui imposer de conteneur). Ce padding se dérive de `_controlLineHeight`, qui est une **mesure** et non `taille × interligne` : le moteur de texte arrondit la boîte de ligne. **À revérifier si la taille de police change.**

### Libellés de contrôle : la mesure, pas l'œil

La police des widget tests donne à **chaque glyphe la largeur de la taille de police** — un libellé de 11 caractères mesure donc 198 px en `controlTextStyle`, là où un segment n'en offre que 164 sur un écran de 400 px. Conséquence : le test plafonne à **9 caractères** dans un sélecteur à 2 segments. C'est cette mesure qui a coûté le millibar au convertisseur.

**C'est un premier filtre, pas un verdict** — elle consomme environ le double d'une vraie police. Un libellé qu'elle refuse peut être retenu après vérification **sur appareil** : « Symétriques / Asymétriques » et « Calcul écart / Calcul nombre » l'ont été (Pixel 5, 22/09/2026). Ces exceptions sont nommées une à une dans `knownWiderThanTestFont` (`distribution_screen_test.dart`), qui les épingle à l'envers : si l'une se met à tenir, le test le signale. La liste se vide, elle ne s'allonge pas — chaque entrée coûte la protection du libellé qu'elle contient, et rien ne rattrape une troncature silencieuse.

Un libellé plus long doit donc sortir du sélecteur segmenté : les quatre dispositions de bords de la Répartition sont des tuiles en grille 2 × 2, **pictogramme + texte sur deux lignes** (`EdgePreviewPainter`). Le dessin y vaut mieux que la phrase de toute façon : « Écart – Élément » et « Élément – Écart » se distinguent d'un coup d'œil sur un schéma, presque pas dans un libellé.

### Aide de champ : une feuille basse, jamais un dépliant

`LabeledField.about` prend un `FieldHelp` (titre + corps + points détachés) et pose un ⓘ **après** le libellé ; toute la ligne de libellé l'ouvre dans un `showModalBottomSheet`. `NumberField` le relaie. Les contenus d'un outil vivent groupés dans un `*_help.dart` : c'est du texte, il se relit et se corrige comme du texte.

Trois raisons de ne pas y revenir :

- **Pas de dépliant en place.** La carte de saisie apparie des champs sur une même ligne (`_Pair`) : un panneau qui pousse le contenu ferait grandir la ligne sous un seul des deux champs, avec un texte à demi-largeur qui part sur quatre lignes. La feuille ignore complètement le layout.
- **Pas de popover, pas de tooltip.** Le tooltip demande un appui long sur tactile — indécouvrable. Le popover se renvoie en visant à côté : geste de précision qui, avec un gant, atterrit sur un contrôle et change une cote. La feuille se renvoie d'un glissement n'importe où. Et elle portera un croquis le jour où l'explication en mérite un — pour la géométrie, le dessin bat la phrase (`EdgePreviewPainter` l'a déjà montré).
- **La ligne de libellé passe de 20 à 32 px, et seulement là où il y a un ⓘ.** C'est le seul endroit où la cible descend sous `kFieldHeight`, assumé : elle fait la largeur de la carte, et rater un ⓘ n'abîme rien — là où rater un champ change une cote. Un champ sans `about` ne paie rien (test).

`help` et `about` ne font pas le même métier et coexistent : `help` énonce une contrainte de saisie et reste affiché (« 0 = points sans épaisseur ») ; `about` explique, et ne s'ouvre qu'à la demande. Ce qu'ils ont le droit d'écrire est cadré plus bas, « Ponctuation des textes ».

### Ponctuation des textes : le tiret sépare, il ne relie pas

**Le tiret cadratin (—) et le point-virgule n'ont pas leur place dans un texte explicatif** : corps et points détachés d'un `FieldHelp`, message de `CalcException`, toute prose de plus d'une ligne. Ils y enchaînent des propositions que le lecteur d'atelier doit démêler debout, souvent sans lire jusqu'au bout. Deux phrases, ou un deux-points, ou une parenthèse. Jamais une incise entre tirets.

Ils restent en revanche **là où ils séparent visuellement**, et c'est un rôle utile :

- **libellés** — `Surface — largeur`, `Lamage — Ø × profondeur` : le tiret y tient lieu de colonne, il ne ponctue rien ;
- **notes de `ResultTile`** et lignes `help` d'une seule ligne, où il accroche une précision à ce qui précède ;
- **légendes de schéma** (`Rapport hors échelle — formes non à l'échelle`) ;
- **`kNoValue`** et la puce des `FieldHelp.bullets`, qui sont des glyphes, pas de la ponctuation.

Le test : si le tiret pourrait être remplacé par un saut de ligne ou un `:` dans un tableau, il sépare — il reste. S'il porte une incise au milieu d'une phrase, il part.

### Tuiles de résultat

`ResultTile` sépare la valeur de son unité : `unit` se rend après le chiffre, en plus petit et dans le gris des libellés, comme le `suffixText` d'un `NumberField`. L'unité ne va pas entre parenthèses dans le libellé — une cote se lit d'un bloc (`12,5 %`, `250 mm`), et le chiffre garde pour lui le gros style tabulaire, donc les valeurs restent alignées d'une tuile à l'autre. Exception assumée : dans une **table**, l'unité va en en-tête de colonne, parce qu'elle qualifie la colonne entière.

`ToolScaffold.results` prend une **liste**, pas une `Column` : c'est la carte qui intercale les filets (`AppColors.cardBorder`, de bord à bord, jamais avant le premier ni après le dernier).

---

## Commentaires

Les commentaires sont en **français**. Ils documentent le *pourquoi* du code tel qu'il est — jamais son évolution, c'est le rôle de git.

### Forme

- **`///` (dartdoc)** sur tout ce qui est déclaré : types, membres, constantes, champs `@freezed`. **`//`** uniquement pour une subtilité à l'intérieur d'un corps.
- Première ligne = une phrase courte qui se suffit, terminée par un point. Puis une ligne `///` vide, puis l'explication.
- Commencer par un verbe (« Répartit… ») ou un groupe nominal (« Vue de dessus : … »). Jamais « Cette fonction… », « Widget qui… ».
- Référencer les symboles entre crochets : `[computeDistribution]`, `[kFieldHeight]`. C'est un lien, pas une décoration.
- `// TODO(scope):` seulement pour ce qui figure au « Reste à faire » ci-dessous.
- Le tiret cadratin et le point-virgule sont **autorisés ici** : la règle de ponctuation plus haut ne vise que les textes lus dans l'app.

### À supprimer

- La paraphrase du code, et le découpage narratif d'un `build()` (`// la colonne des résultats`).
- Le code commenté, les TODO périmés, les commentaires devenus faux.
- Toute référence à un document de travail : notes, plans, comptes-rendus, fichiers de spec. Ils bougent ou disparaissent, le commentaire reste et ment. On énonce la contrainte elle-même, pas où elle est écrite.
- Tout ce qui retrace un historique : « avant on faisait X », « ajouté pour la v2 ».
- Les en-têtes de fichier décoratifs et les séparateurs `// ====`.

### À conserver et améliorer

Un commentaire se garde s'il porte une **contrainte métier** (règle de l'art d'un avant-trou), une **mesure** (les 198 px de la police de test), une **unité ou un invariant** (tout est en mm ; `pilotHole < clearanceHole`), un **choix non trivial** (pourquoi `ref.read` et pas `ref.watch`), ou une **décision à ne pas défaire**.

Ces derniers ont le droit d'être longs : c'est ce qui empêche de refaire l'erreur. On les resserre, on ne les tronque pas. Tout le reste tient en une ou deux lignes.

### Par couche

- **`core/calc/`** — documenter l'unité, les bornes, et ce qui lève `CalcException`. C'est la seule couche testable sans appareil, et son dartdoc est ce que lisent les écrans qui l'appellent.
- **Painters** — aucun commentaire de géométrie : la math est dans `core`. On y explique un ordre de tracé ou un seuil de densité, rien d'autre.
- **Widgets partagés** — les valeurs de thème et les hauteurs se justifient (pourquoi 48 px, pourquoi ce `contentPadding`), surtout les pièges vérifiés à la mesure.
- **Tests** — le nom du `test()` est le commentaire. On ne commente qu'un nombre magique ou la raison d'être d'un garde-fou.
- **Fichiers générés** (`*.g.dart`, `*.freezed.dart`, `app_localizations*.dart`) — jamais touchés.

### Consignes de passe

- Ne modifier que les commentaires, jamais la logique.
- Dans le doute, garder.
- `dart format lib` et `flutter analyze` doivent rester propres après la passe.

---

## Reste à faire

### 1. Câblages manquants
- **Retour haptique global** : `hapticsEnabledProvider` (dans `settings_controller.dart`) rend le réglage sans `AsyncValue` à déballer, et l'action « réinitialiser » de `ToolScaffold` s'en sert. Les quatre widgets partagés (`NumberField`, `AppSegmentedButton`, `AppSwitchField`, `AppDisclosure`) gardent en revanche un paramètre `haptics` codé à `true` — seul l'écran Réglages leur passe le réglage réel, donc les 4 écrans-outils vibrent encore quoi qu'il arrive. Il ne reste qu'à leur passer `ref.watch(hapticsEnabledProvider)` aux points d'appel. C'est le **seul** réglage que l'app expose.
- **Densité de vignette pour le Convertisseur** : `RulerPainter` et `ComparisonPainter` sont les deux seuls à ne pas prendre de `compact`. Ils se régulent seuls (graduations secondaires au-dessus de 5 px, libellé qui chevauche sauté), donc rien ne presse, mais leur vignette et leur plein écran sont identiques à l'échelle près.

### 2. Calepinage : la carte de saisie déborde sur mobile
Huit contrôles, même appariés en largeur × longueur, poussent le schéma à ~700 px du haut sur un écran de 844 — donc sous la ligne de flottaison, ce que la spec interdit. **`AppDisclosure` existe maintenant** : la Répartition règle le même problème en repliant ses trois réglages avancés (schéma à ~540 px, sous garde de test). Les jeux X/Y (optionnels, défaut 0) derrière un dépliant iraient de même. Règle d'emploi du dépliant : ce qui est replié doit être sans effet par défaut, sinon on cache la raison d'un résultat surprenant.

### 3. Convertisseur : la visu est faible hors longueur
La double règle ne vaut que pour des longueurs. Les quatre autres grandeurs passent par `ComparisonPainter`, qui compare la valeur à un repère rond (1 m², 1 L, 1 kg, 1 bar). C'est honnête mais pauvre pour la masse et la pression, qui n'ont pas de forme. Assumé en l'état ; à reprendre si l'outil se révèle utilisé.

### 4. Plus tard
- **Réglage global métrique / impérial** : *décidé puis reporté.* La saisie reste en mm partout, donc le réglage n'aurait rien à gouverner tant qu'aucun outil ne change d'unité. Le jour où il revient, trois choses à savoir : les painters cotent en dur eux aussi (`distribution_painter.dart`, `layout_painter.dart`) et divergeraient des tuiles ; **Avant-trous doit en être exclu** (une vis de 4 mm n'est pas `0,157 po`, c'est un gauge, une autre table) ; et la saisie resterait en mm, donc l'impérial serait un système en lecture seule.
- **Calepinage v2** : réemploi de la chute de début de rangée pour un % de perte juste. C'est là qu'un trait de scie deviendrait utile — il n'y a aujourd'hui aucun calcul qui le consommerait.
- **Répartition avec trait de scie** : débiter une planche en N morceaux égaux, où les traits mangent la longueur. Maintenant que l'outil connaît la largeur d'un élément, c'est le dernier cas manquant — et celui où un menuisier se fait avoir.
- **`riverpod_lint` / `custom_lint`** : retenter quand les versions se seront alignées sur Riverpod 3.4 + freezed 3.x.
- **Équerrage de caisson** : gardé en réserve, hors MVP. Candidat naturel si un 6ᵉ outil arrive.
- **`README.md`** : encore le texte par défaut de Flutter.
