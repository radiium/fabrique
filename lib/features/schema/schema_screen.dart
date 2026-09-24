import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/haptics.dart';
import '../converter/converter_schema.dart';
import '../distribution/distribution_plan.dart';
import '../fasteners/fasteners_schema.dart';
import '../layout/layout_plan.dart';
import '../level/level_schema.dart';

/// Jusqu'où le schéma se laisse réduire, en fraction de la taille d'ajustement.
///
/// Un tiers : assez pour reprendre d'un coup d'œil un schéma qu'on vient de
/// pivoter ou de parcourir au zoom, pas assez pour en faire une vignette
/// perdue au milieu du blanc.
const double _minScale = 1 / 3;

/// Débord de cadrage — sans lui, `InteractiveViewer` plafonne la réduction à
/// la taille d'ajustement.
///
/// Son plancher d'échelle vaut `viewport / cadre` : tant que le cadre est le
/// dessin lui-même, ce plancher est 1 et [_minScale] n'a jamais la parole. Un
/// débord infini le ramène à zéro et rend la main à [_minScale]. En échange,
/// le déplacement n'est plus borné non plus — d'où le bouton « ajuster », qui
/// est la seule façon de revenir d'un schéma poussé hors de l'écran.
const EdgeInsets _panBoundary = EdgeInsets.all(double.infinity);

/// Le schéma d'un outil, seul à l'écran, zoomable et déplaçable.
///
/// Une page et non une boîte de dialogue. Le geste de retour du système la
/// ferme, là où une croix se vise — et viser, avec un gant, c'est rater. La
/// rotation en paysage donne au Calepinage la largeur qui lui manque, ce
/// qu'une boîte de dialogue, contrainte par la page qui la porte, ne peut pas
/// offrir. Et sur le web, la page a une URL et un bouton « précédent ».
///
/// Le schéma reste vivant : il lit les mêmes providers que l'écran de l'outil,
/// donc une saisie modifiée avant l'ouverture s'y retrouve telle quelle.
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
  /// **Le bouton est là pour le téléphone dont la rotation est verrouillée.**
  /// Sans verrou, tourner l'appareil fait mieux : la barre suit et les cotes
  /// restent droites. Ici la chrome ne pivote pas, donc les chiffres partent à
  /// 90° et ne se redressent que si la main tourne aussi le téléphone — c'est
  /// le geste visé. Ne jamais « corriger » ça en contre-pivotant les libellés
  /// dans les painters : ils seraient alors de travers dans le seul cas où le
  /// bouton sert à quelque chose.
  ///
  /// Le zoom est remis à zéro avec la rotation : le dessin change de forme, et
  /// un déplacement hérité de l'orientation précédente laisserait l'écran sur
  /// une zone vide, sans rien dire de ce qui s'est passé.
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
      // La feuille est l'écran entier : ni rembourrage ni coin arrondi, donc
      // pas de `SchemaSheet` ici. Tout pixel rendu au dessin en est un de plus
      // à déplacer sous le doigt, et c'est pour ça qu'on est venu.
      backgroundColor: AppColors.cardSurface,
      appBar: AppBar(
        title: Text(widget.tool.label),
        actions: [
          // Grisé tant que rien n'a bougé, jamais masqué : c'est le seul
          // retour possible d'un schéma réduit ou poussé hors de l'écran, et
          // une chrome qui s'efface se cherche.
          ValueListenableBuilder<Matrix4>(
            valueListenable: _view,
            builder: (context, view, child) => IconButton(
              icon: const Icon(Icons.fit_screen),
              tooltip: 'Ajuster à l’écran',
              onPressed: view.isIdentity() ? null : _fit,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.rotate_90_degrees_cw),
            tooltip: 'Pivoter le schéma',
            onPressed: _rotate,
          ),
          // L'export en dernier : « ajuster » et « pivoter » règlent la vue,
          // celui-ci fait quelque chose de ce qu'on regarde.
          ..._exportActionsFor(widget.tool),
        ],
      ),
      body: InteractiveViewer(
        transformationController: _view,
        boundaryMargin: _panBoundary,
        minScale: _minScale,
        maxScale: 6,
        // `RotatedBox` et non `Transform.rotate` : il pivote aussi les
        // contraintes, donc un schéma large se redessine dans une boîte haute
        // au lieu d'y être posé en biais et rogné. Le painter n'a rien à
        // savoir de l'orientation, il reçoit une taille, c'est tout.
        child: RotatedBox(
          quarterTurns: _quarterTurns,
          child: _schemaFor(widget.tool),
        ),
      ),
    );
  }
}

/// Le schéma de chaque outil, en pleine densité — c'est la page qui a la place.
///
/// La Répartition et le Calepinage y montrent leur **plan** et non leur seul
/// schéma : la feuille A4, le dessin et le cartouche, c'est-à-dire exactement
/// l'image qu'exporte le bouton d'à côté. Un aperçu qui montrerait autre chose
/// que le fichier n'en serait pas un.
Widget _schemaFor(Tool tool) => switch (tool) {
  Tool.layout => const LayoutPlanView(),
  Tool.fasteners => const FastenersSchema(),
  Tool.distribution => const DistributionPlanView(),
  Tool.level => const LevelSchema(),
  Tool.converter => const ConverterSchema(),
};

/// L'export, pour les outils qui ont un plan. Les autres n'ont pas encore de
/// cartouche, et un schéma sans cartouche ne se lit pas une fois sorti de
/// l'app.
List<Widget> _exportActionsFor(Tool tool) => switch (tool) {
  Tool.distribution => const [DistributionExportAction(compact: true)],
  Tool.layout => const [LayoutExportAction(compact: true)],
  Tool.fasteners || Tool.level || Tool.converter => const [],
};
