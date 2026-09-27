/// Décalage du départ de chaque rangée en calepinage.
enum JointOffset { straight, half, third }

/// Libellés d'affichage. L'app est FR uniquement au lancement ; ces chaînes
/// rejoindront `app_fr.arb` le jour où une seconde langue arrive.
extension JointOffsetDisplay on JointOffset {
  /// Court : ces libellés tiennent dans un segment de sélecteur.
  String get label => switch (this) {
    JointOffset.straight => 'Droit',
    JointOffset.half => '½',
    JointOffset.third => '⅓',
  };
}
