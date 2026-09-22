import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/enums.dart';
import 'calc_exception.dart';

part 'fasteners.freezed.dart';
part 'fasteners.g.dart';

/// Coefficient d'avant-trou de guidage par matériau : `pilotHole = k * Ø`.
///
/// ⚠️ Règles de l'art indicatives, centralisées ici pour être ajustées et
/// validées à part. Le calcul ne fait qu'appliquer la table.
const Map<MaterialKind, double> pilotHoleFactor = {
  MaterialKind.softwood: 0.55,
  MaterialKind.hardwood: 0.70,
  MaterialKind.chipboard: 0.60,
  MaterialKind.plywood: 0.65,
};

/// Jeu ajouté au Ø nominal pour le trou de passage, en mm.
const double clearanceAllowance = 0.5;

/// Plafond de pénétration dans la pièce support, en mm.
const double maxPenetration = 60;

/// Ø de lamage : `counterboreDia = k * Ø`, calé sur un Ø de tête courant.
const double counterboreDiaFactor = 2.0;

/// Profondeur de lamage ≈ hauteur de tête : `counterboreDepth = k * Ø`.
const double counterboreDepthFactor = 0.6;

/// Pénétration visée dans la pièce support : `k * épaisseur traversée`,
/// écrêtée à [maxPenetration].
const double penetrationFactor = 2.0;

/// Ø nominal minimal accepté, en mm.
///
/// En dessous, `clearanceHole = Ø + 0.5` rattraperait `counterboreDia = 2 * Ø`
/// et l'invariant `pilotHole < clearanceHole < counterboreDia` tomberait : on
/// préfère lever plutôt que rendre une cote incohérente.
const double minScrewDiameter = 1.0;

@freezed
abstract class FastenerInput with _$FastenerInput {
  const factory FastenerInput({
    required MaterialKind material,

    /// Ø nominal de la vis, en mm.
    required double screwDiameter,

    /// Épaisseur de la pièce traversée, en mm.
    required double fixedThickness,
  }) = _FastenerInput;

  factory FastenerInput.fromJson(Map<String, dynamic> json) =>
      _$FastenerInputFromJson(json);
}

@freezed
abstract class FastenerResult with _$FastenerResult {
  const factory FastenerResult({
    /// Ø du trou de passage.
    required double clearanceHole,

    /// Ø de l'avant-trou de guidage.
    required double pilotHole,
    required double counterboreDia,
    required double counterboreDepth,
    required double screwLength,
    required double penetration,
  }) = _FastenerResult;
}

/// Applique la table de règles ci-dessus.
///
/// Invariant : `pilotHole < clearanceHole < counterboreDia`.
FastenerResult computeFastener(FastenerInput input) {
  final d = input.screwDiameter;
  final thickness = input.fixedThickness;

  if (!d.isFinite || !thickness.isFinite) {
    throw const CalcException('Cote non finie');
  }
  if (d <= 0) {
    throw const CalcException('Ø de vis nul ou négatif');
  }
  if (d < minScrewDiameter) {
    throw const CalcException('Ø de vis hors plage');
  }
  if (thickness <= 0) {
    throw const CalcException('Épaisseur nulle ou négative');
  }

  final penetration = math.min(penetrationFactor * thickness, maxPenetration);

  return FastenerResult(
    clearanceHole: d + clearanceAllowance,
    pilotHole: pilotHoleFactor[input.material]! * d,
    counterboreDia: counterboreDiaFactor * d,
    counterboreDepth: counterboreDepthFactor * d,
    screwLength: thickness + penetration,
    penetration: penetration,
  );
}
