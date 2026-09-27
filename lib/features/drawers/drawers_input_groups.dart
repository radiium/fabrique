import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/drawers.dart';
import '../../core/widgets/app_disclosure.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_segmented_button.dart';
import '../../core/widgets/choice_tiles.dart';
import '../../core/widgets/count_field.dart';
import '../../core/widgets/field_pair.dart';
import '../../core/widgets/labeled_field.dart';
import '../../core/widgets/number_field.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/numbers.dart';
import 'drawers_controller.dart';
import 'drawers_front_heights.dart';
import 'drawers_help.dart';
import 'drawers_labels.dart';
import 'drawers_painter.dart';

/// Valeur du menu des longueurs qui rend le choix à l'outil.
///
/// Un zéro et non `null` : `DropdownMenu` ne rend jamais une sélection nulle.
const double _autoSlideLength = 0;

/// Les cotes de l'ouverture, seul groupe ouvert à l'arrivée : c'est ce qu'on
/// vient de mesurer, et ce qui change d'un caisson à l'autre.
class DrawersOpeningGroup extends StatelessWidget {
  const DrawersOpeningGroup({
    required this.input,
    required this.form,
    super.key,
  });

  final DrawersInput input;
  final DrawersForm form;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppDisclosure(
      title: l10n.drawersOpening,
      icon: Icons.crop_square,
      initiallyExpanded: true,
      summary: l10n.drawersSummaryOpening(
        l10n.number(input.openingWidth),
        l10n.number(input.openingHeight),
        l10n.number(input.openingDepth),
        l10n.number(input.carcassThickness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dans l'ordre où on mesure le caisson : largeur, hauteur, puis on
          // plonge le mètre pour la profondeur.
          FieldPair(
            first: NumberField(
              label: l10n.drawersOpeningWidth,
              suffix: 'mm',
              about: aboutOpening(l10n),
              value: input.openingWidth,
              onChanged: form.setOpeningWidth,
            ),
            second: NumberField(
              label: l10n.drawersOpeningHeight,
              suffix: 'mm',
              value: input.openingHeight,
              onChanged: form.setOpeningHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          NumberField(
            label: l10n.drawersOpeningDepth,
            suffix: 'mm',
            value: input.openingDepth,
            onChanged: form.setOpeningDepth,
          ),
          const SizedBox(height: AppSpacing.md),
          NumberField(
            label: l10n.drawersCarcassThickness,
            suffix: 'mm',
            value: input.carcassThickness,
            onChanged: form.setCarcassThickness,
          ),
        ],
      ),
    );
  }
}

/// Le nombre de tiroirs et tout ce qui fait la façade.
class DrawersFrontsGroup extends StatelessWidget {
  const DrawersFrontsGroup({
    required this.input,
    required this.form,
    super.key,
  });

  final DrawersInput input;
  final DrawersForm form;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final count = input.drawerCount;
    final isAdjusted = input.fixedFrontHeights.any((h) => h != null);

    return AppDisclosure(
      title: l10n.drawersFrontsGroup,
      icon: Icons.view_agenda_outlined,
      summary: l10n.drawersSummaryFronts(
        count,
        (isAdjusted ? l10n.drawersHeightsAdjusted : l10n.drawersHeightsEqual)
            .toLowerCase(),
        input.frontMount.label(l10n).toLowerCase(),
        l10n.number(input.frontThickness),
        l10n.number(input.frontGap),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CountField(
            label: l10n.drawersCount,
            value: count,
            onChanged: form.setDrawerCount,
            min: 1,
            max: kMaxDrawerCount,
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledField(
            label: l10n.drawersHeights,
            about: aboutFrontHeights(l10n),
            child: const FrontHeightsButton(),
          ),
          const FrontHeightsSummary(),
          const SizedBox(height: AppSpacing.md),
          LabeledField(
            label: l10n.drawersFrontMount,
            about: aboutFrontMount(l10n),
            child: AppSegmentedButton<FrontMount>(
              segments: [
                for (final mount in FrontMount.values)
                  AppSegment(value: mount, label: mount.label(l10n)),
              ],
              value: input.frontMount,
              onChanged: form.setFrontMount,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // L'épaisseur de façade reste affichée dans les deux poses : le
          // calcul ne s'en sert qu'encastrée, mais le schéma dessine la façade
          // toujours.
          NumberField(
            label: l10n.drawersFrontThickness,
            suffix: 'mm',
            value: input.frontThickness,
            onChanged: form.setFrontThickness,
          ),
          const SizedBox(height: AppSpacing.md),
          NumberField(
            label: l10n.drawersFrontGap,
            suffix: 'mm',
            value: input.frontGap,
            onChanged: form.setFrontGap,
          ),
        ],
      ),
    );
  }
}

/// La glissière : sa famille, ses jeux si on les saisit, sa longueur.
class DrawersSlideGroup extends StatelessWidget {
  const DrawersSlideGroup({required this.input, required this.form, super.key});

  final DrawersInput input;
  final DrawersForm form;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spec = slideSpecFor(input);

    return AppDisclosure(
      title: l10n.drawersSlide,
      icon: Icons.swap_vert,
      summary: _summary(input, spec, l10n),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: l10n.drawersSlide,
            about: aboutSlide(l10n),
            child: AppDropdown<SlideKind>(
              value: input.slide,
              onSelected: form.setSlide,
              entries: {for (final k in SlideKind.values) k: k.label(l10n)},
            ),
          ),
          if (input.slide == SlideKind.custom) ...[
            const SizedBox(height: AppSpacing.md),
            NumberField(
              label: l10n.drawersSideClearance,
              suffix: 'mm',
              value: input.customSideClearance,
              onChanged: form.setCustomSideClearance,
            ),
            const SizedBox(height: AppSpacing.md),
            NumberField(
              label: l10n.drawersLengthReduction,
              suffix: 'mm',
              value: input.customLengthReduction,
              onChanged: form.setCustomLengthReduction,
            ),
          ],
          if (spec.nominalLengths.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            LabeledField(
              label: l10n.drawersSlideLength,
              about: aboutSlideLength(l10n),
              child: AppDropdown<double>(
                value: input.slideLength ?? _autoSlideLength,
                onSelected: (mm) =>
                    form.setSlideLength(mm == _autoSlideLength ? null : mm),
                entries: {
                  _autoSlideLength: l10n.drawersSlideLengthAuto,
                  for (final mm in spec.nominalLengths)
                    mm: '${l10n.number(mm)} mm',
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// La famille, puis ce qui s'y règle : les jeux d'une glissière saisie à la
  /// main, la longueur d'une glissière qu'on achète.
  static String _summary(
    DrawersInput input,
    SlideSpec spec,
    AppLocalizations l10n,
  ) {
    final length = input.slideLength;
    return [
      input.slide.label(l10n),
      if (input.slide == SlideKind.custom)
        l10n.drawersSummaryCustomSlide(
          l10n.number(input.customSideClearance),
          l10n.number(input.customLengthReduction),
        ),
      if (spec.nominalLengths.isNotEmpty)
        length == null
            ? l10n.drawersSummaryAutoLength
            : l10n.drawersSummaryLength(l10n.number(length)),
    ].join(' · ');
  }
}

/// La caisse : ses épaisseurs, son assemblage, son fond.
class DrawersBoxGroup extends StatelessWidget {
  const DrawersBoxGroup({required this.input, required this.form, super.key});

  final DrawersInput input;
  final DrawersForm form;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomRecess = slideSpecFor(input).bottomRecess;

    return AppDisclosure(
      title: l10n.drawersBox,
      icon: Icons.inventory_2_outlined,
      summary: _summary(input, bottomRecess, l10n),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FieldPair(
            first: NumberField(
              label: l10n.drawersSideThickness,
              suffix: 'mm',
              help: l10n.drawersSideThicknessHelp,
              value: input.sideThickness,
              onChanged: form.setSideThickness,
            ),
            second: NumberField(
              label: l10n.drawersBottomThickness,
              suffix: 'mm',
              value: input.bottomThickness,
              onChanged: form.setBottomThickness,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledField(
            label: l10n.drawersBoxJoint,
            about: aboutBoxJoint(l10n),
            child: ChoiceTiles<BoxJoint>(
              tiles: [
                for (final joint in BoxJoint.values)
                  ChoiceTile(
                    value: joint,
                    label: joint.label(l10n),
                    preview: ({required selected}) => BoxJointPreviewPainter(
                      joint: joint,
                      selected: selected,
                    ),
                  ),
              ],
              value: input.boxJoint,
              onChanged: form.setBoxJoint,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (bottomRecess != null)
            LabeledField(
              label: l10n.drawersBottom,
              help: l10n.drawersBottomImposedHelp,
              child: _LockedValue(
                text: l10n.drawersBottomRecess(l10n.number(bottomRecess)),
              ),
            )
          else ...[
            LabeledField(
              label: l10n.drawersBottom,
              about: aboutBottomMount(l10n),
              child: ChoiceTiles<BottomMount>(
                tiles: [
                  for (final mount in BottomMount.values)
                    ChoiceTile(
                      value: mount,
                      label: mount.label(l10n),
                      preview: ({required selected}) =>
                          BottomMountPreviewPainter(
                            mount: mount,
                            selected: selected,
                          ),
                    ),
                ],
                value: input.bottomMount,
                onChanged: form.setBottomMount,
                // Trois sur une ligne plutôt que 2 + 1 : une tuile seule sur
                // sa ligne se lirait comme un choix à part.
                columns: 3,
              ),
            ),
            if (input.bottomMount == BottomMount.groove) ...[
              const SizedBox(height: AppSpacing.md),
              NumberField(
                label: l10n.drawersGrooveDepth,
                suffix: 'mm',
                value: input.grooveDepth,
                onChanged: form.setGrooveDepth,
              ),
            ],
          ],
        ],
      ),
    );
  }

  /// Le fond se dit tel qu'il est monté, y compris quand la glissière l'impose
  /// : c'est là qu'on chercherait pourquoi les tuiles du fond ont disparu.
  static String _summary(
    DrawersInput input,
    double? bottomRecess,
    AppLocalizations l10n,
  ) {
    final bottom = switch ((bottomRecess, input.bottomMount)) {
      (final recess?, _) => l10n.drawersSummaryRecess(l10n.number(recess)),
      (null, BottomMount.groove) => l10n.drawersSummaryGroove(
        l10n.number(input.grooveDepth),
      ),
      (null, final mount) => mount.label(l10n).toLowerCase(),
    };
    return l10n.drawersSummaryBox(
      l10n.number(input.sideThickness),
      l10n.number(input.bottomThickness),
      input.boxJoint.label(l10n).toLowerCase(),
      bottom,
    );
  }
}

/// Une valeur que la saisie ne commande pas, à la place de son contrôle.
///
/// Elle garde la hauteur d'un champ : le panneau ne saute pas quand on change
/// de glissière.
class _LockedValue extends StatelessWidget {
  const _LockedValue({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kFieldHeight,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.field),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: controlTextStyle(context)
                  ?.copyWith(color: AppColors.label),
            ),
          ),
          const Icon(Icons.lock_outline, size: 18, color: AppColors.label),
        ],
      ),
    );
  }
}
