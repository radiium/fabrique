# Écrire les textes de l'app

Français et anglais. Les textes vivent dans `lib/l10n/app_fr.arb` (le gabarit) et `app_en.arb`, jamais dans le code. Une clé porte sa portée en préfixe (`layout…`, `drawers…`, `calc…`, `common…`) ; sa `description` dit où le texte s'affiche quand ça change sa forme (segment, cartouche, lecteur d'écran).

## Vocabulaire

- **Vocabulaire d'atelier, un seul mot par chose.** Une cote qui s'appelle « largeur totale » à l'écran s'appelle ainsi dans son aide et dans ses messages d'erreur.
- **Les messages de refus nomment les cotes comme l'écran** et portent les chiffres. « Surface X » enverrait chercher un champ qui n'existe pas.
- **Une aide ne paraphrase pas son libellé.** « Entrez le nombre d'éléments » coûte un tap pour rien, et apprend à ne plus ouvrir les suivantes. Elle dit ce que le libellé ne dit pas, et la conséquence sur le résultat.

### En anglais

Anglais d'atelier américain, un seul mot par chose, comme en français :

| Français | Anglais |
|---|---|
| élément (Répartition, Calepinage) | piece |
| écart | gap |
| jeu (entre éléments, périphérique, entre façades) | gap |
| jeu par côté (glissière) | side clearance |
| entraxe | pitch |
| repère | mark |
| façade | front (drawer front dans la fiche de débit) |
| caisse | box |
| caisson | carcass (cabinet dans une phrase) |
| glissière | slide |
| axe de glissière | slide centerline |
| fiche de débit | cut list |

Les cotes restent en millimètres dans les deux langues : seuls le séparateur décimal (`l10n.number`) et les symboles impériaux (`in`, `ft`, `BF`) changent.

## Ponctuation : le tiret sépare, il ne relie pas

**Ni tiret cadratin ni point-virgule dans un texte explicatif** : corps et points d'un `FieldHelp`, message d'un refus (`calc…` dans les ARB), toute prose de plus d'une ligne. Le lecteur est debout et ne démêle pas une incise. Deux phrases, un deux-points ou une parenthèse.

Le tiret reste **là où il sépare visuellement** :

- libellés à deux étages : `Surface — largeur`, `Lamage — Ø × profondeur`
- notes de `ResultTile` et lignes `help` d'une ligne
- légendes de schéma : `Cotes en mm — Détails ×1,5`
- `kNoValue` et la puce des `FieldHelp.bullets`, qui sont des glyphes

Test : s'il pourrait être remplacé par un saut de ligne ou un `:`, il reste. S'il porte une incise au milieu d'une phrase, il part.

Cette règle vaut pour les textes lus dans l'app, dans les deux langues, pas pour les commentaires de code.

## Longueur des libellés : la mesure, pas l'œil

`AppSegmentedButton`, la valeur fermée d'un `DropdownMenu` et le sous-titre d'une carte d'accueil **tronquent en silence** (`overflow: ellipsis`).

- La police des widget tests donne à chaque glyphe la largeur de la taille de police : 11 caractères en `controlTextStyle` font 198 px, pour 164 disponibles dans un segment sur deux, sur un écran de 400 px. D'où un plafond de **9 caractères** dans un sélecteur à deux segments.
- C'est un **premier filtre**, pessimiste (environ le double d'une vraie police). Un libellé refusé peut être retenu après vérification **sur appareil**. Il est alors nommé dans `knownWiderThanTestFont` (`distribution_screen_test.dart`), qui l'épingle à l'envers : s'il se met à tenir, le test le signale. **Cette liste se vide, elle ne s'allonge pas.**
- Un libellé trop long sort du sélecteur : tuiles avec pictogramme (`ChoiceTiles`, dans `core/widgets`), ou dropdown (grandeurs du Convertisseur).
- Convertisseur, Répartition et Calepinage ont chacun un test qui vérifie qu'aucun libellé de sélecteur n'est tronqué sur un téléphone, **dans chaque langue**. Les résumés des Tiroirs se mesurent aussi en anglais.
