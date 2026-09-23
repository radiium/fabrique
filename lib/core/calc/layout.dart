import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../format.dart';
import '../models/enums.dart';
import 'calc_exception.dart';

part 'layout.freezed.dart';
part 'layout.g.dart';

/// Borne de volume, en éléments posés.
///
/// Sans elle, un élément de 1 mm saisi par mégarde sur une surface d'atelier
/// demande plusieurs millions de rectangles : l'app fige avant d'avoir dessiné.
/// C'est le pendant de `kMaxDistributionCount`, que la Répartition a depuis
/// toujours et que le Calepinage n'avait pas.
const int kMaxLayoutElements = 5000;

/// Convention d'axes : les éléments s'alignent le long d'un **axe de pose**,
/// les rangées s'empilent perpendiculairement, et le décalage de joints décale
/// le départ de chaque rangée le long de l'axe de pose.
///
/// Sans inversion, l'axe de pose est X et les rangées montent selon Y.
@freezed
abstract class LayoutInput with _$LayoutInput {
  const factory LayoutInput({
    required double surfaceX,
    required double surfaceY,
    required double elementX,
    required double elementY,
    @Default(0.0) double gapX,
    @Default(0.0) double gapY,

    /// Retrait sur les **quatre bords** avant de poser, en mm.
    ///
    /// Joint de dilatation d'un parquet, joint au mur d'un carrelage, jeu au
    /// sol d'une plaque : la pose recule, mais la pièce ne rétrécit pas —
    /// [LayoutResult.surfaceArea] reste l'aire de la surface entière.
    @Default(0.0) double perimeterGap,

    /// Ne jamais finir sur un filet.
    ///
    /// Quand la dernière bande tombe sous un demi-élément, on sacrifie une
    /// bande pleine et on partage son épaisseur avec le reliquat entre la
    /// première et la dernière, qui deviennent identiques.
    ///
    /// ⚠️ Cela **coûte de la matière** : deux bandes de bord coupées au lieu
    /// d'une, donc [LayoutResult.cutCount] et la perte montent. C'est un
    /// arbitrage esthétique, pas une amélioration gratuite.
    @Default(false) bool balanceRows,

    /// Pivote le motif d'un quart de tour : l'élément se pose le long de Y et
    /// les rangées s'empilent selon X.
    ///
    /// Le décalage des joints **suit** la rotation — c'est tout l'intérêt :
    /// décaler les joints d'un bardage vertical n'a de sens que le long des
    /// lames, pas en travers.
    @Default(false) bool flip,
    @Default(JointOffset.half) JointOffset offset,
  }) = _LayoutInput;

  factory LayoutInput.fromJson(Map<String, dynamic> json) =>
      _$LayoutInputFromJson(json);
}

/// Un élément posé, en coordonnées surface (mm).
@freezed
abstract class PlacedElement with _$PlacedElement {
  const factory PlacedElement({
    /// Coin haut-gauche.
    required double x,
    required double y,

    /// Dimensions réellement posées (rognées si pièce de bord).
    required double w,
    required double h,

    /// Pièce partielle, à surligner comme une coupe.
    required bool isCut,
  }) = _PlacedElement;
}

@freezed
abstract class LayoutResult with _$LayoutResult {
  const factory LayoutResult({
    required List<PlacedElement> elements,
    required int fullCount,
    required int cutCount,

    /// `fullCount + cutCount` — stock sans réemploi des chutes.
    required int totalCount,
    required double surfaceArea,
    required double coveredArea,
    required double wastePercent,

    /// Épaisseur commune des deux rangées de bord, si l'équilibrage a joué.
    ///
    /// Nul quand la règle ne s'est pas appliquée — c'est ce qui permet à
    /// l'écran de ne montrer sa tuile que lorsqu'il y a quelque chose à dire.
    double? balancedRow,

    /// Longueur commune des deux pièces de bout, si l'équilibrage a joué sur
    /// l'axe de pose. Nul sous tout décalage autre que droit.
    double? balancedEnd,
  }) = _LayoutResult;
}

/// Pose des éléments rectangulaires identiques sur une surface rectangulaire.
///
/// Sans réemploi des chutes : chaque pièce partielle consomme un élément, donc
/// `wastePercent` est volontairement pessimiste.
LayoutResult computeLayout(LayoutInput input) {
  _validate(input);

  // Repère de pose. `u` est l'axe le long duquel les éléments s'alignent et le
  // long duquel joue le décalage ; `v` est l'axe d'empilement des rangées.
  // L'inversion échange les deux : tout le motif pivote, décalage compris, et
  // l'algorithme ci-dessous n'a pas à le savoir.
  final flip = input.flip;
  final margin = input.perimeterGap;

  // Zone de pose, et non surface : le jeu périphérique se retire des quatre
  // bords. Tout ce qui suit travaille dedans, et l'origine revient au repère
  // de la surface au moment de poser le rectangle.
  final su = (flip ? input.surfaceY : input.surfaceX) - 2 * margin;
  final sv = (flip ? input.surfaceX : input.surfaceY) - 2 * margin;
  final eu = input.elementX;
  final ev = input.elementY;

  // Les jeux, eux, restent définis à l'écran : `gapX` reste horizontal et
  // `gapY` vertical, quel que soit le sens de pose.
  final gapU = flip ? input.gapY : input.gapX;
  final gapV = flip ? input.gapX : input.gapY;

  if (eu > su + _eps || ev > sv + _eps) {
    // Avec un jeu périphérique, la zone à couvrir n'est plus la surface saisie
    // et l'écart ne se voit nulle part : le message porte donc les deux cotes.
    throw CalcException(
      "L'élément fait ${formatNumber(eu)} × ${formatNumber(ev)} mm pour une "
      'zone à couvrir de ${formatNumber(su)} × ${formatNumber(sv)} mm',
    );
  }

  _guardVolume(su: su, sv: sv, eu: eu, ev: ev, gapU: gapU, gapV: gapV);

  // L'axe d'empilement s'équilibre toujours ; l'axe de pose seulement en
  // décalage droit. Deux raisons qui pointent au même endroit : sous un
  // décalage, chaque rangée démarre ailleurs, donc il n'existe plus de pièce
  // de bout commune à équilibrer — et l'équilibrage s'exprime de toute façon
  // par le départ de rangée, que le décalage occupe déjà.
  final balance = input.balanceRows;
  final balancedRow = balance ? _balancedEdge(sv, ev, gapV) : null;
  final balancedEnd = balance && input.offset == JointOffset.straight
      ? _balancedEdge(su, eu, gapU)
      : null;

  final step = switch (input.offset) {
    JointOffset.straight => 0.0,
    JointOffset.half => eu / 2,
    JointOffset.third => eu / 3,
  };

  // Équilibrer un bord revient à démarrer en arrière de ce bord : la première
  // bande est rognée à l'épaisseur voulue, et la dernière déborde d'autant,
  // donc tombe à la même. C'est le mécanisme du décalage de joints, et c'est
  // pourquoi les deux ne peuvent pas jouer sur le même axe.
  final startV = balancedRow == null ? 0.0 : -(ev - balancedRow);
  final baseU = balancedEnd == null ? 0.0 : -(eu - balancedEnd);

  final elements = <PlacedElement>[];
  var fullCount = 0;
  var cutCount = 0;
  var coveredArea = 0.0;

  // Une rangée peut être rabotée par l'un ou l'autre bord de la zone de pose :
  // par le bord opposé quand elle tombe en dernier, par le bord de départ
  // quand l'équilibrage l'a fait commencer en arrière.
  var rowIndex = 0;
  for (var v = startV; v < sv - _eps; v += ev + gapV, rowIndex++) {
    final vNear = math.max(v, 0.0);
    final thickness = math.min(v + ev, sv) - vNear;
    if (thickness <= _eps) continue;
    final rowIsCut = thickness < ev - _eps;

    // Un départ de rangée négatif coupe la première pièce.
    final startU = baseU - ((rowIndex * step) % eu);

    for (var u = startU; u < su - _eps; u += eu + gapU) {
      final near = math.max(u, 0.0);
      final far = math.min(u + eu, su);
      final length = far - near;
      if (length <= _eps) continue;

      final isCut = rowIsCut || length < eu - _eps;
      // Retour au repère de la surface, jeu périphérique compris.
      elements.add(
        flip
            ? PlacedElement(
                x: margin + vNear,
                y: margin + near,
                w: thickness,
                h: length,
                isCut: isCut,
              )
            : PlacedElement(
                x: margin + near,
                y: margin + vNear,
                w: length,
                h: thickness,
                isCut: isCut,
              ),
      );
      if (isCut) {
        cutCount++;
      } else {
        fullCount++;
      }
      coveredArea += length * thickness;
    }
  }

  // Une coupe = un élément consommé, sans réemploi de chute : la perte est
  // volontairement pessimiste.
  final totalCount = fullCount + cutCount;
  final stockArea = totalCount * eu * ev;
  final wastePercent = stockArea <= 0
      ? 0.0
      : (stockArea - coveredArea) / stockArea * 100;

  return LayoutResult(
    elements: List.unmodifiable(elements),
    fullCount: fullCount,
    cutCount: cutCount,
    totalCount: totalCount,
    surfaceArea: input.surfaceX * input.surfaceY,
    coveredArea: coveredArea,
    wastePercent: wastePercent,
    balancedRow: balancedRow,
    balancedEnd: balancedEnd,
  );
}

/// Tolérance de comparaison, en mm — absorbe les résidus de virgule flottante
/// du cumul des rangées et du modulo de décalage.
const double _eps = 1e-6;

/// Épaisseur commune des deux bandes de bord, ou `null` si la règle « ne
/// jamais finir sur un filet » ne s'applique pas.
///
/// Sur une portée [s], pour un élément [e] séparé d'un jeu [g] : `n` bandes
/// pleines, et un reliquat `r` qui est l'épaisseur de la bande rabotée.
///
/// Trois sorties qui ne touchent à rien, et c'est ce qui en fait une règle
/// plutôt qu'un recentrage systématique : ça tombe juste (`r ≤ 0`), la bande
/// de bord est une bande normale et non un filet (`r ≥ e / 2`), ou il n'y a
/// pas deux bandes pleines à sacrifier.
///
/// Invariant : le résultat tient dans `[e / 2, 3e / 4[`, donc la règle garantit
/// exactement ce que son seuil énonce.
double? _balancedEdge(double s, double e, double g) {
  final pitch = e + g;
  final n = ((s - e + _eps) / pitch).floor() + 1;
  if (n < 2) return null;

  final r = s - n * pitch;
  if (r <= _eps || r >= e / 2 - _eps) return null;

  return (e + r) / 2;
}

/// Refuse une saisie qui demanderait plus de [kMaxLayoutElements] rectangles.
///
/// Estimation volontairement haute et calculée en `double` : un `ceil()` sur
/// un quotient énorme déborde l'entier 64 bits, et c'est précisément la saisie
/// qu'on cherche à attraper.
void _guardVolume({
  required double su,
  required double sv,
  required double eu,
  required double ev,
  required double gapU,
  required double gapV,
}) {
  final rows = (sv / (ev + gapV)).ceilToDouble();
  // Un départ de rangée négatif — décalage ou équilibrage — ajoute au plus une
  // pièce à la rangée.
  final cols = ((su + eu) / (eu + gapU)).ceilToDouble();
  if (rows * cols > kMaxLayoutElements) {
    // L'ordre de grandeur plutôt que le seul plafond : sur une faute de frappe
    // il y a deux zéros d'écart, et c'est ça qui dit où chercher.
    throw CalcException(
      'Cette saisie demanderait ${formatNumber(rows * cols)} éléments, '
      '$kMaxLayoutElements au maximum',
    );
  }
}

void _validate(LayoutInput input) {
  // Les cotes se nomment ici comme à l'écran. Un refus qui parlerait de
  // « Surface X » enverrait chercher un champ qui n'existe pas.
  final dims = {
    'La largeur de surface': input.surfaceX,
    'La longueur de surface': input.surfaceY,
    "La largeur d'élément": input.elementX,
    "La longueur d'élément": input.elementY,
  };
  for (final entry in dims.entries) {
    if (!entry.value.isFinite || entry.value <= 0) {
      throw CalcException('${entry.key} doit être un nombre positif');
    }
  }

  final gaps = {
    'Le jeu horizontal': input.gapX,
    'Le jeu vertical': input.gapY,
    'Le jeu périphérique': input.perimeterGap,
  };
  for (final entry in gaps.entries) {
    if (!entry.value.isFinite || entry.value < 0) {
      throw CalcException('${entry.key} ne peut pas être négatif');
    }
  }

  final smallest = math.min(input.surfaceX, input.surfaceY);
  if (2 * input.perimeterGap >= smallest) {
    throw CalcException(
      'Le jeu périphérique de ${formatNumber(input.perimeterGap)} mm ne laisse '
      'rien à couvrir sur ${formatNumber(smallest)} mm',
    );
  }
}
