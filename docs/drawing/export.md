# Exporter un plan

Le schéma d'un outil sort de l'app en **PNG**, sur une **A4 à l'italienne** portant son **cartouche** : le dessin, les valeurs que le dessin ne cote pas, et une table.

- `lib/core/export/plan.dart` : la feuille et le cartouche (`Plan`, `PlanTable`, `PlanPainter`). Générique, il reçoit des chaînes déjà formatées.
- `lib/core/export/plan_export.dart` : rendu PNG, enregistrement, partage.
- `lib/core/export/plan_export_action.dart` : les boutons « Exporter » et « Partager » (`PlanExportAction`), communs à tous les outils et sans Riverpod.
- `lib/features/<outil>/<outil>_plan.dart` : ce que le cartouche de l'outil écrit (`build<Outil>Plan`), la vue plein écran, et une enveloppe d'une quinzaine de lignes qui branche `PlanExportAction` sur les providers de l'outil.

Câblé pour la Répartition, le Calepinage et les Tiroirs. Le Niveau en est exclu : un flux capteur figé n'est pas un plan.

## La feuille

- **Le dessin seul ne s'exporte pas.** Les cotes vivent en partie dans les tuiles de résultat : parti sans elles, le dessin ferait deviner. Le cartouche est la convention du plan, il n'y a rien à expliquer à qui le reçoit.
- **L'aperçu est le fichier.** La page plein écran et l'export traversent le même `build<Outil>Plan`, au pixel près. Saisie refusée : pas de plan, la page retombe sur le schéma seul et l'export s'éteint.
- **Le painter se rejoue hors de l'arbre de widgets**, à 2339 px de large (A4 à 200 dpi). Capturer la page affichée rendrait la vignette à la résolution du téléphone de celui qui exporte. 200 et non 150 dpi : le corps 8,5 du cartouche descendrait sinon à 25 px.
- **Tout est coté dans une boîte de 594 × 420** (`kPlanWidth` × `kPlanHeight`), qu'une seule mise à l'échelle uniforme amène à la taille disponible. ⚠️ Ces deux valeurs fixent aussi les tailles de texte du cartouche, réglées à la mesure : y toucher rouvre la question du nombre de lignes qui tiennent.
- **Cartouche en colonne le long du bord droit**, pas en bandeau bas. Une liste veut de la hauteur, et la zone de dessin garde des proportions proches de celles des schémas. Un schéma plus large que 4/3 laissera du blanc au-dessus et en dessous.
- **Nom de fichier** : `fabrique-<outil>-<date>.png`. Un dossier de chantier en contient plusieurs.

## Le cartouche

- **Un tableau réglé, pas une liste de valeurs.** Encre noire franche, une case par champ, intitulé en petites capitales interlettrées dans le coin, valeur en gras dessous. Cadre à 1, refends à 0,5 : les deux épaisseurs du dessin. Il se lit comme n'importe quel cartouche, là où un panneau typographique se lirait comme une capture d'app.
- **La case de tête ne porte que le nom de l'outil.**
- **Il ne porte que ce que le dessin ne cote pas.** Réécrire une cote du schéma serait une redite, et chaque case gagnée est une ligne de table de plus.
- **Les hauteurs de case se dérivent** de `_lineHeight`, figé. Posées à l'œil, la valeur passait sous son intitulé, et ça ne se voit qu'au rendu.
- **La note est réservée avant tout le reste.** C'est là que va l'avertissement d'un outil : la seule ligne qu'on n'a pas le droit de perdre sous un débordement.

## La table

- **Elle change avec l'outil** : positions pour la Répartition, liste de débit pour le Calepinage, fiche de débit puis axes de glissière pour les Tiroirs. C'est elle qui rend le plan utile hors de l'app.
- **Plusieurs tables s'empilent**, la plus importante d'abord (`Plan.tables`). Chacune est en tout ou rien pour son compte : celle du dessous cède la première.
- **Tout ou rien.** Si elle ne tient pas, elle cède entièrement la place à une ligne de repli (`fallback`). Une liste tronquée sur un plan d'atelier, c'est une pièce en moins, et rien sur la feuille ne le dirait.
- ⚠️ **La première colonne est celle des numéros, étroite et fixe** (26 unités). Une cellule trop étroite ne tronque pas : elle **n'écrit rien**. Les comptes et les cotes vont donc dans les colonnes suivantes.
- L'unité va dans l'en-tête de colonne.

## Enregistrer et partager

Deux boutons en pied de la carte de résultats (`resultsFooter`), « Exporter » en premier. Sur la page plein écran, une seule action, l'enregistrement.

- **« Exporter » enregistre dans les photos** (`gal`), en un tap, sans dialogue. **« Partager »** ouvre la feuille du système.
- **Pourquoi deux boutons** : le sélecteur de partage d'Android ne liste que des applications, sans action « enregistrer ». Sans le premier bouton, on ne pourrait pas simplement garder son plan.
- **Pourquoi les photos** : c'est le seul endroit que tout le monde sait rouvrir, d'où le téléphone sait déjà imprimer et envoyer, et un petit paquet suffit à y écrire. Qui veut ranger ailleurs passe par « Partager ».
- **Sans album**, ni droit de lecture : une app de bricolage n'a rien à faire à lire les photos de qui que ce soit. `WRITE_EXTERNAL_STORAGE` est déclaré avec `maxSdkVersion="29"` : au-delà, rien n'est demandé.
- **Le SnackBar porte « Voir »** (`Gal.open`) : un enregistrement invérifiable envoie chercher hors de l'app. La galerie s'ouvre sur son dernier élément, qui vient d'être écrit.
- ⚠️ **`SnackBar` pose `persist = action != null` par défaut** : un SnackBar avec action ne se ferme jamais seul. Celui-ci force `persist: false`.
- **Sur le web, « Exporter » télécharge** (`plan_download_web.dart`, import conditionnel sur `dart.library.js_interop`, souche qui lève ailleurs). L'API Web Share ne prend les fichiers que sur quelques navigateurs. Deux pièges : le lien doit être **dans** le document avant le clic (Firefox), et l'URL objet ne se libère pas tout de suite (Safari abandonne le téléchargement).
- **Dans le pied de carte, pas dans l'`AppBar`** : on exporte après avoir lu ses résultats.
- **Tout s'éteint sur une saisie refusée, rien ne disparaît.**

## Écarté

- **PDF.** N'apporterait que l'impression, que le PNG assure déjà, pour une dépendance de plus et un dessin qui resterait rastérisé (pas de pont entre un `Canvas` et la toile du paquet `pdf`).
- **Dossier au choix, ou mémorisé dans les Réglages.** *Écarté après chiffrage.* Une boîte « enregistrer sous » coûte trois taps par export. Un chemin mémorisé demanderait une autorisation d'arbre persistante (SAF, `saf_util`, `android_intent_plus`, écriture par `DocumentsContract`), plus un réglage et des cas d'erreur (dossier supprimé, autorisation révoquée).
- **Ouvrir le fichier exact depuis « Voir ».** Demanderait `saver_gallery` et `open_filex`, deux dépendances pour un tap de moins : la galerie s'ouvre déjà sur le plan qui vient d'être écrit.
