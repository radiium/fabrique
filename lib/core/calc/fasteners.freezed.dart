// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fasteners.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FastenerInput {

 MaterialKind get material;/// Ø nominal de la vis, en mm.
 double get screwDiameter;/// Épaisseur de la pièce traversée, en mm.
 double get fixedThickness;
/// Create a copy of FastenerInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FastenerInputCopyWith<FastenerInput> get copyWith => _$FastenerInputCopyWithImpl<FastenerInput>(this as FastenerInput, _$identity);

  /// Serializes this FastenerInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FastenerInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FastenerInput&&(identical(other.material, _this.material) || other.material == _this.material)&&(identical(other.screwDiameter, _this.screwDiameter) || other.screwDiameter == _this.screwDiameter)&&(identical(other.fixedThickness, _this.fixedThickness) || other.fixedThickness == _this.fixedThickness));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FastenerInput;
  return Object.hash(runtimeType,_this.material,_this.screwDiameter,_this.fixedThickness);
}

@override
String toString() {
  final _this = this as FastenerInput;
  return 'FastenerInput(material: ${_this.material}, screwDiameter: ${_this.screwDiameter}, fixedThickness: ${_this.fixedThickness})';
}


}

/// @nodoc
abstract mixin class $FastenerInputCopyWith<$Res>  {
  factory $FastenerInputCopyWith(FastenerInput value, $Res Function(FastenerInput) _then) = _$FastenerInputCopyWithImpl;
@useResult
$Res call({
 MaterialKind material, double screwDiameter, double fixedThickness
});




}
/// @nodoc
class _$FastenerInputCopyWithImpl<$Res>
    implements $FastenerInputCopyWith<$Res> {
  _$FastenerInputCopyWithImpl(this._self, this._then);

  final FastenerInput _self;
  final $Res Function(FastenerInput) _then;

/// Create a copy of FastenerInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? material = null,Object? screwDiameter = null,Object? fixedThickness = null,}) {
  return _then(FastenerInput(
material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as MaterialKind,screwDiameter: null == screwDiameter ? _self.screwDiameter : screwDiameter // ignore: cast_nullable_to_non_nullable
as double,fixedThickness: null == fixedThickness ? _self.fixedThickness : fixedThickness // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FastenerInput].
extension FastenerInputPatterns on FastenerInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FastenerInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FastenerInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FastenerInput value)  $default,){
final _that = this;
switch (_that) {
case _FastenerInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FastenerInput value)?  $default,){
final _that = this;
switch (_that) {
case _FastenerInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MaterialKind material,  double screwDiameter,  double fixedThickness)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FastenerInput() when $default != null:
return $default(_that.material,_that.screwDiameter,_that.fixedThickness);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MaterialKind material,  double screwDiameter,  double fixedThickness)  $default,) {final _that = this;
switch (_that) {
case _FastenerInput():
return $default(_that.material,_that.screwDiameter,_that.fixedThickness);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MaterialKind material,  double screwDiameter,  double fixedThickness)?  $default,) {final _that = this;
switch (_that) {
case _FastenerInput() when $default != null:
return $default(_that.material,_that.screwDiameter,_that.fixedThickness);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FastenerInput implements FastenerInput {
  const _FastenerInput({required this.material, required this.screwDiameter, required this.fixedThickness});
  factory _FastenerInput.fromJson(Map<String, dynamic> json) => _$FastenerInputFromJson(json);

@override final  MaterialKind material;
/// Ø nominal de la vis, en mm.
@override final  double screwDiameter;
/// Épaisseur de la pièce traversée, en mm.
@override final  double fixedThickness;

/// Create a copy of FastenerInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FastenerInputCopyWith<_FastenerInput> get copyWith => __$FastenerInputCopyWithImpl<_FastenerInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FastenerInputToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FastenerInput&&(identical(other.material, material) || other.material == material)&&(identical(other.screwDiameter, screwDiameter) || other.screwDiameter == screwDiameter)&&(identical(other.fixedThickness, fixedThickness) || other.fixedThickness == fixedThickness));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,material,screwDiameter,fixedThickness);
}

@override
String toString() {
    return 'FastenerInput(material: $material, screwDiameter: $screwDiameter, fixedThickness: $fixedThickness)';
}


}

/// @nodoc
abstract mixin class _$FastenerInputCopyWith<$Res> implements $FastenerInputCopyWith<$Res> {
  factory _$FastenerInputCopyWith(_FastenerInput value, $Res Function(_FastenerInput) _then) = __$FastenerInputCopyWithImpl;
@override @useResult
$Res call({
 MaterialKind material, double screwDiameter, double fixedThickness
});




}
/// @nodoc
class __$FastenerInputCopyWithImpl<$Res>
    implements _$FastenerInputCopyWith<$Res> {
  __$FastenerInputCopyWithImpl(this._self, this._then);

  final _FastenerInput _self;
  final $Res Function(_FastenerInput) _then;

/// Create a copy of FastenerInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? material = null,Object? screwDiameter = null,Object? fixedThickness = null,}) {
  return _then(_FastenerInput(
material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as MaterialKind,screwDiameter: null == screwDiameter ? _self.screwDiameter : screwDiameter // ignore: cast_nullable_to_non_nullable
as double,fixedThickness: null == fixedThickness ? _self.fixedThickness : fixedThickness // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$FastenerResult {

/// Ø du trou de passage.
 double get clearanceHole;/// Ø de l'avant-trou de guidage.
 double get pilotHole; double get counterboreDia; double get counterboreDepth; double get screwLength; double get penetration;
/// Create a copy of FastenerResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FastenerResultCopyWith<FastenerResult> get copyWith => _$FastenerResultCopyWithImpl<FastenerResult>(this as FastenerResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FastenerResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FastenerResult&&(identical(other.clearanceHole, _this.clearanceHole) || other.clearanceHole == _this.clearanceHole)&&(identical(other.pilotHole, _this.pilotHole) || other.pilotHole == _this.pilotHole)&&(identical(other.counterboreDia, _this.counterboreDia) || other.counterboreDia == _this.counterboreDia)&&(identical(other.counterboreDepth, _this.counterboreDepth) || other.counterboreDepth == _this.counterboreDepth)&&(identical(other.screwLength, _this.screwLength) || other.screwLength == _this.screwLength)&&(identical(other.penetration, _this.penetration) || other.penetration == _this.penetration));
}


@override
int get hashCode {
  final _this = this as FastenerResult;
  return Object.hash(runtimeType,_this.clearanceHole,_this.pilotHole,_this.counterboreDia,_this.counterboreDepth,_this.screwLength,_this.penetration);
}

@override
String toString() {
  final _this = this as FastenerResult;
  return 'FastenerResult(clearanceHole: ${_this.clearanceHole}, pilotHole: ${_this.pilotHole}, counterboreDia: ${_this.counterboreDia}, counterboreDepth: ${_this.counterboreDepth}, screwLength: ${_this.screwLength}, penetration: ${_this.penetration})';
}


}

/// @nodoc
abstract mixin class $FastenerResultCopyWith<$Res>  {
  factory $FastenerResultCopyWith(FastenerResult value, $Res Function(FastenerResult) _then) = _$FastenerResultCopyWithImpl;
@useResult
$Res call({
 double clearanceHole, double pilotHole, double counterboreDia, double counterboreDepth, double screwLength, double penetration
});




}
/// @nodoc
class _$FastenerResultCopyWithImpl<$Res>
    implements $FastenerResultCopyWith<$Res> {
  _$FastenerResultCopyWithImpl(this._self, this._then);

  final FastenerResult _self;
  final $Res Function(FastenerResult) _then;

/// Create a copy of FastenerResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clearanceHole = null,Object? pilotHole = null,Object? counterboreDia = null,Object? counterboreDepth = null,Object? screwLength = null,Object? penetration = null,}) {
  return _then(FastenerResult(
clearanceHole: null == clearanceHole ? _self.clearanceHole : clearanceHole // ignore: cast_nullable_to_non_nullable
as double,pilotHole: null == pilotHole ? _self.pilotHole : pilotHole // ignore: cast_nullable_to_non_nullable
as double,counterboreDia: null == counterboreDia ? _self.counterboreDia : counterboreDia // ignore: cast_nullable_to_non_nullable
as double,counterboreDepth: null == counterboreDepth ? _self.counterboreDepth : counterboreDepth // ignore: cast_nullable_to_non_nullable
as double,screwLength: null == screwLength ? _self.screwLength : screwLength // ignore: cast_nullable_to_non_nullable
as double,penetration: null == penetration ? _self.penetration : penetration // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FastenerResult].
extension FastenerResultPatterns on FastenerResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FastenerResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FastenerResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FastenerResult value)  $default,){
final _that = this;
switch (_that) {
case _FastenerResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FastenerResult value)?  $default,){
final _that = this;
switch (_that) {
case _FastenerResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double clearanceHole,  double pilotHole,  double counterboreDia,  double counterboreDepth,  double screwLength,  double penetration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FastenerResult() when $default != null:
return $default(_that.clearanceHole,_that.pilotHole,_that.counterboreDia,_that.counterboreDepth,_that.screwLength,_that.penetration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double clearanceHole,  double pilotHole,  double counterboreDia,  double counterboreDepth,  double screwLength,  double penetration)  $default,) {final _that = this;
switch (_that) {
case _FastenerResult():
return $default(_that.clearanceHole,_that.pilotHole,_that.counterboreDia,_that.counterboreDepth,_that.screwLength,_that.penetration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double clearanceHole,  double pilotHole,  double counterboreDia,  double counterboreDepth,  double screwLength,  double penetration)?  $default,) {final _that = this;
switch (_that) {
case _FastenerResult() when $default != null:
return $default(_that.clearanceHole,_that.pilotHole,_that.counterboreDia,_that.counterboreDepth,_that.screwLength,_that.penetration);case _:
  return null;

}
}

}

/// @nodoc


class _FastenerResult implements FastenerResult {
  const _FastenerResult({required this.clearanceHole, required this.pilotHole, required this.counterboreDia, required this.counterboreDepth, required this.screwLength, required this.penetration});
  

/// Ø du trou de passage.
@override final  double clearanceHole;
/// Ø de l'avant-trou de guidage.
@override final  double pilotHole;
@override final  double counterboreDia;
@override final  double counterboreDepth;
@override final  double screwLength;
@override final  double penetration;

/// Create a copy of FastenerResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FastenerResultCopyWith<_FastenerResult> get copyWith => __$FastenerResultCopyWithImpl<_FastenerResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FastenerResult&&(identical(other.clearanceHole, clearanceHole) || other.clearanceHole == clearanceHole)&&(identical(other.pilotHole, pilotHole) || other.pilotHole == pilotHole)&&(identical(other.counterboreDia, counterboreDia) || other.counterboreDia == counterboreDia)&&(identical(other.counterboreDepth, counterboreDepth) || other.counterboreDepth == counterboreDepth)&&(identical(other.screwLength, screwLength) || other.screwLength == screwLength)&&(identical(other.penetration, penetration) || other.penetration == penetration));
}


@override
int get hashCode {
    return Object.hash(runtimeType,clearanceHole,pilotHole,counterboreDia,counterboreDepth,screwLength,penetration);
}

@override
String toString() {
    return 'FastenerResult(clearanceHole: $clearanceHole, pilotHole: $pilotHole, counterboreDia: $counterboreDia, counterboreDepth: $counterboreDepth, screwLength: $screwLength, penetration: $penetration)';
}


}

/// @nodoc
abstract mixin class _$FastenerResultCopyWith<$Res> implements $FastenerResultCopyWith<$Res> {
  factory _$FastenerResultCopyWith(_FastenerResult value, $Res Function(_FastenerResult) _then) = __$FastenerResultCopyWithImpl;
@override @useResult
$Res call({
 double clearanceHole, double pilotHole, double counterboreDia, double counterboreDepth, double screwLength, double penetration
});




}
/// @nodoc
class __$FastenerResultCopyWithImpl<$Res>
    implements _$FastenerResultCopyWith<$Res> {
  __$FastenerResultCopyWithImpl(this._self, this._then);

  final _FastenerResult _self;
  final $Res Function(_FastenerResult) _then;

/// Create a copy of FastenerResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clearanceHole = null,Object? pilotHole = null,Object? counterboreDia = null,Object? counterboreDepth = null,Object? screwLength = null,Object? penetration = null,}) {
  return _then(_FastenerResult(
clearanceHole: null == clearanceHole ? _self.clearanceHole : clearanceHole // ignore: cast_nullable_to_non_nullable
as double,pilotHole: null == pilotHole ? _self.pilotHole : pilotHole // ignore: cast_nullable_to_non_nullable
as double,counterboreDia: null == counterboreDia ? _self.counterboreDia : counterboreDia // ignore: cast_nullable_to_non_nullable
as double,counterboreDepth: null == counterboreDepth ? _self.counterboreDepth : counterboreDepth // ignore: cast_nullable_to_non_nullable
as double,screwLength: null == screwLength ? _self.screwLength : screwLength // ignore: cast_nullable_to_non_nullable
as double,penetration: null == penetration ? _self.penetration : penetration // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
