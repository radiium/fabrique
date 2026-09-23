import 'dart:typed_data';

/// Jamais appelée hors du web — l'appelant garde l'accès derrière `kIsWeb`.
///
/// Elle lève plutôt que de ne rien faire : un jour où la garde sauterait, un
/// export silencieusement perdu serait pire qu'un plantage.
Future<void> downloadPlan(Uint8List bytes, String fileName) =>
    throw UnsupportedError('Le téléchargement n’existe que sur le web.');
