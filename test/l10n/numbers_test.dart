import 'package:fabrique/l10n/numbers.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/l10n.dart';

void main() {
  test('les nombres prennent le séparateur décimal de la langue', () {
    expect(fr.number(2.5), '2,5');
    expect(en.number(2.5), '2.5');
    expect(fr.degrees(0.4), '0,4');
  });
}
