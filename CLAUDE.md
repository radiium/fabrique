# CLAUDE.md

Ce fichier guide Claude Code (claude.ai/code) lorsqu'il travaille sur ce dépôt.

## État du projet

`fabrique` est l'app **« Menuiserie »** — une app portfolio de 5 outils de calcul pour l'atelier, sur iOS, Android et Web.

Le cœur de calcul est **entièrement implémenté et couvert** (192 tests : `test/core/calc/` pour le cœur, `test/features/` pour ce qui ne se vérifie qu'au rendu). Les **six écrans sont câblés** — les 5 outils plus les Réglages — les **six painters sont écrits**, et l'app est utilisable de bout en bout.

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
flutter test                         # 192 tests — cœur de calcul et écrans, sans appareil

# codegen — obligatoire après toute modif d'une déclaration @freezed / @riverpod
dart run build_runner build
dart run build_runner watch          # pendant l'itération

flutter gen-l10n                     # après édition de lib/l10n/app_fr.arb
```

Toolchain : Flutter 3.47 stable / Dart 3.13.

### Code généré

`*.freezed.dart`, `*.g.dart` et `lib/l10n/app_localizations*.dart` sont générés — ne jamais les éditer à la main. `generate: true` dans `pubspec.yaml` déclenche aussi `gen-l10n` lors d'un build normal.

## Dépendances

Installées conformément à `SPECS.md` §« Librairies externes » : `flutter_riverpod` 3.4 + `riverpod_annotation`/`riverpod_generator` 4.x, `go_router` 18, `sensors_plus` 7, `shared_preferences` 2.5, `share_plus` 13, `gal` 2.3, `freezed` 4 + `json_serializable`, `flutter_localizations` + `intl`, `build_runner`.

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
lib/core/painting.dart primitives de cotation partagées : SchemaViewport, cotes, flèches,
                       traits de rupture — espace objet / espace papier
lib/core/persistence/  PreferencesStore + SettingsController global
lib/core/export/       plan.dart (la feuille A4 + son cartouche) · plan_export.dart
                       (rendu PNG, remise au système)
lib/core/widgets/      AppCard, AppCardActions, ToolScaffold, ResultTile, NumberField,
                       LabeledField,
                       AppSegmentedButton, AppSwitchField, AppDropdown, SchemaCard,
                       SchemaSheet, AppDisclosure, FieldHelp, HapticsScope
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

`*_schema.dart` est le point de construction unique du painter : la vignette et la page plein écran le traversent tous les deux, et son paramètre `compact` fait tomber les annotations secondaires dans la vignette (les deux cotes du Calepinage, les trois Ø et la colonne de hauteurs des Avant-trous — toutes reprises dans les tuiles de résultat juste en dessous). Le Convertisseur, le Niveau et la Répartition n'en ont pas : les deux premiers se régulent seuls, et le troisième n'a plus rien à faire tomber depuis que ses cotes vivent dans ses panneaux de détail. Le Niveau est le seul outil dont la carte n'est pas tapable.

### Répartition : une vue d'ensemble, deux bouts agrandis

Une vue d'ensemble ne peut pas coter ce qu'elle montre. Sur une pièce de 1800 mm, une marge de 40 fait deux pixels et l'élément de 18 qu'elle borde encore moins : le chiffre ne tient pas, et la chaîne de cotes se tassait jusqu'à se replier sur une seule légende `N × écart`. Le schéma est donc en trois bandes — la pièce entière avec sa **seule cote totale**, puis **deux panneaux** qui reprennent le début et la fin, chacun terminé par un trait de rupture.

- **Un agrandissement rond et écrit**, pas un « hors échelle ». Les panneaux prennent le plus grand rang de `_zoomLadder` qui laisse tenir marge + élément + écart, et le rapport se lit sous le dessin (`Détails ×1,5`). L'échelle se prend au rang inférieur, donc un rang manquant se paie en agrandissement perdu — d'où les demis jusqu'à 3, sans lesquels le cas courant d'une rangée de cinq (rapport ~1,8) retomberait à 1, c'est-à-dire à des panneaux qui n'agrandissent rien.
- **Trois étages de cote fixes** — marge, élément, écart — occupés ou non. Les attribuer au fil des cotes présentes ferait remonter l'élément et l'écart d'un cran dès qu'on remet une marge à zéro. Le premier étage est à la même distance du bas de la barre que deux étages le sont l'un de l'autre, donc les trois tombent à une, deux et trois fois cette distance : un peigne régulier se lit comme une seule chose, trois écarts inégaux donnent à croire qu'ils veulent dire quelque chose.
- **Les panneaux couvrent 83 % de la largeur de la vue d'ensemble** (retrait plus gouttière), et leur barre fait exactement le double de la sienne. Sans ce retrait, deux bouts se lisaient aussi longs que la pièce entière ; sans cette épaisseur, un détail agrandi en largeur seulement se lisait comme un étirement.
- **La matière est détourée par la ligne brisée elle-même** (`schemaBreakPoints`), pas par une verticale posée dessous. Un détourage droit laisse la matière déborder des dents, et le trait de rupture ne coupe alors plus rien.
- **Cotes serrées** : `drawHDimension(tight: true)` retourne les flèches vers l'extérieur et sort le chiffre de l'espace mesuré, au lieu de taire la cote. C'est la convention du dessin technique pour les petites cotes, et le seul moyen de coter 40 et 18 côte à côte. Le chiffre sort **hors de la pièce** (`labelSide`), vers la marge de la feuille : vers l'intérieur il tomberait au-delà des traits d'attache de l'étage voisin, qui descendent plus bas que lui. `bounds` le recale s'il n'y a pas la place.
- **Espace objet / espace papier**, comme sur un plan. `SchemaViewport` (`core/painting.dart`) est le seul point de passage entre les millimètres de la pièce et la feuille : une place (`rect`), un millimètre d'origine, une échelle. Le schéma en pose **trois** — la vue d'ensemble, et les deux panneaux à l'échelle agrandie. Ce qui se lit (chiffres, flèches, épaisseurs de trait) reste en unités de feuille et ne traverse jamais une fenêtre, donc un chiffre garde sa taille quelle que soit l'échelle de la vue qu'il cote. C'est ce qui rend possibles deux échelles dans un même dessin sans que l'une impose sa réduction à l'autre.
- **Le dessin ne se recompose pas avec le canvas, il s'y pose en entier.** Tout est coté dans une boîte fixe de 336 × 237, qu'une seule mise à l'échelle **uniforme** amène à la taille disponible, centrée. Sans ça, la largeur suivait le canvas et la hauteur suivait ses chiffres : le schéma s'étirait à chaque redimensionnement — invisible sur un téléphone, flagrant sur le web. Le `visualizationAspectRatio` de 4/3 est choisi pour que ce facteur vaille 1 sur la vignette d'un téléphone, là où l'outil se lit d'abord.
- **Identique en vignette et en plein écran.** Il n'y a plus d'annotation secondaire à faire tomber : la vue d'ensemble ne porte qu'un chiffre, les panneaux portent tout le reste, et un panneau sans ses cotes serait un zoom vide. La vignette prend en échange un `visualizationAspectRatio` de 4/3 — le seul outil à relever le 16/10 commun. Le plein écran, lui, pose ce même dessin sur une feuille A4 : voir « Exporter un plan ».
- **Pas de numérotation des éléments.** Elle reliait le schéma à la table des positions, mais elle se tassait exactement là où la table devient utile.

### Exporter un plan

Le schéma de la Répartition sort de l'app en **PNG**, sur une feuille A4 à l'italienne portant son **cartouche** : le dessin, les résultats et la table des positions. `lib/core/export/` tient la feuille (`plan.dart`) et sa sortie (`plan_export.dart`) ; `distribution_plan.dart` décrit ce que le cartouche de l'outil écrit. Les quatre autres outils n'en ont pas encore.

- **Le dessin seul ne s'exporte pas.** Les cotes vivent dans les tuiles de résultat, pas sur le schéma : partie sans elles, l'image demanderait au destinataire de deviner. Le cartouche est la convention du dessin technique, donc il n'y a rien à expliquer à qui le reçoit.
- **La page plein écran montre le plan, pas le schéma.** C'est l'aperçu de ce qui sortira, au pixel près — les deux traversent `buildDistributionPlan`, point de construction unique du `PlanPainter`, exactement comme `*_schema.dart` l'est du painter d'outil. Un aperçu qui montrerait autre chose ferait découvrir le cartouche dans le fichier, une fois parti. Saisie refusée : il n'y a pas de plan, la page retombe sur le schéma seul et l'export s'éteint.
- **Un seul format.** Le PNG s'ouvre partout, s'affiche dans une conversation sans être téléchargé, et s'imprime. Le PDF n'aurait apporté que l'impression, et aurait coûté une seconde dépendance pour un dessin qui resterait rastérisé de toute façon — il n'existe pas de pont entre un `Canvas` de `dart:ui` et la toile du paquet `pdf`.
- **Le painter se rejoue hors de l'arbre de widgets**, à 2339 px de large (A4 à 200 dpi). Capturer la `RepaintBoundary` de l'écran rendrait au contraire la vignette telle qu'affichée : densité réduite, cadrage et résolution dépendant du téléphone de celui qui exporte.
- **Cartouche en colonne le long du bord droit**, et non en bandeau bas. Une liste veut de la hauteur, et la zone de tracé garde ainsi des proportions proches de celles des schémas — en bandeau, un dessin en 5/4 se retrouvait cerné de blanc sur ses deux flancs.
- **Le cartouche est un tableau réglé, pas une liste de valeurs.** Encre noir franc (`#000000`), une case par champ, intitulé en petites capitales interlettrées dans le coin et valeur en gras dessous, cadre de feuille à `1` et refends à `0,5` : les deux épaisseurs du dessin technique. C'est la forme qu'a le cartouche de n'importe quel plan, donc elle se lit sans qu'on l'explique — un panneau typographique, lui, se lisait comme une capture d'app. La case de tête ne porte **que le nom de l'outil** : ni nom d'app, ni sous-titre.
- **Il ne porte que ce que le dessin ne cote pas.** La largeur totale, la largeur d'élément et les marges sont sur le schéma, aux mêmes chiffres exacts : les réécrire serait une redite. Seule exception, l'**écart souhaité** en mode « Calcul nombre » — le dessin ne porte que l'écart obtenu, et sans la cible rien n'explique le nombre trouvé. Il va donc dans les cases, juste avant sa réponse.
- **Les hauteurs de case se dérivent, elles ne se posent pas à l'œil** : `_lineHeight` est figé, donc une boîte de ligne vaut exactement `taille × ce facteur` et la hauteur d'une case se calcule. Posée à la main, elle laissait la valeur passer sous son intitulé — et ça ne se voit qu'au rendu.
- **La table des positions, c'est tout ou rien.** Vingt-deux lignes tiennent dans le cartouche ; au-delà, la table entière cède la place à `N positions — à copier depuis l'app`. Une liste tronquée sur un plan d'atelier, c'est une pièce percée en moins, et rien sur la feuille ne dirait qu'il en manque.
- ⚠️ **La colonne des numéros doit tenir le plus grand numéro possible** (`kMaxDistributionCount`, trois chiffres). Sous-dimensionnée, une cellule ne tronque pas : elle **n'écrit rien**, et la colonne se vide en silence à partir de 10.
- **La note du cartouche est réservée avant tout le reste.** C'est elle qui borne la table, et c'est là que va l'avertissement d'un outil — la seule ligne qu'on n'ait pas le droit de perdre sous un débordement. La Répartition n'en a pas ; le Calepinage y mettra son `%` de perte pessimiste.
- **Tout est coté dans une boîte de 594 × 420**, qu'une seule mise à l'échelle uniforme amène à la taille disponible : même règle que les schémas, et c'est elle qui fait que l'aperçu vaut pour le fichier quelle que soit la taille de l'écran.
- **`kPlanWidth` / `kPlanHeight` fixent aussi les tailles de texte du cartouche.** Elles sont réglées à la mesure sur une vraie police : y toucher, c'est rouvrir la question du nombre de positions qui tiennent.

**Deux gestes, et « Exporter » passe devant.** Le pied de la carte de résultats (`ToolScaffold.resultsFooter`) porte deux boutons : « Exporter », qui enregistre le PNG dans les photos de l'appareil, et « Partager », qui ouvre la feuille du système.

- **Le sélecteur de partage d'Android ne liste que des applications.** Il n'y a aucune action « enregistrer » dedans, contrairement à celui d'iOS qui porte « Enregistrer l'image » et « Enregistrer dans Fichiers ». Sans le premier bouton, on ne pourrait pas simplement garder son plan — seulement l'envoyer quelque part.
- **Dans les photos, en un tap** (`gal`), sans boîte de dialogue : c'est le seul endroit que tout le monde sait rouvrir, et d'où le téléphone sait déjà imprimer et envoyer. Qui veut ranger ailleurs passe par « Partager », qui ouvre Fichiers et Drive.
- **Pas de dossier au choix, et surtout pas de dossier mémorisé.** *Décidé après essai.* Une boîte « enregistrer sous » coûte trois taps à chaque export ; un chemin retenu dans les Réglages demanderait à Android une autorisation d'arbre persistante (`ACTION_OPEN_DOCUMENT_TREE` + `takePersistableUriPermission`, écriture par `DocumentsContract` — un `content://` ne s'écrit pas avec `dart:io`), donc un paquet de plus, des signets à portée de sécurité sur iOS, et un chemin qui périme quand le dossier disparaît. Pour un réglage, dans une app qui n'en expose qu'un.
- **Le SnackBar porte « Voir »** (`Gal.open`, déjà dans le paquet) : un enregistrement qu'on ne peut pas vérifier envoie chercher le plan hors de l'app. La galerie s'ouvre sur son dernier élément, qui vient d'être écrit — pas sur le fichier lui-même. Viser le fichier demanderait `saver_gallery` (le seul à rendre l'URI écrite) **plus** `open_filex`, et ne marcherait **que sur Android** : sur iOS l'URI rendue est un `ph://<identifiant>` de PHAsset, qu'aucune API publique n'ouvre depuis une app tierce.
- ⚠️ **`SnackBar` pose `persist = persist ?? action != null`.** Un SnackBar qui porte une action **ne se referme jamais tout seul**. Celui-ci est un accusé de réception, pas une question : il force `persist: false` pour garder son bouton *et* s'effacer. Invisible à la lecture, vérifié à l'usage.
- **Pas de chemin d'enregistrement réglable.** *Écarté après chiffrage.* Il faudrait `saf_util` et `android_intent_plus`, tous deux Android uniquement, plus un réglage, plus un cas d'erreur (dossier supprimé, autorisation révoquée), plus un parcours iOS distinct. Il n'existe pas en Flutter de « dossier parcourable » qui se comporte pareil des deux côtés : Android passe par SAF, iOS par des signets à portée de sécurité. Photos est la seule destination identique sur les deux avec un seul petit paquet — c'est la raison du choix.
- **Sans album.** Un album demanderait l'accès complet à la photothèque sur iOS, là où l'ajout seul se contente de `NSPhotoLibraryAddUsageDescription`. Sur Android, `WRITE_EXTERNAL_STORAGE` est déclaré avec `maxSdkVersion="29"` : au-delà, le stockage cloisonné n'en veut plus, et rien n'est demandé à l'utilisateur.
- **Sur le web, « Exporter » télécharge** (`plan_download_web.dart`, import conditionnel sur `dart.library.js_interop`, souche qui lève ailleurs pour que `dart:js_interop` ne parte jamais dans un build mobile). Le navigateur n'a pas de galerie, et passer par la feuille de partage serait un détour : l'API Web Share ne prend les fichiers que sur une poignée de navigateurs, et là où elle manque l'utilisateur ne voit rien se produire. `package:web` était déjà là en transitif, donc zéro paquet de plus. Deux pièges de navigateur dans ce fichier : le lien doit être **dans** le document avant le clic (Firefox ignore un lien détaché), et l'URL objet ne se libère pas dans la foulée (Safari abandonne le téléchargement si la source disparaît trop tôt).
- **Le pied plutôt que l'`AppBar`** sur l'écran de l'outil : on exporte **après** avoir lu ses résultats, et c'est là qu'on arrive en fin de lecture. L'`AppBar` reste à « réinitialiser », l'action à rendre difficile.
- **Une seule action sur la page plein écran**, l'enregistrement : « ajuster » et « pivoter » occupent déjà la barre, et partager reste à un écran de distance.

Tout s'éteint sur une saisie refusée, rien ne disparaît.

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

`resultsFooter` est son symétrique en bas de pile, pour ce qu'on fait des résultats une fois lus. Même pose, même filet, et c'est la place d'`AppCardActions` : une rangée de boutons pleins à parts égales, hauts de `kFieldHeight` et écrits en `controlTextStyle`. Aucun `Divider` ne l'en sépare — le pied porte son propre filet, et deux traits superposés se verraient.

Ces boutons sont **pleins, en `AppColors.accentDeep` sur texte blanc** : c'est la pastille du sélecteur segmenté, donc la seule couleur de l'app qui dise déjà « ceci est actif ». Une ligne de texte discrète, à cette place, se lirait comme une note de bas de carte. **L'icône ne s'affiche que si elle tient** — mesurée au rendu contre la largeur réelle du bouton, le libellé passant d'abord : c'est lui qui nomme l'action. Sous garde de test, comme tout libellé qui partage une largeur (`distribution_plan_test.dart`).

### « Réinitialiser » vit dans l'`AppBar`, pas dans une barre basse

`ToolScaffold` prend `onReset` (absent = pas d'action, cas du Niveau) et `canReset`. Trois décisions à ne pas défaire sans raison :

- **Pas de barre basse fixe.** Elle retrancherait ~75 px à *chaque* écran en permanence — la ressource même pour laquelle le Calepinage se bat — pour une action utilisée une fois par chantier. Et comme le calcul est temps réel, il n'y a aucune action principale à lui tenir compagnie : la barre n'existerait que pour le reset. L'`AppBar` existe déjà : coût vertical nul, et le coin opposé au pouce rend l'appui délibéré.
- **Pas de confirmation, pas de SnackBar « Annuler ».** Les cotes ne vivent pas dans l'app — elles viennent du mètre. Un reset accidentel fait retaper ce qui est encore mesurable à un mètre de là ; confirmer punirait les appuis voulus pour couvrir une erreur rare et bon marché. Le retour haptique est le seul accusé de réception.
- **`canReset: false` grise, ne masque pas.** Icône éteinte = la saisie est aux défauts, rien n'a été restauré. C'est le signal qui remplace la fenêtre de fraîcheur écartée, donc il doit rester visible — jamais dans un menu déroulant ni renvoyé aux Réglages. Chaque outil compare sa saisie à sa constante `kXDefaults`, déclarée à côté de son `build()`. FR uniquement au lancement, i18n câblée via `flutter_localizations` + `lib/l10n/app_fr.arb` — en pratique seul l'écran Réglages passe par `AppLocalizations`, les écrans-outils ont leurs libellés en dur.

### Le retour haptique : une portée, pas un paramètre

`HapticsScope` (`core/widgets/haptics.dart`) descend le réglage depuis la racine ; les contrôles appellent `hapticSelection(context)` ou `hapticImpact(context)`, qui l'interrogent au moment de vibrer. `FabriqueApp` est le **seul** endroit qui lit `hapticsEnabledProvider`. C'est le seul réglage que l'app expose.

- **Pas de paramètre `haptics` passé de main en main.** Cinq widgets vibrent, mais ils sont appelés une trentaine de fois dans les écrans : le paramètre réclamait une ligne à chaque nouveau champ, et il suffisait de l'oublier une fois pour qu'un contrôle vibre contre le réglage, sans que rien ne lève.
- **La portée n'est pas Riverpod.** `core/widgets` reste du Flutter nu, donc ses widgets se montent seuls dans un test sans `ProviderScope` — ce que `control_metrics_test.dart` et `field_help_test.dart` font déjà.
- **Hors portée, ça vibre.** `HapticsScope.of` rend `true` quand personne n'a posé de portée : un câblage oublié fait vibrer de trop, jamais rester muet.
- **Lecture sans dépendance** (`getInheritedWidgetOfExactType`) : l'appelant est un gestionnaire de geste, pas un `build`. Changer le réglage ne reconstruit aucun contrôle.

`test/features/haptics_test.dart` tient les deux bouts : que la portée coupée fasse taire un contrôle, et que la racine de l'app l'alimente bien.

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
- **Le plan des quatre autres outils.** `core/export/` est générique : il prend un painter et une description de cartouche. Il manque un `*_plan.dart` par outil, plus les deux points d'entrée (`resultsFooter` et l'action de l'`AppBar` du plein écran, toutes deux déjà branchées dans `schema_screen.dart` par un `switch` sur `Tool`). Le Niveau en est exclu : un flux capteur figé n'est pas un plan. Deux choses à vérifier au passage : le pied du cartouche doit porter l'avertissement de l'outil (le % de perte pessimiste du Calepinage, l'« indicatif » des coefficients d'avant-trou), et un schéma plus large que 4/3 laissera du blanc au-dessus et en dessous de la zone de tracé.
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
