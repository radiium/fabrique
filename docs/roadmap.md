# Reste à faire

## À faire

- **Vérifier sur appareil le cartouche des Tiroirs** : la police de test est trop pessimiste pour dire si `Personnalisée`, `Encastrée, jeu 3` ou une cote à deux décimales tiennent dans leur case.
- **Le plan du Convertisseur.** `core/export/` est générique, boutons compris : il manque un `converter_plan.dart` (le cartouche, et une enveloppe de `PlanExportAction`), branché dans `resultsFooter` et dans le `switch` sur `Tool` de `schema_screen.dart`. Un schéma plus large que 4/3 laissera du blanc au-dessus et en dessous.
- **Vérifier sur appareil le libellé du sélecteur de matériau** du Calepinage. Un nom de produit et deux cotes ne peuvent pas passer la mesure pessimiste de la police de test, donc son test garde le rapport au lieu du seuil. À confirmer à l'œil, comme l'ont été « Symétriques » et « Calcul écart ».

## Si l'usage le demande

- **La visu du Convertisseur hors longueur.** La comparaison à un repère est honnête, mais pauvre pour la masse et la pression.
- **Un mode vignette pour le Convertisseur.** Ses deux painters n'ont pas de `compact`, mais ils se régulent seuls.
- **Répartition à entraxe imposé** : trous d'étagère au pas de 32, tourillons au gabarit, barreaudage au pas fixe. L'entraxe ne bouge pas, c'est le reste qui s'ajuste aux extrémités. Un troisième mode :
  - saisie : `Entraxe imposé` à la place du nombre ou de l'écart, `Calage` (`Début` · `Centré` · `Fin`) à la place de la grille des bords. Les marges deviennent des minimums
  - résultats : nombre d'éléments, **premier axe depuis le bord** (la cote qu'on reporte), reste
  - schéma : l'étage de la marge cote du bord au premier axe, celui de l'écart cote l'entraxe. `DistributionResult` porte alors les jeux de début et de fin, que le painter n'a plus à déduire des bords
  - piège : `Calcul écart` et `Calcul nombre` tiennent déjà tout juste, un troisième segment ne passera pas. Piste : `Écart` · `Nombre` · `Pas fixe`
- **Hypothèse : le plan en PDF multipage, à la place du PNG.** Seul gain : une table longue continuerait page suivante au lieu de céder à son `fallback`. Piste évaluée :
  - pages rastérisées (`renderPlanPng` à 200 dpi) posées en pleine page par le paquet `pdf`, en pur Dart donc valable sur le web : l'aperçu reste le fichier et aucun painter ne change. Le vectoriel demanderait une abstraction de dessin sous tous les painters, et la même TTF des deux côtés pour que le cartouche tombe juste
  - la pagination, qui est le vrai travail : capacité calculée depuis `_tableRowHeight`, en-têtes répétés, pages de suite avec un cartouche réduit (outil, « page 2/3 »), note gardée en page 1, et un aperçu plein écran qui montre toutes les pages
  - le prix : `gal` ne prend que des images, donc « Exporter » perd les photos. Il faudrait écrire dans Téléchargements via MediaStore (canal natif ou paquet). « Voir » demanderait d'ouvrir un fichier (`open_filex` ou intention maison)
  - si elle est retenue, `docs/drawing/export.md` se réécrit : « Écarté », « Enregistrer et partager », la règle « tout ou rien »

## Plus tard

- **Réglage métrique / impérial.** *Décidé puis reporté* : la saisie reste en mm partout, donc le réglage n'aurait rien à gouverner. Le jour où il revient :
  - les painters cotent en dur eux aussi, et divergeraient des tuiles
  - la saisie resterait en mm, donc l'impérial serait en lecture seule
  - `core/calc/units/units.dart` (`toMm`, `fromMm`, `LengthUnit`) est gardé pour lui : aucun écran ne s'en sert d'ici là
- **Calepinage v3** : réemploi des chutes et trait de scie, pour une perte juste (voir [tools/layout.md](tools/layout.md)).
- **Répartition avec trait de scie** : débiter une planche en N morceaux égaux, où les traits mangent la longueur. C'est le dernier cas manquant, et celui où un menuisier se fait avoir.
- **Projets** (sauvegarder plusieurs saisies) : il faudrait une vraie base locale (Drift ou Isar), isolée derrière un repository.
- **`riverpod_lint` / `custom_lint`** : retenter quand leurs versions s'aligneront sur Riverpod 3.4 + freezed 3.x.
- **Équerrage de caisson** : en réserve, candidat naturel pour un septième outil.
- **`README.md` racine** : encore le texte par défaut de Flutter.
