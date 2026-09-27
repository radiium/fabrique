/// Les grandeurs que le Convertisseur sait traiter, et leurs unités.
///
/// Le tri est volontairement sévère : une unité n'entre ici que si on la
/// croise dans un vrai chantier **et** qu'elle est pénible sans outil. C'est ce
/// qui sépare cet écran d'un convertisseur générique — celui-là, le téléphone
/// le fait déjà mieux.
///
/// Corollaire : pas de préfixes SI purs pour le plaisir (mg, dL, hPa…). Un
/// décalage de virgule se fait de tête et ne mérite pas une tuile.
library;

/// Une famille d'unités. Chaque grandeur a sa propre table, et on ne convertit
/// jamais d'une famille à l'autre.
enum Quantity {
  length,
  area,
  volume,
  mass,
  pressure;

  /// Les unités de cette grandeur, dans l'ordre d'affichage : métrique du plus
  /// petit au plus grand, puis impérial.
  ///
  /// **Cinq au maximum** — c'est la largeur que tient un `AppSegmentedButton`
  /// sur un téléphone, et c'est déjà la limite atteinte par les longueurs.
  ///
  /// Groupé une fois pour toutes : ce getter est lu à chaque `build` de
  /// l'écran, il n'a pas à refiltrer les 24 unités à chaque fois. Le `!` est
  /// sûr : la table est bâtie à partir de `Quantity.values`.
  List<MeasureUnit> get units => _unitsByQuantity[this]!;

  /// L'unité proposée à l'ouverture, et celle sur laquelle on retombe quand on
  /// change de catégorie : la plus courante de la famille, pas la plus petite.
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
/// Le facteur de conversion ne vit pas ici mais dans `core/calc/units/` : même
/// découpe que `LengthUnit` et `mmPerUnit` — l'enum décrit, le cœur calcule.
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

  // Volume — base mm³. Le mm³ ne figure pas dans la liste : aucune cote
  // d'atelier ne s'exprime ainsi, il ne sert que de pivot interne.
  cm3(Quantity.volume),
  liter(Quantity.volume),
  m3(Quantity.volume),
  inch3(Quantity.volume),

  /// Le pied-planche (PMP) : l'unité d'achat du bois dur. Conversion pénible,
  /// propre au bois, et absente de tous les convertisseurs génériques — c'est
  /// elle qui justifie à elle seule que cet outil existe.
  boardFoot(Quantity.volume),

  // Masse — base g.
  gram(Quantity.mass),
  kilogram(Quantity.mass),
  tonne(Quantity.mass),
  ounce(Quantity.mass),
  pound(Quantity.mass),

  // Pression — base Pa. bar et PSI pour le compresseur et la cloueuse, MPa
  // pour les résistances de matériaux (béton, bois). Pas de mbar : c'est un
  // décalage de virgule depuis le bar, et son symbole est le seul de toute la
  // table qui ne tienne pas dans un segment sur un téléphone de 400 px.
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
