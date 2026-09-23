import '../../core/calc/layout.dart';
import '../../core/models/enums.dart';

/// Un produit courant et les règles de pose qui vont avec.
///
/// Un preset **pré-remplit** une saisie, il ne branche aucun calcul : le
/// calepinage est le même pour du carrelage et pour une plaque de plâtre, et
/// c'est ce qui autorise un outil unique. Il vit donc ici, côté feature, et
/// jamais dans `core/calc` — contrairement à la table des Avant-trous, que le
/// calcul applique.
class LayoutPreset {
  const LayoutPreset({
    required this.label,
    required this.elementX,
    required this.elementY,
    required this.perimeterGap,
    required this.offset,
    this.gapAlong = 0,
    this.gapAcross = 0,
  });

  /// Court : la valeur fermée d'un `DropdownMenu` tronque en silence.
  final String label;

  final double elementX;
  final double elementY;

  /// Jeu en bout, le long de l'élément. Se traduit en jeu d'écran au moment du
  /// remplissage, selon l'inversion en cours.
  final double gapAlong;

  /// Jeu entre lames, en travers de l'élément.
  final double gapAcross;

  final double perimeterGap;
  final JointOffset offset;

  /// La saisie que ce preset produit, sans toucher à la surface.
  ///
  /// La surface vient de la pièce et n'appartient pas au matériau — c'est
  /// aussi ce qui fixe la place du sélecteur dans le formulaire, au-dessus de
  /// tout ce qu'il remplit et en dessous de ce qu'il laisse tranquille.
  LayoutInput applyTo(LayoutInput input) => input.copyWith(
    elementX: elementX,
    elementY: elementY,
    gapX: input.flip ? gapAcross : gapAlong,
    gapY: input.flip ? gapAlong : gapAcross,
    perimeterGap: perimeterGap,
    offset: offset,
  );

  /// La saisie courante est exactement celle de ce preset.
  ///
  /// C'est ce qui rend la valeur du sélecteur **dérivée** : rien de neuf à
  /// persister, et aucune dérive possible entre le formulaire restauré au
  /// lancement et ce que le sélecteur affiche.
  bool matches(LayoutInput input) => applyTo(input) == input;
}

/// Les six produits retenus.
///
/// Une entrée n'entre que si elle porte **au moins une règle hors défaut** :
/// celle qui ne transporterait qu'un format remplit deux champs qu'on tape en
/// quatre secondes, et allonge une liste qu'on relit à chaque ouverture. Même
/// tri que les unités du Convertisseur.
///
/// Ce qui a été écarté à ce titre : les autres longueurs de plaque, les quatre
/// autres formats de carreau, le parquet contrecollé, les deux autres lames de
/// terrasse et la dalle de faux plafond, dont toutes les règles valent le
/// défaut. Un format absent se tape par-dessus le preset le plus proche, qui
/// garde ses jeux et son décalage.
///
/// Le bardage à clin n'y est pas et ne peut pas y être : un clin se recouvre,
/// donc son jeu serait négatif et la zone de recouvrement se compterait deux
/// fois. Seule la claire-voie est représentable.
const List<LayoutPreset> kLayoutPresets = [
  LayoutPreset(
    label: 'Placo 1200×2500',
    elementX: 1200,
    elementY: 2500,
    perimeterGap: 0,
    offset: JointOffset.straight,
  ),
  LayoutPreset(
    label: 'Carrelage 600×600',
    elementX: 600,
    elementY: 600,
    gapAlong: 2,
    gapAcross: 2,
    perimeterGap: 5,
    offset: JointOffset.straight,
  ),
  // Au-delà de ~60 cm de long côté, le demi-décalage fait tuiler le milieu du
  // carreau : la règle passe au tiers. C'est le seul produit doublé de la
  // table, et c'est ce qui le justifie.
  LayoutPreset(
    label: 'Carrelage 600×1200',
    elementX: 1200,
    elementY: 600,
    gapAlong: 2,
    gapAcross: 2,
    perimeterGap: 5,
    offset: JointOffset.third,
  ),
  LayoutPreset(
    label: 'Parquet 1285×192',
    elementX: 1285,
    elementY: 192,
    perimeterGap: 10,
    offset: JointOffset.third,
  ),
  LayoutPreset(
    label: 'Terrasse 4000×145',
    elementX: 4000,
    elementY: 145,
    gapAlong: 3,
    gapAcross: 5,
    perimeterGap: 10,
    offset: JointOffset.straight,
  ),
  LayoutPreset(
    label: 'Panneau 2500×1250',
    elementX: 2500,
    elementY: 1250,
    gapAlong: 1,
    gapAcross: 1,
    perimeterGap: 10,
    offset: JointOffset.half,
  ),
];

/// Le preset qui correspond à la saisie courante, ou `null` — « Personnalisé ».
LayoutPreset? matchLayoutPreset(LayoutInput input) {
  for (final preset in kLayoutPresets) {
    if (preset.matches(input)) return preset;
  }
  return null;
}
