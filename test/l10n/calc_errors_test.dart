import 'package:fabrique/core/calc/calc_error.dart';
import 'package:fabrique/core/models/measure_unit.dart';
import 'package:fabrique/l10n/calc_errors.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/l10n.dart';

void main() {
  /// Un motif de chaque sorte, chaque champ compris.
  final samples = <CalcError>[
    const IncompleteInput(),
    const NonFiniteValue(),
    const NegativeLength(),
    const InvalidDenominator(),
    const IncompatibleUnits(MeasureUnit.inch, MeasureUnit.kilogram),
    const InvalidLevelThreshold(),
    const InvalidSensorReading(),
    for (final field in PositiveField.values) MustBePositive(field),
    for (final field in NonNegativeField.values) MustNotBeNegative(field),
    const MarginsFillWidth(),
    const TooFewElements(2),
    const TooManyElements(500),
    const ElementsOverflow(count: 11, occupied: 110, available: 100),
    const WidthAndGapBothZero(),
    const NoDistributionForGap(),
    const GapTooSmall(500),
    const TileLargerThanSurface(
      tileWidth: 2000,
      tileLength: 100,
      surfaceWidth: 1000,
      surfaceLength: 1000,
    ),
    const TooManyTiles(count: 6e6, maxCount: 100000),
    const PerimeterGapFillsSurface(gap: 500, smallest: 1000),
    const NoDrawer(),
    const FrontGapsFillWidth(),
    const FrontGapsFillHeight(),
    const InsetFrontFillsDepth(),
    const SlideAndSidesTooWide(needed: 55.4, opening: 50),
    const BoxTooShort(12),
    const BoxTooLow(height: 40.5, drawer: 3, minimum: 60),
    const GrooveThroughSide(groove: 15, side: 15),
    const FixedHeightsTooTall(fixed: 900, available: 750),
    const SlideTooLong(slide: 600, usefulDepth: 540),
    const DepthTooShortForSlides(usefulDepth: 200, shortestSlide: 250),
  ];

  test('chaque refus se rédige dans chaque langue, sans nom de code', () {
    // « Surface X » enverrait chercher un champ qui n'existe pas : un refus
    // nomme les cotes comme l'écran.
    for (final l10n in allLocales) {
      for (final error in samples) {
        final message = l10n.calcError(error);
        expect(message.trim(), isNotEmpty, reason: '$error');
        for (final codeish in ['Surface X', 'Élément X', 'Jeu X', 'null']) {
          expect(message, isNot(contains(codeish)), reason: message);
        }
      }
    }
  });

  test('les cotes d’un refus prennent le séparateur de la langue', () {
    const error = SlideAndSidesTooWide(needed: 55.4, opening: 50);
    expect(fr.calcError(error), contains('55,4 mm'));
    expect(en.calcError(error), contains('55.4 mm'));
  });

  test('un compte s’accorde au pluriel', () {
    expect(fr.calcError(const TooFewElements(1)), endsWith('1 élément'));
    expect(fr.calcError(const TooFewElements(2)), endsWith('2 éléments'));
    expect(en.calcError(const TooFewElements(1)), endsWith('1 piece'));
    expect(
      fr.calcError(
        const ElementsOverflow(count: 11, occupied: 110, available: 100),
      ),
      startsWith('Les 11 éléments occupent 110 mm'),
    );
  });

  test('une conversion impossible nomme les unités dans la langue', () {
    const error = IncompatibleUnits(MeasureUnit.inch, MeasureUnit.kilogram);
    expect(fr.calcError(error), contains('po (Longueur)'));
    expect(en.calcError(error), contains('in (Length)'));
  });
}
