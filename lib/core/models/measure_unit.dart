/// Les grandeurs que le Convertisseur sait traiter, et leurs unités.
///
/// Une unité n'entre que si on la croise sur un chantier et qu'elle est
/// pénible sans outil. Pas de préfixes SI de simple virgule (mg, dL, hPa).
library;

/// Une famille d'unités. On ne convertit jamais d'une famille à l'autre.
enum Quantity {
  length,
  area,
  volume,
  mass,
  pressure;

  /// Les unités de cette grandeur, dans l'ordre d'affichage : métrique du plus
  /// petit au plus grand, puis impérial.
  ///
  /// Cinq au plus : la largeur d'un `AppSegmentedButton` sur un téléphone.
  /// Le `!` est sûr : la table est bâtie sur `Quantity.values`.
  List<MeasureUnit> get units => _unitsByQuantity[this]!;

  /// L'unité proposée à l'ouverture et au changement de grandeur : la plus
  /// courante.
  MeasureUnit get defaultUnit => switch (this) {
    Quantity.length => MeasureUnit.mm,
    Quantity.area => MeasureUnit.m2,
    Quantity.volume => MeasureUnit.liter,
    Quantity.mass => MeasureUnit.kilogram,
    Quantity.pressure => MeasureUnit.bar,
  };
}

/// Une unité, rattachée à sa grandeur.
///
/// Le facteur de conversion est dans `core/calc/units/`.
enum MeasureUnit {
  // Longueur — base mm.
  mm(Quantity.length),
  cm(Quantity.length),
  m(Quantity.length),
  inch(Quantity.length),
  foot(Quantity.length),

  // Surface — base mm².
  mm2(Quantity.area),
  cm2(Quantity.area),
  m2(Quantity.area),
  inch2(Quantity.area),
  foot2(Quantity.area),

  // Volume — base mm³, qui ne s'affiche pas.
  cm3(Quantity.volume),
  liter(Quantity.volume),
  m3(Quantity.volume),
  inch3(Quantity.volume),

  /// Le pied-planche (PMP) : l'unité d'achat du bois dur.
  boardFoot(Quantity.volume),

  // Masse — base g.
  gram(Quantity.mass),
  kilogram(Quantity.mass),
  tonne(Quantity.mass),
  ounce(Quantity.mass),
  pound(Quantity.mass),

  // Pression — base Pa. Pas de mbar : son symbole ne tient pas dans un
  // segment de téléphone.
  bar(Quantity.pressure),
  kilopascal(Quantity.pressure),
  megapascal(Quantity.pressure),
  psi(Quantity.pressure);

  const MeasureUnit(this.quantity);

  /// La famille à laquelle l'unité appartient.
  final Quantity quantity;
}

/// Les unités groupées par grandeur, calculé au premier accès.
final Map<Quantity, List<MeasureUnit>> _unitsByQuantity = {
  for (final q in Quantity.values)
    q: List.unmodifiable(MeasureUnit.values.where((u) => u.quantity == q)),
};
