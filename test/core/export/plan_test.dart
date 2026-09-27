import 'package:fabrique/core/export/plan.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/l10n.dart';

void main() {
  test('la date du cartouche suit l’ordre de la langue', () {
    final date = DateTime(2026, 9, 3);
    expect(formatPlanDate(date, fr), '03/09/2026');
    expect(formatPlanDate(date, en), '09/03/2026');
  });
}
