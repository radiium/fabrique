import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/calc/layout.dart';
import '../../core/format.dart';
import '../../core/models/enums.dart';
import '../../core/models/tool.dart';
import '../../core/widgets/app_disclosure.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_segmented_button.dart';
import '../../core/widgets/app_switch_field.dart';
import '../../core/widgets/error_banner.dart';
import '../../core/widgets/field_pair.dart';
import '../../core/widgets/labeled_field.dart';
import '../../core/widgets/number_field.dart';
import '../../core/widgets/result_tile.dart';
import '../../core/widgets/schema_card.dart';
import '../../core/widgets/tool_scaffold.dart';
import 'layout_controller.dart';
import 'layout_help.dart';
import 'layout_plan.dart';
import 'layout_presets.dart';
import 'layout_schema.dart';

/// Millimètres carrés dans un mètre carré.
///
/// Le cœur travaille en mm ; une surface d'atelier s'y compte en millions, ce
/// qui ne se lit pas. Conversion à la frontière UI, comme le veut la règle de
/// l'unité interne unique.
const double _mm2PerM2 = 1000 * 1000;

/// Outil signature. Un seul outil unifié, pas de sélecteur de mode.
class LayoutScreen extends ConsumerWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(layoutFormProvider);
    final outcome = ref.watch(layoutResultProvider);
    final result = outcome is LayoutReady ? outcome.result : null;
    final form = ref.read(layoutFormProvider.notifier);

    return ToolScaffold(
      title: Tool.layout.label,
      onReset: form.reset,
      canReset: input != kLayoutDefaults,
      input: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Les cotes vont par paires : six champs empilés repousseraient le
          // schéma — la vedette de l'écran — sous la ligne de flottaison.
          FieldPair(
            first: NumberField(
              label: 'Surface — largeur',
              suffix: 'mm',
              value: input.surfaceX,
              onChanged: form.setSurfaceX,
            ),
            second: NumberField(
              label: 'Surface — longueur',
              suffix: 'mm',
              value: input.surfaceY,
              onChanged: form.setSurfaceY,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Le sélecteur se pose à la frontière entre ce qu'il ne touche pas
          // et ce qu'il remplit : la surface vient de la pièce et lui échappe,
          // l'élément, le décalage et les jeux sont à lui. Un contrôle qui
          // réécrirait des champs situés au-dessus de lui se lirait comme un
          // bug.
          LabeledField(
            label: 'Matériau',
            child: _PresetDropdown(input: input, form: form),
          ),
          const SizedBox(height: AppSpacing.md),
          FieldPair(
            first: NumberField(
              label: 'Élément — largeur',
              suffix: 'mm',
              value: input.elementX,
              onChanged: form.setElementX,
            ),
            second: NumberField(
              label: 'Élément — longueur',
              suffix: 'mm',
              value: input.elementY,
              onChanged: form.setElementY,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledField(
            label: 'Décalage des joints',
            about: kAboutOffset,
            child: AppSegmentedButton<JointOffset>(
              value: input.offset,
              onChanged: form.setOffset,
              segments: [
                for (final offset in JointOffset.values)
                  AppSegment(value: offset, label: offset.label),
              ],
            ),
          ),
          // Le refus s'affiche là où on peut le corriger. Sur mobile, les
          // résultats sont sous le schéma : un message posé là serait lu deux
          // écrans plus bas que le champ fautif.
          if (outcome is LayoutFailure) ...[
            const SizedBox(height: AppSpacing.md),
            ErrorBanner(message: outcome.message),
          ],
        ],
      ),
      inputFooter: AppDisclosure(
        title: 'Réglages avancés',
        modified: _advancedModified(input),
        child: _AdvancedSettings(input: input, form: form),
      ),
      visualization: const SchemaCard(
        expandFor: Tool.layout,
        child: LayoutSchema(compact: true),
      ),
      results: [
        ResultTile(
          label: 'Éléments entiers',
          value: result == null ? kNoValue : '${result.fullCount}',
        ),
        ResultTile(
          label: 'Éléments à couper',
          value: result == null ? kNoValue : '${result.cutCount}',
          note: 'Surlignés en orange sur le schéma',
        ),
        if (result case LayoutResult(:final balancedRow?, :final balancedEnd))
          ResultTile(
            label: 'Rangées de bord',
            value: formatNumber(balancedRow),
            unit: 'mm',
            note: _balancedNote(balancedEnd),
          ),
        ResultTile(
          label: 'Total à prévoir',
          value: result == null ? kNoValue : '${result.totalCount}',
          note: 'Stock sans réemploi des chutes',
        ),
        ResultTile(
          label: 'Surface',
          value: formatNumber(
            result == null ? null : result.surfaceArea / _mm2PerM2,
          ),
          unit: 'm²',
          note: result == null
              ? null
              : 'Couverte : '
                    '${formatNumber(result.coveredArea / _mm2PerM2)} m²',
        ),
        ResultTile(
          label: 'Perte',
          value: formatNumber(result?.wastePercent),
          unit: '%',
          note: 'Sans réemploi des chutes — estimation pessimiste',
        ),
      ],
      resultsFooter: const LayoutExportAction(),
    );
  }
}

/// Ce qui n'a rien à faire dans la carte tant qu'on n'en a pas besoin.
///
/// Les trois jeux valent 0 par défaut et l'équilibrage est éteint : replier ne
/// cache donc aucune raison d'un résultat surprenant, ce qui est la condition
/// d'emploi d'[AppDisclosure]. C'est la pastille de son en-tête qui tient
/// l'autre bout, le jour où un preset remplit ces champs à la place du doigt.
class _AdvancedSettings extends StatelessWidget {
  const _AdvancedSettings({required this.input, required this.form});

  final LayoutInput input;
  final LayoutForm form;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldPair(
          first: NumberField(
            label: 'Jeu horizontal',
            suffix: 'mm',
            value: input.gapX,
            onChanged: form.setGapX,
          ),
          second: NumberField(
            label: 'Jeu vertical',
            suffix: 'mm',
            value: input.gapY,
            onChanged: form.setGapY,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        NumberField(
          label: 'Jeu périphérique',
          suffix: 'mm',
          help: 'Retrait tout autour de la pose, contre les quatre bords.',
          about: kAboutPerimeterGap,
          value: input.perimeterGap,
          onChanged: form.setPerimeterGap,
          step: 1,
        ),
        const SizedBox(height: AppSpacing.md),
        AppSwitchField(
          label: 'Inverser l’orientation',
          help: 'Le décalage de joints suit.',
          value: input.flip,
          onChanged: form.setFlip,
        ),
        const SizedBox(height: AppSpacing.md),
        // Pas de ⓘ ici : toute la ligne d'un [AppSwitchField] bascule
        // l'interrupteur, y compris le libellé, et une cible d'aide posée
        // dedans changerait le réglage une fois sur deux. L'explication tient
        // donc dans la ligne d'aide.
        AppSwitchField(
          label: 'Équilibrer les rangées',
          help: 'Évite de finir sur une rangée plus mince qu’un demi-élément.',
          value: input.balanceRows,
          onChanged: form.setBalanceRows,
        ),
      ],
    );
  }
}

/// Au moins un réglage replié n'est plus à son défaut.
bool _advancedModified(LayoutInput input) =>
    input.gapX != kLayoutDefaults.gapX ||
    input.gapY != kLayoutDefaults.gapY ||
    input.perimeterGap != kLayoutDefaults.perimeterGap ||
    input.flip != kLayoutDefaults.flip ||
    input.balanceRows != kLayoutDefaults.balanceRows;

/// Ce que l'équilibrage a réellement produit.
///
/// Il ne change aucun autre chiffre de la carte — même nombre d'éléments, même
/// perte — donc sans cette tuile l'option semblerait sans effet.
///
/// [end] est la longueur des pièces de bout, nulle quand l'axe de pose ne
/// s'est pas équilibré (tout décalage autre que droit).
String _balancedNote(double? end) {
  const base = 'Première et dernière, à la même épaisseur';
  return end == null ? base : '$base. Pièces de bout : ${formatNumber(end)} mm';
}

/// Le sélecteur de produit. Sa valeur se **dérive** de la saisie courante.
///
/// Rien de neuf à persister, donc aucune dérive possible entre le formulaire
/// restauré au lancement et ce que le sélecteur affiche : c'est la saisie qui
/// dit quel preset est en cours, jamais l'inverse.
///
/// « Personnalisé » n'est proposé que lorsqu'il est la valeur courante. Le
/// laisser en permanence donnerait une entrée qui ne fait rien quand on la
/// choisit, et une liste de sept lignes pour six produits.
class _PresetDropdown extends StatelessWidget {
  const _PresetDropdown({required this.input, required this.form});

  final LayoutInput input;
  final LayoutForm form;

  @override
  Widget build(BuildContext context) {
    final current = matchLayoutPreset(input);
    return AppDropdown<LayoutPreset?>(
      // `DropdownMenu` ne lit `initialSelection` qu'à la construction : sans
      // cette clé, taper une cote ferait passer la saisie en « Personnalisé »
      // sans que la valeur fermée bouge.
      key: ValueKey(current?.label),
      value: current,
      onSelected: (preset) {
        if (preset != null) form.applyPreset(preset);
      },
      entries: {
        if (current == null) null: 'Personnalisé',
        for (final preset in kLayoutPresets) preset: preset.label,
      },
    );
  }
}
