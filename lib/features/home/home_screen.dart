import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/models/tool.dart';
import '../../l10n/app_localizations.dart';
import 'tool_card.dart';

/// Accueil : titre, bouton Réglages, liste de cartes d'outils.
///
/// Liste simple en colonne — une carte claire par outil, espacées de
/// [AppSpacing.md] ; jamais de grille.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          // Hors périmètre produit : n'apparaît qu'en debug.
          if (kDebugMode)
            IconButton(
              onPressed: () => context.go('/playground'),
              icon: const Icon(Icons.widgets_outlined),
              tooltip: 'Playground Material',
            ),
          IconButton(
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: Tool.values.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, i) => ToolCard(tool: Tool.values[i]),
        ),
      ),
    );
  }
}
