import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/models/tool.dart';
import '../features/converter/converter_screen.dart';
import '../features/distribution/distribution_screen.dart';
import '../features/fasteners/fasteners_screen.dart';
import '../features/home/home_screen.dart';
import '../features/layout/layout_screen.dart';
import '../features/level/level_screen.dart';
import '../features/playground/playground_screen.dart';
import '../features/schema/schema_screen.dart';
import '../features/settings/settings_screen.dart';
import 'routes.dart';

/// Navigation déclarative, deep-linking prêt pour le web : accueil, réglages,
/// et une route paramétrée par outil.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          // Page de référence, hors périmètre produit — cf. PlaygroundScreen.
          GoRoute(
            path: 'playground',
            builder: (context, state) => const PlaygroundScreen(),
          ),
          GoRoute(
            path: 'tool/:id',
            builder: (context, state) {
              final tool = Tool.fromId(state.pathParameters['id'] ?? '');
              return switch (tool) {
                Tool.converter => const ConverterScreen(),
                Tool.fasteners => const FastenersScreen(),
                Tool.distribution => const DistributionScreen(),
                Tool.layout => const LayoutScreen(),
                Tool.level => const LevelScreen(),
                null => const _UnknownToolScreen(),
              };
            },
            routes: [
              // Le schéma seul, par-dessus son outil. Empilé et non substitué :
              // on y entre pour regarder, on en sort par le geste de retour, et
              // la saisie reste derrière, intacte.
              GoRoute(
                path: 'schema',
                pageBuilder: (context, state) {
                  final tool = Tool.fromId(state.pathParameters['id'] ?? '');
                  return MaterialPage(
                    fullscreenDialog: true,
                    child: tool == null
                        ? const _UnknownToolScreen()
                        : SchemaScreen(tool: tool),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class _UnknownToolScreen extends StatelessWidget {
  const _UnknownToolScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Outil inconnu')));
  }
}
