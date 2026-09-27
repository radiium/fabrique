/// Les libellés des modèles partagés, dans la langue de l'app.
///
/// Les enums de `core/models` ne portent aucun texte : c'est ce qui les garde
/// lisibles par `core/calc`, sans Flutter. Chaque table est un `switch`, pour
/// qu'une valeur ajoutée casse la compilation plutôt que d'afficher un vide.
library;

import '../core/models/enums.dart';
import '../core/models/measure_unit.dart';
import '../core/models/tool.dart';
import 'app_localizations.dart';

extension ToolLabels on Tool {
  String label(AppLocalizations l10n) => switch (this) {
    Tool.layout => l10n.toolLayout,
    Tool.distribution => l10n.toolDistribution,
    Tool.drawers => l10n.toolDrawers,
    Tool.level => l10n.toolLevel,
    Tool.converter => l10n.toolConverter,
  };

  /// Une ligne de gloss sous le nom, sur la carte d'accueil.
  ///
  /// Rendu sur une seule ligne, tronqué en silence : à 14 px il reste environ
  /// 250 px sur un écran de 400, soit ~34 caractères. Une énumération de cinq
  /// termes n'y tient pas : d'où le sous-titre du convertisseur, qui nomme le
  /// tri des unités plutôt que les grandeurs une à une.
  String subtitle(AppLocalizations l10n) => switch (this) {
    Tool.layout => l10n.toolLayoutSubtitle,
    Tool.distribution => l10n.toolDistributionSubtitle,
    Tool.drawers => l10n.toolDrawersSubtitle,
    Tool.level => l10n.toolLevelSubtitle,
    Tool.converter => l10n.toolConverterSubtitle,
  };
}

extension QuantityLabels on Quantity {
  /// Libellé affiché dans le sélecteur de grandeur.
  String label(AppLocalizations l10n) => switch (this) {
    Quantity.length => l10n.quantityLength,
    Quantity.area => l10n.quantityArea,
    Quantity.volume => l10n.quantityVolume,
    Quantity.mass => l10n.quantityMass,
    Quantity.pressure => l10n.quantityPressure,
  };
}

extension MeasureUnitLabels on MeasureUnit {
  /// Symbole court, tel qu'il s'écrit à côté d'un chiffre, et assez étroit
  /// pour tenir dans un segment de sélecteur sur un téléphone.
  ///
  /// Seuls les symboles impériaux changent avec la langue (`po` / `in`) : les
  /// symboles SI, `oz`, `lb` et `PSI` s'écrivent pareil partout.
  String symbol(AppLocalizations l10n) => switch (this) {
    MeasureUnit.mm => 'mm',
    MeasureUnit.cm => 'cm',
    MeasureUnit.m => 'm',
    MeasureUnit.inch => l10n.unitInchSymbol,
    MeasureUnit.foot => l10n.unitFootSymbol,
    MeasureUnit.mm2 => 'mm²',
    MeasureUnit.cm2 => 'cm²',
    MeasureUnit.m2 => 'm²',
    MeasureUnit.inch2 => '${l10n.unitInchSymbol}²',
    MeasureUnit.foot2 => '${l10n.unitFootSymbol}²',
    MeasureUnit.cm3 => 'cm³',
    MeasureUnit.liter => 'L',
    MeasureUnit.m3 => 'm³',
    MeasureUnit.inch3 => '${l10n.unitInchSymbol}³',
    MeasureUnit.boardFoot => l10n.unitBoardFootSymbol,
    MeasureUnit.gram => 'g',
    MeasureUnit.kilogram => 'kg',
    MeasureUnit.tonne => 't',
    MeasureUnit.ounce => 'oz',
    MeasureUnit.pound => 'lb',
    MeasureUnit.bar => 'bar',
    MeasureUnit.kilopascal => 'kPa',
    MeasureUnit.megapascal => 'MPa',
    MeasureUnit.psi => 'PSI',
  };

  /// Nom complet, pour les libellés de tuile de résultat.
  String label(AppLocalizations l10n) => switch (this) {
    MeasureUnit.mm => l10n.unitMillimeters,
    MeasureUnit.cm => l10n.unitCentimeters,
    MeasureUnit.m => l10n.unitMeters,
    MeasureUnit.inch => l10n.unitInches,
    MeasureUnit.foot => l10n.unitFeet,
    MeasureUnit.mm2 => l10n.unitSquareMillimeters,
    MeasureUnit.cm2 => l10n.unitSquareCentimeters,
    MeasureUnit.m2 => l10n.unitSquareMeters,
    MeasureUnit.inch2 => l10n.unitSquareInches,
    MeasureUnit.foot2 => l10n.unitSquareFeet,
    MeasureUnit.cm3 => l10n.unitCubicCentimeters,
    MeasureUnit.liter => l10n.unitLiters,
    MeasureUnit.m3 => l10n.unitCubicMeters,
    MeasureUnit.inch3 => l10n.unitCubicInches,
    MeasureUnit.boardFoot => l10n.unitBoardFeet,
    MeasureUnit.gram => l10n.unitGrams,
    MeasureUnit.kilogram => l10n.unitKilograms,
    MeasureUnit.tonne => l10n.unitTonnes,
    MeasureUnit.ounce => l10n.unitOunces,
    MeasureUnit.pound => l10n.unitPounds,
    MeasureUnit.bar => l10n.unitBars,
    MeasureUnit.kilopascal => l10n.unitKilopascals,
    MeasureUnit.megapascal => l10n.unitMegapascals,
    MeasureUnit.psi => l10n.unitPsi,
  };
}

extension JointOffsetLabels on JointOffset {
  /// Court : ces libellés tiennent dans un segment de sélecteur.
  String label(AppLocalizations l10n) => switch (this) {
    JointOffset.straight => l10n.jointOffsetStraight,
    JointOffset.half => '½',
    JointOffset.third => '⅓',
  };
}
