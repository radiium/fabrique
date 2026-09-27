import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/layout.dart';
import '../../core/models/enums.dart';
import '../../core/widgets/app_disclosure.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_segmented_button.dart';
import '../../core/widgets/app_switch_field.dart';
import '../../core/widgets/field_pair.dart';
import '../../core/widgets/labeled_field.dart';
import '../../core/widgets/number_field.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/labels.dart';
import '../../l10n/numbers.dart';
import 'layout_controller.dart';
import 'layout_help.dart';
import 'layout_presets.dart';

/// La surface à couvrir, seul groupe ouvert à l'arrivée : elle vient de la
/// pièce, et c'est elle qu'on vient de mesurer.
class LayoutSurfaceGroup extends StatelessWidget {
  const LayoutSurfaceGroup({
    required this.input,
    required this.form,
    super.key,
  });

  final LayoutInput input;
  final LayoutForm form;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppDisclosure(
      title: l10n.layoutSurfaceGroup,
      icon: Icons.crop_square,
      initiallyExpanded: true,
      summary:
          '${l10n.number(input.surfaceX)} × '
          '${l10n.number(input.surfaceY)} mm',
      // Les cotes vont par paires : une largeur et une longueur se lisent
      // ensemble.
      child: FieldPair(
        first: NumberField(
          label: l10n.layoutSurfaceWidth,
          suffix: 'mm',
          value: input.surfaceX,
          onChanged: form.setSurfaceX,
        ),
        second: NumberField(
          label: l10n.layoutSurfaceLength,
          suffix: 'mm',
          value: input.surfaceY,
          onChanged: form.setSurfaceY,
        ),
      ),
    );
  }
}

/// Le matériau, son format et la façon de le poser.
class LayoutElementGroup extends StatelessWidget {
  const LayoutElementGroup({
    required this.input,
    required this.form,
    super.key,
  });

  final LayoutInput input;
  final LayoutForm form;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppDisclosure(
      title: l10n.layoutElementGroup,
      icon: Icons.grid_view,
      summary: _summary(input, l10n),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Le sélecteur se pose au-dessus de ce qu'il remplit : l'élément, le
          // décalage, et les jeux du groupe suivant. Un contrôle qui
          // réécrirait des champs situés au-dessus de lui se lirait comme un
          // bug.
          LabeledField(
            label: l10n.layoutMaterial,
            child: _PresetDropdown(input: input, form: form),
          ),
          const SizedBox(height: AppSpacing.md),
          FieldPair(
            first: NumberField(
              label: l10n.layoutElementWidth,
              suffix: 'mm',
              value: input.elementX,
              onChanged: form.setElementX,
            ),
            second: NumberField(
              label: l10n.layoutElementLength,
              suffix: 'mm',
              value: input.elementY,
              onChanged: form.setElementY,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledField(
            label: l10n.layoutOffset,
            about: aboutOffset(l10n),
            child: AppSegmentedButton<JointOffset>(
              value: input.offset,
              onChanged: form.setOffset,
              segments: [
                for (final offset in JointOffset.values)
                  AppSegment(value: offset, label: offset.label(l10n)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppSwitchField(
            label: l10n.layoutFlip,
            help: l10n.layoutFlipHelp,
            value: input.flip,
            onChanged: form.setFlip,
          ),
          const SizedBox(height: AppSpacing.md),
          // Pas de ⓘ ici : toute la ligne d'un [AppSwitchField] bascule
          // l'interrupteur, y compris le libellé, et une cible d'aide posée
          // dedans changerait le réglage une fois sur deux. L'explication tient
          // donc dans la ligne d'aide.
          AppSwitchField(
            label: l10n.layoutBalance,
            help: l10n.layoutBalanceHelp,
            value: input.balanceRows,
            onChanged: form.setBalanceRows,
          ),
        ],
      ),
    );
  }

  /// Le nom du produit s'il correspond, le format sinon : le nom porte déjà
  /// ses cotes. Un interrupteur ne s'y lit qu'allumé, éteint il ne change rien.
  static String _summary(LayoutInput input, AppLocalizations l10n) {
    final preset = matchLayoutPreset(input);
    return [
      preset?.label(l10n) ??
          '${l10n.number(input.elementX)} × '
              '${l10n.number(input.elementY)} mm',
      l10n.layoutSummaryOffset(input.offset.label(l10n).toLowerCase()),
      if (input.flip) l10n.layoutSummaryFlipped,
      if (input.balanceRows) l10n.layoutSummaryBalanced,
    ].join(' · ');
  }
}

/// Les jeux, à 0 par défaut : replié, ce groupe ne cache rien de surprenant.
class LayoutGapsGroup extends StatelessWidget {
  const LayoutGapsGroup({required this.input, required this.form, super.key});

  final LayoutInput input;
  final LayoutForm form;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppDisclosure(
      title: l10n.layoutGapsGroup,
      icon: Icons.border_outer,
      summary: _summary(input, l10n),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FieldPair(
            first: NumberField(
              label: l10n.layoutGapX,
              suffix: 'mm',
              value: input.gapX,
              onChanged: form.setGapX,
            ),
            second: NumberField(
              label: l10n.layoutGapY,
              suffix: 'mm',
              value: input.gapY,
              onChanged: form.setGapY,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          NumberField(
            label: l10n.layoutPerimeterGap,
            suffix: 'mm',
            help: l10n.layoutPerimeterGapHelp,
            about: aboutPerimeterGap(l10n),
            value: input.perimeterGap,
            onChanged: form.setPerimeterGap,
          ),
        ],
      ),
    );
  }

  /// Horizontal × vertical, comme les champs, puis le périphérique.
  static String _summary(LayoutInput input, AppLocalizations l10n) {
    if (input.gapX == 0 && input.gapY == 0 && input.perimeterGap == 0) {
      return l10n.layoutNoGap;
    }
    return l10n.layoutSummaryGaps(
      l10n.number(input.gapX),
      l10n.number(input.gapY),
      l10n.number(input.perimeterGap),
    );
  }
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
    final l10n = AppLocalizations.of(context);
    final current = matchLayoutPreset(input);
    return AppDropdown<LayoutPreset?>(
      // `DropdownMenu` ne lit `initialSelection` qu'à la construction : sans
      // cette clé, taper une cote ferait passer la saisie en « Personnalisé »
      // sans que la valeur fermée bouge.
      key: ValueKey(current),
      value: current,
      onSelected: (preset) {
        if (preset != null) form.applyPreset(preset);
      },
      entries: {
        if (current == null) null: l10n.layoutCustom,
        for (final preset in kLayoutPresets) preset: preset.label(l10n),
      },
    );
  }
}
