import '../../core/calc/layout.dart';
import '../../core/models/enums.dart';
import '../../l10n/app_localizations.dart';

/// La famille d'un produit, qui le nomme.
enum LayoutMaterial {
  drywall,
  tile,
  flooring,
  decking,
  panel;

  String label(AppLocalizations l10n) => switch (this) {
    LayoutMaterial.drywall => l10n.layoutMaterialDrywall,
    LayoutMaterial.tile => l10n.layoutMaterialTile,
    LayoutMaterial.flooring => l10n.layoutMaterialFlooring,
    LayoutMaterial.decking => l10n.layoutMaterialDecking,
    LayoutMaterial.panel => l10n.layoutMaterialPanel,
  };
}

/// Un produit courant et les règles de pose qui vont avec.
///
/// Pré-remplit une saisie sans changer le calcul, d'où sa place hors de
/// `core/calc`.
class LayoutPreset {
  const LayoutPreset({
    required this.material,
    required this.size,
    required this.elementX,
    required this.elementY,
    required this.perimeterGap,
    required this.offset,
    this.gapAlong = 0,
    this.gapAcross = 0,
  });

  final LayoutMaterial material;

  /// Le format du fournisseur, pas forcément dans l'ordre des champs.
  final String size;

  /// Court : la valeur fermée d'un `DropdownMenu` tronque en silence.
  String label(AppLocalizations l10n) => '${material.label(l10n)} $size';

  final double elementX;
  final double elementY;

  /// Jeu en bout, le long de l'élément, traduit en jeu d'écran selon
  /// l'inversion.
  final double gapAlong;

  /// Jeu entre lames, en travers de l'élément.
  final double gapAcross;

  final double perimeterGap;
  final JointOffset offset;

  /// La saisie que ce preset produit, sans toucher à la surface, qui vient de
  /// la pièce.
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
  /// Le sélecteur en dérive : rien de plus à persister.
  bool matches(LayoutInput input) => applyTo(input) == input;
}

/// Les six produits retenus : chacun porte au moins une règle hors défaut.
///
/// Le bardage à clin est exclu : son recouvrement demanderait un jeu négatif.
const List<LayoutPreset> kLayoutPresets = [
  LayoutPreset(
    material: LayoutMaterial.drywall,
    size: '1200×2500',
    elementX: 1200,
    elementY: 2500,
    perimeterGap: 0,
    offset: JointOffset.straight,
  ),
  LayoutPreset(
    material: LayoutMaterial.tile,
    size: '600×600',
    elementX: 600,
    elementY: 600,
    gapAlong: 2,
    gapAcross: 2,
    perimeterGap: 5,
    offset: JointOffset.straight,
  ),
  // Au-delà de ~60 cm, le demi-décalage fait tuiler le carreau : tiers.
  LayoutPreset(
    material: LayoutMaterial.tile,
    size: '600×1200',
    elementX: 1200,
    elementY: 600,
    gapAlong: 2,
    gapAcross: 2,
    perimeterGap: 5,
    offset: JointOffset.third,
  ),
  LayoutPreset(
    material: LayoutMaterial.flooring,
    size: '1285×192',
    elementX: 1285,
    elementY: 192,
    perimeterGap: 10,
    offset: JointOffset.third,
  ),
  LayoutPreset(
    material: LayoutMaterial.decking,
    size: '4000×145',
    elementX: 4000,
    elementY: 145,
    gapAlong: 3,
    gapAcross: 5,
    perimeterGap: 10,
    offset: JointOffset.straight,
  ),
  LayoutPreset(
    material: LayoutMaterial.panel,
    size: '2500×1250',
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
