// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DrawersInput _$DrawersInputFromJson(Map<String, dynamic> json) =>
    _DrawersInput(
      openingWidth: (json['openingWidth'] as num).toDouble(),
      openingHeight: (json['openingHeight'] as num).toDouble(),
      openingDepth: (json['openingDepth'] as num).toDouble(),
      drawerCount: (json['drawerCount'] as num).toInt(),
      fixedFrontHeights:
          (json['fixedFrontHeights'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toDouble())
              .toList() ??
          const <double?>[],
      slide:
          $enumDecodeNullable(_$SlideKindEnumMap, json['slide']) ??
          SlideKind.ballBearing,
      customSideClearance:
          (json['customSideClearance'] as num?)?.toDouble() ?? 12.7,
      customLengthReduction:
          (json['customLengthReduction'] as num?)?.toDouble() ?? 0,
      slideLength: (json['slideLength'] as num?)?.toDouble(),
      frontMount:
          $enumDecodeNullable(_$FrontMountEnumMap, json['frontMount']) ??
          FrontMount.overlay,
      frontGap: (json['frontGap'] as num?)?.toDouble() ?? 3,
      sideThickness: (json['sideThickness'] as num?)?.toDouble() ?? 15,
      bottomThickness: (json['bottomThickness'] as num?)?.toDouble() ?? 8,
      carcassThickness: (json['carcassThickness'] as num?)?.toDouble() ?? 19,
      frontThickness: (json['frontThickness'] as num?)?.toDouble() ?? 19,
      boxJoint:
          $enumDecodeNullable(_$BoxJointEnumMap, json['boxJoint']) ??
          BoxJoint.sidesOverlap,
      bottomMount:
          $enumDecodeNullable(_$BottomMountEnumMap, json['bottomMount']) ??
          BottomMount.groove,
      grooveDepth: (json['grooveDepth'] as num?)?.toDouble() ?? 6,
    );

Map<String, dynamic> _$DrawersInputToJson(_DrawersInput instance) =>
    <String, dynamic>{
      'openingWidth': instance.openingWidth,
      'openingHeight': instance.openingHeight,
      'openingDepth': instance.openingDepth,
      'drawerCount': instance.drawerCount,
      'fixedFrontHeights': instance.fixedFrontHeights,
      'slide': _$SlideKindEnumMap[instance.slide]!,
      'customSideClearance': instance.customSideClearance,
      'customLengthReduction': instance.customLengthReduction,
      'slideLength': instance.slideLength,
      'frontMount': _$FrontMountEnumMap[instance.frontMount]!,
      'frontGap': instance.frontGap,
      'sideThickness': instance.sideThickness,
      'bottomThickness': instance.bottomThickness,
      'carcassThickness': instance.carcassThickness,
      'frontThickness': instance.frontThickness,
      'boxJoint': _$BoxJointEnumMap[instance.boxJoint]!,
      'bottomMount': _$BottomMountEnumMap[instance.bottomMount]!,
      'grooveDepth': instance.grooveDepth,
    };

const _$SlideKindEnumMap = {
  SlideKind.ballBearing: 'ballBearing',
  SlideKind.undermount: 'undermount',
  SlideKind.woodOnWood: 'woodOnWood',
  SlideKind.custom: 'custom',
};

const _$FrontMountEnumMap = {
  FrontMount.overlay: 'overlay',
  FrontMount.inset: 'inset',
};

const _$BoxJointEnumMap = {
  BoxJoint.sidesOverlap: 'sidesOverlap',
  BoxJoint.frontBackOverlap: 'frontBackOverlap',
};

const _$BottomMountEnumMap = {
  BottomMount.groove: 'groove',
  BottomMount.between: 'between',
  BottomMount.underneath: 'underneath',
};
