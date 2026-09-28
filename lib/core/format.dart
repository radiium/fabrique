/// Rendu des nombres côté UI : combien de décimales une cote mérite.
library;

/// Ce qu'affiche une valeur indisponible : saisie refusée.
const String kNoValue = '—';

/// Formate une cote sans zéros inutiles : `100`, `2.5`, `0.0394`.
///
/// La précision suit la magnitude. `null` ou valeur non finie → [kNoValue].
/// [decimalSeparator] vient de la langue (`l10n.number`).
String formatNumber(double? value, {String decimalSeparator = '.'}) {
  if (value == null || !value.isFinite) return kNoValue;

  final magnitude = value.abs();
  final decimals = switch (magnitude) {
    >= 1000 => 1,
    >= 100 => 2,
    >= 1 => 3,
    _ => 4,
  };

  final text = value.toStringAsFixed(decimals);
  if (!text.contains('.')) return text;
  // Rogne les zéros de queue, et le point s'il reste seul.
  return text
      .replaceFirst(RegExp(r'\.?0+$'), '')
      .replaceFirst('.', decimalSeparator);
}

/// Formate un angle au dixième de degré, sans le symbole.
///
/// Précision fixe, pour une valeur qui bouge en continu. `-0.0` devient `0.0`.
String formatDegrees(double? value, {String decimalSeparator = '.'}) {
  if (value == null || !value.isFinite) return kNoValue;
  final text = value.toStringAsFixed(1);
  return (text == '-0.0' ? '0.0' : text).replaceFirst('.', decimalSeparator);
}
