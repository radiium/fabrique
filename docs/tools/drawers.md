# Tiroirs

> **Maquette.** L'écran et le schéma existent, le calcul non : les résultats sont un exemple écrit à la main (`kDrawersPreview`), sans bandeau pour le dire. L'outil est exclu des tests transversaux jusqu'au branchement (voir [roadmap.md](../roadmap.md)).

« J'ai une ouverture de caisson. Qu'est-ce que je débite pour mes tiroirs et leurs façades, et où je visse les glissières ? »

| Couche | Fichiers |
|---|---|
| Calcul | `lib/core/calc/drawers.dart` (types et préréglages de glissière, pas encore de calcul) |
| Écran | `lib/features/drawers/` : `_screen`, `_controller`, `_help`, et ses composants `_front_heights` (bouton et feuille des hauteurs), `_cut_list` (fiche de débit) |
| Schéma | `_schema`, `_painter` (dont les pictogrammes d'assemblage et de fond) · `test/features/drawers/drawers_painter_test.dart` |

---

## Règles métier

- **Le caisson est une donnée d'entrée**, pas un résultat : on saisit son ouverture intérieure. Son débit est hors de l'outil.
- **Une ouverture, une colonne de N tiroirs** de même largeur et même profondeur. Avec des traverses entre les tiroirs, chacun a sa propre ouverture : un calcul par tiroir, avec N = 1.
- **Caisse bois et façade rapportée** : côtés, devant, dos, fond, plus la façade.
- **Une glissière est un jeu de paramètres, pas une marque** (`SlideSpec`) : jeu latéral par côté, réduction de longueur, longueurs nominales vendues, retrait de fond imposé. Trois préréglages et « Personnalisée », qui recopie une fiche fabricant.

  | Glissière | Jeu par côté | Longueur de caisse | Fond |
  |---|---|---|---|
  | À billes | 12,7 | nominale | libre |
  | Sous tiroir | 5 (largeur int. = ouverture − 42 avec des côtés de 16) | nominale − 10 | en retrait de 13, dos posé dessus |
  | Bois sur bois | 1 | profondeur utile | libre |
  | Personnalisée | saisi | nominale − saisie | libre |

  ⚠️ Les valeurs sous tiroir sont **indicatives** : elles varient d'une gamme à l'autre.
- **Longueur de glissière automatique** : la plus grande longueur nominale qui tient dans la profondeur utile (profondeur, moins l'épaisseur de façade en pose encastrée). On peut l'imposer.
- **Pose de la façade** : en applique, la façade recouvre le chant des flancs, et c'est l'**épaisseur du caisson** qui compte. Encastrée, elle entre dans l'ouverture et mange la profondeur, et c'est l'**épaisseur de façade** qui compte. Les deux épaisseurs restent toujours affichées, quelle que soit la pose : le schéma dessine le caisson et la façade dans les deux cas.
- **Hauteurs des façades** : égales par défaut. Une hauteur saisie devient fixe, et les façades non fixées se partagent le reste à parts égales. Changer le nombre de tiroirs garde les hauteurs fixées des tiroirs qui restent.
- **Assemblage** : seule compte la question de savoir quelles pièces courent d'un bout à l'autre (côtés, ou devant et dos). Queue d'aronde, tourillons ou vis ne changent pas les cotes.
- **Fond** : en rainure (profondeur de rainure, la largeur est l'épaisseur du fond), entre les côtés sans rainure (cotes intérieures de la caisse), ou sous la caisse. La feuillure revient au même calcul que la rainure : pas d'option pour elle. Une glissière sous tiroir impose le sien, et le choix se verrouille.
- **Une épaisseur pour les côtés, le devant et le dos**, une pour le fond.

---

## Calcul

À écrire. Points d'entrée prévus : `computeDrawers(DrawersInput)` → `DrawersResult` (façades, caisse, longueur de glissière, axes, fiche de débit). `slideSpecFor` existe déjà.

### Refus prévus

Ouverture trop étroite pour la glissière et les côtés · profondeur plus courte que la plus petite glissière · caisse trop basse · hauteurs fixées qui dépassent la hauteur · rainure plus profonde que l'épaisseur du côté.

---

## Écran

### Saisie

En **quatre groupes repliables**, chacun résumé sous son titre (voir [ui/tool-screen.md](../ui/tool-screen.md)). Seule l'ouverture est dépliée à l'arrivée : c'est ce qu'on vient de mesurer.

| Groupe | Contenu | Résumé par défaut |
|---|---|---|
| `Ouverture` | `Largeur intérieure` · `Hauteur intérieure`, puis `Profondeur intérieure` · `Épaisseur du caisson` : l'ordre dans lequel on mesure le caisson | `562 × 720 × 540 mm · caisson 19 mm` |
| `Tiroirs et façades` | `Nombre de tiroirs` · `Hauteurs`, pose de la façade (`Applique` · `Encastrée`), épaisseur de façade et jeu entre façades | `3 tiroirs · hauteurs égales · applique, façade 19 · jeu 3 mm` |
| `Glissière` | le type, ses jeux si `Personnalisée`, la longueur (sauf bois sur bois) | `À billes · longueur automatique` |
| `Caisse` | épaisseurs des côtés et du fond, assemblage, fond (et profondeur de rainure) | `côtés 15, fond 8 mm · côtés recouvrants · fond en rainure de 6 mm` |

- `Hauteurs` : le bouton dit l'état (`Égales` ou `Ajustées`) et ouvre une feuille basse, un champ par tiroir et `Remettre à égales`. Quand les hauteurs sont ajustées, le détail s'affiche sous la ligne.
- `Glissière` : une **liste déroulante**. Une grille de tuiles prenait une centaine de pixels pour un choix qu'on fait une fois, et en segments « Bois sur bois » et « Personnalisée » seraient tronqués. « Personnalisée » ajoute `Jeu par côté` et `Réduction de longueur` sous le menu, et le résumé les reprend.
- Le résumé de `Caisse` dit le fond **même imposé** par une glissière sous tiroir (`fond en retrait de 13 mm`) : c'est là qu'on chercherait pourquoi ses tuiles ont disparu.

**Assemblage et fond en tuiles pictogramme + texte** (`ChoiceTiles`), deux par ligne pour l'assemblage, trois pour le fond. « Devant et dos recouvrants » ne tient pas dans un segment, et le dessin (la caisse vue de dessus, la caisse en coupe) répond à la question mieux que le mot. Avec une glissière sous tiroir, les tuiles du fond laissent place à la valeur verrouillée : deux choix dont aucun ne s'applique ne se montrent pas.

**Défauts** (`kDrawersDefaults`) : un caisson de cuisine de 600 (562 × 720 × 540), trois tiroirs à billes, façades en applique, côtés de 15, fond de 8 en rainure de 6, caisson et façade de 19, jeu de 3.

### Résultats

- `Façades — largeur × hauteur`
- `Caisse — largeur × longueur`, hors tout, avec le jeu par côté
- `Longueur de glissière` (absente en bois sur bois)
- `Axes de glissière`, depuis le bas de l'ouverture : ce qu'on trace sur le flanc
- la fiche de débit, en deux colonnes : `Pièce` (`Côté ×6`) et `L × l × ép (mm)`. Cinq colonnes ne tiendraient pas sur un téléphone.

---

## Schéma

**Coupe de face** de la colonne et **coupe de dessus** d'un tiroir, côte à côte, **à la même échelle** : une profondeur tracée plus grande qu'une hauteur mentirait.

- Coupe de face : un plan vertical au milieu de la profondeur, vu vers l'avant. En coupe, le caisson, les côtés et le fond de chaque caisse (en rainure, entre les côtés ou dessous, tel que monté), et les glissières en gris : latérales dans le jeu, sous tiroir dans le retrait du fond. Derrière le plan, les façades en contour fin. Largeur de façade au-dessus, chaque hauteur de façade à droite.
- La hauteur de profil d'une glissière latérale (35 mm) et la largeur d'une glissière sous tiroir (30 mm) sont des ordres de grandeur pour la reconnaître, pas des cotes.
- Le résultat porte ce que la coupe demande : le bas de chaque caisse (`boxBottoms`) et la hauteur du fond au-dessus de ce bas (`bottomLift`).
- Coupe de dessus : flancs du caisson, glissières en gris dans le jeu, caisse et ses parois, façade devant. Largeur de caisse au-dessus, longueur à droite.

---

## Plan exporté

À faire : les deux vues dans la zone de dessin (côte à côte, elles tombent à peu près dans le 4/3), la fiche de débit dans la table du cartouche, et l'« indicatif » des glissières sous tiroir en note.

---

## Décidé / écarté

- **Pas de répartition progressive** des façades : égales, ou ajustées à la main.
- **Façade intégrée** (le devant du tiroir est la façade) : reportée.
- **Tiroirs à côtés métal** : si l'usage le demande. On n'y débite que le fond et le dos, selon une table propre à chaque fabricant.
- **Hors de l'outil** : débit du caisson, perçage des poignées, casiers intérieurs, optimisation du débit sur panneau.
