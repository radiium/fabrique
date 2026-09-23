/// Les 5 outils du MVP. L'`id` sert de segment de route (`/tool/:id`).
///
/// L'ordre est celui de l'accueil, et il pitche l'app : le calepinage ouvre la
/// liste parce que c'est l'outil signature, le convertisseur la ferme parce
/// que c'est un service qu'on ouvre en passant, pas une destination.
enum Tool {
  layout('layout', 'Calepinage', 'Pose sur surface, % de perte'),
  fasteners('fasteners', 'Avant-trous & vis', 'Perçage, lamage, longueur'),
  distribution('distribution', 'Répartition', 'Écart ou nombre d’éléments'),
  level('level', 'Niveau', 'Bulle et inclinomètre'),
  converter('converter', 'Convertisseur', 'Cinq grandeurs, unités d’atelier');

  const Tool(this.id, this.label, this.subtitle);

  final String id;
  final String label;

  /// Une ligne de gloss sous le nom, sur la carte d'accueil.
  ///
  /// Rendu sur une seule ligne, tronqué en silence : à 14 px il reste environ
  /// 250 px sur un écran de 400, soit ~34 caractères. Une énumération de cinq
  /// termes n'y tient pas — d'où le sous-titre du convertisseur, qui nomme le
  /// tri des unités plutôt que les grandeurs une à une.
  final String subtitle;

  static Tool? fromId(String id) {
    for (final tool in Tool.values) {
      if (tool.id == id) return tool;
    }
    return null;
  }
}
