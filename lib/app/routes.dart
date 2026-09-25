import '../core/models/tool.dart';

/// Les chemins de l'app, construits en un seul endroit.
///
/// À part de `router.dart`, qui importe tous les écrans : un widget de `core/`
/// doit pouvoir construire un chemin sans tirer les features derrière lui.
/// `test/app/routes_test.dart` vérifie que chaque chemin mène bien à son écran.
abstract final class AppRoutes {
  static const String home = '/';
  static const String settings = '/settings';

  static String tool(Tool tool) => '/tool/${tool.id}';

  /// Le schéma d'un outil, empilé sur son écran.
  static String schema(Tool tool) => '${AppRoutes.tool(tool)}/schema';
}
