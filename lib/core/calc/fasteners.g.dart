// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fasteners.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FastenerInput _$FastenerInputFromJson(Map<String, dynamic> json) =>
    _FastenerInput(
      material: $enumDecode(_$MaterialKindEnumMap, json['material']),
      screwDiameter: (json['screwDiameter'] as num).toDouble(),
      fixedThickness: (json['fixedThickness'] as num).toDouble(),
    );

Map<String, dynamic> _$FastenerInputToJson(_FastenerInput instance) =>
    <String, dynamic>{
      'material': _$MaterialKindEnumMap[instance.material]!,
      'screwDiameter': instance.screwDiameter,
      'fixedThickness': instance.fixedThickness,
    };

const _$MaterialKindEnumMap = {
  MaterialKind.softwood: 'softwood',
  MaterialKind.hardwood: 'hardwood',
  MaterialKind.chipboard: 'chipboard',
  MaterialKind.plywood: 'plywood',
};
