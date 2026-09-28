# Reste à faire

- [À faire](#à-faire)
- [Publication](#publication)
- [Si l'usage le demande](#si-lusage-le-demande)
- [Plus tard](#plus-tard)

## À faire

- **Vérifier sur appareil le cartouche des Tiroirs** : la police de test est trop pessimiste pour dire si `Personnalisée`, `Encastrée, jeu 3` ou une cote à deux décimales tiennent dans leur case.
- **Le plan du Convertisseur.** `core/export/` est générique, boutons compris : il manque un `converter_plan.dart` (le cartouche, et une enveloppe de `PlanExportAction`), branché dans `resultsFooter` et dans le `switch` sur `Tool` de `schema_screen.dart`. Un schéma plus large que 4/3 laissera du blanc au-dessus et en dessous.
- **Vérifier sur appareil le libellé du sélecteur de matériau** du Calepinage. Un nom de produit et deux cotes ne peuvent pas passer la mesure pessimiste de la police de test, donc son test garde le rapport au lieu du seuil.

## Publication

Dans l'ordre. La signature, la version et la fiche sont en place (voir [release.md](release.md)).

- **L'icône de l'app** : c'est encore celle de Flutter, dans `android/app/src/main/res/mipmap-*` et `web/icons/`. F-Droid la tire de l'APK.
- **Les captures d'écran** de la fiche, une série par langue : `fastlane/metadata/android/fr-FR/images/phoneScreenshots/1.png`, `2.png`… et de même sous `en-US/`.
- **Un dépôt public**, GitHub ou Codeberg : F-Droid et IzzyOnDroid partent des sources et des tags. Puis le premier tag, `v0.1.0`.
- **Le workflow de release**, sur un tag `v*` : analyse et tests, APK signé (la clé en secret du dépôt, réécrite en `key.properties`), Release avec l'APK joint.
- **IzzyOnDroid** : demande d'inclusion une fois la première Release publiée. Il reprend l'APK de la Release, signé par notre clé, et publie en un jour.
- **F-Droid officiel** : merge request sur `fdroiddata`, avec Flutter figé en sous-module git, `UpdateCheckMode: Tags` et le `versionCode` lu dans le `pubspec`. Revue de quelques semaines. F-Droid signe alors avec sa propre clé : passer d'IzzyOnDroid à F-Droid demandera de réinstaller, sauf build reproductible.
- **Le web** : `flutter build web`, hébergé sur les Pages de l'hébergeur git.

## Si l'usage le demande

- **La visu du Convertisseur hors longueur.** La comparaison à un repère est honnête, mais pauvre pour la masse et la pression : elles n'ont pas de forme, leur en inventer une mentirait.
- **Un mode vignette pour le Convertisseur.** Ses deux painters n'ont pas de `compact`, mais ils se régulent seuls.
- **Répartition à entraxe imposé** : trous d'étagère au pas de 32, tourillons au gabarit, barreaudage au pas fixe. L'entraxe ne bouge pas, c'est le reste qui s'ajuste aux extrémités. Un troisième mode :
  - saisie : `Entraxe imposé` à la place du nombre ou de l'écart, `Calage` (`Début` · `Centré` · `Fin`) à la place de la grille des bords. Les marges deviennent des minimums
  - résultats : nombre d'éléments, **premier axe depuis le bord** (la cote qu'on reporte), reste
  - schéma : l'étage de la marge cote du bord au premier axe, celui de l'écart cote l'entraxe. `DistributionResult` porte alors les jeux de début et de fin, que le painter n'a plus à déduire des bords
  - piège : `Calcul écart` et `Calcul nombre` tiennent déjà tout juste, un troisième segment ne passera pas. Piste : `Écart` · `Nombre` · `Pas fixe`
- **Hypothèse : le plan en PDF multipage, à la place du PNG.** Seul gain : une table longue continuerait page suivante au lieu de céder à son repli. Pages rastérisées posées par le paquet `pdf` (pur Dart, donc valable sur le web), aucun painter ne change. Le vrai travail est la pagination (en-têtes répétés, cartouche réduit en page de suite). Le prix : `gal` ne prend que des images, donc « Exporter » perdrait les photos.

## Plus tard

- **Réglage métrique / impérial.** *Décidé puis reporté* : la saisie reste en mm partout, donc le réglage n'aurait rien à gouverner. Le jour où il revient :
  - les painters cotent en dur eux aussi, et divergeraient des tuiles
  - la saisie resterait en mm, donc l'impérial serait en lecture seule
  - `core/calc/units/units.dart` (`toMm`, `fromMm`, `LengthUnit`) est gardé pour lui : aucun écran ne s'en sert d'ici là
- **Calepinage v3** : réemploi des chutes et trait de scie, pour une perte juste (voir [tools/layout.md](tools/layout.md)).
- **Répartition avec trait de scie** : débiter une planche en N morceaux égaux, où les traits mangent la longueur. C'est le dernier cas manquant, et celui où un menuisier se fait avoir.
- **Projets** (sauvegarder plusieurs saisies) : il faudrait une vraie base locale (Drift ou Isar), isolée derrière un repository.
- **Équerrage de caisson** : en réserve, candidat naturel pour un sixième outil.
