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
mixin _$TiltResult {

 double get pitchDeg; double get rollDeg; bool get isLevel;
/// Create a copy of TiltResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TiltResultCopyWith<TiltResult> get copyWith => _$TiltResultCopyWithImpl<TiltResult>(this as TiltResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TiltResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TiltResult&&(identical(other.pitchDeg, _this.pitchDeg) || other.pitchDeg == _this.pitchDeg)&&(identical(other.rollDeg, _this.rollDeg) || other.rollDeg == _this.rollDeg)&&(identical(other.isLevel, _this.isLevel) || other.isLevel == _this.isLevel));
}


@override
int get hashCode {
  final _this = this as TiltResult;
  return Object.hash(runtimeType,_this.pitchDeg,_this.rollDeg,_this.isLevel);
}

@override
String toString() {
  final _this = this as TiltResult;
  return 'TiltResult(pitchDeg: ${_this.pitchDeg}, rollDeg: ${_this.rollDeg}, isLevel: ${_this.isLevel})';
}


}

/// @nodoc
abstract mixin class $TiltResultCopyWith<$Res>  {
  factory $TiltResultCopyWith(TiltResult value, $Res Function(TiltResult) _then) = _$TiltResultCopyWithImpl;
@useResult
$Res call({
 double pitchDeg, double rollDeg, bool isLevel
});




}
/// @nodoc
class _$TiltResultCopyWithImpl<$Res>
    implements $TiltResultCopyWith<$Res> {
  _$TiltResultCopyWithImpl(this._self, this._then);

  final TiltResult _self;
  final $Res Function(TiltResult) _then;

/// Create a copy of TiltResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pitchDeg = null,Object? rollDeg = null,Object? isLevel = null,}) {
  return _then(TiltResult(
pitchDeg: null == pitchDeg ? _self.pitchDeg : pitchDeg // ignore: cast_nullable_to_non_nullable
as double,rollDeg: null == rollDeg ? _self.rollDeg : rollDeg // ignore: cast_nullable_to_non_nullable
as double,isLevel: null == isLevel ? _self.isLevel : isLevel // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TiltResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TiltResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TiltResult value)  $default,){
final _that = this;
switch (_that) {
case _TiltResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TiltResult value)?  $default,){
final _that = this;
switch (_that) {
case _TiltResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double pitchDeg,  double rollDeg,  bool isLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TiltResult() when $default != null:
return $default(_that.pitchDeg,_that.rollDeg,_that.isLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double pitchDeg,  double rollDeg,  bool isLevel)  $default,) {final _that = this;
switch (_that) {
case _TiltResult():
return $default(_that.pitchDeg,_that.rollDeg,_that.isLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double pitchDeg,  double rollDeg,  bool isLevel)?  $default,) {final _that = this;
switch (_that) {
case _TiltResult() when $default != null:
return $default(_that.pitchDeg,_that.rollDeg,_that.isLevel);case _:
  return null;

}
}

}

/// @nodoc


class _TiltResult implements TiltResult {
  const _TiltResult({required this.pitchDeg, required this.rollDeg, required this.isLevel});
  

@override final  double pitchDeg;
@override final  double rollDeg;
@override final  bool isLevel;

/// Create a copy of TiltResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TiltResultCopyWith<_TiltResult> get copyWith => __$TiltResultCopyWithImpl<_TiltResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TiltResult&&(identical(other.pitchDeg, pitchDeg) || other.pitchDeg == pitchDeg)&&(identical(other.rollDeg, rollDeg) || other.rollDeg == rollDeg)&&(identical(other.isLevel, isLevel) || other.isLevel == isLevel));
}


@override
int get hashCode {
    return Object.hash(runtimeType,pitchDeg,rollDeg,isLevel);
}

@override
String toString() {
    return 'TiltResult(pitchDeg: $pitchDeg, rollDeg: $rollDeg, isLevel: $isLevel)';
}


}

/// @nodoc
abstract mixin class _$TiltResultCopyWith<$Res> implements $TiltResultCopyWith<$Res> {
  factory _$TiltResultCopyWith(_TiltResult value, $Res Function(_TiltResult) _then) = __$TiltResultCopyWithImpl;
@override @useResult
$Res call({
 double pitchDeg, double rollDeg, bool isLevel
});




}
/// @nodoc
class __$TiltResultCopyWithImpl<$Res>
    implements _$TiltResultCopyWith<$Res> {
  __$TiltResultCopyWithImpl(this._self, this._then);

  final _TiltResult _self;
  final $Res Function(_TiltResult) _then;

/// Create a copy of TiltResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pitchDeg = null,Object? rollDeg = null,Object? isLevel = null,}) {
  return _then(_TiltResult(
pitchDeg: null == pitchDeg ? _self.pitchDeg : pitchDeg // ignore: cast_nullable_to_non_nullable
as double,rollDeg: null == rollDeg ? _self.rollDeg : rollDeg // ignore: cast_nullable_to_non_nullable
as double,isLevel: null == isLevel ? _self.isLevel : isLevel // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
