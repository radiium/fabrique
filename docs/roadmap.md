# Reste à faire

## À faire

- **Le plan du Convertisseur et des Avant-trous.** `core/export/` est générique : il manque un `*_plan.dart` par outil et ses deux points d'entrée (`resultsFooter`, et l'action de l'`AppBar` plein écran, déjà aiguillée par un `switch` sur `Tool` dans `schema_screen.dart`). La note du cartouche des Avant-trous devra porter l'« indicatif » des coefficients. Un schéma plus large que 4/3 laissera du blanc au-dessus et en dessous.
- **Vérifier sur appareil le libellé du sélecteur de matériau** du Calepinage. Un nom de produit et deux cotes ne peuvent pas passer la mesure pessimiste de la police de test, donc son test garde le rapport au lieu du seuil. À confirmer à l'œil, comme l'ont été « Symétriques » et « Calcul écart ».

## Si l'usage le demande

- **La visu du Convertisseur hors longueur.** La comparaison à un repère est honnête, mais pauvre pour la masse et la pression.
- **Un mode vignette pour le Convertisseur.** Ses deux painters n'ont pas de `compact`, mais ils se régulent seuls.

## Plus tard

- **Réglage métrique / impérial.** *Décidé puis reporté* : la saisie reste en mm partout, donc le réglage n'aurait rien à gouverner. Le jour où il revient :
  - les painters cotent en dur eux aussi, et divergeraient des tuiles
  - **les Avant-trous en sont exclus** : une vis de 4 mm n'est pas `0,157 po`, c'est un gauge, une autre table
  - la saisie resterait en mm, donc l'impérial serait en lecture seule
  - `core/calc/units/units.dart` (`toMm`, `fromMm`, `LengthUnit`) est gardé pour lui : aucun écran ne s'en sert d'ici là
- **Calepinage v3** : réemploi des chutes et trait de scie, pour une perte juste (voir [tools/layout.md](tools/layout.md)).
- **Répartition avec trait de scie** : débiter une planche en N morceaux égaux, où les traits mangent la longueur. C'est le dernier cas manquant, et celui où un menuisier se fait avoir.
- **Projets** (sauvegarder plusieurs saisies) : il faudrait une vraie base locale (Drift ou Isar), isolée derrière un repository.
- **`riverpod_lint` / `custom_lint`** : retenter quand leurs versions s'aligneront sur Riverpod 3.4 + freezed 3.x.
- **Équerrage de caisson** : en réserve, candidat naturel pour un sixième outil.
- **`README.md` racine** : encore le texte par défaut de Flutter.
