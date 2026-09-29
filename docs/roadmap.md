# Reste à faire

- [Publication](#publication)
- [Si l'usage le demande](#si-lusage-le-demande)
- [Plus tard](#plus-tard)

## Publication

Dans l'ordre. La signature, la version, la fiche, l'icône, les captures et le workflow de release sont en place, `v0.1.0` est publiée (voir [release.md](release.md)).

- **IzzyOnDroid** : demande d'inclusion une fois la première Release publiée. Il reprend l'APK de la Release, signé par notre clé, et publie en un jour.
- **F-Droid officiel** : merge request sur `fdroiddata`, avec Flutter figé en sous-module git, `UpdateCheckMode: Tags` et le `versionCode` lu dans le `pubspec`. Revue de quelques semaines. F-Droid signe alors avec sa propre clé : passer d'IzzyOnDroid à F-Droid demandera de réinstaller, sauf build reproductible.

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
- **Le calcul dans les champs** : `600-2*18` retient `564`. En atelier, on déduit sans cesse épaisseurs, jeux et feuillures.
  - analyseur pur Dart dans `core/calc` : quatre opérations et parenthèses
  - une expression invalide est un `CalcError` comme un autre
  - évaluée à la perte du focus, la valeur retenue reste affichée
- **Les cotes d'atelier partagées** : épaisseur de panneau (18 ou 19), trait de scie, jeu de coulisse, réglés une fois dans les Réglages et repris comme défauts par chaque outil. Prépare la Répartition avec trait de scie et le Calepinage v3.
- **L'écran qui reste allumé** sur un écran d'outil, le Niveau surtout : on lit une cote, on coupe, on revient les mains pleines de sciure. Dépendance `wakelock_plus` à justifier, option dans les Réglages.
- **Les modèles enregistrés** : une saisie nommée (« Caisson cuisine 600 »), rappelée d'un appui. Quelques entrées par outil tiennent en JSON dans le stockage actuel : l'essentiel des Projets sans base locale.
- **Projets** (sauvegarder plusieurs saisies) : il faudrait une vraie base locale (Drift ou Isar), isolée derrière un repository.
- **Partager un calcul par lien** : la saisie encodée dans l'URL, ouverte sur le web ou dans l'app (lien profond Android) avec les mêmes cotes. Le destinataire reçoit un calcul modifiable, pas une image.
- **Les raccourcis de l'icône** : appui long sur l'icône Android, et `shortcuts` du manifeste web, un par outil. Piège : le manifeste n'a qu'une langue, les noms d'outils n'y seraient qu'en français.
- **Équerrage de caisson** : en réserve, candidat naturel pour un sixième outil.
