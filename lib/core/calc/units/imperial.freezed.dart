// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'imperial.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImperialParts {

 int get feet; int get inches;/// Numérateur de la fraction de pouce (0 si valeur entière).
 int get num;/// Dénominateur de la fraction (16, 32…).
 int get den;
/// Create a copy of ImperialParts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImperialPartsCopyWith<ImperialParts> get copyWith => _$ImperialPartsCopyWithImpl<ImperialParts>(this as ImperialParts, _$identity);

  /// Serializes this ImperialParts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ImperialParts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImperialParts&&(identical(other.feet, _this.feet) || other.feet == _this.feet)&&(identical(other.inches, _this.inches) || other.inches == _this.inches)&&(identical(other.num, _this.num) || other.num == _this.num)&&(identical(other.den, _this.den) || other.den == _this.den));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ImperialParts;
  return Object.hash(runtimeType,_this.feet,_this.inches,_this.num,_this.den);
}

@override
String toString() {
  final _this = this as ImperialParts;
  return 'ImperialParts(feet: ${_this.feet}, inches: ${_this.inches}, num: ${_this.num}, den: ${_this.den})';
}


}

/// @nodoc
abstract mixin class $ImperialPartsCopyWith<$Res>  {
  factory $ImperialPartsCopyWith(ImperialParts value, $Res Function(ImperialParts) _then) = _$ImperialPartsCopyWithImpl;
@useResult
$Res call({
 int feet, int inches, int num, int den
});




}
/// @nodoc
class _$ImperialPartsCopyWithImpl<$Res>
    implements $ImperialPartsCopyWith<$Res> {
  _$ImperialPartsCopyWithImpl(this._self, this._then);

  final ImperialParts _self;
  final $Res Function(ImperialParts) _then;

/// Create a copy of ImperialParts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? feet = null,Object? inches = null,Object? num = null,Object? den = null,}) {
  return _then(ImperialParts(
feet: null == feet ? _self.feet : feet // ignore: cast_nullable_to_non_nullable
as int,inches: null == inches ? _self.inches : inches // ignore: cast_nullable_to_non_nullable
as int,num: null == num ? _self.num : num // ignore: cast_nullable_to_non_nullable
as int,den: null == den ? _self.den : den // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ImperialParts].
extension ImperialPartsPatterns on ImperialParts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImperialParts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImperialParts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImperialParts value)  $default,){
final _that = this;
switch (_that) {
case _ImperialParts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImperialParts value)?  $default,){
final _that = this;
switch (_that) {
case _ImperialParts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int feet,  int inches,  int num,  int den)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImperialParts() when $default != null:
return $default(_that.feet,_that.inches,_that.num,_that.den);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int feet,  int inches,  int num,  int den)  $default,) {final _that = this;
switch (_that) {
case _ImperialParts():
return $default(_that.feet,_that.inches,_that.num,_that.den);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int feet,  int inches,  int num,  int den)?  $default,) {final _that = this;
switch (_that) {
case _ImperialParts() when $default != null:
return $default(_that.feet,_that.inches,_that.num,_that.den);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImperialParts implements ImperialParts {
  const _ImperialParts({required this.feet, required this.inches, required this.num, required this.den});
  factory _ImperialParts.fromJson(Map<String, dynamic> json) => _$ImperialPartsFromJson(json);

@override final  int feet;
@override final  int inches;
/// Numérateur de la fraction de pouce (0 si valeur entière).
@override final  int num;
/// Dénominateur de la fraction (16, 32…).
@override final  int den;

/// Create a copy of ImperialParts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImperialPartsCopyWith<_ImperialParts> get copyWith => __$ImperialPartsCopyWithImpl<_ImperialParts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImperialPartsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImperialParts&&(identical(other.feet, feet) || other.feet == feet)&&(identical(other.inches, inches) || other.inches == inches)&&(identical(other.num, num) || other.num == num)&&(identical(other.den, den) || other.den == den));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,feet,inches,num,den);
}

@override
String toString() {
    return 'ImperialParts(feet: $feet, inches: $inches, num: $num, den: $den)';
}


}

/// @nodoc
abstract mixin class _$ImperialPartsCopyWith<$Res> implements $ImperialPartsCopyWith<$Res> {
  factory _$ImperialPartsCopyWith(_ImperialParts value, $Res Function(_ImperialParts) _then) = __$ImperialPartsCopyWithImpl;
@override @useResult
$Res call({
 int feet, int inches, int num, int den
});




}
/// @nodoc
class __$ImperialPartsCopyWithImpl<$Res>
    implements _$ImperialPartsCopyWith<$Res> {
  __$ImperialPartsCopyWithImpl(this._self, this._then);

  final _ImperialParts _self;
  final $Res Function(_ImperialParts) _then;

/// Create a copy of ImperialParts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? feet = null,Object? inches = null,Object? num = null,Object? den = null,}) {
  return _then(_ImperialParts(
feet: null == feet ? _self.feet : feet // ignore: cast_nullable_to_non_nullable
as int,inches: null == inches ? _self.inches : inches // ignore: cast_nullable_to_non_nullable
as int,num: null == num ? _self.num : num // ignore: cast_nullable_to_non_nullable
as int,den: null == den ? _self.den : den // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
