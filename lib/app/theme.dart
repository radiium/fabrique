import 'package:flutter/material.dart';

/// Design system de l'app.
///
/// Thème clair uniquement, un seul accent chaud bois/ambre, orange réservé au
/// surlignage des pièces à couper dans les schémas.
abstract final class AppColors {
  static const Color accent = Color(0xFFB4741E);

  /// Brun profond : fond des éléments sélectionnés, toujours sous du blanc.
  static const Color accentDeep = Color(0xFF734C27);

  /// Texte, icône ou témoin posé sur [accentDeep].
  static const Color onAccent = Colors.white;

  static const Color cut = Color(0xFFE2711D);
  static const Color background = Color(0xFFF7F5F2);
  static const Color surface = Colors.white;

  /// Cartes sans élévation, cernées de [cardBorder] : claires pour la saisie
  /// et les résultats, teintées pour les schémas.
  static const Color cardSurface = surface;
  static const Color cardTinted = Color(0xFFEFE7D8);
  static const Color cardBorder = Color(0xFFE2DACA);

  /// Remplissage des champs de saisie, contrasté sur la carte blanche.
  static const Color field = Color(0xFFF6F3EE);

  /// Ambre lavé : fond d'une option retenue qui porte un dessin (tuiles de
  /// bords). [accentDeep] y masquerait le pictogramme.
  static const Color accentWash = Color(0xFFEEE0CE);

  /// Un seul filet pour les champs et les cartes.
  static const Color border = cardBorder;

  /// Libellés au-dessus des champs, et unités en suffixe.
  static const Color label = Color(0xFF6B625A);

  /// Encart posé dans une carte claire (arbitrage de la Répartition).
  ///
  /// Seul filet autre que [border] : l'encart se détache sur une carte blanche.
  static const Color callout = Color(0xFFEFE7D5);
  static const Color calloutBorder = Color(0xFFDCCFB4);
}

/// Espacements.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Rayons du design system.
abstract final class AppRadii {
  static const double card = 10;

  /// Champs, boutons − / +, menus, tuiles de résultat, piste
  /// d'`AppSegmentedButton`.
  static const double field = 9;

  /// Feuille blanche d'un schéma, posée dans sa carte teintée.
  ///
  /// Juste sous [card] : plus arrondie, la feuille se décollerait du coin.
  static const double schemaSheet = 8;
}

/// Hauteur de tout ce qui se saisit ou se choisit : la cible tactile minimale.
const double kFieldHeight = 48;

/// Taille du texte des contrôles, et son interligne.
///
/// Interligne figé, pour que [_dropdownVerticalPadding] se calcule.
const double kControlFontSize = 18;
const double _controlHeightFactor = 1.3;

/// Hauteur rendue d'une ligne de [controlTextStyle], mesurée.
///
/// Le moteur arrondit la boîte de ligne : 23 et non les 23,4 calculés.
const double _controlLineHeight = 23;

/// Marge verticale qui amène un `DropdownMenu` à [kFieldHeight].
///
/// Sa hauteur ne vient que du padding. À remesurer si la police change.
const double _dropdownVerticalPadding = (kFieldHeight - _controlLineHeight) / 2;

/// Le style de tout ce qui se saisit ou se choisit : une seule taille pour
/// tous les contrôles.
///
/// [emphasized] ne joue que sur la graisse, pour l'option retenue.
TextStyle? controlTextStyle(BuildContext context, {bool emphasized = false}) =>
    Theme.of(context).textTheme.titleLarge?.copyWith(
      fontSize: kControlFontSize,
      height: _controlHeightFactor,
      fontWeight: emphasized ? FontWeight.w700 : FontWeight.w600,
    );

/// Rupture mobile ↔ web large (saisie à gauche, visualisation à droite).
const double kWideBreakpoint = 800;

OutlineInputBorder _fieldBorder(Color color, {double width = 1}) =>
    OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(AppRadii.field)),
      borderSide: BorderSide(color: color, width: width),
    );

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.accent,
    brightness: Brightness.light,
  ).copyWith(surface: AppColors.surface, error: AppColors.cut);

  final base = ThemeData(colorScheme: scheme, useMaterial3: true);

  // Libellé au-dessus du champ, jamais flottant : il reste lisible pendant la
  // saisie.
  final inputTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.field,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    // Padding horizontal seul : la hauteur vient du conteneur du champ.
    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    hintStyle: const TextStyle(color: AppColors.label),
    suffixStyle: const TextStyle(color: AppColors.label),
    border: _fieldBorder(AppColors.border),
    enabledBorder: _fieldBorder(AppColors.border),
    focusedBorder: _fieldBorder(AppColors.accent, width: 2),
    errorBorder: _fieldBorder(AppColors.cut),
    focusedErrorBorder: _fieldBorder(AppColors.cut, width: 2),
    disabledBorder: _fieldBorder(AppColors.border.withValues(alpha: 0.5)),
  );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    cardTheme: const CardThemeData(
      color: AppColors.cardSurface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadii.card)),
        side: BorderSide(color: AppColors.cardBorder),
      ),
    ),
    inputDecorationTheme: inputTheme,
    // Même trait que la bordure des cartes. `space: 1` : le rythme vertical
    // vient des tuiles.
    dividerTheme: const DividerThemeData(
      color: AppColors.cardBorder,
      thickness: 1,
      space: 1,
    ),
    // `DropdownMenu` n'hérite pas de `inputDecorationTheme` : on le rebranche.
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: inputTheme.copyWith(
        // Déduite de [controlTextStyle] pour retomber sur [kFieldHeight].
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: _dropdownVerticalPadding,
        ),
        // Sinon le chevron, en IconButton de 48 plus 4 de marge, fixe la hauteur
        // à 56.
        suffixIconConstraints: const BoxConstraints(maxHeight: 48),
      ),
      // Le panneau reprend le champ. Sans élévation ni teinte, que Material grise.
      menuStyle: MenuStyle(
        backgroundColor: const WidgetStatePropertyAll(AppColors.field),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(0),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(AppSpacing.xs)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.field),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    ),
    // L'option courante reprend la pastille du sélecteur. Un `textStyle` posé
    // ici est ignoré (mesuré) : la taille passe par `DropdownMenuEntry.style`.
    menuButtonTheme: MenuButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.focused)
              ? Colors.white
              : AppColors.label,
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.focused)
              ? AppColors.accentDeep
              : Colors.transparent,
        ),
        overlayColor: WidgetStatePropertyAll(
          AppColors.accent.withValues(alpha: 0.12),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.field),
          ),
        ),
      ),
    ),
    // La piste active reprend la pastille du sélecteur ; sinon le Switch M3
    // prend le violet dérivé du seed.
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? Colors.white
            : AppColors.label,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.accentDeep
            : AppColors.field,
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.accentDeep
            : AppColors.border,
      ),
      overlayColor: WidgetStatePropertyAll(
        AppColors.accent.withValues(alpha: 0.12),
      ),
    ),
    textTheme: base.textTheme.copyWith(
      // Chiffres tabulaires pour tous les résultats.
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    ),
  );
}
