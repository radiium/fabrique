import 'dart:io';

import 'package:fabrique/app/version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('la version affichée est celle du pubspec', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final match = RegExp(
      r'^version:\s*([^+\s]+)',
      multiLine: true,
    ).firstMatch(pubspec);
    expect(match?.group(1), kAppVersion);
  });
}
