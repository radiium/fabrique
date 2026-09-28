# Convertisseur

Une valeur, convertie dans toutes les unités de sa grandeur à la fois.

- [Règles métier](#règles-métier)
- [Écran](#écran)
- [Schéma](#schéma)

## Règles métier

- **Le tri des unités fait la valeur de l'outil.** Une unité n'entre que si on la croise sur un chantier **et** qu'elle est pénible sans outil. Sans ce tri, l'écran redevient un convertisseur générique, que le téléphone fait déjà mieux.
  - D'où le **pied-planche** (`pmp`, 144 po³), l'unité d'achat du bois dur, absente des convertisseurs génériques.
  - D'où **aucun préfixe SI pur** (mg, dL, hPa…) : un décalage de virgule se fait de tête.
- **Cinq unités au plus par grandeur**, symboles courts : c'est ce que tient un `AppSegmentedButton` sur un téléphone.
- **On ne convertit jamais d'une grandeur à l'autre.**

| Grandeur | Unités |
|---|---|
| Longueur | mm · cm · m · po · pi |
| Surface | mm² · cm² · m² · po² · pi² |
| Volume | cm³ · L · m³ · po³ · pmp |
| Masse | g · kg · t · oz · lb |
| Pression | bar · kPa · MPa · PSI |

Les pivots de calcul (mm³, Pa…) ne sont pas proposés quand personne ne s'en sert : on ne commande pas du bois en mm³.

## Écran

- **La grandeur se choisit en premier**, en dropdown : elle commande tout le reste, et « Pression » ne tient pas dans un segment.
- **Changer de grandeur garde la valeur** : on convertit souvent le même nombre d'une grandeur à l'autre.
- **La grandeur se déduit de l'unité**, elle n'est pas stockée : deux champs pourraient se contredire.
- **L'impérial composé ne concerne que les longueurs** : masqué ailleurs plutôt que grisé, puisqu'il n'y aurait aucun sens.

## Schéma

- **Longueur : double règle**, métrique en haut, impérial en bas, **à la même échelle physique**. Un curseur les traverse d'un seul trait : une position, deux lectures.
- **Autres grandeurs : comparaison à un repère rond** (1 m², 1 L, 1 kg, 1 bar). Carrés pour une surface, cubes pour un volume (un facteur 1000 ne fait que 10 sur l'arête), barres pour ce qui n'a pas de forme.
- **Pas de plan exporté** : toutes les valeurs sont dans les tuiles, et une conversion ne part pas à l'atelier.
- **La carte n'est pas tapable** : les painters règlent seuls leur densité, le plein écran n'aurait rien de plus à montrer.
- **Pas de visu plus riche hors longueur** pour l'instant : voir [roadmap.md](../roadmap.md).
