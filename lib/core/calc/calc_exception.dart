/// Erreur levée par la couche `core/calc` sur une entrée invalide.
///
/// Convention : jamais de valeur silencieuse fausse — une saisie incohérente
/// lève, l'UI décide comment l'afficher.
class CalcException implements Exception {
  const CalcException(this.message);

  final String message;

  @override
  String toString() => 'CalcException: $message';
}
