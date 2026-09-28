# Répartition

Répartir des éléments identiques sur une largeur : barreaudage, lames, étagères, axes de perçage.

- [Règles métier](#règles-métier)
- [Mode inverse](#mode-inverse)
- [Écran](#écran)
- [Schéma](#schéma)
- [Plan exporté](#plan-exporté)
- [Décidé / écarté](#décidé--écarté)

## Règles métier

- **Vocabulaire** : la cote totale est la **largeur**, les bandes réservées aux extrémités sont des **marges**. Jamais « longueur » ni « décalage » (réservé au Calepinage). Les champs `length`, `startOffset` et `endOffset` gardent leur nom de code : les renommer changerait les clés JSON persistées.
- **On répartit des éléments de largeur.** Les points purs sont le cas `elementWidth = 0`.
- **Le nombre de jeux découle des bords** :

  | Bords | Jeux |
  |---|---|
  | Écart – Écart | `N + 1` |
  | Élément – Élément | `N − 1` |
  | mixte | `N` |

- **Une disposition impose un minimum** : un élément par bord occupé.
- **Les marges sont retirées de la largeur avant le calcul.** Elles réservent un chant, un tasseau existant.
- **On reporte l'entraxe**, pas le jeu. Le centre donne l'axe de perçage.
- **Le nombre est borné à 500 dans les deux modes.** Un écart de 0,001 saisi par mégarde produirait sinon un million de positions.

## Mode inverse

Écart voulu, on cherche le nombre : on résout `utile = N × largeur + (N + c) × écart` en N, avec `c = 1 − (bords occupés)`. On évalue les deux entiers qui encadrent le N fractionnaire, et le meilleur est le plus proche de la cible. **Pas de réglage d'arrondi** : on rend les deux bornes. Une cible exacte ne rend qu'une réponse, une borne irréalisable est écartée.

L'écran propose la borne **écartée** dans un encart. Qui a un maximum à ne pas dépasser (un barreaudage à 110 mm) veut la plus serrée, et le cœur ne connaît que la distance à la cible. **L'adopter fait passer en « Calcul écart »** avec ce nombre : recopier l'écart obtenu reposerait la même question, sans fin.

## Écran

- **`Mode de calcul` se nomme par ce qu'on cherche** : `Calcul écart` · `Calcul nombre`.
- **Les quatre dispositions en tuiles pictogramme + texte.** En segments, « Élément – Élément » serait tronqué, et le dessin distingue « Écart – Élément » de « Élément – Écart » mieux que la phrase.
- **Repasser en marges symétriques réaligne la fin sur le début**, sinon le schéma mentirait.
- **Le résumé des bords dit la disposition** : elle change le nombre de jeux, donc l'écart. Repliée sans résumé, elle cacherait la raison d'un écart inattendu.
- **Changer de mode n'efface pas la valeur de l'autre** : la saisie porte à la fois le nombre et l'écart visé.

## Schéma

**Une vue d'ensemble ne peut pas coter ce qu'elle montre** : sur 1800 mm, une marge de 40 fait deux pixels. Le schéma a donc trois bandes : la pièce entière avec sa **seule cote totale**, puis deux panneaux `Début` et `Fin` agrandis, chacun terminé par un trait de rupture.

- **Agrandissement rond et écrit** (`Détails ×1,5`), pour que la cote se lise sans calcul.
- **Trois étages de cote fixes** : marge, élément, écart, présents ou non. Attribués au fil des cotes, ils remonteraient d'un cran dès qu'on remet une marge à zéro.
- **Proportions** : les panneaux couvrent 83 % de la largeur de la vue d'ensemble (sinon deux bouts se lisent aussi longs que la pièce), et leur barre est deux fois plus épaisse (sinon le détail se lit comme un étirement).
- **Une seule grammaire** : des rectangles à l'échelle, qu'une largeur nulle réduit à un trait. Basculer vers des disques ferait sauter le dessin à chaque passage par zéro.
- **Marges hachurées** : la zone existe, rien n'y est réparti.

## Plan exporté

- **L'écart souhaité a sa case**, bien que le dessin cote l'écart : il ne porte que l'écart obtenu, et sans la cible rien n'explique le nombre trouvé.
- **La table est celle des positions depuis l'origine** : bord et centre, ou position seule pour des repères.

## Décidé / écarté

- **Pas de réglage d'arrondi en mode inverse** : on rend les deux bornes.
- **Pas de numérotation des éléments sur le schéma** : elle se tassait exactement là où la table devient utile.
- **Reporté : répartition avec trait de scie**, et à entraxe imposé (voir [roadmap.md](../roadmap.md)).
