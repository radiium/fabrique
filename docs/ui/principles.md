# Principes UX

L'app se lit dans un atelier : debout, à bout de bras, en pleine lumière, parfois avec des gants, la scie qui tourne.

- **Fort contraste, gros texte, cibles ≥ 48 px.** Tout ce qui se saisit ou se choisit fait `kFieldHeight`.
- **Une main.** Actions principales en bas, dans le pouce. L'action à rendre difficile (« réinitialiser ») va dans le coin opposé.
- **Calcul en temps réel.** Pas de bouton « calculer » : résultats et schéma suivent la frappe.
- **Clavier numérique par défaut**, résultats **copiables** d'un tap.
- **Le schéma est la vedette** et ne passe jamais sous la ligne de flottaison sur mobile.
- **Viser, c'est rater.** Préférer une grande cible (une ligne entière, une carte entière) à un petit bouton. Préférer un geste qui se fait n'importe où (glisser pour fermer) à un geste qui se vise (une croix).
- **Rien ne disparaît.** Un contrôle sans effet s'éteint (grisé) au lieu de se masquer : une chrome qui s'efface se cherche. Exception : un contrôle qui n'a *aucun sens* dans le contexte (l'impérial composé pour une masse) est masqué.
- **Un refus se dit.** Quand une saisie est refusée pour une raison métier, l'écran affiche le motif, là où on peut le corriger.

## Plateformes

iOS, Android et Web. Pas de desktop dédié : le web est un mobile élargi, en deux colonnes au-delà de 800 px.

## Accueil et Réglages

- **Accueil** : titre, icône Réglages en haut à droite, grille de cartes d'outils (icône, nom, sous-titre d'une ligne). Le sous-titre tronque en silence au-delà d'environ 34 caractères.
- **Réglages** : le retour haptique (le seul réglable), plus le thème (clair) et la langue (FR), affichés verrouillés.
