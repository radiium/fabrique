// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distribution_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DistributionFormState _$DistributionFormStateFromJson(
  Map<String, dynamic> json,
) => _DistributionFormState(
  mode:
      $enumDecodeNullable(_$DistributionModeEnumMap, json['mode']) ??
      DistributionMode.spacing,
  length: (json['length'] as num?)?.toDouble() ?? 1000,
  elementWidth: (json['elementWidth'] as num?)?.toDouble() ?? 20,
  count: (json['count'] as num?)?.toInt() ?? 5,
  targetSpacing: (json['targetSpacing'] as num?)?.toDouble() ?? 150,
  startEdge:
      $enumDecodeNullable(_$DistributionEdgeEnumMap, json['startEdge']) ??
      DistributionEdge.gap,
  endEdge:
      $enumDecodeNullable(_$DistributionEdgeEnumMap, json['endEdge']) ??
      DistributionEdge.gap,
  symmetricOffsets: json['symmetricOffsets'] as bool? ?? true,
  startOffset: (json['startOffset'] as num?)?.toDouble() ?? 0,
  endOffset: (json['endOffset'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$DistributionFormStateToJson(
  _DistributionFormState instance,
) => <String, dynamic>{
  'mode': _$DistributionModeEnumMap[instance.mode]!,
  'length': instance.length,
  'elementWidth': instance.elementWidth,
  'count': instance.count,
  'targetSpacing': instance.targetSpacing,
  'startEdge': _$DistributionEdgeEnumMap[instance.startEdge]!,
  'endEdge': _$DistributionEdgeEnumMap[instance.endEdge]!,
  'symmetricOffsets': instance.symmetricOffsets,
  'startOffset': instance.startOffset,
  'endOffset': instance.endOffset,
};

const _$DistributionModeEnumMap = {
  DistributionMode.spacing: 'spacing',
  DistributionMode.count: 'count',
};

const _$DistributionEdgeEnumMap = {
  DistributionEdge.gap: 'gap',
  DistributionEdge.element: 'element',
};
