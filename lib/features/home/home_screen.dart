import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../core/models/tool.dart';
import '../../l10n/app_localizations.dart';
import 'tool_card.dart';

/// Largeur minimale d'une tuile de la grille : en dessous, une colonne de moins.
const double _kMinTileWidth = 280;

/// Largeur maximale d'une tuile : la grille se centre au-delà.
const double _kMaxTileWidth = 360;

const int _kMaxColumns = 3;

/// Accueil : titre, bouton Réglages, cartes d'outils.
///
/// En colonne sur mobile, en grille au-delà de [kWideBreakpoint].
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            onPressed: () => context.go(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) =>
              constraints.maxWidth >= kWideBreakpoint
              ? const _ToolGrid()
              : const _ToolList(),
        ),
      ),
    );
  }
}

class _ToolList extends StatelessWidget {
  const _ToolList();

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const EdgeInsets.all(AppSpacing.md),
    itemCount: Tool.values.length,
    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
    itemBuilder: (context, i) => ToolCard(tool: Tool.values[i]),
  );
}

/// Grille de tuiles, rangée par rangée.
///
/// Pas de `GridView` : sa hauteur de cellule fixe couperait le texte agrandi.
/// Chaque rangée prend la hauteur de sa tuile la plus haute.
class _ToolGrid extends StatelessWidget {
  const _ToolGrid();

  static const double _maxWidth =
      _kMaxColumns * _kMaxTileWidth + (_kMaxColumns - 1) * AppSpacing.md;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.md),
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns =
                ((constraints.maxWidth + AppSpacing.md) /
                        (_kMinTileWidth + AppSpacing.md))
                    .floor()
                    .clamp(1, _kMaxColumns);
            const tools = Tool.values;
            return Column(
              children: [
                for (var start = 0; start < tools.length; start += columns) ...[
                  if (start > 0) const SizedBox(height: AppSpacing.md),
                  _ToolRow(
                    tools: tools.skip(start).take(columns).toList(),
                    columns: columns,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    ),
  );
}

/// Une rangée de la grille : la dernière garde ses cellules vides à droite,
/// pour que toutes les tuiles aient la même largeur.
class _ToolRow extends StatelessWidget {
  const _ToolRow({required this.tools, required this.columns});

  final List<Tool> tools;
  final int columns;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < columns; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          Expanded(
            child: i < tools.length
                ? ToolCard(tool: tools[i], isTile: true)
                : const SizedBox.shrink(),
          ),
        ],
      ],
    ),
  );
}
