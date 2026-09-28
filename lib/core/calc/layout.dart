import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/enums.dart';
import 'calc_exception.dart';

part 'layout.freezed.dart';
part 'layout.g.dart';

/// Borne de volume, en éléments posés.
///
/// Un élément de 1 mm sur une surface d'atelier demanderait des millions de
/// rectangles et figerait l'app.
const int kMaxLayoutElements = 5000;

/// Convention d'axes : les éléments s'alignent le long d'un axe de pose, les
/// rangées s'empilent perpendiculairement. Sans inversion, l'axe de pose est X.
@freezed
abstract class LayoutInput with _$LayoutInput {
  const factory LayoutInput({
    required double surfaceX,
    required double surfaceY,
    required double elementX,
    required double elementY,
    @Default(0.0) double gapX,
    @Default(0.0) double gapY,

    /// Retrait sur les quatre bords avant de poser, en mm.
    ///
    /// [LayoutResult.surfaceArea] reste l'aire de la surface entière.
    @Default(0.0) double perimeterGap,

    /// Ne jamais finir sur un filet.
    ///
    /// Sous un demi-élément, la dernière bande partage son épaisseur avec la
    /// première. Seul [LayoutResult.cutCount] change : deux bandes à couper.
    @Default(false) bool balanceRows,

    /// Pivote le motif d'un quart de tour : l'élément se pose le long de Y.
    ///
    /// Le décalage des joints suit la rotation, le long des lames.
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

    /// `fullCount + cutCount` : stock sans réemploi des chutes.
    required int totalCount,
    required double surfaceArea,
    required double coveredArea,
    required double wastePercent,

    /// Épaisseur commune des deux rangées de bord, si l'équilibrage a joué ;
    /// sinon `null`.
    double? balancedRow,

    /// Longueur commune des deux pièces de bout, si l'équilibrage a joué sur
    /// l'axe de pose. Nul sous tout décalage autre que droit.
    double? balancedEnd,
  }) = _LayoutResult;
}

/// Une cote de coupe et le nombre de pièces qui la portent.
@freezed
abstract class CutPiece with _$CutPiece {
  const factory CutPiece({
    required double w,
    required double h,
    required int count,
  }) = _CutPiece;
}

/// Les pièces à couper, groupées par cote : la liste de débit.
///
/// Les cotes se regroupent à l'arrondi d'affichage : deux coupes écrites
/// pareil sont la même coupe.
List<CutPiece> summarizeCuts(LayoutResult result) {
  final counts = <(double, double), int>{};
  for (final element in result.elements) {
    if (!element.isCut) continue;
    final key = (_roundCut(element.w), _roundCut(element.h));
    counts[key] = (counts[key] ?? 0) + 1;
  }

  final pieces = [
    for (final entry in counts.entries)
      CutPiece(w: entry.key.$1, h: entry.key.$2, count: entry.value),
  ];
  // De la plus grande à la plus petite, l'ordre d'une liste de débit.
  pieces.sort((a, b) => (b.w * b.h).compareTo(a.w * a.h));
  return List.unmodifiable(pieces);
}

/// Arrondi de regroupement, au dixième de millimètre.
double _roundCut(double mm) => (mm * 10).roundToDouble() / 10;

/// Pose des éléments rectangulaires identiques sur une surface rectangulaire.
///
/// Sans réemploi des chutes : chaque pièce partielle consomme un élément.
LayoutResult computeLayout(LayoutInput input) {
  _validate(input);

  // Repère de pose : `u` est l'axe de pose, `v` l'axe d'empilement.
  // L'inversion les échange, décalage compris.
  final flip = input.flip;
  final margin = input.perimeterGap;

  // Zone de pose : la surface moins le jeu périphérique. L'origine revient
  // au repère de la surface au moment de poser.
  final su = (flip ? input.surfaceY : input.surfaceX) - 2 * margin;
  final sv = (flip ? input.surfaceX : input.surfaceY) - 2 * margin;
  final eu = input.elementX;
  final ev = input.elementY;

  // Les jeux restent définis à l'écran : `gapX` horizontal, `gapY` vertical.
  final gapU = flip ? input.gapY : input.gapX;
  final gapV = flip ? input.gapX : input.gapY;

  if (eu > su + _eps || ev > sv + _eps) {
    throw CalcException(
      TileLargerThanSurface(
        tileWidth: eu,
        tileLength: ev,
        surfaceWidth: su,
        surfaceLength: sv,
      ),
    );
  }

  _guardVolume(su: su, sv: sv, eu: eu, ev: ev, gapU: gapU, gapV: gapV);

  // L'axe de pose ne s'équilibre qu'en décalage droit : le décalage occupe
  // déjà le départ de rangée.
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

  // Équilibrer un bord revient à démarrer en arrière : la première bande est
  // rognée, la dernière déborde d'autant.
  final startV = balancedRow == null ? 0.0 : -(ev - balancedRow);
  final baseU = balancedEnd == null ? 0.0 : -(eu - balancedEnd);

  final elements = <PlacedElement>[];
  var fullCount = 0;
  var cutCount = 0;
  var coveredArea = 0.0;

  // Une rangée peut être rabotée par le bord opposé ou, sous équilibrage, par
  // le bord de départ.
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

  // Une coupe consomme un élément, sans réemploi de chute.
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

/// Tolérance de comparaison, en mm, contre les résidus de virgule flottante.
const double _eps = 1e-6;

/// Épaisseur commune des deux bandes de bord, ou `null` si la règle « ne
/// jamais finir sur un filet » ne s'applique pas.
///
/// Portée [s], élément [e], jeu [g]. Le résultat tient dans `[e / 2, 3e / 4[`.
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
/// Estimation haute en `double` : un `ceil()` entier déborderait sur 64 bits.
void _guardVolume({
  required double su,
  required double sv,
  required double eu,
  required double ev,
  required double gapU,
  required double gapV,
}) {
  final rows = (sv / (ev + gapV)).ceilToDouble();
  // Un départ de rangée négatif ajoute au plus une pièce.
  final cols = ((su + eu) / (eu + gapU)).ceilToDouble();
  if (rows * cols > kMaxLayoutElements) {
    // Le compte estimé, pas seulement le plafond, montre l'ordre de grandeur.
    throw CalcException(
      TooManyTiles(count: rows * cols, maxCount: kMaxLayoutElements),
    );
  }
}

void _validate(LayoutInput input) {
  for (final (field, value) in [
    (PositiveField.surfaceWidth, input.surfaceX),
    (PositiveField.surfaceLength, input.surfaceY),
    (PositiveField.tileWidth, input.elementX),
    (PositiveField.tileLength, input.elementY),
  ]) {
    if (!value.isFinite || value <= 0) {
      throw CalcException(MustBePositive(field));
    }
  }

  for (final (field, value) in [
    (NonNegativeField.horizontalGap, input.gapX),
    (NonNegativeField.verticalGap, input.gapY),
    (NonNegativeField.perimeterGap, input.perimeterGap),
  ]) {
    if (!value.isFinite || value < 0) {
      throw CalcException(MustNotBeNegative(field));
    }
  }

  final smallest = math.min(input.surfaceX, input.surfaceY);
  if (2 * input.perimeterGap >= smallest) {
    throw CalcException(
      PerimeterGapFillsSurface(gap: input.perimeterGap, smallest: smallest),
    );
  }
}
