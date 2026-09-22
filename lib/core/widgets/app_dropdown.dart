import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// `DropdownMenu` calé sur le design system : pleine largeur, et non éditable
/// — la liste est fermée, ouvrir un clavier en atelier n'aurait aucun sens.
///
/// L'habillage (fond, filet, rayon, panneau déroulant) vient du
/// `dropdownMenuTheme` ; il ne reste ici que la géométrie et les entrées.
///
/// La valeur fermée prend [controlTextStyle], comme tous les contrôles :
/// recopier le style ici le laisserait dériver de celui des champs.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    required this.value,
    required this.onSelected,
    required this.entries,
    super.key,
  });

  final T value;
  final ValueChanged<T> onSelected;

  /// Valeur → libellé, dans l'ordre d'affichage.
  final Map<T, String> entries;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      initialSelection: value,
      requestFocusOnTap: false,
      expandedInsets: EdgeInsets.zero,
      textStyle: controlTextStyle(context),
      onSelected: (next) {
        if (next != null) onSelected(next);
      },
      dropdownMenuEntries: [
        for (final entry in entries.entries)
          DropdownMenuEntry(
            value: entry.key,
            label: entry.value,
            // Le `textStyle` du `menuButtonTheme` n'est pas relayé par
            // `DropdownMenu` : sans ce style par entrée, le panneau resterait
            // au défaut Material et ne s'accorderait pas au segmented.
            style: ButtonStyle(
              textStyle: WidgetStateProperty.resolveWith(
                (states) => controlTextStyle(
                  context,
                  // Le thème marque l'entrée courante par `focused`.
                  emphasized: states.contains(WidgetState.focused),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
