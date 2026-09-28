import '../core/calc/calc_error.dart';
import 'app_localizations.dart';
import 'labels.dart';
import 'numbers.dart';

/// Les refus du cœur de calcul, rédigés dans la langue de l'app.
///
/// Un refus nomme les cotes comme l'écran et porte les chiffres.
extension CalcErrorText on AppLocalizations {
  String calcError(CalcError error) => switch (error) {
    IncompleteInput() => calcIncompleteInput,
    NonFiniteValue() => calcNonFiniteValue,
    NegativeLength() => calcNegativeLength,
    InvalidDenominator() => calcInvalidDenominator,
    IncompatibleUnits(:final from, :final to) => calcIncompatibleUnits(
      from.symbol(this),
      from.quantity.label(this),
      to.symbol(this),
      to.quantity.label(this),
    ),
    InvalidLevelThreshold() => calcInvalidLevelThreshold,
    InvalidSensorReading() => calcInvalidSensorReading,
    UnsteadyReading() => calcUnsteadyReading,
    PoseChanged() => calcPoseChanged,
    NotOnEdge() => calcNotOnEdge,
    BiasTooLarge(:final maxDeg) => calcBiasTooLarge(degrees(maxDeg)),
    MustBePositive(:final field) => _positive(field),
    MustNotBeNegative(:final field) => _nonNegative(field),
    MarginsFillWidth() => calcMarginsFillWidth,
    TooFewElements(:final minCount) => calcTooFewElements(minCount),
    TooManyElements(:final maxCount) => calcTooManyElements(maxCount),
    ElementsOverflow(:final count, :final occupied, :final available) =>
      calcElementsOverflow(count, number(occupied), number(available)),
    WidthAndGapBothZero() => calcWidthAndGapBothZero,
    NoDistributionForGap() => calcNoDistributionForGap,
    GapTooSmall(:final maxCount) => calcGapTooSmall(maxCount),
    TileLargerThanSurface(
      :final tileWidth,
      :final tileLength,
      :final surfaceWidth,
      :final surfaceLength,
    ) =>
      calcTileLargerThanSurface(
        number(tileWidth),
        number(tileLength),
        number(surfaceWidth),
        number(surfaceLength),
      ),
    TooManyTiles(:final count, :final maxCount) => calcTooManyTiles(
      number(count),
      maxCount,
    ),
    PerimeterGapFillsSurface(:final gap, :final smallest) =>
      calcPerimeterGapFillsSurface(number(gap), number(smallest)),
    NoDrawer() => calcNoDrawer,
    FrontGapsFillWidth() => calcFrontGapsFillWidth,
    FrontGapsFillHeight() => calcFrontGapsFillHeight,
    InsetFrontFillsDepth() => calcInsetFrontFillsDepth,
    SlideAndSidesTooWide(:final needed, :final opening) =>
      calcSlideAndSidesTooWide(number(needed), number(opening)),
    BoxTooShort(:final length) => calcBoxTooShort(number(length)),
    BoxTooLow(:final height, :final drawer, :final minimum) => calcBoxTooLow(
      number(height),
      drawer,
      number(minimum),
    ),
    GrooveThroughSide(:final groove, :final side) => calcGrooveThroughSide(
      number(groove),
      number(side),
    ),
    FixedHeightsTooTall(:final fixed, :final available) =>
      calcFixedHeightsTooTall(number(fixed), number(available)),
    SlideTooLong(:final slide, :final usefulDepth) => calcSlideTooLong(
      number(slide),
      number(usefulDepth),
    ),
    DepthTooShortForSlides(:final usefulDepth, :final shortestSlide) =>
      calcDepthTooShortForSlides(number(usefulDepth), number(shortestSlide)),
  };

  String _positive(PositiveField field) => switch (field) {
    PositiveField.totalWidth => calcPositiveTotalWidth,
    PositiveField.surfaceWidth => calcPositiveSurfaceWidth,
    PositiveField.surfaceLength => calcPositiveSurfaceLength,
    PositiveField.tileWidth => calcPositiveTileWidth,
    PositiveField.tileLength => calcPositiveTileLength,
    PositiveField.openingWidth => calcPositiveOpeningWidth,
    PositiveField.openingHeight => calcPositiveOpeningHeight,
    PositiveField.openingDepth => calcPositiveOpeningDepth,
    PositiveField.carcassThickness => calcPositiveCarcassThickness,
    PositiveField.frontThickness => calcPositiveFrontThickness,
    PositiveField.sideThickness => calcPositiveSideThickness,
    PositiveField.bottomThickness => calcPositiveBottomThickness,
    PositiveField.frontHeight => calcPositiveFrontHeight,
    PositiveField.slideLength => calcPositiveSlideLength,
    PositiveField.grooveDepth => calcPositiveGrooveDepth,
  };

  String _nonNegative(NonNegativeField field) => switch (field) {
    NonNegativeField.elementWidth => calcNonNegativeElementWidth,
    NonNegativeField.margin => calcNonNegativeMargin,
    NonNegativeField.elementCount => calcNonNegativeElementCount,
    NonNegativeField.targetGap => calcNonNegativeTargetGap,
    NonNegativeField.horizontalGap => calcNonNegativeHorizontalGap,
    NonNegativeField.verticalGap => calcNonNegativeVerticalGap,
    NonNegativeField.perimeterGap => calcNonNegativePerimeterGap,
    NonNegativeField.frontGap => calcNonNegativeFrontGap,
    NonNegativeField.sideClearance => calcNonNegativeSideClearance,
    NonNegativeField.lengthReduction => calcNonNegativeLengthReduction,
  };
}
