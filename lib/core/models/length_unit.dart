/// Unités de longueur supportées par l'app.
///
/// L'unité interne est toujours le millimètre ; ces unités ne servent qu'aux
/// frontières (saisie et affichage).
enum LengthUnit { mm, cm, m, inch, foot }

/// Libellés d'affichage. L'app est FR uniquement au lancement ; ces chaînes
/// rejoindront `app_fr.arb` le jour où une seconde langue arrive.
extension LengthUnitDisplay on LengthUnit {
  /// Symbole court, tel qu'il s'écrit à côté d'une cote — et assez étroit pour
  /// tenir dans un segment de sélecteur sur un écran de téléphone.
  String get symbol => switch (this) {
    LengthUnit.mm => 'mm',
    LengthUnit.cm => 'cm',
    LengthUnit.m => 'm',
    LengthUnit.inch => 'po',
    LengthUnit.foot => 'pi',
  };

  /// Nom complet, pour les libellés de tuile de résultat.
  String get label => switch (this) {
    LengthUnit.mm => 'Millimètres',
    LengthUnit.cm => 'Centimètres',
    LengthUnit.m => 'Mètres',
    LengthUnit.inch => 'Pouces',
    LengthUnit.foot => 'Pieds',
  };
}
