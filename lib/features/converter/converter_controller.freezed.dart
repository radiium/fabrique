// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'converter_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConverterInput {

 double get value; MeasureUnit get unit;/// Affiche l'impérial en composé (pied + pouce + fraction).
///
/// Longueurs seulement. Conservé au changement de catégorie.
 bool get compoundImperial;
/// Create a copy of ConverterInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConverterInputCopyWith<ConverterInput> get copyWith => _$ConverterInputCopyWithImpl<ConverterInput>(this as ConverterInput, _$identity);

  /// Serializes this ConverterInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConverterInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConverterInput&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.compoundImperial, _this.compoundImperial) || other.compoundImperial == _this.compoundImperial));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConverterInput;
  return Object.hash(runtimeType,_this.value,_this.unit,_this.compoundImperial);
}

@override
String toString() {
  final _this = this as ConverterInput;
  return 'ConverterInput(value: ${_this.value}, unit: ${_this.unit}, compoundImperial: ${_this.compoundImperial})';
}


}

/// @nodoc
abstract mixin class $ConverterInputCopyWith<$Res>  {
  factory $ConverterInputCopyWith(ConverterInput value, $Res Function(ConverterInput) _then) = _$ConverterInputCopyWithImpl;
@useResult
$Res call({
 double value, MeasureUnit unit, bool compoundImperial
});




}
/// @nodoc
class _$ConverterInputCopyWithImpl<$Res>
    implements $ConverterInputCopyWith<$Res> {
  _$ConverterInputCopyWithImpl(this._self, this._then);

  final ConverterInput _self;
  final $Res Function(ConverterInput) _then;

/// Create a copy of ConverterInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? unit = null,Object? compoundImperial = null,}) {
  return _then(ConverterInput(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as MeasureUnit,compoundImperial: null == compoundImperial ? _self.compoundImperial : compoundImperial // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ConverterInput].
extension ConverterInputPatterns on ConverterInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConverterInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConverterInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConverterInput value)  $default,){
final _that = this;
switch (_that) {
case _ConverterInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConverterInput value)?  $default,){
final _that = this;
switch (_that) {
case _ConverterInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double value,  MeasureUnit unit,  bool compoundImperial)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConverterInput() when $default != null:
return $default(_that.value,_that.unit,_that.compoundImperial);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double value,  MeasureUnit unit,  bool compoundImperial)  $default,) {final _that = this;
switch (_that) {
case _ConverterInput():
return $default(_that.value,_that.unit,_that.compoundImperial);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double value,  MeasureUnit unit,  bool compoundImperial)?  $default,) {final _that = this;
switch (_that) {
case _ConverterInput() when $default != null:
return $default(_that.value,_that.unit,_that.compoundImperial);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConverterInput extends ConverterInput {
  const _ConverterInput({required this.value, required this.unit, this.compoundImperial = true}): super._();
  factory _ConverterInput.fromJson(Map<String, dynamic> json) => _$ConverterInputFromJson(json);

@override final  double value;
@override final  MeasureUnit unit;
/// Affiche l'impérial en composé (pied + pouce + fraction).
///
/// Longueurs seulement. Conservé au changement de catégorie.
@override@JsonKey() final  bool compoundImperial;

/// Create a copy of ConverterInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConverterInputCopyWith<_ConverterInput> get copyWith => __$ConverterInputCopyWithImpl<_ConverterInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConverterInputToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConverterInput&&(identical(other.value, value) || other.value == value)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.compoundImperial, compoundImperial) || other.compoundImperial == compoundImperial));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,value,unit,compoundImperial);
}

@override
String toString() {
    return 'ConverterInput(value: $value, unit: $unit, compoundImperial: $compoundImperial)';
}


}

/// @nodoc
abstract mixin class _$ConverterInputCopyWith<$Res> implements $ConverterInputCopyWith<$Res> {
  factory _$ConverterInputCopyWith(_ConverterInput value, $Res Function(_ConverterInput) _then) = __$ConverterInputCopyWithImpl;
@override @useResult
$Res call({
 double value, MeasureUnit unit, bool compoundImperial
});




}
/// @nodoc
class __$ConverterInputCopyWithImpl<$Res>
    implements _$ConverterInputCopyWith<$Res> {
  __$ConverterInputCopyWithImpl(this._self, this._then);

  final _ConverterInput _self;
  final $Res Function(_ConverterInput) _then;

/// Create a copy of ConverterInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? unit = null,Object? compoundImperial = null,}) {
  return _then(_ConverterInput(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as MeasureUnit,compoundImperial: null == compoundImperial ? _self.compoundImperial : compoundImperial // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ConverterResult {

 Quantity get quantity;/// La valeur dans l'unité pivot de la catégorie (mm, mm², mm³, g, Pa).
 double get base; Map<MeasureUnit, double> get perUnit;/// Décomposition pied + pouce + fraction — `null` hors longueur.
 ImperialParts? get imperial;
/// Create a copy of ConverterResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConverterResultCopyWith<ConverterResult> get copyWith => _$ConverterResultCopyWithImpl<ConverterResult>(this as ConverterResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ConverterResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConverterResult&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.base, _this.base) || other.base == _this.base)&&const DeepCollectionEquality().equals(other.perUnit, _this.perUnit)&&(identical(other.imperial, _this.imperial) || other.imperial == _this.imperial));
}


@override
int get hashCode {
  final _this = this as ConverterResult;
  return Object.hash(runtimeType,_this.quantity,_this.base,const DeepCollectionEquality().hash(_this.perUnit),_this.imperial);
}

@override
String toString() {
  final _this = this as ConverterResult;
  return 'ConverterResult(quantity: ${_this.quantity}, base: ${_this.base}, perUnit: ${_this.perUnit}, imperial: ${_this.imperial})';
}


}

/// @nodoc
abstract mixin class $ConverterResultCopyWith<$Res>  {
  factory $ConverterResultCopyWith(ConverterResult value, $Res Function(ConverterResult) _then) = _$ConverterResultCopyWithImpl;
@useResult
$Res call({
 Quantity quantity, double base, Map<MeasureUnit, double> perUnit, ImperialParts? imperial
});


$ImperialPartsCopyWith<$Res>? get imperial;

}
/// @nodoc
class _$ConverterResultCopyWithImpl<$Res>
    implements $ConverterResultCopyWith<$Res> {
  _$ConverterResultCopyWithImpl(this._self, this._then);

  final ConverterResult _self;
  final $Res Function(ConverterResult) _then;

/// Create a copy of ConverterResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quantity = null,Object? base = null,Object? perUnit = null,Object? imperial = freezed,}) {
  return _then(ConverterResult(
quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Quantity,base: null == base ? _self.base : base // ignore: cast_nullable_to_non_nullable
as double,perUnit: null == perUnit ? _self.perUnit : perUnit // ignore: cast_nullable_to_non_nullable
as Map<MeasureUnit, double>,imperial: freezed == imperial ? _self.imperial : imperial // ignore: cast_nullable_to_non_nullable
as ImperialParts?,
  ));
}
/// Create a copy of ConverterResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImperialPartsCopyWith<$Res>? get imperial {
    if (_self.imperial == null) {
    return null;
  }

  return $ImperialPartsCopyWith<$Res>(_self.imperial!, (value) {
    return _then(_self.copyWith(imperial: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConverterResult].
extension ConverterResultPatterns on ConverterResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConverterResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConverterResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConverterResult value)  $default,){
final _that = this;
switch (_that) {
case _ConverterResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConverterResult value)?  $default,){
final _that = this;
switch (_that) {
case _ConverterResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Quantity quantity,  double base,  Map<MeasureUnit, double> perUnit,  ImperialParts? imperial)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConverterResult() when $default != null:
return $default(_that.quantity,_that.base,_that.perUnit,_that.imperial);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Quantity quantity,  double base,  Map<MeasureUnit, double> perUnit,  ImperialParts? imperial)  $default,) {final _that = this;
switch (_that) {
case _ConverterResult():
return $default(_that.quantity,_that.base,_that.perUnit,_that.imperial);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Quantity quantity,  double base,  Map<MeasureUnit, double> perUnit,  ImperialParts? imperial)?  $default,) {final _that = this;
switch (_that) {
case _ConverterResult() when $default != null:
return $default(_that.quantity,_that.base,_that.perUnit,_that.imperial);case _:
  return null;

}
}

}

/// @nodoc


class _ConverterResult implements ConverterResult {
  const _ConverterResult({required this.quantity, required this.base, required  Map<MeasureUnit, double> perUnit, this.imperial}): _perUnit = perUnit;
  

@override final  Quantity quantity;
/// La valeur dans l'unité pivot de la catégorie (mm, mm², mm³, g, Pa).
@override final  double base;
 final  Map<MeasureUnit, double> _perUnit;
@override Map<MeasureUnit, double> get perUnit {
  if (_perUnit is EqualUnmodifiableMapView) return _perUnit;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_perUnit);
}

/// Décomposition pied + pouce + fraction — `null` hors longueur.
@override final  ImperialParts? imperial;

/// Create a copy of ConverterResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConverterResultCopyWith<_ConverterResult> get copyWith => __$ConverterResultCopyWithImpl<_ConverterResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConverterResult&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.base, base) || other.base == base)&&const DeepCollectionEquality().equals(other.perUnit, _perUnit)&&(identical(other.imperial, imperial) || other.imperial == imperial));
}


@override
int get hashCode {
    return Object.hash(runtimeType,quantity,base,const DeepCollectionEquality().hash(_perUnit),imperial);
}

@override
String toString() {
    return 'ConverterResult(quantity: $quantity, base: $base, perUnit: $perUnit, imperial: $imperial)';
}


}

/// @nodoc
abstract mixin class _$ConverterResultCopyWith<$Res> implements $ConverterResultCopyWith<$Res> {
  factory _$ConverterResultCopyWith(_ConverterResult value, $Res Function(_ConverterResult) _then) = __$ConverterResultCopyWithImpl;
@override @useResult
$Res call({
 Quantity quantity, double base, Map<MeasureUnit, double> perUnit, ImperialParts? imperial
});


@override $ImperialPartsCopyWith<$Res>? get imperial;

}
/// @nodoc
class __$ConverterResultCopyWithImpl<$Res>
    implements _$ConverterResultCopyWith<$Res> {
  __$ConverterResultCopyWithImpl(this._self, this._then);

  final _ConverterResult _self;
  final $Res Function(_ConverterResult) _then;

/// Create a copy of ConverterResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quantity = null,Object? base = null,Object? perUnit = null,Object? imperial = freezed,}) {
  return _then(_ConverterResult(
quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Quantity,base: null == base ? _self.base : base // ignore: cast_nullable_to_non_nullable
as double,perUnit: null == perUnit ? _self._perUnit : perUnit // ignore: cast_nullable_to_non_nullable
as Map<MeasureUnit, double>,imperial: freezed == imperial ? _self.imperial : imperial // ignore: cast_nullable_to_non_nullable
as ImperialParts?,
  ));
}

/// Create a copy of ConverterResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImperialPartsCopyWith<$Res>? get imperial {
    if (_self.imperial == null) {
    return null;
  }

  return $ImperialPartsCopyWith<$Res>(_self.imperial!, (value) {
    return _then(_self.copyWith(imperial: value));
  });
}
}

// dart format on
