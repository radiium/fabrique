import 'calc_error.dart';

export 'calc_error.dart';

/// Erreur levée par la couche `core/calc` sur une entrée invalide.
///
/// Porte un motif, pas une phrase : l'UI la rédige dans sa langue.
class CalcException implements Exception {
  const CalcException(this.reason);

  final CalcError reason;

  @override
  String toString() => 'CalcException: ${reason.runtimeType}';
}
