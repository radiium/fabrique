// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LayoutInput _$LayoutInputFromJson(Map<String, dynamic> json) => _LayoutInput(
  surfaceX: (json['surfaceX'] as num).toDouble(),
  surfaceY: (json['surfaceY'] as num).toDouble(),
  elementX: (json['elementX'] as num).toDouble(),
  elementY: (json['elementY'] as num).toDouble(),
  gapX: (json['gapX'] as num?)?.toDouble() ?? 0.0,
  gapY: (json['gapY'] as num?)?.toDouble() ?? 0.0,
  flip: json['flip'] as bool? ?? false,
  offset:
      $enumDecodeNullable(_$JointOffsetEnumMap, json['offset']) ??
      JointOffset.half,
);

Map<String, dynamic> _$LayoutInputToJson(_LayoutInput instance) =>
    <String, dynamic>{
      'surfaceX': instance.surfaceX,
      'surfaceY': instance.surfaceY,
      'elementX': instance.elementX,
      'elementY': instance.elementY,
      'gapX': instance.gapX,
      'gapY': instance.gapY,
      'flip': instance.flip,
      'offset': _$JointOffsetEnumMap[instance.offset]!,
    };

const _$JointOffsetEnumMap = {
  JointOffset.straight: 'straight',
  JointOffset.half: 'half',
  JointOffset.third: 'third',
};
