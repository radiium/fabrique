import 'dart:typed_data';

/// Jamais appelée hors du web. Lève plutôt que de perdre un export en
/// silence.
Future<void> downloadPlan(Uint8List bytes, String fileName) =>
    throw UnsupportedError('Le téléchargement n’existe que sur le web.');
