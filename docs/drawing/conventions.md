# Conventions de dessin

Les schémas suivent le dessin technique. Primitives partagées dans `lib/core/painting.dart` : sans elles, chaque painter recopierait sa version et les schémas cesseraient de se ressembler.

Ce qui suit vaut pour les schémas cotés : Répartition, Calepinage, Tiroirs, Avant-trous. Le Convertisseur et le Niveau ne sont pas des plans, et leur texte reste dans le gris des libellés (défaut de `schemaText`).

## La feuille

Les schémas se dessinent sur une **feuille blanche** (`SchemaSheet`). Donc **la matière se dessine en `AppColors.field` et le vide en blanc** (surface découverte, perçage, fiole). Une pièce blanche sur une feuille blanche ne tiendrait que par son filet.

## Deux épaisseurs, une encre

- **`kOutlineStroke` (1) pour un contour vu, `kDimStroke` (0,5) pour toute la cotation** : trait de cote, flèche, attache, rupture, hachure. C'est **le rapport 1:2** qui porte la hiérarchie : les deux bougent ensemble. Deux groupes, pas trois : un troisième ne se distinguerait plus.
- **`kSchemaInk` (noir franc)** pour les contours et la cotation. C'est l'encre, pas l'épaisseur, qui tient le contraste : un trait fin et noir se lit mieux à bout de bras qu'un trait gras et gris.
- **Gris (`kExtensionLine`) pour les attaches et les hachures**, qui accompagnent sans concurrencer. Opaque, pas transparent : un gris par transparence noircirait à chaque recouvrement.
- **Le contour dit seul où la pièce s'arrête.** Pas de tiret d'extrémité en doublon.
- **Une coupe se dessine en deux passes : tous les aplats, puis tous les contours.** Le trait est centré sur l'arête : deux pièces assemblées la partagent, et leurs traits se confondent en un seul. Dessinées pièce par pièce, l'aplat de la suivante mangerait la moitié du contour de la précédente. La quincaillerie (aplat gris) passe avec les aplats, et prend le même contour que la matière : sans lui, son bout s'arrêterait au milieu du trait de la pièce voisine. Les Tiroirs, le Calepinage et la Répartition suivent cette règle, pas encore les Avant-trous.
- **Donc des pièces qui ne se chevauchent jamais.** Chacune a sa forme réelle, calculée par le cœur : un côté de tiroir est entaillé par la rainure du fond, pas recouvert par lui. Un test d'invariant le vérifie.
- ⚠️ **Un clip posé pile sur une arête en emporte la moitié extérieure** (le filet est centré dessus). Détourer une épaisseur de contour plus loin, sinon le coin se lit comme deux rectangles décalés.

## Cotes

- **Le chiffre se pose au-dessus d'une ligne de cote continue** (`drawDimensionLabel`). Un pavé détouré qui perce la ligne est une habitude de diagramme, et sur un peigne de cotes il troue tous les étages. Posé au-dessus, le chiffre ne peut pas rogner une flèche : il ne se mesure que contre l'espace coté.
- ⚠️ Un chiffre au-dessus a besoin de **sa hauteur au-dessus de la ligne**. C'est ce qui fixe les marges hautes des schémas.
- **Cote serrée** (`drawHDimension(tight: true)`) : flèches retournées vers l'extérieur, chiffre sorti de l'espace mesuré du côté `labelSide`, recalé dans `bounds`. Convention du dessin technique pour les petites cotes, au lieu de taire la cote.
- **Un bout de cote porte un tiret ou une flèche, jamais les deux** (`ticks:`). Là où une attache arrive, le tiret n'ajoute rien. Les cotes sans attache (les Ø des Avant-trous) le gardent.
- **Une attache part à `kExtensionGap` de la matière et traverse sa ligne de cote de `kExtensionOvershoot`.** C'est ce dépassement qui marque le point coté.
- **Cote verticale** : le chiffre se pose à côté, jamais pivoté.
- **Flèches pleines et courtes** (trapèze, pas triangle) : une pointe qui s'affine à zéro n'a plus d'encre au bout.

## Unité

**Déclarée une fois, sous le dessin** (`kUnitNote` = `Cotes en mm`). Tous les chiffres restent nus. Répétée sur chaque cote, elle alourdit le chiffre et laisse croire que les autres se lisent autrement. Exception : le `Ø`, qui est un symbole de cote.

## Libellés détourés

`drawSchemaLabel` pose un texte sur un pavé de la couleur de la feuille. Seules les deux règles du Convertisseur s'en servent, par-dessus leurs graduations. ⚠️ La couleur du détourage et celle de `SchemaSheet` doivent bouger ensemble.

## Espace objet / espace papier

`SchemaViewport` est le seul passage entre les millimètres de la pièce et la feuille : une place (`rect`), un millimètre d'origine, une échelle. Ce qui se lit (chiffres, flèches, épaisseurs) reste en unités de feuille. Un schéma peut ainsi porter deux échelles (vue d'ensemble et détail) sans que l'une impose sa réduction à l'autre.

## Mise à l'échelle

**Échelle uniforme, toujours.** Un calepinage ou une coupe déformée ne veut rien dire.

Un schéma à texte fixe se dessine dans une **boîte de référence** qu'une seule mise à l'échelle amène à la taille disponible, centrée. Sans ça, la largeur suit le canvas et la hauteur suit les chiffres : le dessin s'étire à chaque redimensionnement (flagrant sur le web). C'est le cas de la Répartition et du plan exporté.

## Ruptures

`schemaBreakPoints` rend les sommets du zigzag, `drawBreakLine` le trace. La matière se **détoure par la même ligne brisée**, sinon elle déborde des dents et le trait ne coupe rien.

## Saisie refusée

`drawSchemaPlaceholder` pose le tiret de `kNoValue` au centre. Une carte vide passerait pour un bug.
