# Principes UX

L'app se lit dans un atelier : debout, à bout de bras, en pleine lumière, parfois avec des gants, la scie qui tourne.

- **Fort contraste, gros texte, cibles ≥ 48 px.** Tout ce qui se saisit ou se choisit fait `kFieldHeight`.
- **Une main.** Ce qu'on fait des résultats (exporter, partager) se pose au pied de la carte de résultats, là où la lecture se termine. L'action à rendre difficile (« réinitialiser ») va dans le coin haut, loin du pouce.
- **Calcul en temps réel.** Pas de bouton « calculer » : résultats et schéma suivent la frappe.
- **Clavier numérique par défaut**, résultats **copiables** d'un tap.
- **Le schéma est la vedette**, sans place réservée au-dessus de la ligne de flottaison : un outil riche ne tient pas dans un écran. On le rapproche en repliant la saisie, pas en la limitant.
- **Viser, c'est rater.** Préférer une grande cible (une ligne entière, une carte entière) à un petit bouton. Préférer un geste qui se fait n'importe où (glisser pour fermer) à un geste qui se vise (une croix).
- **Rien ne disparaît.** Un contrôle sans effet s'éteint (grisé) au lieu de se masquer : une chrome qui s'efface se cherche. Exception : un contrôle qui n'a *aucun sens* dans le contexte (l'impérial composé pour une masse) est masqué.
- **Un refus se dit.** Quand une saisie est refusée pour une raison métier, l'écran affiche le motif, là où on peut le corriger.

## Plateformes

Android et Web. Pas d'iOS : sans équivalent de F-Droid, l'app n'y serait distribuable que par l'App Store. Pas de desktop dédié : le web est un mobile élargi, en deux colonnes au-delà de 800 px.

## Accueil et Réglages

- **Accueil** : titre, icône Réglages en haut à droite, grille de cartes d'outils (icône, nom, sous-titre d'une ligne). Le sous-titre tronque en silence au-delà d'environ 34 caractères.
- **Réglages** : le retour haptique et la langue (celle du téléphone, français ou anglais), plus le thème (clair), affiché verrouillé. La langue est une liste déroulante : « Langue du téléphone » ne tient pas dans un segment sur trois. Chaque langue s'y écrit dans sa propre langue, pour qu'on retrouve la sienne dans une app réglée dans une autre.
