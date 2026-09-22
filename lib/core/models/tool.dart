/// Les 5 outils du MVP. L'`id` sert de segment de route (`/tool/:id`).
///
/// L'ordre est celui de l'accueil, et il pitche l'app : le calepinage ouvre la
/// liste parce que c'est l'outil signature, le convertisseur la ferme parce
/// que c'est un service qu'on ouvre en passant, pas une destination.
enum Tool {
  layout('layout', 'Calepinage', 'Pose sur surface, % de perte'),
  fasteners('fasteners', 'Avant-trous & vis', 'Perçage, lamage, longueur'),
  distribution('distribution', 'Répartition', 'Points équidistants'),
  level('level', 'Niveau', 'Bulle et inclinomètre'),
  converter('converter', 'Convertisseur', 'Longueur, volume, masse, pression');

  const Tool(this.id, this.label, this.subtitle);

  final String id;
  final String label;
  final String subtitle;

  static Tool? fromId(String id) {
    for (final tool in Tool.values) {
      if (tool.id == id) return tool;
    }
    return null;
  }
}
