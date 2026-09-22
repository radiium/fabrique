import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/calc/distribution.dart';
import '../../core/format.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/app_disclosure.dart';
import '../../core/widgets/app_segmented_button.dart';
import '../../core/widgets/labeled_field.dart';
import '../../core/widgets/number_field.dart';
import '../../core/widgets/result_tile.dart';
import '../../core/widgets/tool_scaffold.dart';
import '../../core/widgets/zoomable_canvas.dart';
import 'distribution_controller.dart';
import 'distribution_form.dart';
import 'distribution_help.dart';
import 'distribution_painter.dart';

class DistributionScreen extends ConsumerWidget {
  const DistributionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(distributionFormProvider);
    final outcome = ref.watch(distributionResultProvider);
    final form = ref.read(distributionFormProvider.notifier);

    final ready = outcome is DistributionReady ? outcome : null;
    final result = ready?.best;

    return ToolScaffold(
      title: Tool.distribution.label,
      onReset: form.reset,
      canReset: input != kDistributionDefaults,
      input: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: 'Mode de calcul',
            about: kAboutMode,
            child: AppSegmentedButton<DistributionMode>(
              segments: [
                for (final mode in DistributionMode.values)
                  AppSegment(value: mode, label: mode.label),
              ],
              value: input.mode,
              onChanged: form.setMode,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Les deux cotes de la géométrie vont par paire, sans boutons − / + :
          // à cette largeur, une paire de champs à pas serait illisible.
          _Pair(
            first: NumberField(
              label: 'Largeur totale',
              suffix: 'mm',
              about: kAboutLength,
              value: input.length,
              onChanged: form.setLength,
            ),
            second: NumberField(
              label: 'Largeur d’un élément',
              suffix: 'mm',
              help: '0 = points sans épaisseur',
              about: kAboutElementWidth,
              value: input.elementWidth,
              onChanged: form.setElementWidth,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Le champ qui reste est celui que l'on connaît : le mode ne change
          // pas seulement le résultat, il échange la saisie et la réponse.
          if (input.mode == DistributionMode.spacing)
            NumberField(
              label: 'Nombre d’éléments',
              about: kAboutCount,
              value: input.count.toDouble(),
              onChanged: (v) => form.setCount(v.round()),
              decimal: false,
              step: 1,
              min: minDistributionCount(
                input.startEdge,
                input.endEdge,
              ).toDouble(),
              max: kMaxDistributionCount.toDouble(),
            )
          else
            NumberField(
              label: 'Écart souhaité',
              suffix: 'mm',
              help: 'Le nombre d’éléments s’ajuste au plus proche.',
              about: kAboutTargetSpacing,
              value: input.targetSpacing,
              onChanged: form.setTargetSpacing,
              step: 5,
            ),
          // Le refus s'affiche là où on peut le corriger. Sur mobile, les
          // résultats sont sous le schéma : un message posé là serait lu deux
          // écrans plus bas que le champ fautif.
          if (outcome is DistributionFailure) ...[
            const SizedBox(height: AppSpacing.md),
            _ErrorBanner(message: outcome.message),
          ],
        ],
      ),
      inputFooter: AppDisclosure(
        title: 'Réglages avancés',
        child: _AdvancedSettings(input: input, form: form),
      ),
      visualization: ZoomableCanvas(
        painter: DistributionPainter(
          result: result,
          length: input.length,
          elementWidth: input.elementWidth,
          startOffset: input.startOffset,
          endOffset: input.endOffset,
        ),
      ),
      results: [
        if (input.mode == DistributionMode.count)
          ResultTile(
            label: 'Nombre d’éléments',
            value: result == null ? kNoValue : '${result.count}',
            note:
                'Pour un écart visé de ${formatNumber(input.targetSpacing)} '
                'mm',
          ),
        ResultTile(
          label: input.mode == DistributionMode.count
              ? 'Écart obtenu'
              : 'Écart',
          value: formatNumber(result?.spacing),
          unit: 'mm',
          note: result == null ? null : _gapRule(result),
        ),
        // Sans épaisseur, l'entraxe *est* l'écart : deux tuiles identiques ne
        // diraient rien de plus.
        if (input.elementWidth > 0)
          ResultTile(
            label: 'Entraxe',
            value: formatNumber(result?.pitch),
            unit: 'mm',
            note: 'D’un bord d’élément au bord suivant',
          ),
        if (ready?.other case final other?)
          ResultTile(
            label: 'Autre possibilité',
            value: formatNumber(other.spacing),
            unit: 'mm',
            note:
                '${other.count} élément${_s(other.count)} — '
                'l’autre côté de l’écart visé',
          ),
        _PositionsTable(result: result, hasWidth: input.elementWidth > 0),
      ],
    );
  }

  /// Rappelle la règle du modèle avec les chiffres en cours. Le nombre de jeux
  /// vient du cœur : il dépend des bords, et l'écran n'a pas à le redéduire.
  static String _gapRule(DistributionResult r) =>
      '${r.count} élément${_s(r.count)} → '
      '${r.gapCount} écart${_s(r.gapCount)}';

  static String _s(int n) => n > 1 ? 's' : '';
}

/// Ce qu'on ne règle qu'une fois sur dix, et qui n'a aucun effet par défaut :
/// bords aux écarts, marges nulles.
class _AdvancedSettings extends StatelessWidget {
  const _AdvancedSettings({required this.input, required this.form});

  final DistributionFormState input;
  final DistributionForm form;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledField(
          label: 'Type de répartition',
          about: kAboutEdges,
          child: _EdgeGrid(
            startEdge: input.startEdge,
            endEdge: input.endEdge,
            onChanged: form.setEdges,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        LabeledField(
          label: 'Marges',
          help: 'Réservées avant répartition — un chant, un tasseau en place.',
          about: kAboutOffsetMode,
          child: AppSegmentedButton<bool>(
            segments: const [
              AppSegment(value: true, label: 'Symétriques'),
              AppSegment(value: false, label: 'Asymétriques'),
            ],
            value: input.symmetricOffsets,
            onChanged: form.setSymmetricOffsets,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (input.symmetricOffsets)
          NumberField(
            label: 'Marge',
            suffix: 'mm',
            about: kAboutOffset,
            value: input.startOffset,
            onChanged: form.setStartOffset,
            step: 5,
          )
        else
          _Pair(
            first: NumberField(
              label: 'Marge début',
              suffix: 'mm',
              about: kAboutOffsetStart,
              value: input.startOffset,
              onChanged: form.setStartOffset,
            ),
            second: NumberField(
              label: 'Marge fin',
              suffix: 'mm',
              about: kAboutOffsetEnd,
              value: input.endOffset,
              onChanged: form.setEndOffset,
            ),
          ),
      ],
    );
  }
}

/// Un couple de bords, son dessin et son nom.
class _EdgeChoice {
  const _EdgeChoice(this.start, this.end, this.label);

  final DistributionEdge start;
  final DistributionEdge end;
  final String label;
}

const List<_EdgeChoice> _edgeChoices = [
  _EdgeChoice(DistributionEdge.gap, DistributionEdge.gap, 'Écart – Écart'),
  _EdgeChoice(
    DistributionEdge.element,
    DistributionEdge.element,
    'Élément – Élément',
  ),
  _EdgeChoice(
    DistributionEdge.element,
    DistributionEdge.gap,
    'Élément – Écart',
  ),
  _EdgeChoice(
    DistributionEdge.gap,
    DistributionEdge.element,
    'Écart – Élément',
  ),
];

/// Les quatre dispositions, en grille 2 × 2.
///
/// Quatre segments sur une ligne donneraient 90 px par libellé : « Élément –
/// Élément » y serait tronqué en silence. La grille laisse la place au
/// pictogramme, qui est de toute façon plus lisible que la phrase.
class _EdgeGrid extends StatelessWidget {
  const _EdgeGrid({
    required this.startEdge,
    required this.endEdge,
    required this.onChanged,
  });

  final DistributionEdge startEdge;
  final DistributionEdge endEdge;
  final void Function(DistributionEdge start, DistributionEdge end) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row = 0; row < 2; row++) ...[
          if (row > 0) const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (var col = 0; col < 2; col++) ...[
                if (col > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _EdgeTile(
                    choice: _edgeChoices[row * 2 + col],
                    selected:
                        _edgeChoices[row * 2 + col].start == startEdge &&
                        _edgeChoices[row * 2 + col].end == endEdge,
                    onTap: onChanged,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _EdgeTile extends StatelessWidget {
  const _EdgeTile({
    required this.choice,
    required this.selected,
    required this.onTap,
  });

  final _EdgeChoice choice;
  final bool selected;
  final void Function(DistributionEdge start, DistributionEdge end) onTap;

  static const double _previewHeight = 30;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: () => onTap(choice.start, choice.end),
        borderRadius: BorderRadius.circular(AppRadii.field),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? AppColors.accentWash : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.field),
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: _previewHeight,
                  child: CustomPaint(
                    painter: EdgePreviewPainter(
                      startEdge: choice.start,
                      endEdge: choice.end,
                      selected: selected,
                    ),
                    size: Size.infinite,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  choice.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: selected ? AppColors.accentDeep : AppColors.label,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                  // Deux lignes : « Élément – Élément » ne tient pas sur une
                  // seule à cette largeur, et il vaut mieux le voir passer à
                  // la ligne que se faire couper.
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Le refus du cœur, affiché tel quel.
///
/// Dans la couleur d'erreur du thème — le même orange que la bordure d'un
/// champ en faute, et non un rouge de plus dans une app qui n'a qu'un accent.
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.error;

    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadii.field),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline, size: 20, color: color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Les cotes de pose en table numérotée plutôt qu'en ruban `250 · 500 · 750`.
///
/// Le geste réel, c'est lire une position, tracer, lire la suivante, tracer —
/// sur un ruban qui passe à la ligne, on perd sa place et on recompte à chaque
/// trait. Numérotées, les positions se retrouvent : « l'élément 7 ».
///
/// Deux colonnes dès qu'il y a une épaisseur : on trace au bord quand on pose
/// à la règle, au centre quand on perce. La colonne centre disparaît pour des
/// points purs, où les deux se confondent.
///
/// Chiffres tabulaires **alignés à droite** : unités sous unités, centaines
/// sous centaines, donc un entraxe irrégulier se verrait à l'œil. En
/// `titleMedium` et non en [controlTextStyle] — ici on a le nez sur l'écran avec
/// un crayon, c'est le repérage qui compte, pas la lecture à bout de bras, et
/// quinze lignes à 22 px ne tiendraient nulle part.
class _PositionsTable extends StatelessWidget {
  const _PositionsTable({required this.result, required this.hasWidth});

  /// `null` = saisie refusée, distinct d'une liste vide (zéro élément demandé).
  final DistributionResult? result;

  final bool hasWidth;

  /// Largeur de la colonne N°, **mesurée** sur le plus large de ses contenus
  /// (l'en-tête ou le dernier numéro) plutôt que fixée. Une largeur ronde y
  /// laisserait du mou : les numéros sont cadrés à droite, donc ce mou tombe
  /// entièrement à gauche du chiffre et s'ajoute à [_cellPadding] — la première
  /// cellule aurait alors trois fois le blanc de la dernière. Collée au
  /// contenu, la colonne rend le rembourrage de la ligne visible tel quel des
  /// deux côtés.
  static double _indexColumnWidth(
    String widestIndex,
    TextStyle? headerStyle,
    TextStyle? cellStyle,
  ) {
    double widthOf(String text, TextStyle? style) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      return painter.width;
    }

    return math.max(
      widthOf(_indexHeader, headerStyle),
      widthOf(widestIndex, cellStyle),
    );
  }

  static const String _indexHeader = 'N°';

  /// Le tableau tient la gouttière de [AppSpacing.md] de la carte, comme tout
  /// le reste — c'est la rayure qui commence et finit sur cette ligne. Les
  /// cellules, elles, rentrent de [AppSpacing.sm] : sans ça le dernier chiffre,
  /// cadré à droite, toucherait le bord de la rayure. Porté par les lignes et
  /// par l'en-tête, jamais par le titre, sinon les colonnes décrocheraient.
  static const EdgeInsets _cellPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.sm,
  );

  Future<void> _copy(BuildContext context, DistributionResult r) async {
    final messenger = ScaffoldMessenger.of(context);
    // Une position par ligne, colonnes séparées par une tabulation : ça tombe
    // dans un tableur, là où le point médian de l'affichage ne se colle nulle
    // part.
    final lines = [
      for (final (i, position) in r.positions.indexed)
        hasWidth
            ? '${formatNumber(position)}\t${formatNumber(r.centers[i])}'
            : formatNumber(position),
    ];
    await Clipboard.setData(ClipboardData(text: lines.join('\n')));
    messenger.showSnackBar(const SnackBar(content: Text('Copié')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = result;
    final hasRows = r != null && r.positions.isNotEmpty;

    final headerStyle = theme.textTheme.bodySmall?.copyWith(
      color: AppColors.label,
    );
    final cellStyle = theme.textTheme.titleMedium?.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final indexWidth = _indexColumnWidth(
      '${hasRows ? r.positions.length : 0}',
      headerStyle,
      cellStyle,
    );

    return InkWell(
      // Même geste que sur une ResultTile : un tap copie tout.
      onTap: hasRows ? () => _copy(context, r) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Positions depuis l’origine',
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                if (hasRows) const Icon(Icons.copy_outlined),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (!hasRows)
              Text(
                r == null ? kNoValue : 'Aucun élément',
                style: theme.textTheme.titleLarge,
              )
            else ...[
              // L'unité va dans l'en-tête : elle qualifie la colonne entière,
              // pas chaque ligne — la répéter quinze fois serait du bruit.
              Padding(
                padding: _cellPadding,
                child: Row(
                  children: [
                    SizedBox(
                      width: indexWidth,
                      child: Text(
                        _indexHeader,
                        style: headerStyle,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        hasWidth ? 'Bord (mm)' : 'Position (mm)',
                        style: headerStyle,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    if (hasWidth) ...[
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'Centre (mm)',
                          style: headerStyle,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              for (final (i, position) in r.positions.indexed)
                DecoratedBox(
                  decoration: BoxDecoration(
                    // Rayures discrètes : de l'accroche pour l'œil qui
                    // redescend la colonne entre deux traits de crayon.
                    color: i.isOdd ? AppColors.field : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadii.field),
                  ),
                  child: Padding(
                    padding: _cellPadding.add(
                      const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: indexWidth,
                          child: Text(
                            '${i + 1}',
                            style: cellStyle?.copyWith(color: AppColors.label),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            formatNumber(position),
                            style: cellStyle,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        if (hasWidth) ...[
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              formatNumber(r.centers[i]),
                              style: cellStyle,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Deux champs de front. Aucun des deux ne porte de boutons − / + : à cette
/// largeur ils tiennent, là où une paire de champs à pas serait illisible sur
/// un téléphone.
class _Pair extends StatelessWidget {
  const _Pair({required this.first, required this.second});

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: second),
      ],
    );
  }
}
