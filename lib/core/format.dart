/// Rendu des nombres côté UI.
///
/// Le cœur de calcul travaille en `double` bruts ; c'est ici que l'on décide
/// combien de décimales une cote mérite à l'écran. Partagé par tous les écrans
/// pour que « 0.1 » s'écrive pareil partout.
library;

/// Ce qu'affiche une valeur indisponible — saisie invalide, calcul qui a levé.
///
/// Convention de `core/calc` : une entrée incohérente rend `null`, jamais une
/// valeur fausse. L'UI la matérialise par ce tiret.
const String kNoValue = '—';

/// Formate une cote sans zéros inutiles : `100`, `2.5`, `0.0394`.
///
/// La précision suit la magnitude — une cote en mètres a besoin de plus de
/// décimales qu'une cote en millimètres pour rester exploitable.
/// `null` ou valeur non finie → [kNoValue].
String formatNumber(double? value) {
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
  // Rogne la queue de zéros, et le point s'il ne reste plus rien derrière.
  return text.replaceFirst(RegExp(r'\.?0+$'), '');
}

/// Formate un angle au dixième de degré, sans le symbole — l'appelant le pose
/// lui-même (`unit: '°'` sur une tuile, accolé dans un schéma).
///
/// Contrairement à [formatNumber], la précision est fixe : un angle de niveau
/// se lit au dixième, et une décimale qui danse au gré de la magnitude serait
/// illisible sur une valeur qui bouge en continu.
///
/// `-0.0` est ramené à `0.0` : le signe laisserait croire à une inclinaison là
/// où il n'y en a pas.
String formatDegrees(double? value) {
  if (value == null || !value.isFinite) return kNoValue;
  final text = value.toStringAsFixed(1);
  return text == '-0.0' ? '0.0' : text;
}

/// Marque du pluriel après un compte : `''` pour 0 et 1, `'s'` au-delà.
///
/// La règle française, où zéro reste au singulier (« 0 élément »).
String pluralS(int count) => count > 1 ? 's' : '';
