# Niveau

Niveau à bulle en tube, par l'accéléromètre, téléphone posé sur une tranche comme un niveau de maçon. Aucune saisie : la carte du haut ne porte que le calibrage.

- [Règles métier](#règles-métier)
- [Poses](#poses)
- [Pente](#pente)
- [Calibrage](#calibrage)
- [Écran](#écran)
- [Schéma](#schéma)
- [Écarté](#écarté)

## Règles métier

- **Seule la math vit dans `core/calc`.** Le flux capteur et son lissage restent dans le contrôleur : un filtre a une mémoire et dépend de la cadence, `computeTilt` reste une fonction pure d'une seule lecture.
- **Le calibrage compte pour la crédibilité** : la précision dépend du capteur du téléphone, et l'écran affiche la pente au dixième de mm/m.

## Poses

- **Sur la tranche dès que la gravité est à plus de 45° de l'axe de l'écran.** En deçà, le téléphone est à plat et rien ne se mesure. Les deux usages sont loin de cette frontière : pas d'hystérésis.
- **Un seul angle**, dans le plan de l'écran, rapporté au quart de tour le plus proche. Poser le téléphone sur sa grande tranche ou le tenir debout contre un montant, c'est la même mesure : si le bas est de niveau, les côtés sont d'aplomb.
- **Debout, on parle d'aplomb ; couché sur une grande tranche, de niveau.** Seuls les mots changent.

## Pente

- **En mm/m, à côté de l'angle** : l'unité de l'atelier. Un menuisier cale au millimètre, il ne raisonne pas en degrés, et la cale d'une pièce se déduit de tête (4 mm/m sur 2,40 m, 10 mm environ).
- **Sans signe, le côté dans la note** : « Caler sous l'extrémité gauche », ou, debout, « Le haut penche à gauche ». Un signe moins obligerait à se souvenir de la convention.
- **Au dixième**, pour une valeur qui suit le capteur : plus fin, le chiffre sauterait sans rien apprendre.

## Calibrage

- **Par retournement.** Deux mesures, la seconde après un demi-tour sur place : la pente de la surface change de signe, le biais non. Leur moyenne est le biais. Aucune surface de niveau n'est nécessaire, c'est ce qui rend le geste faisable en atelier. Le biais d'une coque ou d'une tranche arrondie, constant, s'annule de la même façon.
- **Un biais par tranche.** Il dépend de l'axe du capteur qui porte la gravité, et de la tranche qui touche.
- **Persisté, propre au téléphone** : c'est un réglage de l'appareil, pas une saisie. On l'efface depuis l'assistant.
- **Une mesure immobile** attend 1 s (la main quitte le téléphone, le lissage se stabilise) puis fait la moyenne sur 1 s. Une lecture qui s'écarte de plus de 0,3° de la moyenne fait refuser la mesure : un appui qui bouge le téléphone fausserait tout.
- **Un biais de plus de 3° est refusé.** Un accéléromètre de téléphone dérive de quelques dixièmes. Au-delà, le téléphone n'a pas été retourné sur la même marque.
- **L'assistant est une feuille basse sur le Niveau**, pas une page : le verrou portrait reste en place, et on retrouve le tube en la fermant.
- **L'état « Calibré / Non calibré » s'affiche pour la tranche en cours.**

## Écran

- **Verrouillé en portrait.** Posé sur la tranche, le téléphone ferait pivoter l'écran au moment même de la mesure. Le dessin se redresse seul.
- **Capteur indisponible** (navigateur de bureau, émulateur, permission refusée) : on le dit, plutôt que de laisser une bulle figée au centre passer pour un niveau parfait. Un navigateur sans capteur n'émet rien et ne lève rien : faute de première lecture après 2 s, le capteur est déclaré muet.
- **À plat, des tirets dans les tuiles** et la consigne dans le dessin : le téléphone y passe beaucoup de temps entre deux mesures, l'écran ne doit pas faire croire à une lecture.
- **Pas de tuile « État »** : le dessin le dit déjà, en couleur, sous le tube.
- **Pas de « Réinitialiser »** : il n'y a aucune saisie à rendre.

## Schéma

- **La bulle monte du côté haut**, comme dans un vrai niveau, pas comme une bille qui roule. La lecture se transpose à l'outil qu'on a déjà en main.
- **Échelle resserrée** : `a / (|a| + 2°)`. En linéaire sur ±10°, le seuil de 0,5° ne ferait que 3 px sur un téléphone ; ici il prend un cinquième de la course, et aucun angle ne sort du tube.
- **Les repères de la cible sont le seuil** : bulle entièrement entre eux, et seulement alors, de niveau. Les graduations suivent la même règle.
- **Le dessin tourne d'un quart de tour** avec la tranche posée, pour se lire dans le sens du monde. La carte est carrée pour qu'il y tienne dans les quatre sens.
- **Pas de plan exporté** : un flux capteur figé n'est pas un plan.

## Écarté

- **La mesure à plat (fiole ronde, deux axes).** La surépaisseur de l'appareil photo fausse l'assise du dos, et l'usage d'atelier passe par la tranche.
- **La référence** (mesurer par rapport à une surface choisie plutôt qu'à l'horizontale). Usage marginal, et un second geste de calibrage à ne pas confondre avec le vrai.
- **La longueur de la pièce, pour une cale en mm.** À 1000 mm par défaut, elle répétait la pente en mm/m. Utile seulement retapée à chaque pièce, ce qu'on ne fait pas à l'atelier, pour un champ qui repoussait le tube vers le bas de l'écran.
