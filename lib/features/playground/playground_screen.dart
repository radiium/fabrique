import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/widgets/app_segmented_button.dart';
import '../../core/widgets/labeled_field.dart';
import '../../core/widgets/number_field.dart';
import '../../core/widgets/result_tile.dart';
import 'playground_showcase.dart';

/// Page de référence, hors périmètre produit : inventaire des widgets Material
/// dont l'app a besoin, et de ceux qu'elle pourrait utiliser.
///
/// Sert à deux choses : vérifier d'un coup d'œil que le thème tient sur tous
/// les composants, et trancher un choix de contrôle avant de l'implémenter.
/// Accessible via `/playground`, exposée uniquement en debug depuis l'accueil.
///
/// Note : c'est le seul écran qui utilise `setState`. La règle « zéro setState »
/// vaut pour le flux de calcul des outils ; ici l'état est purement local et
/// jetable, un provider Riverpod n'aurait aucun sens.
class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  String _system = 'mm';
  String _unit = 'mm';
  String _offset = 'half';
  String? _material = 'softwood';
  bool _compound = true;
  double _value = 100;
  double _points = 3;
  double _gap = 2;
  double _sliderPoints = 3;
  String _chip = 'half';
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playground Material')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          children: [
            const ShowcaseSection(
              title: 'Saisie',
              subtitle: 'Nécessaires — tous les écrans-outils',
            ),
            ..._inputWidgets(),

            const ShowcaseSection(
              title: 'Actions & retours',
              subtitle: 'Nécessaires',
            ),
            ..._actionWidgets(),

            const ShowcaseSection(
              title: 'Structure & surfaces',
              subtitle: 'Nécessaires',
            ),
            ..._structureWidgets(),

            const ShowcaseSection(
              title: 'Visualisation',
              subtitle: 'Nécessaires — la vedette de chaque écran',
            ),
            ..._visualizationWidgets(),

            const ShowcaseSection(
              title: 'Candidats',
              subtitle: 'Pas encore utilisés — options retenues pour la suite',
            ),
            ..._candidateWidgets(),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  List<Widget> _inputWidgets() => [
    WidgetShowcase(
      name: 'LabeledField',
      usage:
          'Libellé statique au-dessus du contrôle, jamais flottant : il '
          'reste lisible pendant la saisie, à bout de bras. S\'applique à '
          'n\'importe quel contrôle, pas qu\'aux champs texte.',
      child: LabeledField(
        label: 'Décalage des joints',
        help: 'Visible surtout sur des éléments allongés (lames).',
        child: AppSegmentedButton<String>(
          segments: const [
            AppSegment(value: 'straight', label: 'Droit'),
            AppSegment(value: 'half', label: '½'),
            AppSegment(value: 'third', label: '⅓'),
          ],
          value: _offset,
          onChanged: (v) => setState(() => _offset = v),
        ),
      ),
    ),
    WidgetShowcase(
      name: 'TextFormField — via NumberField',
      usage:
          'Toute saisie chiffrée. Clavier numérique, gros texte, notifie à '
          'chaque frappe (calcul temps réel).',
      child: NumberField(
        label: 'Largeur totale',
        suffix: 'mm',
        value: _value,
        onChanged: (v) => setState(() => _value = v),
      ),
    ),
    WidgetShowcase(
      name: 'NumberField — avec pas − / +',
      usage:
          'Ajustement au pouce sans ouvrir le clavier. Appui maintenu pour '
          'défiler, boutons désactivés aux bornes. Idéal pour le nombre de '
          'points et les jeux.',
      child: Column(
        children: [
          NumberField(
            label: 'Nombre de points',
            value: _points,
            decimal: false,
            step: 1,
            min: 0,
            max: 24,
            onChanged: (v) => setState(() => _points = v),
          ),
          const SizedBox(height: AppSpacing.md),
          NumberField(
            label: 'Jeu entre éléments',
            suffix: 'mm',
            value: _gap,
            step: 0.5,
            max: 50,
            onChanged: (v) => setState(() => _gap = v),
          ),
        ],
      ),
    ),
    WidgetShowcase(
      name: 'AppSegmentedButton',
      usage:
          'Unité source du convertisseur · décalage des joints du '
          'calepinage (Droit · ½ · ⅓). Remplace SegmentedButton, qui ne sait '
          'pas dessiner la pastille arrondie posée dans la piste.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSegmentedButton<String>(
            segments: const [
              AppSegment(value: 'mm', label: 'Métrique'),
              AppSegment(value: 'in', label: 'Impérial'),
            ],
            value: _system,
            onChanged: (v) => setState(() => _system = v),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSegmentedButton<String>(
            segments: const [
              AppSegment(value: 'mm', label: 'mm'),
              AppSegment(value: 'cm', label: 'cm'),
              AppSegment(value: 'm', label: 'm'),
              AppSegment(value: 'in', label: 'po'),
            ],
            value: _unit,
            onChanged: (v) => setState(() => _unit = v),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSegmentedButton<String>(
            segments: const [
              AppSegment(value: 'straight', label: 'Droit'),
              AppSegment(value: 'half', label: '½'),
              AppSegment(value: 'third', label: '⅓'),
            ],
            value: _offset,
            onChanged: (v) => setState(() => _offset = v),
          ),
        ],
      ),
    ),
    WidgetShowcase(
      name: 'DropdownMenu',
      usage:
          'Matériau et Ø vis dans l\'outil avant-trous. Préféré au '
          'DropdownButton en Material 3.',
      child: LabeledField(
        label: 'Matériau',
        child: DropdownMenu<String>(
          initialSelection: _material,
          expandedInsets: EdgeInsets.zero,
          onSelected: (v) => setState(() => _material = v),
          dropdownMenuEntries: const [
            DropdownMenuEntry(value: 'softwood', label: 'Résineux'),
            DropdownMenuEntry(value: 'hardwood', label: 'Feuillu'),
            DropdownMenuEntry(value: 'chipboard', label: 'Aggloméré'),
            DropdownMenuEntry(value: 'plywood', label: 'Contreplaqué'),
          ],
        ),
      ),
    ),
    WidgetShowcase(
      name: 'Switch.adaptive',
      usage:
          'Impérial composé · inversion d\'orientation · retour haptique. '
          'La variante adaptive rend la bascule iOS native sur iOS.',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch.adaptive(
            value: _compound,
            onChanged: (v) => setState(() => _compound = v),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Text('Impérial composé'),
        ],
      ),
    ),
  ];

  List<Widget> _actionWidgets() => [
    WidgetShowcase(
      name: 'FilledButton / OutlinedButton / TextButton',
      usage:
          '« Mettre à zéro » du niveau. Hiérarchie d\'actions : une seule '
          'action pleine par écran.',
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.adjust_outlined),
            label: const Text('Mettre à zéro'),
          ),
          OutlinedButton(onPressed: () {}, child: const Text('Secondaire')),
          TextButton(onPressed: () {}, child: const Text('Tertiaire')),
        ],
      ),
    ),
    WidgetShowcase(
      name: 'IconButton',
      usage:
          'Accès aux réglages depuis l\'accueil. Cible tactile ≥ 48 px par '
          'défaut.',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Réglages',
          ),
          IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.copy_outlined),
          ),
        ],
      ),
    ),
    WidgetShowcase(
      name: 'SnackBar — via ScaffoldMessenger',
      usage: 'Confirmation « Copié » après un tap sur une tuile de résultat.',
      child: FilledButton.tonal(
        onPressed: () =>
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Copié'))),
        child: const Text('Déclencher'),
      ),
    ),
    const WidgetShowcase(
      name: 'CircularProgressIndicator.adaptive',
      usage: 'Chargement des réglages depuis shared_preferences.',
      child: SizedBox(
        height: 32,
        width: 32,
        child: CircularProgressIndicator.adaptive(),
      ),
    ),
  ];

  List<Widget> _structureWidgets() => [
    const WidgetShowcase(
      name: 'Card + InkWell — via ResultTile',
      usage:
          'Tuiles de résultat, copiables d\'un tap. Cartes blanches, coins '
          'arrondis doux, ombre légère.',
      child: ResultTile(
        label: 'Entraxe',
        value: '250,0 mm',
        note: 'Largeur ÷ (points + 1)',
      ),
    ),
    WidgetShowcase(
      name: 'ListTile / SwitchListTile.adaptive',
      usage: 'Écran Réglages — liste courte.',
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Thème'),
            trailing: const Text('Clair'),
            onTap: () {},
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Retour haptique'),
            value: _compound,
            onChanged: (v) => setState(() => _compound = v),
          ),
        ],
      ),
    ),
    WidgetShowcase(
      name: 'GridView — SliverGridDelegateWithMaxCrossAxisExtent',
      usage:
          'Grille d\'outils de l\'accueil : largeur de carte cible, pas un '
          'nombre fixe de colonnes (2 sur mobile, 3–4 en web large).',
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 160,
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          childAspectRatio: 1.6,
        ),
        children: [
          for (final icon in const [
            Icons.straighten_outlined,
            Icons.grid_on_outlined,
            Icons.architecture_outlined,
          ])
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.accent),
            ),
        ],
      ),
    ),
  ];

  List<Widget> _visualizationWidgets() => [
    const WidgetShowcase(
      name: 'CustomPaint',
      usage:
          'Le cœur visuel des 5 outils. Le painter peint, le core calcule : '
          'il consomme un résultat déjà produit.',
      child: SizedBox(
        height: 90,
        width: double.infinity,
        child: CustomPaint(painter: _SampleLayoutPainter()),
      ),
    ),
    WidgetShowcase(
      name: 'InteractiveViewer — via SchemaScreen',
      usage:
          'Zoom et déplacement au doigt sur le schéma agrandi. Les vignettes '
          'des écrans-outils ne zooment pas : elles ouvrent cette page. '
          'Pincez la zone ci-dessous.',
      child: SizedBox(
        height: 90,
        width: double.infinity,
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 6,
          child: const CustomPaint(painter: _SampleLayoutPainter()),
        ),
      ),
    ),
    const WidgetShowcase(
      name: 'Tooltip',
      usage: 'Expliciter une icône ou une valeur sans encombrer l\'écran.',
      child: Tooltip(
        message: 'Pièce à couper',
        child: Icon(Icons.info_outline, color: AppColors.cut),
      ),
    ),
  ];

  List<Widget> _candidateWidgets() => [
    WidgetShowcase(
      name: 'Slider',
      candidate: true,
      usage:
          'Ajuster le nombre de points ou un jeu sans ouvrir le clavier — '
          'utile en atelier, une seule main.',
      child: Slider(
        value: _sliderPoints,
        max: 12,
        divisions: 12,
        label: '${_sliderPoints.round()} points',
        onChanged: (v) => setState(() => _sliderPoints = v),
      ),
    ),
    WidgetShowcase(
      name: 'ChoiceChip',
      candidate: true,
      usage:
          'Alternative plus compacte au SegmentedButton quand les options '
          'dépassent 3–4 et doivent passer à la ligne.',
      child: Wrap(
        spacing: AppSpacing.sm,
        children: [
          for (final entry in const {
            'straight': 'Droit',
            'half': '½',
            'third': '⅓',
          }.entries)
            ChoiceChip(
              label: Text(entry.value),
              selected: _chip == entry.key,
              onSelected: (_) => setState(() => _chip = entry.key),
            ),
        ],
      ),
    ),
    const WidgetShowcase(
      name: 'ExpansionTile',
      candidate: true,
      usage:
          'Justification des avant-trous, ou schéma compact « extensible au '
          'tap » demandé sur mobile.',
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text('Pourquoi ce Ø ?'),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              'Résineux : avant-trou ≈ 0,55 × Ø nominal. Règle de l\'art '
              'indicative.',
            ),
          ),
        ],
      ),
    ),
    WidgetShowcase(
      name: 'showModalBottomSheet',
      candidate: true,
      usage:
          'Actions principales dans le pouce — répond directement à la '
          'contrainte « une seule main ».',
      child: FilledButton.tonal(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          builder: (_) => const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Text('Feuille d\'actions — atteignable au pouce'),
          ),
        ),
        child: const Text('Ouvrir'),
      ),
    ),
    WidgetShowcase(
      name: 'AlertDialog',
      candidate: true,
      usage:
          'Confirmer un calibrage du niveau, ou une réinitialisation de '
          'saisie.',
      child: FilledButton.tonal(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Mettre à zéro ?'),
            content: const Text(
              'Le calibrage actuel sera remplacé par la position courante.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Calibrer'),
              ),
            ],
          ),
        ),
        child: const Text('Ouvrir'),
      ),
    ),
    const WidgetShowcase(
      name: 'TabBar',
      candidate: true,
      usage:
          'Niveau : séparer « bulle » et « inclinomètre » dans un même '
          'écran, comme le prévoit la spec.',
      child: SizedBox(
        height: 48,
        width: double.infinity,
        child: DefaultTabController(
          length: 2,
          child: TabBar(
            tabs: [
              Tab(text: 'Bulle'),
              Tab(text: 'Inclinomètre'),
            ],
          ),
        ),
      ),
    ),
    WidgetShowcase(
      name: 'DataTable',
      candidate: true,
      usage:
          'Positions cumulées de la répartition, en chiffres tabulaires et '
          'copiables ligne à ligne.',
      child: DataTable(
        columnSpacing: AppSpacing.lg,
        columns: const [
          DataColumn(label: Text('Point')),
          DataColumn(label: Text('Position')),
        ],
        rows: const [
          DataRow(cells: [DataCell(Text('1')), DataCell(Text('250 mm'))]),
          DataRow(cells: [DataCell(Text('2')), DataCell(Text('500 mm'))]),
          DataRow(cells: [DataCell(Text('3')), DataCell(Text('750 mm'))]),
        ],
      ),
    ),
    const WidgetShowcase(
      name: 'LinearProgressIndicator',
      candidate: true,
      usage:
          'Rendre le % de perte du calepinage lisible d\'un coup d\'œil, en '
          'plus du chiffre.',
      child: SizedBox(
        width: double.infinity,
        child: LinearProgressIndicator(value: 0.045, color: AppColors.cut),
      ),
    ),
    const WidgetShowcase(
      name: 'Badge',
      candidate: true,
      usage:
          'Signaler le nombre de coupes directement sur la carte Calepinage '
          'de l\'accueil.',
      child: Badge(
        label: Text('11'),
        child: Icon(Icons.grid_on_outlined, size: 32),
      ),
    ),
    WidgetShowcase(
      name: 'FloatingActionButton',
      candidate: true,
      usage:
          'Action principale ancrée en bas, dans la zone du pouce. À peser '
          'contre une barre d\'actions, plus sobre.',
      child: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {},
        icon: const Icon(Icons.copy_all_outlined),
        label: const Text('Tout copier'),
      ),
    ),
    WidgetShowcase(
      name: 'NavigationBar',
      candidate: true,
      usage:
          'Si la navigation entre outils devient persistante plutôt que par '
          'retour à l\'accueil.',
      child: SizedBox(
        width: double.infinity,
        child: NavigationBar(
          selectedIndex: _navIndex,
          onDestinationSelected: (i) => setState(() => _navIndex = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.straighten_outlined),
              label: 'Convertir',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_on_outlined),
              label: 'Calepiner',
            ),
            NavigationDestination(
              icon: Icon(Icons.architecture_outlined),
              label: 'Niveau',
            ),
          ],
        ),
      ),
    ),
    WidgetShowcase(
      name: 'PopupMenuButton',
      candidate: true,
      usage:
          'Actions secondaires d\'un outil : tout copier, réinitialiser la '
          'saisie, partager.',
      child: PopupMenuButton<String>(
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'copy', child: Text('Tout copier')),
          PopupMenuItem(value: 'reset', child: Text('Réinitialiser')),
        ],
      ),
    ),
  ];
}

/// Échantillon de calepinage : 5 éléments pleins, 1 coupe en bout de rangée.
class _SampleLayoutPainter extends CustomPainter {
  const _SampleLayoutPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const count = 6;
    final gap = size.width * 0.01;
    final w = (size.width - gap * (count - 1)) / count;

    final fill = Paint()..color = AppColors.accent.withValues(alpha: 0.15);
    final cutFill = Paint()..color = AppColors.cut.withValues(alpha: 0.25);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = AppColors.accent;
    final cutStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = AppColors.cut;

    for (var i = 0; i < count; i++) {
      final isCut = i == count - 1;
      final rect = Rect.fromLTWH(
        i * (w + gap),
        0,
        isCut ? w * 0.55 : w,
        size.height,
      );
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(3));
      canvas
        ..drawRRect(rrect, isCut ? cutFill : fill)
        ..drawRRect(rrect, isCut ? cutStroke : stroke);
    }
  }

  @override
  bool shouldRepaint(_SampleLayoutPainter oldDelegate) => false;
}
