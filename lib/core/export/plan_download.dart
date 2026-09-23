/// Le téléchargement d'un plan, sur le web.
///
/// Import conditionnel : la version web est la seule qui existe vraiment, et
/// la souche prend sa place partout ailleurs pour que `dart:js_interop` ne
/// parte jamais dans un build mobile.
library;

export 'plan_download_stub.dart'
    if (dart.library.js_interop) 'plan_download_web.dart';
