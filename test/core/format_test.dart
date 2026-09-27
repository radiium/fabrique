import 'package:fabrique/core/format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('une cote s’écrit avec le séparateur demandé, zéros rognés', () {
    expect(formatNumber(2.5), '2.5');
    expect(formatNumber(2.5, decimalSeparator: ','), '2,5');
    expect(formatNumber(100, decimalSeparator: ','), '100');
    expect(formatNumber(1234.5, decimalSeparator: ','), '1234,5');
  });

  test('un angle garde son dixième, sans signe devant zéro', () {
    expect(formatDegrees(-0.01, decimalSeparator: ','), '0,0');
    expect(formatDegrees(1.25), '1.3');
  });
}
