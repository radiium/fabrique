# Niveau

Niveau à bulle et inclinomètre, par l'accéléromètre. Aucune saisie.

- [Règles métier](#règles-métier)
- [Écran](#écran)
- [Schéma](#schéma)

## Règles métier

- **Seule la math vit dans `core/calc`.** Le flux capteur et son lissage restent dans le contrôleur : un filtre a une mémoire et dépend de la cadence, `computeTilt` reste une fonction pure d'une seule lecture.
- **Le calibrage « zéro » compte pour la crédibilité** : la précision dépend du capteur du téléphone.

## Écran

- **`Annuler` suit un zéro posé.** Sans retour au zéro absolu, un mauvais calibrage ne se rattraperait qu'en redémarrant l'app. Le zéro n'est pas persisté.
- **Capteur indisponible** (navigateur de bureau, émulateur, permission refusée) : on le dit, plutôt que de laisser une bulle figée au centre passer pour un niveau parfait.

## Schéma

- **Fiole circulaire plutôt que tubulaire** : l'inclinaison a deux axes, un tube n'en montrerait qu'un.
- **La bulle monte du côté haut**, comme dans un vrai niveau, pas comme une bille qui roule. La lecture se transpose à l'outil qu'on a déjà en main.
- **Pas de plan exporté** : un flux capteur figé n'est pas un plan.
