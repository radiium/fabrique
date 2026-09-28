# Interface

Les choix d'interface qui ne se lisent pas dans les widgets : surtout ce qui a été écarté, et pourquoi. Les règles communes (cibles de 48 px, tokens de thème, textes traduits) sont dans `CLAUDE.md`.

- [Écran d'un outil](#écran-dun-outil)
- [Saisie](#saisie)
- [Schéma](#schéma)
- [Retour haptique](#retour-haptique)

## Écran d'un outil

- **« Réinitialiser » dans l'`AppBar`, pas dans une barre basse.** Une barre fixe coûterait ~75 px sur chaque écran pour une action utilisée une fois par chantier. Le coin opposé au pouce rend l'appui délibéré.
- **Pas de confirmation ni de SnackBar « Annuler » au reset.** Les cotes viennent du mètre : un reset accidentel fait retaper ce qui se remesure à un mètre de là.
- **Exporter et partager au pied de la carte de résultats**, pas dans l'`AppBar` : on exporte après avoir lu ses résultats.
- **Un refus s'affiche dans la carte de saisie** (`ErrorBanner`), pas dans les résultats : sur mobile, ils sont sous le schéma, deux écrans plus bas que le champ fautif.

## Saisie

- **L'aide ⓘ s'ouvre en feuille basse.** Pas de dépliant en place : sur une ligne de deux champs, il ferait grandir la ligne sous un seul des deux. Pas de tooltip (appui long, indécouvrable) ni de popover (se ferme en visant à côté, et avec un gant ce tap atterrit sur un contrôle).
- **Jamais de ⓘ dans un `AppSwitchField`** : toute la ligne bascule, une cible d'aide posée là changerait le réglage une fois sur deux.
- **Un `FieldPair` réunit deux cotes du même objet**, jamais deux champs sans lien pour gagner de la place.
- **Un libellé trop long sort du sélecteur** (tuiles `ChoiceTiles`, ou dropdown) plutôt que d'être abrégé : un segment tronque en silence.
- **Groupes repliables sans pastille « modifié »** : avant d'exporter, on vérifie le schéma et les résultats, pas l'état des panneaux. **Sans fond teinté une fois ouverts** : `field` ne se distingue pas du fond de page, et une teinte plus marquée ferait une carte dans la carte.

## Schéma

- **La vignette ne zoome pas.** Un pincement dans une carte de 200 px, coincée entre deux zones de scroll, se déclenche de travers. Toute la carte ouvre la page plein écran : un bouton d'agrandissement se viserait.
- **La page plein écran est une page, pas une boîte de dialogue.** Le geste de retour la ferme, la rotation en paysage donne sa largeur au Calepinage, et le web y gagne une URL.
- **Les libellés ne se contre-pivotent pas** quand on fait pivoter le schéma : ils se redressent quand la main tourne le téléphone verrouillé en portrait, et c'est le geste visé.
- **Les cartes du Niveau et du Convertisseur ne sont pas tapables** : rien à aller chercher en plein écran. Pour le Niveau, une page par-dessus couperait en plus des yeux le flux du capteur.

## Retour haptique

`HapticsScope` descend le réglage depuis la racine.

- **Une portée, pas un paramètre** : chaque contrôle partagé est appelé une trentaine de fois, et un paramètre oublié une fois ferait vibrer un contrôle contre le réglage.
- **Pas Riverpod** : `core/widgets` reste du Flutter nu, montable dans un test sans `ProviderScope`.
- **Hors portée, ça vibre** : un câblage oublié vibre de trop, jamais ne reste muet.
