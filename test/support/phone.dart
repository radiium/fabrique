import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

/// Le téléphone de référence des tests d'écran : 400 × 844 px, densité 1.
///
/// Les seuils de troncature des libellés se mesurent sur cette largeur.
const Size kReferencePhone = Size(400, 844);

/// Pose [kReferencePhone] le temps du test.
void usePhone(WidgetTester tester) {
  tester.view.physicalSize = kReferencePhone;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}
