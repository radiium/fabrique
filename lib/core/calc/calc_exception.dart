import 'calc_error.dart';

export 'calc_error.dart';

/// Erreur levée par la couche `core/calc` sur une entrée invalide.
///
/// Convention : jamais de valeur silencieuse fausse — une saisie incohérente
/// lève, l'UI décide comment l'afficher. Elle porte un motif, pas une phrase :
/// la phrase dépend de la langue, que le cœur ignore.
class CalcException implements Exception {
  const CalcException(this.reason);

  final CalcError reason;

  @override
  String toString() => 'CalcException: ${reason.runtimeType}';
}
