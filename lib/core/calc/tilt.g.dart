// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tilt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccelReading _$AccelReadingFromJson(Map<String, dynamic> json) =>
    _AccelReading(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
      (json['z'] as num).toDouble(),
    );

Map<String, dynamic> _$AccelReadingToJson(_AccelReading instance) =>
    <String, dynamic>{'x': instance.x, 'y': instance.y, 'z': instance.z};
