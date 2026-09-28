import '../core/models/tool.dart';

/// Les chemins de l'app, construits en un seul endroit.
///
/// À part de `router.dart`, pour qu'un widget de `core/` construise un chemin
/// sans importer les features.
abstract final class AppRoutes {
  static const String home = '/';
  static const String settings = '/settings';

  static String tool(Tool tool) => '/tool/${tool.id}';

  /// Le schéma d'un outil, empilé sur son écran.
  static String schema(Tool tool) => '${AppRoutes.tool(tool)}/schema';
}
