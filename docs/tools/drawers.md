# Tiroirs

« J'ai une ouverture de caisson. Qu'est-ce que je débite pour mes tiroirs et leurs façades, et où je visse les glissières ? »

- [Règles métier](#règles-métier)
- [Glissières](#glissières)
- [Calcul](#calcul)
- [Écran](#écran)
- [Schéma](#schéma)
- [Plan exporté](#plan-exporté)
- [Décidé / écarté](#décidé--écarté)

## Règles métier

- **Le caisson est une donnée d'entrée**, pas un résultat : on saisit son ouverture intérieure, la cote que demande la glissière. Son débit est hors de l'outil.
- **Une ouverture, une colonne de N tiroirs** de même largeur et même profondeur. Avec des traverses entre les tiroirs, chacun a sa propre ouverture : un calcul par tiroir, avec N = 1.
- **Caisse bois et façade rapportée** : côtés, devant, dos, fond, plus la façade.
- **Pose de la façade** : en applique, la façade recouvre le chant des flancs, et c'est l'**épaisseur du caisson** qui compte. Encastrée, elle entre dans l'ouverture et mange la profondeur, et c'est l'**épaisseur de façade** qui compte. Les deux restent toujours saisissables : le schéma dessine le caisson et la façade dans les deux cas.
- **Hauteurs des façades** : égales par défaut. Une hauteur saisie devient fixe, et les façades non fixées se partagent le reste. Changer le nombre de tiroirs garde les hauteurs fixées des tiroirs qui restent.
- **Assemblage** : seule compte la question de savoir quelles pièces courent d'un bout à l'autre (côtés, ou devant et dos). Queue d'aronde, tourillons ou vis ne changent pas les cotes.
- **Fond** : en rainure, entre les côtés, ou sous la caisse. La feuillure revient au même calcul que la rainure : pas d'option pour elle.

## Glissières

**Une glissière est un jeu de paramètres, pas une marque** : jeu latéral par côté, réduction de longueur, longueurs nominales vendues, retrait de fond imposé. Trois préréglages et « Personnalisée », qui recopie une fiche fabricant.

| Glissière | Jeu par côté | Longueur de caisse | Fond | Axe tracé sur le flanc |
|---|---|---|---|---|
| À billes | 12,7 | nominale | libre | milieu de la caisse |
| Sous tiroir | 5 | nominale − 10 | en retrait de 13, dos posé dessus | dessous de la glissière, au bas de la caisse |
| Bois sur bois | 1 | profondeur utile | libre | dessus du coulisseau, au bas de la caisse |
| Personnalisée | saisi | nominale − saisie | libre | milieu de la caisse |

- Les valeurs sous tiroir sont **indicatives** : elles varient d'une gamme à l'autre. Le plan le note.
- **Longueur automatique** : la plus grande longueur nominale qui tient dans la profondeur utile. On peut l'imposer.
- **Une glissière sous tiroir impose son fond**, et le choix se verrouille.

## Calcul

- **Façades.** En applique, la colonne couvre le caisson d'un bord à l'autre, chants compris, et le jeu n'est qu'entre deux façades. Encastrée, un jeu tout autour.
- **Compartiment.** Chaque tiroir a la part de l'ouverture derrière sa façade, coupée au milieu du jeu entre deux façades. En applique, le tiroir du milieu a donc un compartiment plus haut que ceux des bouts, qui perdent le recouvrement du caisson.
- **Caisse.** La plus haute qui tient dans le compartiment, moins les dégagements de la glissière dessous et dessus. En bois sur bois, le dégagement du dessus est le coulisseau du tiroir du dessus.
- **Fiche de débit.** Les pièces identiques sont regroupées, et des tiroirs de hauteurs différentes donnent plusieurs lignes. Le fil du fond court d'un côté à l'autre.

## Écran

- **La glissière se choisit en liste déroulante.** Une grille de tuiles prenait une centaine de pixels pour un choix qu'on fait une fois, et en segments « Bois sur bois » et « Personnalisée » seraient tronqués.
- **Assemblage et fond en tuiles pictogramme + texte.** « Devant et dos recouvrants » ne tient pas dans un segment, et le dessin répond à la question mieux que le mot. Avec une glissière sous tiroir, les tuiles du fond laissent place à la valeur verrouillée : deux choix dont aucun ne s'applique ne se montrent pas.
- **Le résumé de `Caisse` dit le fond même imposé** : c'est là qu'on chercherait pourquoi ses tuiles ont disparu.
- **La fiche de débit tient en deux colonnes**, pièce et cotes : cinq ne tiendraient pas sur un téléphone. Un tap la copie pour un tableur.

## Schéma

**Coupe de face** de la colonne et **coupe de dessus** d'un tiroir, côte à côte, **à la même échelle** : une profondeur tracée plus grande qu'une hauteur mentirait.

- **Le caisson hors tout est coté** en plus de la saisie intérieure : une épaisseur de panneau mesurée à côté ne s'y reporterait pas. Pas de profondeur hors tout : elle dépend de la pose du dos.
- **Le profil d'une glissière est un ordre de grandeur** pour la reconnaître, pas une cote.
- **Une glissière sous tiroir n'apparaît pas en coupe de dessus** : elle est cachée sous le fond.
- **Le cœur rend les coupes toutes faites**, pièces qui ne se chevauchent jamais : en rainure, le côté est entaillé à la place exacte du fond.

## Plan exporté

- **Deux tables, la fiche de débit d'abord**, puis les axes de glissière. Avec beaucoup de tiroirs de hauteurs différentes, la fiche remplit le cartouche et les axes passent à leur repli.
- **L'épaisseur des pièces va dans les cases**, pas dans la fiche : une cinquième colonne ne laisserait plus la place d'écrire `203.67`.

## Décidé / écarté

- **Pas de répartition progressive** des façades : égales, ou ajustées à la main.
- **Façade intégrée** (le devant du tiroir est la façade) : reportée.
- **Tiroirs à côtés métal** : si l'usage le demande. On n'y débite que le fond et le dos, selon une table propre à chaque fabricant.
- **Hors de l'outil** : débit du caisson, perçage des poignées, casiers intérieurs, optimisation du débit sur panneau.
