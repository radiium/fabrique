import 'package:freezed_annotation/freezed_annotation.dart';

import '../calc_exception.dart';

part 'imperial.freezed.dart';
part 'imperial.g.dart';

/// Longueur impériale composée : pieds + pouces + fraction de pouce.
@freezed
abstract class ImperialParts with _$ImperialParts {
  const factory ImperialParts({
    required int feet,
    required int inches,

    /// Numérateur de la fraction de pouce (0 si valeur entière).
    required int num,

    /// Dénominateur de la fraction (16, 32…).
    required int den,
  }) = _ImperialParts;

  factory ImperialParts.fromJson(Map<String, dynamic> json) =>
      _$ImperialPartsFromJson(json);
}

/// Millimètres dans un pouce.
const double _mmPerInch = 25.4;

/// Pouces dans un pied.
const int _inchesPerFoot = 12;

/// Décompose [mm] en pied/pouce/fraction, arrondi au 1/[denominator] de pouce.
///
/// Propage les retenues (16/16 → +1 po ; 12 po → +1 pi) et réduit la fraction
/// (6/16 → 3/8). Une valeur entière rend `num: 0, den: 1`.
ImperialParts mmToImperial(double mm, {int denominator = 16}) {
  if (!mm.isFinite) {
    throw const CalcException(NonFiniteValue());
  }
  if (mm < 0) {
    throw const CalcException(NegativeLength());
  }
  if (denominator < 1) {
    throw const CalcException(InvalidDenominator());
  }

  // En crans de 1/denominator de pouce : l'arrondi propage les retenues.
  final ticks = (mm / _mmPerInch * denominator).round();
  final ticksPerFoot = _inchesPerFoot * denominator;

  final feet = ticks ~/ ticksPerFoot;
  final rest = ticks % ticksPerFoot;
  final inches = rest ~/ denominator;

  var num = rest % denominator;
  var den = denominator;
  final divisor = _gcd(num, den);
  num ~/= divisor;
  den ~/= divisor;

  return ImperialParts(feet: feet, inches: inches, num: num, den: den);
}

/// Recompose une longueur impériale en millimètres.
double imperialToMm(ImperialParts p) {
  if (p.den < 1) {
    throw const CalcException(InvalidDenominator());
  }
  if (p.feet < 0 || p.inches < 0 || p.num < 0) {
    throw const CalcException(NegativeLength());
  }
  final totalInches = p.feet * _inchesPerFoot + p.inches + p.num / p.den;
  return totalInches * _mmPerInch;
}

/// Formate pour l'affichage, ex. `2' 6 3/8"`.
String formatImperial(ImperialParts p) {
  if (p.den < 1) {
    throw const CalcException(InvalidDenominator());
  }

  final fraction = p.num > 0 ? '${p.num}/${p.den}' : '';

  // Les pouces s'affichent s'il y a des pieds ou pas de fraction : `1' 0"`,
  // `5/8"`.
  final showInches = p.inches > 0 || p.feet > 0 || fraction.isEmpty;
  final inchPart = [
    if (showInches) '${p.inches}',
    if (fraction.isNotEmpty) fraction,
  ].join(' ');

  return [if (p.feet > 0) "${p.feet}'", '$inchPart"'].join(' ');
}

int _gcd(int a, int b) {
  while (b != 0) {
    final t = b;
    b = a % b;
    a = t;
  }
  return a == 0 ? 1 : a;
}
