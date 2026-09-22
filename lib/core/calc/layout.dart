import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/enums.dart';
import 'calc_exception.dart';

part 'layout.freezed.dart';
part 'layout.g.dart';

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

    /// `fullCount + cutCount` — stock v1, sans réemploi des chutes.
    required int totalCount,
    required double surfaceArea,
    required double coveredArea,
    required double wastePercent,
  }) = _LayoutResult;
}

/// Pose des éléments rectangulaires identiques sur une surface rectangulaire.
///
/// v1 « honnête simple » : chaque départ de rangée décalé compte comme une
/// coupe, sans réemploi des chutes → `wastePercent` légèrement pessimiste.
LayoutResult computeLayout(LayoutInput input) {
  _validate(input);

  // Repère de pose. `u` est l'axe le long duquel les éléments s'alignent et le
  // long duquel joue le décalage ; `v` est l'axe d'empilement des rangées.
  // L'inversion échange les deux : tout le motif pivote, décalage compris, et
  // l'algorithme ci-dessous n'a pas à le savoir.
  final flip = input.flip;
  final su = flip ? input.surfaceY : input.surfaceX;
  final sv = flip ? input.surfaceX : input.surfaceY;
  final eu = input.elementX;
  final ev = input.elementY;

  // Les jeux, eux, restent définis à l'écran : `gapX` reste horizontal et
  // `gapY` vertical, quel que soit le sens de pose.
  final gapU = flip ? input.gapY : input.gapX;
  final gapV = flip ? input.gapX : input.gapY;

  if (eu > su + _eps || ev > sv + _eps) {
    throw const CalcException('Élément plus grand que la surface');
  }

  final step = switch (input.offset) {
    JointOffset.straight => 0.0,
    JointOffset.half => eu / 2,
    JointOffset.third => eu / 3,
  };

  final elements = <PlacedElement>[];
  var fullCount = 0;
  var cutCount = 0;
  var coveredArea = 0.0;

  // La dernière rangée peut être rabotée par le bord de la surface.
  var rowIndex = 0;
  for (var v = 0.0; v < sv - _eps; v += ev + gapV, rowIndex++) {
    final thickness = math.min(ev, sv - v);
    final rowIsCut = thickness < ev - _eps;

    // Un départ de rangée négatif coupe la première pièce.
    final startU = -((rowIndex * step) % eu);

    for (var u = startU; u < su - _eps; u += eu + gapU) {
      final near = math.max(u, 0.0);
      final far = math.min(u + eu, su);
      final length = far - near;
      if (length <= _eps) continue;

      final isCut = rowIsCut || length < eu - _eps;
      // Retour au repère de la surface.
      elements.add(
        flip
            ? PlacedElement(
                x: v,
                y: near,
                w: thickness,
                h: length,
                isCut: isCut,
              )
            : PlacedElement(
                x: near,
                y: v,
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
  );
}

/// Tolérance de comparaison, en mm — absorbe les résidus de virgule flottante
/// du cumul des rangées et du modulo de décalage.
const double _eps = 1e-6;

void _validate(LayoutInput input) {
  final dims = {
    'Surface X': input.surfaceX,
    'Surface Y': input.surfaceY,
    'Élément X': input.elementX,
    'Élément Y': input.elementY,
  };
  for (final entry in dims.entries) {
    if (!entry.value.isFinite) {
      throw CalcException('${entry.key} non finie');
    }
    if (entry.value <= 0) {
      throw CalcException('${entry.key} nulle ou négative');
    }
  }

  final gaps = {'Jeu X': input.gapX, 'Jeu Y': input.gapY};
  for (final entry in gaps.entries) {
    if (!entry.value.isFinite) {
      throw CalcException('${entry.key} non fini');
    }
    if (entry.value < 0) {
      throw CalcException('${entry.key} négatif');
    }
  }
}
