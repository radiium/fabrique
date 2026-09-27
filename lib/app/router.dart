import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/models/tool.dart';
import '../features/converter/converter_screen.dart';
import '../features/distribution/distribution_screen.dart';
import '../features/drawers/drawers_screen.dart';
import '../features/home/home_screen.dart';
import '../features/layout/layout_screen.dart';
import '../features/level/level_screen.dart';
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
          GoRoute(
            path: 'tool/:id',
            builder: (context, state) {
              final tool = Tool.fromId(state.pathParameters['id'] ?? '');
              return switch (tool) {
                Tool.converter => const ConverterScreen(),
                Tool.distribution => const DistributionScreen(),
                Tool.drawers => const DrawersScreen(),
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
                  return _RisingPage(
                    key: state.pageKey,
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

/// Durée de la montée d'une page, et de sa descente au retour.
const Duration _riseDuration = Duration(milliseconds: 300);

/// Une page qui monte du bas de l'écran, sur toutes les plateformes.
///
/// Le schéma s'ouvre depuis sa vignette et se referme pour y revenir : un
/// glissement latéral le lirait comme une étape de plus dans l'outil, pas
/// comme une vue posée par-dessus. `MaterialPage(fullscreenDialog: true)`
/// garderait la transition du thème, qui glisse.
class _RisingPage extends CustomTransitionPage<void> {
  _RisingPage({required super.child, super.key})
    : super(
        fullscreenDialog: true,
        transitionDuration: _riseDuration,
        reverseTransitionDuration: _riseDuration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeOutCubic)),
              ),
              child: child,
            ),
      );
}

class _UnknownToolScreen extends StatelessWidget {
  const _UnknownToolScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Outil inconnu')));
  }
}
