/// Le téléchargement d'un plan, sur le web.
///
/// Import conditionnel : la souche remplace la version web ailleurs, pour que
/// `dart:js_interop` n'entre pas dans un build mobile.
library;

export 'plan_download_stub.dart'
    if (dart.library.js_interop) 'plan_download_web.dart';
