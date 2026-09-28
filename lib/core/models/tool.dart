/// Les outils de l'app. L'`id` sert de segment de route (`/tool/:id`).
///
/// L'ordre est celui de l'accueil : l'outil signature d'abord, le
/// convertisseur en dernier.
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
