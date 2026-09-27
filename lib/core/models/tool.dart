/// Les outils de l'app. L'`id` sert de segment de route (`/tool/:id`).
///
/// L'ordre est celui de l'accueil, et il pitche l'app : le calepinage ouvre la
/// liste parce que c'est l'outil signature, le convertisseur la ferme parce
/// que c'est un service qu'on ouvre en passant, pas une destination.
enum Tool {
  layout('layout'),
  distribution('distribution'),
  drawers('drawers'),
  level('level'),
  converter('converter');

  const Tool(this.id);

  final String id;

  static Tool? fromId(String id) {
    for (final tool in Tool.values) {
      if (tool.id == id) return tool;
    }
    return null;
  }
}
