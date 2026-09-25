import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/calc/drawers.dart';
import '../../core/format.dart';
import '../../core/widgets/app_disclosure.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_segmented_button.dart';
import '../../core/widgets/choice_tiles.dart';
import '../../core/widgets/field_pair.dart';
import '../../core/widgets/labeled_field.dart';
import '../../core/widgets/number_field.dart';
import 'drawers_controller.dart';
import 'drawers_front_heights.dart';
import 'drawers_help.dart';
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
    return AppDisclosure(
      title: 'Ouverture',
      icon: Icons.crop_square,
      initiallyExpanded: true,
      summary:
          '${formatNumber(input.openingWidth)} × '
          '${formatNumber(input.openingHeight)} × '
          '${formatNumber(input.openingDepth)} mm · '
          'caisson ${formatNumber(input.carcassThickness)} mm',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dans l'ordre où on mesure le caisson : largeur, hauteur, puis on
          // plonge le mètre pour la profondeur.
          FieldPair(
            first: NumberField(
              label: 'Largeur intérieure',
              suffix: 'mm',
              about: kAboutOpening,
              value: input.openingWidth,
              onChanged: form.setOpeningWidth,
            ),
            second: NumberField(
              label: 'Hauteur intérieure',
              suffix: 'mm',
              value: input.openingHeight,
              onChanged: form.setOpeningHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FieldPair(
            first: NumberField(
              label: 'Profondeur intérieure',
              suffix: 'mm',
              value: input.openingDepth,
              onChanged: form.setOpeningDepth,
            ),
            second: NumberField(
              label: 'Épaisseur du caisson',
              suffix: 'mm',
              value: input.carcassThickness,
              onChanged: form.setCarcassThickness,
            ),
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
    final count = input.drawerCount;
    final isAdjusted = input.fixedFrontHeights.any((h) => h != null);

    return AppDisclosure(
      title: 'Tiroirs et façades',
      icon: Icons.view_agenda_outlined,
      summary:
          '$count tiroir${pluralS(count)} · '
          'hauteurs ${isAdjusted ? 'ajustées' : 'égales'} · '
          '${input.frontMount.label.toLowerCase()}, '
          'façade ${formatNumber(input.frontThickness)} · '
          'jeu ${formatNumber(input.frontGap)} mm',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FieldPair(
            first: NumberField(
              label: 'Nombre de tiroirs',
              value: count.toDouble(),
              onChanged: (v) => form.setDrawerCount(v.round()),
              decimal: false,
              min: 1,
              max: kMaxDrawerCount.toDouble(),
            ),
            second: const LabeledField(
              label: 'Hauteurs',
              about: kAboutFrontHeights,
              child: FrontHeightsButton(),
            ),
          ),
          const FrontHeightsSummary(),
          const SizedBox(height: AppSpacing.md),
          LabeledField(
            label: 'Pose de la façade',
            about: kAboutFrontMount,
            child: AppSegmentedButton<FrontMount>(
              segments: [
                for (final mount in FrontMount.values)
                  AppSegment(value: mount, label: mount.label),
              ],
              value: input.frontMount,
              onChanged: form.setFrontMount,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // L'épaisseur de façade reste affichée dans les deux poses : le
          // calcul ne s'en sert qu'encastrée, mais le schéma dessine la façade
          // toujours.
          FieldPair(
            first: NumberField(
              label: 'Épaisseur de façade',
              suffix: 'mm',
              value: input.frontThickness,
              onChanged: form.setFrontThickness,
            ),
            second: NumberField(
              label: 'Jeu entre façades',
              suffix: 'mm',
              value: input.frontGap,
              onChanged: form.setFrontGap,
            ),
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
    final spec = slideSpecFor(input);

    return AppDisclosure(
      title: 'Glissière',
      icon: Icons.swap_vert,
      summary: _summary(input, spec),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: 'Glissière',
            about: kAboutSlide,
            child: AppDropdown<SlideKind>(
              value: input.slide,
              onSelected: form.setSlide,
              entries: {for (final k in SlideKind.values) k: k.label},
            ),
          ),
          if (input.slide == SlideKind.custom) ...[
            const SizedBox(height: AppSpacing.md),
            FieldPair(
              first: NumberField(
                label: 'Jeu par côté',
                suffix: 'mm',
                value: input.customSideClearance,
                onChanged: form.setCustomSideClearance,
              ),
              second: NumberField(
                label: 'Réduction de longueur',
                suffix: 'mm',
                value: input.customLengthReduction,
                onChanged: form.setCustomLengthReduction,
              ),
            ),
          ],
          if (spec.nominalLengths.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            LabeledField(
              label: 'Longueur de glissière',
              about: kAboutSlideLength,
              child: AppDropdown<double>(
                value: input.slideLength ?? _autoSlideLength,
                onSelected: (mm) =>
                    form.setSlideLength(mm == _autoSlideLength ? null : mm),
                entries: {
                  _autoSlideLength: 'Automatique',
                  for (final mm in spec.nominalLengths)
                    mm: '${formatNumber(mm)} mm',
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
  static String _summary(DrawersInput input, SlideSpec spec) {
    final length = input.slideLength;
    return [
      input.slide.label,
      if (input.slide == SlideKind.custom)
        'jeu ${formatNumber(input.customSideClearance)}, '
            'réduction ${formatNumber(input.customLengthReduction)} mm',
      if (spec.nominalLengths.isNotEmpty)
        length == null
            ? 'longueur automatique'
            : 'longueur ${formatNumber(length)} mm',
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
    final bottomRecess = slideSpecFor(input).bottomRecess;

    return AppDisclosure(
      title: 'Caisse',
      icon: Icons.inventory_2_outlined,
      summary: _summary(input, bottomRecess),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FieldPair(
            first: NumberField(
              label: 'Épaisseur des côtés',
              suffix: 'mm',
              help: 'Aussi le devant et le dos.',
              value: input.sideThickness,
              onChanged: form.setSideThickness,
            ),
            second: NumberField(
              label: 'Épaisseur du fond',
              suffix: 'mm',
              value: input.bottomThickness,
              onChanged: form.setBottomThickness,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledField(
            label: 'Assemblage',
            about: kAboutBoxJoint,
            child: ChoiceTiles<BoxJoint>(
              tiles: [
                for (final joint in BoxJoint.values)
                  ChoiceTile(
                    value: joint,
                    label: joint.label,
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
              label: 'Fond',
              help: 'Imposé par la glissière sous tiroir.',
              child: _LockedValue(
                text: 'En retrait de ${formatNumber(bottomRecess)} mm',
              ),
            )
          else ...[
            LabeledField(
              label: 'Fond',
              about: kAboutBottomMount,
              child: ChoiceTiles<BottomMount>(
                tiles: [
                  for (final mount in BottomMount.values)
                    ChoiceTile(
                      value: mount,
                      label: mount.label,
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
                label: 'Profondeur de rainure',
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
  static String _summary(DrawersInput input, double? bottomRecess) {
    final bottom = switch ((bottomRecess, input.bottomMount)) {
      (final recess?, _) => 'en retrait de ${formatNumber(recess)} mm',
      (null, BottomMount.groove) =>
        'en rainure de ${formatNumber(input.grooveDepth)} mm',
      (null, final mount) => mount.label.toLowerCase(),
    };
    return 'côtés ${formatNumber(input.sideThickness)}, '
        'fond ${formatNumber(input.bottomThickness)} mm · '
        '${input.boxJoint.label.toLowerCase()} · fond $bottom';
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
