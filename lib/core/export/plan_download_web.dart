import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Télécharge le plan par le navigateur — le geste « enregistrer » du web.
///
/// Un lien de téléchargement : l'API Web Share ne prend les fichiers que sur
/// peu de navigateurs.
Future<void> downloadPlan(Uint8List bytes, String fileName) async {
  final blob = web.Blob(
    <JSAny>[bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'image/png'),
  );
  final url = web.URL.createObjectURL(blob);

  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = url
    ..download = fileName;
  // Posé dans le document avant le clic : Firefox ignore un clic sur un lien
  // détaché de l'arbre.
  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();

  // L'URL objet ne se libère pas dans la foulée du clic : Safari abandonne le
  // téléchargement si la source disparaît avant qu'il l'ait lue.
  await Future<void>.delayed(const Duration(seconds: 1));
  web.URL.revokeObjectURL(url);
}
