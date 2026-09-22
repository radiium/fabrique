import 'package:flutter/material.dart';

/// Design system de l'app.
///
/// Thème clair uniquement, un seul accent chaud bois/ambre, orange réservé au
/// surlignage des pièces à couper dans les schémas.
abstract final class AppColors {
  static const Color accent = Color(0xFFB4741E);

  /// Brun profond — fond des éléments sélectionnés (pastille du sélecteur),
  /// toujours avec du texte blanc dessus.
  static const Color accentDeep = Color(0xFF734C27);

  static const Color cut = Color(0xFFE2711D);
  static const Color background = Color(0xFFF7F5F2);
  static const Color surface = Colors.white;

  /// Cartes — deux variantes seulement, sans élévation, cernées de
  /// [cardBorder] : claire pour la saisie et les résultats, teintée pour les
  /// schémas.
  static const Color cardSurface = surface;
  static const Color cardTinted = Color(0xFFEFE7D8);
  static const Color cardBorder = Color(0xFFE2DACA);

  /// Remplissage des champs de saisie — beige chaud, contrasté sur la carte
  /// blanche qui les porte.
  static const Color field = Color(0xFFF6F3EE);

  /// Ambre lavé — fond d'une option retenue qui porte un dessin plutôt qu'un
  /// libellé (tuiles de bords de la Répartition). La pastille [accentDeep] y
  /// noierait le pictogramme, qui est justement ce qu'on vient lire ; ce lavis
  /// se voit à bout de bras en laissant passer le croquis et le texte en
  /// [accentDeep].
  static const Color accentWash = Color(0xFFEEE0CE);

  /// Même trait pour les champs et les cartes : un seul filet dans l'app.
  static const Color border = cardBorder;

  /// Libellés au-dessus des champs, et unités en suffixe.
  static const Color label = Color(0xFF6B625A);
}

/// Espacement généreux, aéré.
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

  /// Champs, boutons − / +, panneau du `DropdownMenu`, tuiles de résultat,
  /// piste d'`AppSegmentedButton` (dont la pastille reprend ce rayon moins
  /// son jeu, pour rester concentrique).
  static const double field = 9;
}

/// Hauteur fixe d'un champ de saisie (et des boutons − / + qui l'encadrent).
///
/// Exactement la cible tactile minimale : tout ce qui se
/// saisit ou se choisit tient cette hauteur — champ, sélecteur segmenté,
/// dropdown, ligne de switch, boutons de pas.
const double kFieldHeight = 48;

/// Taille du texte des contrôles, et son interligne.
///
/// L'interligne est figé plutôt qu'hérité du thème : c'est lui qui rend la
/// hauteur d'un contrôle calculable, donc [_dropdownVerticalPadding] dérivable.
const double kControlFontSize = 18;
const double _controlHeightFactor = 1.3;

/// Hauteur réellement occupée par une ligne de [controlTextStyle].
///
/// Mesurée, pas calculée : le moteur de texte arrondit la boîte de ligne, donc
/// `kControlFontSize * _controlHeightFactor` (23.4) ne correspond pas à ce qui
/// est rendu (23). Prendre le calcul pour argent comptant décalerait le
/// dropdown de quelques dixièmes sous les autres contrôles.
const double _controlLineHeight = 23;

/// Marge verticale qui amène un `DropdownMenu` à exactement [kFieldHeight].
///
/// Le champ du `DropdownMenu` n'est pas le nôtre : on ne peut pas lui imposer
/// de conteneur, sa hauteur vient du padding. À revérifier si la taille de
/// police change — c'est une mesure, elle ne suit pas toute seule.
const double _dropdownVerticalPadding = (kFieldHeight - _controlLineHeight) / 2;

/// Le style de **tout ce qui se saisit ou se choisit** : champ numérique,
/// valeur fermée d'un `DropdownMenu`, libellé d'[AppSegmentedButton], entrée de
/// panneau déroulant. Une seule taille pour tous les contrôles.
///
/// Fonction partagée plutôt qu'un `titleLarge` recopié dans chaque widget :
/// un style recopié dérive, et des contrôles qui dérivent cessent de se lire
/// comme un seul jeu.
///
/// [emphasized] ne joue que sur la graisse, pour l'option retenue d'une liste
/// de choix — en appui de la pastille brune, qui reste le vrai indicateur.
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

  // Le libellé vit AU-DESSUS du champ (cf. LabeledField), jamais flottant :
  // il reste lisible en permanence, ce que le label flottant Material ne
  // garantit pas une fois la saisie commencée.
  final inputTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.field,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    // Padding horizontal seul : la hauteur d'un champ est fixée à
    // [kFieldHeight] par son conteneur (cf. NumberField), pas déduite du
    // padding — elle ne bouge donc pas avec le style de texte.
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
    // Un seul filet dans l'app : le séparateur entre tuiles de résultat est le
    // même trait que la bordure des cartes. `space: 1` pour qu'il n'occupe que
    // sa propre épaisseur — le rythme vertical vient des tuiles, pas de lui.
    dividerTheme: const DividerThemeData(
      color: AppColors.cardBorder,
      thickness: 1,
      space: 1,
    ),
    // `DropdownMenu` n'hérite PAS de `inputDecorationTheme` : son champ part
    // des défauts Material (sans remplissage, rayon 4). On le rebranche ici
    // pour qu'il ait le fond, le filet et le rayon d'un champ de saisie.
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: inputTheme.copyWith(
        // La valeur fermée est en [controlTextStyle] : la marge s'en déduit
        // pour retomber sur [kFieldHeight].
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: _dropdownVerticalPadding,
        ),
        // Sans ça, c'est le chevron qui fixe la hauteur : Material l'enveloppe
        // dans un IconButton à cible tactile de 48, plus 4 de marge — 56 au
        // total, soit 4 de trop. Bridé à 48, il repasse sous le texte.
        suffixIconConstraints: const BoxConstraints(maxHeight: 48),
      ),
      // Le panneau déroulant reprend le champ trait pour trait : même fond,
      // même filet, même rayon. Sans élévation ni teinte de surface, sinon
      // Material le grise en le superposant.
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
    // Entrées du panneau déroulant : l'option courante reprend la pastille du
    // sélecteur (brun profond, texte blanc), le survol un voile d'accent.
    //
    // `DropdownMenu` ne relaie que ces quatre propriétés-là depuis le thème —
    // vérifié à la mesure : un `textStyle` posé ici n'a aucun effet, les
    // entrées restent au défaut Material. La taille du texte se règle donc
    // entrée par entrée, via `DropdownMenuEntry.style`.
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
    // Interrupteurs : la piste active reprend la pastille du sélecteur (brun
    // profond, pouce blanc), l'état inactif le fond et le filet d'un champ.
    // Sans ça, le Switch M3 part sur le violet dérivé du seed.
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
