import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

/// Le téléphone de référence des tests d'écran : 400 × 844 px, densité 1.
///
/// C'est sur cette largeur que se mesurent les libellés tronqués (164 px par
/// segment dans un sélecteur à deux). La changer revient à changer tous ces
/// seuils à la fois.
const Size kReferencePhone = Size(400, 844);

/// Pose [kReferencePhone] le temps du test.
void usePhone(WidgetTester tester) {
  tester.view.physicalSize = kReferencePhone;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}
