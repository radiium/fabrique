import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'haptics.dart';

/// `DropdownMenu` du design system : pleine largeur, non éditable.
///
/// L'habillage vient du `dropdownMenuTheme`, le texte de [controlTextStyle].
/// Sans nom pour un lecteur d'écran : `DropdownMenu` enferme son champ dans son
/// propre `Semantics`, sans point d'accroche.
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
        if (next == null || next == value) return;
        hapticSelection(context);
        onSelected(next);
      },
      dropdownMenuEntries: [
        for (final entry in entries.entries)
          DropdownMenuEntry(
            value: entry.key,
            label: entry.value,
            // `DropdownMenu` ne relaie pas le `textStyle` du thème : style par entrée.
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
