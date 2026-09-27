// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fabrique';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get themeLightLocked => 'Light';

  @override
  String get haptics => 'Haptic feedback';

  @override
  String get hapticsHelp =>
      'Short vibration on the − / + buttons and selectors.';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Phone language';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsLockedSection => 'Locked for this version';

  @override
  String get settingsLoadFailed => 'Settings unreadable';

  @override
  String get toolLayout => 'Tile layout';

  @override
  String get toolLayoutSubtitle => 'Surface layout, % waste';

  @override
  String get toolDistribution => 'Spacing';

  @override
  String get toolDistributionSubtitle => 'Gap or number of pieces';

  @override
  String get toolDrawers => 'Drawers';

  @override
  String get toolDrawersSubtitle => 'Cut list, fronts, slides';

  @override
  String get toolLevel => 'Level';

  @override
  String get toolLevelSubtitle => 'Bubble and inclinometer';

  @override
  String get toolConverter => 'Converter';

  @override
  String get toolConverterSubtitle => 'Five quantities, shop units';

  @override
  String get quantityLength => 'Length';

  @override
  String get quantityArea => 'Area';

  @override
  String get quantityVolume => 'Volume';

  @override
  String get quantityMass => 'Weight';

  @override
  String get quantityPressure => 'Pressure';

  @override
  String get unitInchSymbol => 'in';

  @override
  String get unitFootSymbol => 'ft';

  @override
  String get unitBoardFootSymbol => 'BF';

  @override
  String get unitMillimeters => 'Millimeters';

  @override
  String get unitCentimeters => 'Centimeters';

  @override
  String get unitMeters => 'Meters';

  @override
  String get unitInches => 'Inches';

  @override
  String get unitFeet => 'Feet';

  @override
  String get unitSquareMillimeters => 'Square millimeters';

  @override
  String get unitSquareCentimeters => 'Square centimeters';

  @override
  String get unitSquareMeters => 'Square meters';

  @override
  String get unitSquareInches => 'Square inches';

  @override
  String get unitSquareFeet => 'Square feet';

  @override
  String get unitCubicCentimeters => 'Cubic centimeters';

  @override
  String get unitLiters => 'Liters';

  @override
  String get unitCubicMeters => 'Cubic meters';

  @override
  String get unitCubicInches => 'Cubic inches';

  @override
  String get unitBoardFeet => 'Board feet';

  @override
  String get unitGrams => 'Grams';

  @override
  String get unitKilograms => 'Kilograms';

  @override
  String get unitTonnes => 'Metric tons';

  @override
  String get unitOunces => 'Ounces';

  @override
  String get unitPounds => 'Pounds';

  @override
  String get unitBars => 'Bars';

  @override
  String get unitKilopascals => 'Kilopascals';

  @override
  String get unitMegapascals => 'Megapascals';

  @override
  String get unitPsi => 'Pounds per square inch';

  @override
  String get jointOffsetStraight => 'Stacked';

  @override
  String get decimalSeparator => '.';

  @override
  String get commonExpandSchema => 'Enlarge the drawing';

  @override
  String get commonCopied => 'Copied';

  @override
  String commonHelpFor(String label) {
    return 'Help: $label';
  }

  @override
  String get commonReset => 'Reset inputs';

  @override
  String get commonDecrement => 'One less';

  @override
  String get commonIncrement => 'One more';

  @override
  String get commonUnitNote => 'Dimensions in mm';

  @override
  String get calcIncompleteInput => 'Incomplete input';

  @override
  String get calcNonFiniteValue => 'Invalid value';

  @override
  String get calcNegativeLength => 'Negative length';

  @override
  String get calcInvalidDenominator => 'Invalid denominator';

  @override
  String calcIncompatibleUnits(
    String from,
    String fromQuantity,
    String to,
    String toQuantity,
  ) {
    return 'Cannot convert $from ($fromQuantity) to $to ($toQuantity)';
  }

  @override
  String get calcInvalidLevelThreshold => 'Invalid level threshold';

  @override
  String get calcInvalidSensorReading => 'Invalid accelerometer reading';

  @override
  String get calcPositiveTotalWidth => 'Total width must be greater than 0';

  @override
  String get calcPositiveSurfaceWidth =>
      'Surface width must be a positive number';

  @override
  String get calcPositiveSurfaceLength =>
      'Surface length must be a positive number';

  @override
  String get calcPositiveTileWidth => 'Tile width must be a positive number';

  @override
  String get calcPositiveTileLength => 'Tile length must be a positive number';

  @override
  String get calcPositiveOpeningWidth => 'Inside width must be greater than 0';

  @override
  String get calcPositiveOpeningHeight =>
      'Inside height must be greater than 0';

  @override
  String get calcPositiveOpeningDepth => 'Inside depth must be greater than 0';

  @override
  String get calcPositiveCarcassThickness =>
      'Carcass thickness must be greater than 0';

  @override
  String get calcPositiveFrontThickness =>
      'Front thickness must be greater than 0';

  @override
  String get calcPositiveSideThickness =>
      'Side thickness must be greater than 0';

  @override
  String get calcPositiveBottomThickness =>
      'Bottom thickness must be greater than 0';

  @override
  String get calcPositiveFrontHeight => 'A front height must be greater than 0';

  @override
  String get calcPositiveSlideLength => 'Slide length must be greater than 0';

  @override
  String get calcPositiveGrooveDepth => 'Groove depth must be greater than 0';

  @override
  String get calcNonNegativeElementWidth => 'Piece width cannot be negative';

  @override
  String get calcNonNegativeMargin => 'A margin cannot be negative';

  @override
  String get calcNonNegativeElementCount =>
      'The number of pieces cannot be negative';

  @override
  String get calcNonNegativeTargetGap => 'The target gap cannot be negative';

  @override
  String get calcNonNegativeHorizontalGap =>
      'Horizontal gap cannot be negative';

  @override
  String get calcNonNegativeVerticalGap => 'Vertical gap cannot be negative';

  @override
  String get calcNonNegativePerimeterGap => 'Perimeter gap cannot be negative';

  @override
  String get calcNonNegativeFrontGap =>
      'The gap between fronts cannot be negative';

  @override
  String get calcNonNegativeSideClearance =>
      'Side clearance cannot be negative';

  @override
  String get calcNonNegativeLengthReduction =>
      'Length reduction cannot be negative';

  @override
  String get calcMarginsFillWidth =>
      'The margins take up the full width: nothing is left to space out';

  @override
  String calcTooFewElements(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces',
      one: '$count piece',
    );
    return 'This arrangement needs at least $_temp0';
  }

  @override
  String calcTooManyElements(int max) {
    return 'Too many pieces: $max at most';
  }

  @override
  String calcElementsOverflow(int count, String occupied, String available) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces take',
      one: '$count piece takes',
    );
    return '$_temp0 $occupied mm of the $available mm available';
  }

  @override
  String get calcWidthAndGapBothZero => 'Width and gap cannot both be zero';

  @override
  String get calcNoDistributionForGap => 'No spacing matches this gap';

  @override
  String calcGapTooSmall(int max) {
    return 'Gap too small: it would take more than $max pieces';
  }

  @override
  String calcTileLargerThanSurface(
    String tileWidth,
    String tileLength,
    String surfaceWidth,
    String surfaceLength,
  ) {
    return 'The tile is $tileWidth × $tileLength mm for an area to cover of $surfaceWidth × $surfaceLength mm';
  }

  @override
  String calcTooManyTiles(String count, int max) {
    return 'This would take $count tiles, $max at most';
  }

  @override
  String calcPerimeterGapFillsSurface(String gap, String smallest) {
    return 'A $gap mm perimeter gap leaves nothing to cover on $smallest mm';
  }

  @override
  String get calcNoDrawer => 'At least one drawer is needed';

  @override
  String get calcFrontGapsFillWidth =>
      'The gaps around the front take up the full inside width';

  @override
  String get calcFrontGapsFillHeight =>
      'The gaps between fronts take up the full inside height';

  @override
  String get calcInsetFrontFillsDepth =>
      'The inset front takes up the full inside depth';

  @override
  String calcSlideAndSidesTooWide(String needed, String opening) {
    return 'Slides and sides take $needed mm of a $opening mm inside width';
  }

  @override
  String calcBoxTooShort(String length) {
    return 'Box too short: $length mm long';
  }

  @override
  String calcBoxTooLow(String height, int drawer, String minimum) {
    return 'Box too low: $height mm for drawer $drawer ($minimum minimum)';
  }

  @override
  String calcGrooveThroughSide(String groove, String side) {
    return 'A $groove mm groove goes through a $side mm side';
  }

  @override
  String calcFixedHeightsTooTall(String fixed, String available) {
    return 'The fixed heights add up to $fixed mm for $available mm of fronts';
  }

  @override
  String calcSlideTooLong(String slide, String usefulDepth) {
    return 'A $slide mm slide does not fit in $usefulDepth mm of usable depth';
  }

  @override
  String calcDepthTooShortForSlides(String usefulDepth, String shortest) {
    return 'The usable depth ($usefulDepth mm) is shorter than the shortest slide ($shortest mm)';
  }

  @override
  String get converterQuantity => 'Quantity';

  @override
  String get converterValue => 'Value';

  @override
  String get converterSourceUnit => 'From unit';

  @override
  String get converterCompoundImperial => 'Feet and inches';

  @override
  String get converterCompoundImperialHelp =>
      'Feet + inches + fraction, rounded to 1/16 inch.';

  @override
  String get converterBoardFootNote => 'The unit hardwood is sold by — 144 in³';

  @override
  String get converterImperial => 'Imperial';

  @override
  String get converterImperialNote => 'Rounded to 1/16 inch';

  @override
  String get converterOutOfScale => 'Ratio off the chart — shapes not to scale';

  @override
  String get levelRoll => 'Side tilt';

  @override
  String get levelRollNote => 'Left ⇄ right';

  @override
  String get levelPitch => 'Front tilt';

  @override
  String get levelPitchNote => 'Front ⇄ back';

  @override
  String get levelState => 'Status';

  @override
  String get levelFlat => 'Level';

  @override
  String get levelOff => 'Off level';

  @override
  String get levelFromHorizontal => 'Relative to horizontal';

  @override
  String get levelFromZero => 'Relative to the set zero';

  @override
  String get levelSetZero => 'Set zero';

  @override
  String get levelCancelZero => 'Cancel';

  @override
  String get levelHorizontalHelp => 'Angles are given relative to horizontal.';

  @override
  String get levelZeroHelp =>
      'Zero set: angles are relative to the calibrated surface.';

  @override
  String get levelSensorUnavailable => 'Accelerometer unavailable';

  @override
  String get levelSensorUnavailableHelp =>
      'This tool needs a device with an accelerometer.';
}
