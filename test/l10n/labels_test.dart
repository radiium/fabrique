import 'package:fabrique/core/models/measure_unit.dart';
import 'package:fabrique/l10n/labels.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/l10n.dart';

void main() {
  test('symboles distincts au sein d’une grandeur, dans chaque langue', () {
    for (final l10n in allLocales) {
      for (final q in Quantity.values) {
        final symbols = q.units.map((u) => u.symbol(l10n)).toSet();
        expect(symbols.length, q.units.length, reason: q.label(l10n));
      }
    }
  });

  test('les symboles impériaux suivent la langue', () {
    expect(MeasureUnit.inch.symbol(fr), 'po');
    expect(MeasureUnit.inch.symbol(en), 'in');
    expect(MeasureUnit.foot2.symbol(en), 'ft²');
  });
}
