/// Matériau de la pièce recevant la vis.
///
/// Nommé `MaterialKind` et non `Material` (spec) pour ne pas entrer en
/// collision avec le widget `Material` de Flutter côté UI.
enum MaterialKind { softwood, hardwood, chipboard, plywood }

/// Décalage du départ de chaque rangée en calepinage.
enum JointOffset { straight, half, third }

/// Libellés d'affichage. L'app est FR uniquement au lancement ; ces chaînes
/// rejoindront `app_fr.arb` le jour où une seconde langue arrive.
extension MaterialKindDisplay on MaterialKind {
  String get label => switch (this) {
    MaterialKind.softwood => 'Résineux',
    MaterialKind.hardwood => 'Feuillu',
    MaterialKind.chipboard => 'Aggloméré',
    MaterialKind.plywood => 'Contreplaqué',
  };
}

extension JointOffsetDisplay on JointOffset {
  /// Court : ces libellés tiennent dans un segment de sélecteur.
  String get label => switch (this) {
    JointOffset.straight => 'Droit',
    JointOffset.half => '½',
    JointOffset.third => '⅓',
  };
}
