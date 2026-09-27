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
  String get calcPositiveTileWidth => 'Piece width must be a positive number';

  @override
  String get calcPositiveTileLength => 'Piece length must be a positive number';

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
    return 'The piece is $tileWidth × $tileLength mm for an area to cover of $surfaceWidth × $surfaceLength mm';
  }

  @override
  String calcTooManyTiles(String count, int max) {
    return 'This would take $count pieces, $max at most';
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

  @override
  String get distributionModeLabel => 'Solve for';

  @override
  String get distributionModeSpacing => 'Gap';

  @override
  String get distributionModeCount => 'Count';

  @override
  String get distributionEdgeElement => 'Piece';

  @override
  String get distributionEdgeGap => 'Gap';

  @override
  String distributionEdgePair(String start, String end) {
    return '$start – $end';
  }

  @override
  String get distributionGeometry => 'Layout';

  @override
  String get distributionLength => 'Total width';

  @override
  String get distributionElementWidth => 'Piece width';

  @override
  String get distributionCount => 'Number of pieces';

  @override
  String get distributionTargetSpacing => 'Target gap';

  @override
  String get distributionTargetSpacingHelp =>
      'The number of pieces adjusts to the closest match.';

  @override
  String get distributionEdgesGroup => 'Ends and margins';

  @override
  String get distributionEdges => 'Arrangement';

  @override
  String get distributionMargins => 'Margins';

  @override
  String get distributionMarginsHelp =>
      'Set aside before spacing — an edge band, a cleat already in place.';

  @override
  String get distributionSymmetric => 'Equal';

  @override
  String get distributionAsymmetric => 'Separate';

  @override
  String get distributionMargin => 'Margin';

  @override
  String get distributionMarginStart => 'Start margin';

  @override
  String get distributionMarginEnd => 'End margin';

  @override
  String distributionSummaryCount(int count, String width, String length) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces',
      one: '$count piece',
    );
    return '$_temp0 of $width over $length mm';
  }

  @override
  String distributionSummaryCountMarks(int count, String length) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count marks',
      one: '$count mark',
    );
    return '$_temp0 over $length mm';
  }

  @override
  String distributionSummaryTarget(String width, String length, String target) {
    return 'Pieces of $width over $length mm · target gap $target mm';
  }

  @override
  String distributionSummaryTargetMarks(String length, String target) {
    return 'Marks over $length mm · target gap $target mm';
  }

  @override
  String distributionSummaryEdges(String edges, String margins) {
    return '$edges · margins $margins mm';
  }

  @override
  String distributionCountNote(String target) {
    return 'For a target gap of $target mm';
  }

  @override
  String get distributionGapObtained => 'Resulting gap';

  @override
  String get distributionGap => 'Gap';

  @override
  String get distributionPitch => 'Pitch';

  @override
  String get distributionPitchNote => 'From one piece edge to the next';

  @override
  String distributionGapRule(int count, int gaps) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces',
      one: '$count piece',
    );
    String _temp1 = intl.Intl.pluralLogic(
      gaps,
      locale: localeName,
      other: '$gaps gaps',
      one: '$gaps gap',
    );
    return '$_temp0 → $_temp1';
  }

  @override
  String distributionCalloutExact(int count, String spacing) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces',
      one: '$count piece',
    );
    return '$_temp0 · $spacing mm exactly';
  }

  @override
  String distributionCalloutOther(int count, String spacing) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces',
      one: '$count piece',
    );
    return '$_temp0 → $spacing mm actual';
  }

  @override
  String distributionCalloutAdoptLabel(int count, String spacing) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces',
      one: '$count piece',
    );
    return 'Use $_temp0, $spacing millimeter gap';
  }

  @override
  String get distributionCalloutAdopt => 'Use';

  @override
  String get distributionPositions => 'Positions from origin';

  @override
  String get distributionNoElement => 'No pieces';

  @override
  String get distributionEdgeColumn => 'Edge';

  @override
  String get distributionPositionColumn => 'Position';

  @override
  String get distributionCenterColumn => 'Center';

  @override
  String get distributionSchemaStart => 'Start';

  @override
  String get distributionSchemaEnd => 'End';

  @override
  String distributionSchemaLegend(String zoom) {
    return 'Dimensions in mm — Details ×$zoom';
  }

  @override
  String get distributionPlanElements => 'Pieces';

  @override
  String get distributionPlanGaps => 'Gaps';

  @override
  String distributionPlanFallback(int count) {
    return '$count positions — copy them from the app';
  }

  @override
  String get distributionAboutModeBody =>
      'Chooses whether the gap between pieces or their number is worked out from the other values.';

  @override
  String get distributionAboutModeSpacing =>
      'Gap: you give the number of pieces, the tool returns the gap between them.';

  @override
  String get distributionAboutModeCount =>
      'Count: you give the gap you want, the tool returns the number of pieces that comes closest.';

  @override
  String get distributionAboutLengthBody =>
      'The full width available for the pieces: inside the frame, between two posts.';

  @override
  String get distributionAboutElementWidthBody =>
      'The width each piece takes up (baluster, slat, shelf). Enter 0 to place marks, layout lines or drilling centers.';

  @override
  String get distributionAboutCountBody =>
      'How many pieces to space across the available width.\n\nAn arrangement that starts or ends with a piece needs at least one. Two if it does both. The field won’t go lower, and stops at 500.';

  @override
  String get distributionAboutTargetBody =>
      'The distance you want between two neighboring pieces. It almost never comes out even: the number of pieces is whole, the gap isn’t. So the tool returns the two whole-number layouts on either side of your target, closest first. If you have a maximum not to exceed (balusters at 110 mm) read the tighter of the two.';

  @override
  String get distributionAboutEdgesBody =>
      'Sets what the row starts and ends with: a piece against the edge, or a gap. Each combination changes the number of gaps, and so the result. Each tile’s drawing shows it.';

  @override
  String get distributionAboutMarginsBody =>
      'Sets whether both margins move together or separately. A margin reserves a strip at one end (an edge band, a cleat already in place), taken off the total width before the calculation.';

  @override
  String get distributionAboutMarginsSymmetric =>
      'Equal: a single margin, the same on both sides.';

  @override
  String get distributionAboutMarginsAsymmetric =>
      'Separate: one margin per side. Use it as soon as one end is constrained and the other isn’t.';

  @override
  String get distributionAboutMarginBody =>
      'The same margin at the start and the end. It is taken off the total width before the spacing is worked out.';

  @override
  String get distributionAboutMarginStartBody =>
      'The margin at the start, on the left of the drawing. It is taken off the total width before the spacing is worked out.';

  @override
  String get distributionAboutMarginEndBody =>
      'The margin at the end, on the right of the drawing. It is taken off the total width before the spacing is worked out.';

  @override
  String get planDate => 'Date';

  @override
  String get planIndex => 'No.';

  @override
  String get layoutSurfaceGroup => 'Surface';

  @override
  String get layoutSurfaceWidth => 'Surface — width';

  @override
  String get layoutSurfaceLength => 'Surface — length';

  @override
  String get layoutElementGroup => 'Piece and pattern';

  @override
  String get layoutMaterial => 'Material';

  @override
  String get layoutCustom => 'Custom';

  @override
  String get layoutMaterialDrywall => 'Drywall';

  @override
  String get layoutMaterialTile => 'Tile';

  @override
  String get layoutMaterialFlooring => 'Flooring';

  @override
  String get layoutMaterialDecking => 'Decking';

  @override
  String get layoutMaterialPanel => 'Panel';

  @override
  String get layoutElementWidth => 'Piece — width';

  @override
  String get layoutElementLength => 'Piece — length';

  @override
  String get layoutOffset => 'Joint offset';

  @override
  String get layoutFlip => 'Rotate the layout';

  @override
  String get layoutFlipHelp => 'The joint offset follows.';

  @override
  String get layoutBalance => 'Balance the rows';

  @override
  String get layoutBalanceHelp =>
      'Avoids ending on a row narrower than half a piece.';

  @override
  String layoutSummaryOffset(String offset) {
    return 'offset $offset';
  }

  @override
  String get layoutSummaryFlipped => 'rotated';

  @override
  String get layoutSummaryBalanced => 'balanced rows';

  @override
  String get layoutGapsGroup => 'Gaps';

  @override
  String get layoutGapX => 'Horizontal gap';

  @override
  String get layoutGapY => 'Vertical gap';

  @override
  String get layoutPerimeterGap => 'Perimeter gap';

  @override
  String get layoutPerimeterGapHelp =>
      'Setback all around the layout, along all four edges.';

  @override
  String get layoutNoGap => 'No gaps';

  @override
  String layoutSummaryGaps(String x, String y, String perimeter) {
    return 'between pieces $x × $y · perimeter $perimeter mm';
  }

  @override
  String get layoutFullCount => 'Whole pieces';

  @override
  String get layoutCutCount => 'Pieces to cut';

  @override
  String get layoutCutNote => 'Highlighted in orange on the drawing';

  @override
  String get layoutBalancedRows => 'Edge rows';

  @override
  String get layoutBalancedNote => 'First and last, at the same width';

  @override
  String layoutBalancedEndNote(String end) {
    return 'First and last, at the same width. End pieces: $end mm';
  }

  @override
  String get layoutTotal => 'Total to buy';

  @override
  String get layoutTotalNote => 'Stock with no offcuts reused';

  @override
  String get layoutSurface => 'Area';

  @override
  String layoutCovered(String area) {
    return 'Covered: $area m²';
  }

  @override
  String get layoutWaste => 'Waste';

  @override
  String get layoutWasteNote => 'No offcuts reused — a cautious estimate';

  @override
  String get layoutPlanElement => 'Piece';

  @override
  String get layoutPlanOffset => 'Offset';

  @override
  String get layoutPlanGap => 'Gap';

  @override
  String get layoutPlanPerimeterGap => 'Perim. gap';

  @override
  String get layoutPlanFull => 'Whole';

  @override
  String get layoutPlanCut => 'To cut';

  @override
  String get layoutPlanTotal => 'Total';

  @override
  String get layoutPlanWaste => 'Waste';

  @override
  String get layoutPlanCuts => 'Pieces to cut';

  @override
  String get layoutPlanWidthColumn => 'Width';

  @override
  String get layoutPlanLengthColumn => 'Length';

  @override
  String get layoutPlanCountColumn => 'Qty';

  @override
  String get layoutPlanNoCut => 'No cuts, everything fits exactly';

  @override
  String layoutPlanCutsFallback(int count) {
    return '$count cut sizes — read them in the app';
  }

  @override
  String get layoutPlanNote =>
      'Waste estimated with no offcuts reused. Each cut uses up a whole piece.';

  @override
  String get layoutAboutPerimeterBody =>
      'The setback left all around the layout, along all four edges. The room doesn’t shrink: the layout pulls back, so the area shown stays that of the floor or wall.';

  @override
  String get layoutAboutPerimeterFlooring =>
      'Wood and laminate flooring: the expansion gap, around 10 mm.';

  @override
  String get layoutAboutPerimeterTile =>
      'Tile: the gap at the wall, around 5 mm.';

  @override
  String get layoutAboutPerimeterDrywall =>
      'Drywall: the gap at the floor, around 10 mm.';

  @override
  String get layoutAboutPerimeterNone =>
      'A layout tight to the walls stays at 0.';

  @override
  String get layoutAboutOffsetBody =>
      'How far each row starts set back from the one before. The offset follows the laying direction: rotating the layout turns it with the rest of the pattern.';

  @override
  String get layoutAboutOffsetStraight =>
      'Stacked: every row starts at the same place, the joints line up in a grid.';

  @override
  String get layoutAboutOffsetHalf =>
      '½: the usual offset for short boards and sheets.';

  @override
  String get layoutAboutOffsetThird =>
      '⅓: the rule for tiles and boards longer than 60 cm, where a half offset makes the middle of the piece lip.';

  @override
  String get layoutAboutOffsetSquare =>
      'On a square piece or a full sheet, the effect stays minor.';

  @override
  String get drawerPartSide => 'Side';

  @override
  String get drawerPartFront => 'Front';

  @override
  String get drawerPartBack => 'Back';

  @override
  String get drawerPartBottom => 'Bottom';

  @override
  String get drawerPartDrawerFront => 'Drawer front';

  @override
  String get slideBallBearing => 'Ball-bearing';

  @override
  String get slideUndermount => 'Undermount';

  @override
  String get slideWoodOnWood => 'Wood runners';

  @override
  String get slideCustom => 'Custom';

  @override
  String get frontMountOverlay => 'Overlay';

  @override
  String get frontMountInset => 'Inset';

  @override
  String get boxJointSidesOverlap => 'Sides overlap';

  @override
  String get boxJointFrontBackOverlap => 'Front and back overlap';

  @override
  String get bottomMountGroove => 'In a groove';

  @override
  String get bottomMountBetween => 'Between sides';

  @override
  String get bottomMountUnderneath => 'Under the box';

  @override
  String get drawersOpening => 'Opening';

  @override
  String get drawersOpeningWidth => 'Inside width';

  @override
  String get drawersOpeningHeight => 'Inside height';

  @override
  String get drawersOpeningDepth => 'Inside depth';

  @override
  String get drawersCarcassThickness => 'Carcass thickness';

  @override
  String drawersSummaryOpening(
    String width,
    String height,
    String depth,
    String carcass,
  ) {
    return '$width × $height × $depth mm · carcass $carcass mm';
  }

  @override
  String get drawersFrontsGroup => 'Drawers and fronts';

  @override
  String get drawersCount => 'Number of drawers';

  @override
  String get drawersHeights => 'Heights';

  @override
  String get drawersHeightsAdjusted => 'Adjusted';

  @override
  String get drawersHeightsEqual => 'Equal';

  @override
  String get drawersFrontMount => 'Front style';

  @override
  String get drawersFrontThickness => 'Front thickness';

  @override
  String get drawersFrontGap => 'Gap between fronts';

  @override
  String drawersSummaryFronts(
    int count,
    String heights,
    String mount,
    String thickness,
    String gap,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count drawers',
      one: '$count drawer',
    );
    return '$_temp0 · $heights heights · $mount, front $thickness · gap $gap mm';
  }

  @override
  String get drawersSlide => 'Slide';

  @override
  String get drawersSideClearance => 'Side clearance';

  @override
  String get drawersLengthReduction => 'Length reduction';

  @override
  String get drawersSlideLength => 'Slide length';

  @override
  String get drawersSlideLengthAuto => 'Automatic';

  @override
  String drawersSummaryCustomSlide(String clearance, String reduction) {
    return 'clearance $clearance, reduction $reduction mm';
  }

  @override
  String get drawersSummaryAutoLength => 'automatic length';

  @override
  String drawersSummaryLength(String length) {
    return 'length $length mm';
  }

  @override
  String get drawersBox => 'Box';

  @override
  String get drawersSideThickness => 'Side thickness';

  @override
  String get drawersSideThicknessHelp => 'Also the front and back.';

  @override
  String get drawersBottomThickness => 'Bottom thickness';

  @override
  String get drawersBoxJoint => 'Joinery';

  @override
  String get drawersBottom => 'Bottom';

  @override
  String get drawersBottomImposedHelp => 'Set by the undermount slide.';

  @override
  String drawersBottomRecess(String recess) {
    return 'Set back $recess mm';
  }

  @override
  String get drawersGrooveDepth => 'Groove depth';

  @override
  String drawersSummaryRecess(String recess) {
    return 'set back $recess mm';
  }

  @override
  String drawersSummaryGroove(String depth) {
    return 'in a $depth mm groove';
  }

  @override
  String drawersSummaryBox(
    String side,
    String bottom,
    String joint,
    String mount,
  ) {
    return 'sides $side, bottom $bottom mm · $joint · bottom $mount';
  }

  @override
  String get drawersEditHeights => 'Edit front heights';

  @override
  String drawersHeightsTopToBottom(String heights) {
    return 'Top to bottom: $heights mm';
  }

  @override
  String get drawersFrontHeights => 'Front heights';

  @override
  String get drawersFrontHeightsHelp =>
      'A height you enter stays fixed. The other fronts share the rest.';

  @override
  String get drawersHeightShared => 'Shared';

  @override
  String get drawersHeightFixed => 'Fixed';

  @override
  String get drawersResetHeights => 'Reset to equal';

  @override
  String drawersDrawer(int number) {
    return 'Drawer $number';
  }

  @override
  String drawersDrawerTop(int number) {
    return 'Drawer $number (top)';
  }

  @override
  String drawersDrawerBottom(int number) {
    return 'Drawer $number (bottom)';
  }

  @override
  String get drawersCutList => 'Cut list';

  @override
  String get drawersCutListPart => 'Part';

  @override
  String get drawersCutListSizes => 'L × W × T (mm)';

  @override
  String get drawersFrontsResult => 'Fronts — width × height';

  @override
  String drawersFrontsResultNote(String gap) {
    return '$gap mm gap between fronts';
  }

  @override
  String get drawersBoxResult => 'Box — width × length';

  @override
  String drawersBoxResultNote(String clearance) {
    return 'Overall, $clearance mm clearance per side';
  }

  @override
  String get drawersSlideLengthAutoNote => 'The longest that fits';

  @override
  String get drawersSlideLengthImposedNote => 'Your choice';

  @override
  String get drawersSlideAxes => 'Slide centerlines';

  @override
  String get drawersSlideAxesNote =>
      'From the bottom of the opening, top to bottom';

  @override
  String get drawersPlanFronts => 'Fronts';

  @override
  String drawersPlanFrontsValue(String mount, String gap) {
    return '$mount, gap $gap';
  }

  @override
  String get drawersPlanDepth => 'Depth';

  @override
  String get drawersPlanThicknesses => 'Side / bottom th.';

  @override
  String get drawersPlanFrontThickness => 'Front th.';

  @override
  String get drawersPlanLength => 'Length';

  @override
  String get drawersPlanCount => 'Qty';

  @override
  String get drawersPlanLengthColumn => 'L (mm)';

  @override
  String get drawersPlanWidthColumn => 'W (mm)';

  @override
  String drawersPlanCutListFallback(int count) {
    return '$count cut list rows — read them in the app';
  }

  @override
  String get drawersPlanAxes => 'Slide centerlines, drawer 1 at top';

  @override
  String get drawersPlanAxesColumn => 'From the bottom of the opening';

  @override
  String drawersPlanAxesFallback(int count) {
    return '$count centerlines — read them in the app';
  }

  @override
  String get drawersPlanUndermountNote =>
      'Undermount slide dimensions are a guide. Check the maker’s spec sheet.';

  @override
  String get drawersAboutOpeningBody =>
      'Inside dimensions of the cabinet, where the drawers go: between the sides, between the bottom and the top, from the front edge to the back panel.';

  @override
  String get drawersAboutFrontHeightsBody =>
      'By default, the fronts share the height equally. A fixed height stays fixed, and the other fronts share the rest.';

  @override
  String get drawersAboutSlideBody =>
      'It sets the clearance between the cabinet sides and the box, and the box length.';

  @override
  String get drawersAboutSlideBallBearing =>
      'Ball-bearing: side-mount slide, 12.7 mm clearance on each side.';

  @override
  String get drawersAboutSlideUndermount =>
      'Undermount: slide hidden under the box. It needs a set-back bottom. Dimensions are a guide, check the maker’s spec sheet.';

  @override
  String get drawersAboutSlideWood =>
      'Wood runners: the drawer slides on wooden runners, with no hardware.';

  @override
  String get drawersAboutSlideCustom =>
      'Custom: the clearances from your maker’s spec sheet.';

  @override
  String get drawersAboutFrontMountBody =>
      'Where the front sits relative to the cabinet.';

  @override
  String get drawersAboutFrontMountOverlay =>
      'Overlay: in front of the cabinet. The front covers the edges of the sides, flush with their outer faces.';

  @override
  String get drawersAboutFrontMountInset =>
      'Inset: inside the opening. The front sits flush with the edges, with a gap all around.';

  @override
  String get drawersAboutBoxJointBody =>
      'Which parts run the full length. It changes the length of the front, back and sides, not the kind of joint.';

  @override
  String get drawersAboutBottomBody => 'How the bottom is held in the box.';

  @override
  String get drawersAboutBottomGroove =>
      'In a groove: captured in a groove in all four parts. It is larger by the groove depth on each side.';

  @override
  String get drawersAboutBottomBetween =>
      'Between sides: fitted inside with no groove, screwed, glued or on cleats. It takes the inside dimensions of the box.';

  @override
  String get drawersAboutBottomUnderneath =>
      'Under the box: screwed or nailed underneath, to the overall dimensions.';

  @override
  String get drawersAboutSlideLengthBody =>
      'By default, the longest length sold that fits in the depth. Choose one if you already have your slides.';

  @override
  String planDateValue(String day, String month, String year) {
    return '$month/$day/$year';
  }

  @override
  String get planExport => 'Export';

  @override
  String get planShare => 'Share';

  @override
  String get planExportTooltip => 'Export the plan';

  @override
  String get planDownloaded => 'Plan downloaded';

  @override
  String get planSaved => 'Plan saved to your photos';

  @override
  String get planView => 'View';

  @override
  String get planPhotosDenied => 'Photo access denied';

  @override
  String get planSaveFailed => 'Could not save';

  @override
  String get planExportFailed => 'Could not export';

  @override
  String get schemaFit => 'Fit to screen';

  @override
  String get schemaRotate => 'Rotate the drawing';
}
