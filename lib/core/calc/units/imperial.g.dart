// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imperial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImperialParts _$ImperialPartsFromJson(Map<String, dynamic> json) =>
    _ImperialParts(
      feet: (json['feet'] as num).toInt(),
      inches: (json['inches'] as num).toInt(),
      num: (json['num'] as num).toInt(),
      den: (json['den'] as num).toInt(),
    );

Map<String, dynamic> _$ImperialPartsToJson(_ImperialParts instance) =>
    <String, dynamic>{
      'feet': instance.feet,
      'inches': instance.inches,
      'num': instance.num,
      'den': instance.den,
    };
