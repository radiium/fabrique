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

_DeviceCalibration _$DeviceCalibrationFromJson(Map<String, dynamic> json) =>
    _DeviceCalibration(
      edgesDeg:
          (json['edgesDeg'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
          ) ??
          const <int, double>{},
    );

Map<String, dynamic> _$DeviceCalibrationToJson(_DeviceCalibration instance) =>
    <String, dynamic>{
      'edgesDeg': instance.edgesDeg.map((k, e) => MapEntry(k.toString(), e)),
    };
