# Vignette et plein écran

`SchemaCard` (`lib/core/widgets/schema_card.dart`) porte le schéma sur l'écran de l'outil. `SchemaScreen` (`/tool/:id/schema`) le montre seul, zoomable. Les deux passent par le même `*_schema.dart`.

## La vignette

- **Ne fait que montrer.** Pas de zoom : un pincement dans une carte de 200 px, coincée entre deux zones de scroll, se déclenche de travers.
- **Toute la carte est la cible du tap.** Un bouton d'agrandissement se viserait, et viser avec un gant, c'est rater.
- **L'indice ⤢ en bas à droite** dit que la carte est tapable : sans lui, un schéma ressemble à une image. En bas, parce que c'est le coin que les cotes laissent libre.
- **Une feuille blanche dans une carte teintée** (`SchemaSheet`) : la teinte n'est plus qu'un encadrement.
- **Paramètre `compact`** : fait tomber les annotations secondaires, déjà reprises dans les tuiles juste en dessous. Seuls le Calepinage (les deux cotes de surface) et les Avant-trous (les trois Ø et la colonne de hauteurs) en ont un. Les autres n'ont rien à faire tomber.
- Le **Niveau** est le seul outil dont la carte n'est pas tapable : sa bulle n'a pas de détail à aller chercher, et une page par-dessus couperait des yeux le flux du capteur.

## La page plein écran

- **Une page, pas une boîte de dialogue.** Le geste de retour la ferme, la rotation en paysage donne sa largeur au Calepinage, et le web y gagne une URL.
- **Elle monte du bas**, sur toutes les plateformes, et redescend au retour : c'est une vue posée sur l'outil, pas une étape de plus. `MaterialPage(fullscreenDialog: true)` ne le fait que sur iOS.
- **La feuille est l'écran entier** : ni rembourrage ni coin arrondi autour de la zone déplaçable.
- **Répartition et Calepinage y montrent leur plan** (feuille A4 et cartouche), c'est-à-dire exactement ce qu'exporte le bouton voisin. Voir [export.md](export.md).
- **Le schéma reste vivant** : mêmes providers que l'écran de l'outil.

### Zoom

- **Réduction jusqu'au tiers** de l'ajustement (`_minScale`), agrandissement jusqu'à ×6.
- ⚠️ `InteractiveViewer` plafonne la réduction à `viewport / cadre`. Tant que le cadre est le dessin, ce plancher vaut 1 et `minScale` n'a jamais la parole. D'où un `boundaryMargin` infini, qui rend la main à `minScale` mais débride aussi le déplacement. Rien dans le code ne montre ce plancher : un test fait un vrai pincement.
- **« Ajuster à l'écran » est donc le seul retour** d'un schéma réduit ou poussé hors cadre. Grisé tant que rien n'a bougé, jamais masqué.

### Pivoter

Un bouton dans l'`AppBar`, pour le **téléphone verrouillé en portrait**. Sans verrou, tourner l'appareil fait mieux.

- `RotatedBox` et non `Transform.rotate` : il pivote les contraintes, donc le painter redessine dans la nouvelle boîte au lieu d'y être posé en biais. Le zoom est remis à plat.
- ⚠️ **Les libellés partent à 90° et doivent y rester.** Ils se redressent quand la main tourne le téléphone, et c'est tout le geste visé. Les contre-pivoter dans les painters les mettrait de travers dans le seul cas où le bouton sert.

### Barre d'actions

Ajuster · Pivoter · Exporter (seulement pour les outils qui ont un plan). L'export vient en dernier : les deux premiers règlent la vue, le troisième fait quelque chose de ce qu'on regarde.
