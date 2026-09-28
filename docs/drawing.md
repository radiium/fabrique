# Dessin et plan exporté

Les règles de tracé sont portées par les primitives de `lib/core/painting.dart` et leur dartdoc. Ce fichier garde le parti du plan exporté et ce qui a été écarté.

- [Schémas](#schémas)
- [Plan exporté](#plan-exporté)
- [Enregistrer et partager](#enregistrer-et-partager)
- [Écarté](#écarté)

## Schémas

- **Les schémas cotés suivent le dessin technique** : Répartition, Calepinage, Tiroirs. Le Convertisseur et le Niveau ne sont pas des plans.
- **Une coupe se dessine en deux passes : tous les aplats, puis tous les contours**, sur des pièces qui ne se chevauchent jamais. Le trait est centré sur l'arête : dessinées pièce par pièce, l'aplat de la suivante mangerait la moitié du contour de la précédente.
- **L'unité est déclarée une fois, sous le dessin.** Répétée sur chaque cote, elle laisserait croire que les autres se lisent autrement.

## Plan exporté

Le schéma sort en **PNG**, sur une **A4 à l'italienne** portant son **cartouche** et une table. Câblé pour la Répartition, le Calepinage et les Tiroirs. Le Niveau en est exclu : un flux capteur figé n'est pas un plan.

- **Le dessin seul ne s'exporte pas.** Une partie des cotes vit dans les tuiles de résultat : parti sans elles, le dessin ferait deviner.
- **L'aperçu est le fichier.** La page plein écran et l'export traversent le même `build<Outil>Plan`.
- **Le painter se rejoue hors de l'arbre de widgets**, à 200 dpi. Capturer la page affichée rendrait le plan à la résolution du téléphone de celui qui exporte.
- **Cartouche en colonne le long du bord droit**, pas en bandeau bas : une liste veut de la hauteur, et la zone de dessin garde des proportions proches de celles des schémas.
- **Le cartouche ne porte que ce que le dessin ne cote pas.** Chaque case gagnée est une ligne de table de plus.
- **Une table en tout ou rien.** Si elle ne tient pas, elle cède la place à une ligne de repli. Une liste tronquée sur un plan d'atelier, c'est une pièce en moins, et rien sur la feuille ne le dirait.

## Enregistrer et partager

- **Deux boutons** : le sélecteur de partage d'Android ne liste que des applications, sans action « enregistrer ». Sans « Exporter », on ne pourrait pas simplement garder son plan.
- **« Exporter » enregistre dans les photos**, en un tap : c'est le seul endroit que tout le monde sait rouvrir, d'où le téléphone sait déjà imprimer et envoyer. Qui veut ranger ailleurs passe par « Partager ».
- **Sans droit de lecture** sur les photos : une app de bricolage n'a rien à y lire.
- **Sur le web, « Exporter » télécharge** : l'API Web Share ne prend les fichiers que sur quelques navigateurs.

## Écarté

- **PDF.** N'apporterait que l'impression, que le PNG assure déjà, pour une dépendance de plus et un dessin qui resterait rastérisé. Une hypothèse multipage reste dans [roadmap.md](roadmap.md).
- **Dossier au choix, ou mémorisé dans les Réglages.** Une boîte « enregistrer sous » coûte trois taps par export. Un chemin mémorisé demanderait une autorisation d'arbre persistante (SAF), un réglage et des cas d'erreur (dossier supprimé, autorisation révoquée).
- **Ouvrir le fichier exact depuis « Voir ».** Deux dépendances pour un tap de moins : la galerie s'ouvre déjà sur le plan qui vient d'être écrit.
- **Un chiffre de cote dans un pavé qui perce la ligne.** Sur un peigne de cotes, il troue tous les étages : le chiffre se pose au-dessus d'une ligne continue.
- **Une troisième épaisseur de trait.** Elle ne se distinguerait plus : contour et cotation, dans le rapport 1:2.
