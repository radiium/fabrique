// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distribution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DistributionInput _$DistributionInputFromJson(Map<String, dynamic> json) =>
    _DistributionInput(
      length: (json['length'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
      elementWidth: (json['elementWidth'] as num?)?.toDouble() ?? 0,
      startEdge:
          $enumDecodeNullable(_$DistributionEdgeEnumMap, json['startEdge']) ??
          DistributionEdge.gap,
      endEdge:
          $enumDecodeNullable(_$DistributionEdgeEnumMap, json['endEdge']) ??
          DistributionEdge.gap,
      startOffset: (json['startOffset'] as num?)?.toDouble() ?? 0,
      endOffset: (json['endOffset'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$DistributionInputToJson(_DistributionInput instance) =>
    <String, dynamic>{
      'length': instance.length,
      'count': instance.count,
      'elementWidth': instance.elementWidth,
      'startEdge': _$DistributionEdgeEnumMap[instance.startEdge]!,
      'endEdge': _$DistributionEdgeEnumMap[instance.endEdge]!,
      'startOffset': instance.startOffset,
      'endOffset': instance.endOffset,
    };

const _$DistributionEdgeEnumMap = {
  DistributionEdge.gap: 'gap',
  DistributionEdge.element: 'element',
};

_DistributionTargetInput _$DistributionTargetInputFromJson(
  Map<String, dynamic> json,
) => _DistributionTargetInput(
  length: (json['length'] as num).toDouble(),
  targetSpacing: (json['targetSpacing'] as num).toDouble(),
  elementWidth: (json['elementWidth'] as num?)?.toDouble() ?? 0,
  startEdge:
      $enumDecodeNullable(_$DistributionEdgeEnumMap, json['startEdge']) ??
      DistributionEdge.gap,
  endEdge:
      $enumDecodeNullable(_$DistributionEdgeEnumMap, json['endEdge']) ??
      DistributionEdge.gap,
  startOffset: (json['startOffset'] as num?)?.toDouble() ?? 0,
  endOffset: (json['endOffset'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$DistributionTargetInputToJson(
  _DistributionTargetInput instance,
) => <String, dynamic>{
  'length': instance.length,
  'targetSpacing': instance.targetSpacing,
  'elementWidth': instance.elementWidth,
  'startEdge': _$DistributionEdgeEnumMap[instance.startEdge]!,
  'endEdge': _$DistributionEdgeEnumMap[instance.endEdge]!,
  'startOffset': instance.startOffset,
  'endOffset': instance.endOffset,
};
