// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tilt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccelReading {

 double get x; double get y; double get z;
/// Create a copy of AccelReading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccelReadingCopyWith<AccelReading> get copyWith => _$AccelReadingCopyWithImpl<AccelReading>(this as AccelReading, _$identity);

  /// Serializes this AccelReading to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AccelReading;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccelReading&&(identical(other.x, _this.x) || other.x == _this.x)&&(identical(other.y, _this.y) || other.y == _this.y)&&(identical(other.z, _this.z) || other.z == _this.z));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AccelReading;
  return Object.hash(runtimeType,_this.x,_this.y,_this.z);
}

@override
String toString() {
  final _this = this as AccelReading;
  return 'AccelReading(x: ${_this.x}, y: ${_this.y}, z: ${_this.z})';
}


}

/// @nodoc
abstract mixin class $AccelReadingCopyWith<$Res>  {
  factory $AccelReadingCopyWith(AccelReading value, $Res Function(AccelReading) _then) = _$AccelReadingCopyWithImpl;
@useResult
$Res call({
 double x, double y, double z
});




}
/// @nodoc
class _$AccelReadingCopyWithImpl<$Res>
    implements $AccelReadingCopyWith<$Res> {
  _$AccelReadingCopyWithImpl(this._self, this._then);

  final AccelReading _self;
  final $Res Function(AccelReading) _then;

/// Create a copy of AccelReading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x = null,Object? y = null,Object? z = null,}) {
  return _then(AccelReading(
null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,null == z ? _self.z : z // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AccelReading].
extension AccelReadingPatterns on AccelReading {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccelReading value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccelReading() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccelReading value)  $default,){
final _that = this;
switch (_that) {
case _AccelReading():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccelReading value)?  $default,){
final _that = this;
switch (_that) {
case _AccelReading() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double x,  double y,  double z)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccelReading() when $default != null:
return $default(_that.x,_that.y,_that.z);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double x,  double y,  double z)  $default,) {final _that = this;
switch (_that) {
case _AccelReading():
return $default(_that.x,_that.y,_that.z);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double x,  double y,  double z)?  $default,) {final _that = this;
switch (_that) {
case _AccelReading() when $default != null:
return $default(_that.x,_that.y,_that.z);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccelReading implements AccelReading {
  const _AccelReading(this.x, this.y, this.z);
  factory _AccelReading.fromJson(Map<String, dynamic> json) => _$AccelReadingFromJson(json);

@override final  double x;
@override final  double y;
@override final  double z;

/// Create a copy of AccelReading
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccelReadingCopyWith<_AccelReading> get copyWith => __$AccelReadingCopyWithImpl<_AccelReading>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccelReadingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccelReading&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.z, z) || other.z == z));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,x,y,z);
}

@override
String toString() {
    return 'AccelReading(x: $x, y: $y, z: $z)';
}


}

/// @nodoc
abstract mixin class _$AccelReadingCopyWith<$Res> implements $AccelReadingCopyWith<$Res> {
  factory _$AccelReadingCopyWith(_AccelReading value, $Res Function(_AccelReading) _then) = __$AccelReadingCopyWithImpl;
@override @useResult
$Res call({
 double x, double y, double z
});




}
/// @nodoc
class __$AccelReadingCopyWithImpl<$Res>
    implements _$AccelReadingCopyWith<$Res> {
  __$AccelReadingCopyWithImpl(this._self, this._then);

  final _AccelReading _self;
  final $Res Function(_AccelReading) _then;

/// Create a copy of AccelReading
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x = null,Object? y = null,Object? z = null,}) {
  return _then(_AccelReading(
null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,null == z ? _self.z : z // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$DeviceCalibration {

/// Biais de chaque tranche, en degrés, par quart de tour
/// ([EdgeTilt.quarterTurns]).
 Map<int, double> get edgesDeg;
/// Create a copy of DeviceCalibration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceCalibrationCopyWith<DeviceCalibration> get copyWith => _$DeviceCalibrationCopyWithImpl<DeviceCalibration>(this as DeviceCalibration, _$identity);

  /// Serializes this DeviceCalibration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeviceCalibration;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceCalibration&&const DeepCollectionEquality().equals(other.edgesDeg, _this.edgesDeg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeviceCalibration;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.edgesDeg));
}

@override
String toString() {
  final _this = this as DeviceCalibration;
  return 'DeviceCalibration(edgesDeg: ${_this.edgesDeg})';
}


}

/// @nodoc
abstract mixin class $DeviceCalibrationCopyWith<$Res>  {
  factory $DeviceCalibrationCopyWith(DeviceCalibration value, $Res Function(DeviceCalibration) _then) = _$DeviceCalibrationCopyWithImpl;
@useResult
$Res call({
 Map<int, double> edgesDeg
});




}
/// @nodoc
class _$DeviceCalibrationCopyWithImpl<$Res>
    implements $DeviceCalibrationCopyWith<$Res> {
  _$DeviceCalibrationCopyWithImpl(this._self, this._then);

  final DeviceCalibration _self;
  final $Res Function(DeviceCalibration) _then;

/// Create a copy of DeviceCalibration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? edgesDeg = null,}) {
  return _then(DeviceCalibration(
edgesDeg: null == edgesDeg ? _self.edgesDeg : edgesDeg // ignore: cast_nullable_to_non_nullable
as Map<int, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceCalibration].
extension DeviceCalibrationPatterns on DeviceCalibration {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceCalibration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceCalibration() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceCalibration value)  $default,){
final _that = this;
switch (_that) {
case _DeviceCalibration():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceCalibration value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceCalibration() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<int, double> edgesDeg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceCalibration() when $default != null:
return $default(_that.edgesDeg);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<int, double> edgesDeg)  $default,) {final _that = this;
switch (_that) {
case _DeviceCalibration():
return $default(_that.edgesDeg);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<int, double> edgesDeg)?  $default,) {final _that = this;
switch (_that) {
case _DeviceCalibration() when $default != null:
return $default(_that.edgesDeg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceCalibration implements DeviceCalibration {
  const _DeviceCalibration({ Map<int, double> edgesDeg = const <int, double>{}}): _edgesDeg = edgesDeg;
  factory _DeviceCalibration.fromJson(Map<String, dynamic> json) => _$DeviceCalibrationFromJson(json);

/// Biais de chaque tranche, en degrés, par quart de tour
/// ([EdgeTilt.quarterTurns]).
 final  Map<int, double> _edgesDeg;
/// Biais de chaque tranche, en degrés, par quart de tour
/// ([EdgeTilt.quarterTurns]).
@override@JsonKey() Map<int, double> get edgesDeg {
  if (_edgesDeg is EqualUnmodifiableMapView) return _edgesDeg;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_edgesDeg);
}


/// Create a copy of DeviceCalibration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceCalibrationCopyWith<_DeviceCalibration> get copyWith => __$DeviceCalibrationCopyWithImpl<_DeviceCalibration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceCalibrationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceCalibration&&const DeepCollectionEquality().equals(other.edgesDeg, _edgesDeg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_edgesDeg));
}

@override
String toString() {
    return 'DeviceCalibration(edgesDeg: $edgesDeg)';
}


}

/// @nodoc
abstract mixin class _$DeviceCalibrationCopyWith<$Res> implements $DeviceCalibrationCopyWith<$Res> {
  factory _$DeviceCalibrationCopyWith(_DeviceCalibration value, $Res Function(_DeviceCalibration) _then) = __$DeviceCalibrationCopyWithImpl;
@override @useResult
$Res call({
 Map<int, double> edgesDeg
});




}
/// @nodoc
class __$DeviceCalibrationCopyWithImpl<$Res>
    implements _$DeviceCalibrationCopyWith<$Res> {
  __$DeviceCalibrationCopyWithImpl(this._self, this._then);

  final _DeviceCalibration _self;
  final $Res Function(_DeviceCalibration) _then;

/// Create a copy of DeviceCalibration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? edgesDeg = null,}) {
  return _then(_DeviceCalibration(
edgesDeg: null == edgesDeg ? _self._edgesDeg : edgesDeg // ignore: cast_nullable_to_non_nullable
as Map<int, double>,
  ));
}


}

/// @nodoc
mixin _$TiltResult {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TiltResult);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TiltResult()';
}


}

/// @nodoc
class $TiltResultCopyWith<$Res>  {
$TiltResultCopyWith(TiltResult _, $Res Function(TiltResult) __);
}


/// Adds pattern-matching-related methods to [TiltResult].
extension TiltResultPatterns on TiltResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FlatTilt value)?  flat,TResult Function( EdgeTilt value)?  edge,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FlatTilt() when flat != null:
return flat(_that);case EdgeTilt() when edge != null:
return edge(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FlatTilt value)  flat,required TResult Function( EdgeTilt value)  edge,}){
final _that = this;
switch (_that) {
case FlatTilt():
return flat(_that);case EdgeTilt():
return edge(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FlatTilt value)?  flat,TResult? Function( EdgeTilt value)?  edge,}){
final _that = this;
switch (_that) {
case FlatTilt() when flat != null:
return flat(_that);case EdgeTilt() when edge != null:
return edge(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  flat,TResult Function( double angleDeg,  int quarterTurns,  bool isLevel,  bool isCalibrated)?  edge,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FlatTilt() when flat != null:
return flat();case EdgeTilt() when edge != null:
return edge(_that.angleDeg,_that.quarterTurns,_that.isLevel,_that.isCalibrated);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  flat,required TResult Function( double angleDeg,  int quarterTurns,  bool isLevel,  bool isCalibrated)  edge,}) {final _that = this;
switch (_that) {
case FlatTilt():
return flat();case EdgeTilt():
return edge(_that.angleDeg,_that.quarterTurns,_that.isLevel,_that.isCalibrated);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  flat,TResult? Function( double angleDeg,  int quarterTurns,  bool isLevel,  bool isCalibrated)?  edge,}) {final _that = this;
switch (_that) {
case FlatTilt() when flat != null:
return flat();case EdgeTilt() when edge != null:
return edge(_that.angleDeg,_that.quarterTurns,_that.isLevel,_that.isCalibrated);case _:
  return null;

}
}

}

/// @nodoc


class FlatTilt implements TiltResult {
  const FlatTilt();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is FlatTilt);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TiltResult.flat()';
}


}




/// @nodoc


class EdgeTilt implements TiltResult {
  const EdgeTilt({required this.angleDeg, required this.quarterTurns, required this.isLevel, required this.isCalibrated});
  

 final  double angleDeg;
 final  int quarterTurns;
 final  bool isLevel;
 final  bool isCalibrated;

/// Create a copy of TiltResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EdgeTiltCopyWith<EdgeTilt> get copyWith => _$EdgeTiltCopyWithImpl<EdgeTilt>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EdgeTilt&&(identical(other.angleDeg, angleDeg) || other.angleDeg == angleDeg)&&(identical(other.quarterTurns, quarterTurns) || other.quarterTurns == quarterTurns)&&(identical(other.isLevel, isLevel) || other.isLevel == isLevel)&&(identical(other.isCalibrated, isCalibrated) || other.isCalibrated == isCalibrated));
}


@override
int get hashCode {
    return Object.hash(runtimeType,angleDeg,quarterTurns,isLevel,isCalibrated);
}

@override
String toString() {
    return 'TiltResult.edge(angleDeg: $angleDeg, quarterTurns: $quarterTurns, isLevel: $isLevel, isCalibrated: $isCalibrated)';
}


}

/// @nodoc
abstract mixin class $EdgeTiltCopyWith<$Res> implements $TiltResultCopyWith<$Res> {
  factory $EdgeTiltCopyWith(EdgeTilt value, $Res Function(EdgeTilt) _then) = _$EdgeTiltCopyWithImpl;
@useResult
$Res call({
 double angleDeg, int quarterTurns, bool isLevel, bool isCalibrated
});




}
/// @nodoc
class _$EdgeTiltCopyWithImpl<$Res>
    implements $EdgeTiltCopyWith<$Res> {
  _$EdgeTiltCopyWithImpl(this._self, this._then);

  final EdgeTilt _self;
  final $Res Function(EdgeTilt) _then;

/// Create a copy of TiltResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? angleDeg = null,Object? quarterTurns = null,Object? isLevel = null,Object? isCalibrated = null,}) {
  return _then(EdgeTilt(
angleDeg: null == angleDeg ? _self.angleDeg : angleDeg // ignore: cast_nullable_to_non_nullable
as double,quarterTurns: null == quarterTurns ? _self.quarterTurns : quarterTurns // ignore: cast_nullable_to_non_nullable
as int,isLevel: null == isLevel ? _self.isLevel : isLevel // ignore: cast_nullable_to_non_nullable
as bool,isCalibrated: null == isCalibrated ? _self.isCalibrated : isCalibrated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
