import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/haptics.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/labels.dart';
import '../converter/converter_schema.dart';
import '../distribution/distribution_plan.dart';
import '../drawers/drawers_plan.dart';
import '../layout/layout_plan.dart';
import '../level/level_schema.dart';

/// Réduction minimale du schéma, en fraction de la taille d'ajustement.
const double _minScale = 1 / 3;

/// Débord de cadrage infini, sans lequel `InteractiveViewer` plafonne la
/// réduction à la taille d'ajustement.
///
/// Le déplacement n'est plus borné : le bouton « ajuster » ramène le schéma.
const EdgeInsets _panBoundary = EdgeInsets.all(double.infinity);

/// Le schéma d'un outil, seul à l'écran, zoomable et déplaçable.
///
/// Une page, pour le geste retour et la rotation en paysage. Elle lit les
/// mêmes providers que l'écran de l'outil.
class SchemaScreen extends ConsumerStatefulWidget {
  const SchemaScreen({required this.tool, super.key});

  final Tool tool;

  @override
  ConsumerState<SchemaScreen> createState() => _SchemaScreenState();
}

class _SchemaScreenState extends ConsumerState<SchemaScreen> {
  /// Quarts de tour appliqués au schéma, dans le sens horaire.
  int _quarterTurns = 0;

  final TransformationController _view = TransformationController();

  /// Ramène le schéma à sa taille d'ajustement, centré.
  void _fit() => _view.value = Matrix4.identity();

  @override
  void dispose() {
    _view.dispose();
    super.dispose();
  }

  /// Pivote d'un quart de tour et remet la vue à plat.
  ///
  /// Pour un téléphone à rotation verrouillée. Ne pas contre-pivoter les
  /// libellés : ils seraient de travers dans ce seul cas utile.
  void _rotate() {
    hapticSelection(context);
    setState(() {
      _quarterTurns = (_quarterTurns + 1) % 4;
      _fit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Pas de `SchemaSheet` : la feuille est l'écran entier.
      backgroundColor: AppColors.cardSurface,
      appBar: AppBar(
        title: Text(widget.tool.label(AppLocalizations.of(context))),
        actions: [
          // Grisé tant que rien n'a bougé, jamais masqué : c'est le seul retour d'un
          // schéma poussé hors de l'écran.
          ValueListenableBuilder<Matrix4>(
            valueListenable: _view,
            builder: (context, view, child) => IconButton(
              icon: const Icon(Icons.fit_screen),
              tooltip: AppLocalizations.of(context).schemaFit,
              onPressed: view.isIdentity() ? null : _fit,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.rotate_90_degrees_cw),
            tooltip: AppLocalizations.of(context).schemaRotate,
            onPressed: _rotate,
          ),
          // L'export en dernier, après les réglages de vue.
          ..._exportActionsFor(widget.tool),
        ],
      ),
      body: InteractiveViewer(
        transformationController: _view,
        boundaryMargin: _panBoundary,
        minScale: _minScale,
        maxScale: 6,
        // `RotatedBox` pivote aussi les contraintes : le painter reçoit une boîte
        // haute au lieu d'être rogné.
        child: RotatedBox(
          quarterTurns: _quarterTurns,
          child: _schemaFor(widget.tool),
        ),
      ),
    );
  }
}

/// Le schéma de chaque outil. Ceux qui exportent montrent leur plan, l'image
/// même du fichier.
Widget _schemaFor(Tool tool) => switch (tool) {
  Tool.layout => const LayoutPlanView(),
  Tool.distribution => const DistributionPlanView(),
  Tool.drawers => const DrawersPlanView(),
  Tool.level => const LevelSchema(),
  Tool.converter => const ConverterSchema(),
};

/// L'export, pour les outils qui ont un plan : sans cartouche, un schéma ne
/// se lit pas hors de l'app.
List<Widget> _exportActionsFor(Tool tool) => switch (tool) {
  Tool.distribution => const [DistributionExportAction(compact: true)],
  Tool.layout => const [LayoutExportAction(compact: true)],
  Tool.drawers => const [DrawersExportAction(compact: true)],
  Tool.level || Tool.converter => const [],
};
