// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'distribution.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DistributionInput {

/// Largeur totale à garnir, en mm.
 double get length;/// Nombre d'éléments à répartir (>= 0).
 int get count;/// Largeur d'un élément, en mm. `0` = répartition de points purs.
 double get elementWidth;/// Bord de départ, à l'origine.
 DistributionEdge get startEdge;/// Bord d'arrivée.
 DistributionEdge get endEdge;/// « Marge » de début : une bande de largeur soustraite avant toute
/// répartition. Sert à réserver une largeur imposée — un chant, un tasseau
/// existant — que le calcul n'a pas à redistribuer.
 double get startOffset;/// « Marge » de fin. Distinct de [startOffset] : une répartition
/// asymétrique est un cas courant dès qu'un bord est contraint.
 double get endOffset;
/// Create a copy of DistributionInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DistributionInputCopyWith<DistributionInput> get copyWith => _$DistributionInputCopyWithImpl<DistributionInput>(this as DistributionInput, _$identity);

  /// Serializes this DistributionInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DistributionInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DistributionInput&&(identical(other.length, _this.length) || other.length == _this.length)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.elementWidth, _this.elementWidth) || other.elementWidth == _this.elementWidth)&&(identical(other.startEdge, _this.startEdge) || other.startEdge == _this.startEdge)&&(identical(other.endEdge, _this.endEdge) || other.endEdge == _this.endEdge)&&(identical(other.startOffset, _this.startOffset) || other.startOffset == _this.startOffset)&&(identical(other.endOffset, _this.endOffset) || other.endOffset == _this.endOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DistributionInput;
  return Object.hash(runtimeType,_this.length,_this.count,_this.elementWidth,_this.startEdge,_this.endEdge,_this.startOffset,_this.endOffset);
}

@override
String toString() {
  final _this = this as DistributionInput;
  return 'DistributionInput(length: ${_this.length}, count: ${_this.count}, elementWidth: ${_this.elementWidth}, startEdge: ${_this.startEdge}, endEdge: ${_this.endEdge}, startOffset: ${_this.startOffset}, endOffset: ${_this.endOffset})';
}


}

/// @nodoc
abstract mixin class $DistributionInputCopyWith<$Res>  {
  factory $DistributionInputCopyWith(DistributionInput value, $Res Function(DistributionInput) _then) = _$DistributionInputCopyWithImpl;
@useResult
$Res call({
 double length, int count, double elementWidth, DistributionEdge startEdge, DistributionEdge endEdge, double startOffset, double endOffset
});




}
/// @nodoc
class _$DistributionInputCopyWithImpl<$Res>
    implements $DistributionInputCopyWith<$Res> {
  _$DistributionInputCopyWithImpl(this._self, this._then);

  final DistributionInput _self;
  final $Res Function(DistributionInput) _then;

/// Create a copy of DistributionInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? length = null,Object? count = null,Object? elementWidth = null,Object? startEdge = null,Object? endEdge = null,Object? startOffset = null,Object? endOffset = null,}) {
  return _then(DistributionInput(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,elementWidth: null == elementWidth ? _self.elementWidth : elementWidth // ignore: cast_nullable_to_non_nullable
as double,startEdge: null == startEdge ? _self.startEdge : startEdge // ignore: cast_nullable_to_non_nullable
as DistributionEdge,endEdge: null == endEdge ? _self.endEdge : endEdge // ignore: cast_nullable_to_non_nullable
as DistributionEdge,startOffset: null == startOffset ? _self.startOffset : startOffset // ignore: cast_nullable_to_non_nullable
as double,endOffset: null == endOffset ? _self.endOffset : endOffset // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DistributionInput].
extension DistributionInputPatterns on DistributionInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DistributionInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DistributionInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DistributionInput value)  $default,){
final _that = this;
switch (_that) {
case _DistributionInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DistributionInput value)?  $default,){
final _that = this;
switch (_that) {
case _DistributionInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double length,  int count,  double elementWidth,  DistributionEdge startEdge,  DistributionEdge endEdge,  double startOffset,  double endOffset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DistributionInput() when $default != null:
return $default(_that.length,_that.count,_that.elementWidth,_that.startEdge,_that.endEdge,_that.startOffset,_that.endOffset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double length,  int count,  double elementWidth,  DistributionEdge startEdge,  DistributionEdge endEdge,  double startOffset,  double endOffset)  $default,) {final _that = this;
switch (_that) {
case _DistributionInput():
return $default(_that.length,_that.count,_that.elementWidth,_that.startEdge,_that.endEdge,_that.startOffset,_that.endOffset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double length,  int count,  double elementWidth,  DistributionEdge startEdge,  DistributionEdge endEdge,  double startOffset,  double endOffset)?  $default,) {final _that = this;
switch (_that) {
case _DistributionInput() when $default != null:
return $default(_that.length,_that.count,_that.elementWidth,_that.startEdge,_that.endEdge,_that.startOffset,_that.endOffset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DistributionInput implements DistributionInput {
  const _DistributionInput({required this.length, required this.count, this.elementWidth = 0, this.startEdge = DistributionEdge.gap, this.endEdge = DistributionEdge.gap, this.startOffset = 0, this.endOffset = 0});
  factory _DistributionInput.fromJson(Map<String, dynamic> json) => _$DistributionInputFromJson(json);

/// Largeur totale à garnir, en mm.
@override final  double length;
/// Nombre d'éléments à répartir (>= 0).
@override final  int count;
/// Largeur d'un élément, en mm. `0` = répartition de points purs.
@override@JsonKey() final  double elementWidth;
/// Bord de départ, à l'origine.
@override@JsonKey() final  DistributionEdge startEdge;
/// Bord d'arrivée.
@override@JsonKey() final  DistributionEdge endEdge;
/// « Marge » de début : une bande de largeur soustraite avant toute
/// répartition. Sert à réserver une largeur imposée — un chant, un tasseau
/// existant — que le calcul n'a pas à redistribuer.
@override@JsonKey() final  double startOffset;
/// « Marge » de fin. Distinct de [startOffset] : une répartition
/// asymétrique est un cas courant dès qu'un bord est contraint.
@override@JsonKey() final  double endOffset;

/// Create a copy of DistributionInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DistributionInputCopyWith<_DistributionInput> get copyWith => __$DistributionInputCopyWithImpl<_DistributionInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DistributionInputToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DistributionInput&&(identical(other.length, length) || other.length == length)&&(identical(other.count, count) || other.count == count)&&(identical(other.elementWidth, elementWidth) || other.elementWidth == elementWidth)&&(identical(other.startEdge, startEdge) || other.startEdge == startEdge)&&(identical(other.endEdge, endEdge) || other.endEdge == endEdge)&&(identical(other.startOffset, startOffset) || other.startOffset == startOffset)&&(identical(other.endOffset, endOffset) || other.endOffset == endOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,length,count,elementWidth,startEdge,endEdge,startOffset,endOffset);
}

@override
String toString() {
    return 'DistributionInput(length: $length, count: $count, elementWidth: $elementWidth, startEdge: $startEdge, endEdge: $endEdge, startOffset: $startOffset, endOffset: $endOffset)';
}


}

/// @nodoc
abstract mixin class _$DistributionInputCopyWith<$Res> implements $DistributionInputCopyWith<$Res> {
  factory _$DistributionInputCopyWith(_DistributionInput value, $Res Function(_DistributionInput) _then) = __$DistributionInputCopyWithImpl;
@override @useResult
$Res call({
 double length, int count, double elementWidth, DistributionEdge startEdge, DistributionEdge endEdge, double startOffset, double endOffset
});




}
/// @nodoc
class __$DistributionInputCopyWithImpl<$Res>
    implements _$DistributionInputCopyWith<$Res> {
  __$DistributionInputCopyWithImpl(this._self, this._then);

  final _DistributionInput _self;
  final $Res Function(_DistributionInput) _then;

/// Create a copy of DistributionInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? length = null,Object? count = null,Object? elementWidth = null,Object? startEdge = null,Object? endEdge = null,Object? startOffset = null,Object? endOffset = null,}) {
  return _then(_DistributionInput(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,elementWidth: null == elementWidth ? _self.elementWidth : elementWidth // ignore: cast_nullable_to_non_nullable
as double,startEdge: null == startEdge ? _self.startEdge : startEdge // ignore: cast_nullable_to_non_nullable
as DistributionEdge,endEdge: null == endEdge ? _self.endEdge : endEdge // ignore: cast_nullable_to_non_nullable
as DistributionEdge,startOffset: null == startOffset ? _self.startOffset : startOffset // ignore: cast_nullable_to_non_nullable
as double,endOffset: null == endOffset ? _self.endOffset : endOffset // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$DistributionTargetInput {

/// Largeur totale à garnir, en mm.
 double get length;/// Écart visé entre deux éléments, en mm. Presque jamais atteignable
/// exactement — voir [computeDistributionForSpacing].
 double get targetSpacing;/// Largeur d'un élément, en mm.
 double get elementWidth; DistributionEdge get startEdge; DistributionEdge get endEdge; double get startOffset; double get endOffset;
/// Create a copy of DistributionTargetInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DistributionTargetInputCopyWith<DistributionTargetInput> get copyWith => _$DistributionTargetInputCopyWithImpl<DistributionTargetInput>(this as DistributionTargetInput, _$identity);

  /// Serializes this DistributionTargetInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DistributionTargetInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DistributionTargetInput&&(identical(other.length, _this.length) || other.length == _this.length)&&(identical(other.targetSpacing, _this.targetSpacing) || other.targetSpacing == _this.targetSpacing)&&(identical(other.elementWidth, _this.elementWidth) || other.elementWidth == _this.elementWidth)&&(identical(other.startEdge, _this.startEdge) || other.startEdge == _this.startEdge)&&(identical(other.endEdge, _this.endEdge) || other.endEdge == _this.endEdge)&&(identical(other.startOffset, _this.startOffset) || other.startOffset == _this.startOffset)&&(identical(other.endOffset, _this.endOffset) || other.endOffset == _this.endOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DistributionTargetInput;
  return Object.hash(runtimeType,_this.length,_this.targetSpacing,_this.elementWidth,_this.startEdge,_this.endEdge,_this.startOffset,_this.endOffset);
}

@override
String toString() {
  final _this = this as DistributionTargetInput;
  return 'DistributionTargetInput(length: ${_this.length}, targetSpacing: ${_this.targetSpacing}, elementWidth: ${_this.elementWidth}, startEdge: ${_this.startEdge}, endEdge: ${_this.endEdge}, startOffset: ${_this.startOffset}, endOffset: ${_this.endOffset})';
}


}

/// @nodoc
abstract mixin class $DistributionTargetInputCopyWith<$Res>  {
  factory $DistributionTargetInputCopyWith(DistributionTargetInput value, $Res Function(DistributionTargetInput) _then) = _$DistributionTargetInputCopyWithImpl;
@useResult
$Res call({
 double length, double targetSpacing, double elementWidth, DistributionEdge startEdge, DistributionEdge endEdge, double startOffset, double endOffset
});




}
/// @nodoc
class _$DistributionTargetInputCopyWithImpl<$Res>
    implements $DistributionTargetInputCopyWith<$Res> {
  _$DistributionTargetInputCopyWithImpl(this._self, this._then);

  final DistributionTargetInput _self;
  final $Res Function(DistributionTargetInput) _then;

/// Create a copy of DistributionTargetInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? length = null,Object? targetSpacing = null,Object? elementWidth = null,Object? startEdge = null,Object? endEdge = null,Object? startOffset = null,Object? endOffset = null,}) {
  return _then(DistributionTargetInput(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as double,targetSpacing: null == targetSpacing ? _self.targetSpacing : targetSpacing // ignore: cast_nullable_to_non_nullable
as double,elementWidth: null == elementWidth ? _self.elementWidth : elementWidth // ignore: cast_nullable_to_non_nullable
as double,startEdge: null == startEdge ? _self.startEdge : startEdge // ignore: cast_nullable_to_non_nullable
as DistributionEdge,endEdge: null == endEdge ? _self.endEdge : endEdge // ignore: cast_nullable_to_non_nullable
as DistributionEdge,startOffset: null == startOffset ? _self.startOffset : startOffset // ignore: cast_nullable_to_non_nullable
as double,endOffset: null == endOffset ? _self.endOffset : endOffset // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DistributionTargetInput].
extension DistributionTargetInputPatterns on DistributionTargetInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DistributionTargetInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DistributionTargetInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DistributionTargetInput value)  $default,){
final _that = this;
switch (_that) {
case _DistributionTargetInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DistributionTargetInput value)?  $default,){
final _that = this;
switch (_that) {
case _DistributionTargetInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double length,  double targetSpacing,  double elementWidth,  DistributionEdge startEdge,  DistributionEdge endEdge,  double startOffset,  double endOffset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DistributionTargetInput() when $default != null:
return $default(_that.length,_that.targetSpacing,_that.elementWidth,_that.startEdge,_that.endEdge,_that.startOffset,_that.endOffset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double length,  double targetSpacing,  double elementWidth,  DistributionEdge startEdge,  DistributionEdge endEdge,  double startOffset,  double endOffset)  $default,) {final _that = this;
switch (_that) {
case _DistributionTargetInput():
return $default(_that.length,_that.targetSpacing,_that.elementWidth,_that.startEdge,_that.endEdge,_that.startOffset,_that.endOffset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double length,  double targetSpacing,  double elementWidth,  DistributionEdge startEdge,  DistributionEdge endEdge,  double startOffset,  double endOffset)?  $default,) {final _that = this;
switch (_that) {
case _DistributionTargetInput() when $default != null:
return $default(_that.length,_that.targetSpacing,_that.elementWidth,_that.startEdge,_that.endEdge,_that.startOffset,_that.endOffset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DistributionTargetInput implements DistributionTargetInput {
  const _DistributionTargetInput({required this.length, required this.targetSpacing, this.elementWidth = 0, this.startEdge = DistributionEdge.gap, this.endEdge = DistributionEdge.gap, this.startOffset = 0, this.endOffset = 0});
  factory _DistributionTargetInput.fromJson(Map<String, dynamic> json) => _$DistributionTargetInputFromJson(json);

/// Largeur totale à garnir, en mm.
@override final  double length;
/// Écart visé entre deux éléments, en mm. Presque jamais atteignable
/// exactement — voir [computeDistributionForSpacing].
@override final  double targetSpacing;
/// Largeur d'un élément, en mm.
@override@JsonKey() final  double elementWidth;
@override@JsonKey() final  DistributionEdge startEdge;
@override@JsonKey() final  DistributionEdge endEdge;
@override@JsonKey() final  double startOffset;
@override@JsonKey() final  double endOffset;

/// Create a copy of DistributionTargetInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DistributionTargetInputCopyWith<_DistributionTargetInput> get copyWith => __$DistributionTargetInputCopyWithImpl<_DistributionTargetInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DistributionTargetInputToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DistributionTargetInput&&(identical(other.length, length) || other.length == length)&&(identical(other.targetSpacing, targetSpacing) || other.targetSpacing == targetSpacing)&&(identical(other.elementWidth, elementWidth) || other.elementWidth == elementWidth)&&(identical(other.startEdge, startEdge) || other.startEdge == startEdge)&&(identical(other.endEdge, endEdge) || other.endEdge == endEdge)&&(identical(other.startOffset, startOffset) || other.startOffset == startOffset)&&(identical(other.endOffset, endOffset) || other.endOffset == endOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,length,targetSpacing,elementWidth,startEdge,endEdge,startOffset,endOffset);
}

@override
String toString() {
    return 'DistributionTargetInput(length: $length, targetSpacing: $targetSpacing, elementWidth: $elementWidth, startEdge: $startEdge, endEdge: $endEdge, startOffset: $startOffset, endOffset: $endOffset)';
}


}

/// @nodoc
abstract mixin class _$DistributionTargetInputCopyWith<$Res> implements $DistributionTargetInputCopyWith<$Res> {
  factory _$DistributionTargetInputCopyWith(_DistributionTargetInput value, $Res Function(_DistributionTargetInput) _then) = __$DistributionTargetInputCopyWithImpl;
@override @useResult
$Res call({
 double length, double targetSpacing, double elementWidth, DistributionEdge startEdge, DistributionEdge endEdge, double startOffset, double endOffset
});




}
/// @nodoc
class __$DistributionTargetInputCopyWithImpl<$Res>
    implements _$DistributionTargetInputCopyWith<$Res> {
  __$DistributionTargetInputCopyWithImpl(this._self, this._then);

  final _DistributionTargetInput _self;
  final $Res Function(_DistributionTargetInput) _then;

/// Create a copy of DistributionTargetInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? length = null,Object? targetSpacing = null,Object? elementWidth = null,Object? startEdge = null,Object? endEdge = null,Object? startOffset = null,Object? endOffset = null,}) {
  return _then(_DistributionTargetInput(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as double,targetSpacing: null == targetSpacing ? _self.targetSpacing : targetSpacing // ignore: cast_nullable_to_non_nullable
as double,elementWidth: null == elementWidth ? _self.elementWidth : elementWidth // ignore: cast_nullable_to_non_nullable
as double,startEdge: null == startEdge ? _self.startEdge : startEdge // ignore: cast_nullable_to_non_nullable
as DistributionEdge,endEdge: null == endEdge ? _self.endEdge : endEdge // ignore: cast_nullable_to_non_nullable
as DistributionEdge,startOffset: null == startOffset ? _self.startOffset : startOffset // ignore: cast_nullable_to_non_nullable
as double,endOffset: null == endOffset ? _self.endOffset : endOffset // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$DistributionResult {

/// Nombre d'éléments effectivement répartis. Redondant avec la saisie dans
/// le premier mode, mais c'est *le* résultat cherché dans le second.
 int get count;/// Nombre de jeux. C'est la règle de l'outil, rendue explicite : `N + 1`
/// bordé de deux écarts, `N - 1` bordé de deux éléments.
 int get gapCount;/// Jeu libre entre deux éléments voisins, en mm.
 double get spacing;/// Entraxe : `spacing + elementWidth`. C'est lui que l'on reporte au
/// crayon — le jeu, on ne le mesure jamais directement.
 double get pitch;/// Largeur réellement répartie : `length` moins les deux marges.
 double get span;/// Bord d'attaque de chaque élément depuis l'origine, en mm. Pour une
/// largeur nulle, c'est la position du point.
 List<double> get positions;/// Centre de chaque élément, en mm — l'axe de perçage ou de vissage.
 List<double> get centers;
/// Create a copy of DistributionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DistributionResultCopyWith<DistributionResult> get copyWith => _$DistributionResultCopyWithImpl<DistributionResult>(this as DistributionResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DistributionResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DistributionResult&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.gapCount, _this.gapCount) || other.gapCount == _this.gapCount)&&(identical(other.spacing, _this.spacing) || other.spacing == _this.spacing)&&(identical(other.pitch, _this.pitch) || other.pitch == _this.pitch)&&(identical(other.span, _this.span) || other.span == _this.span)&&const DeepCollectionEquality().equals(other.positions, _this.positions)&&const DeepCollectionEquality().equals(other.centers, _this.centers));
}


@override
int get hashCode {
  final _this = this as DistributionResult;
  return Object.hash(runtimeType,_this.count,_this.gapCount,_this.spacing,_this.pitch,_this.span,const DeepCollectionEquality().hash(_this.positions),const DeepCollectionEquality().hash(_this.centers));
}

@override
String toString() {
  final _this = this as DistributionResult;
  return 'DistributionResult(count: ${_this.count}, gapCount: ${_this.gapCount}, spacing: ${_this.spacing}, pitch: ${_this.pitch}, span: ${_this.span}, positions: ${_this.positions}, centers: ${_this.centers})';
}


}

/// @nodoc
abstract mixin class $DistributionResultCopyWith<$Res>  {
  factory $DistributionResultCopyWith(DistributionResult value, $Res Function(DistributionResult) _then) = _$DistributionResultCopyWithImpl;
@useResult
$Res call({
 int count, int gapCount, double spacing, double pitch, double span, List<double> positions, List<double> centers
});




}
/// @nodoc
class _$DistributionResultCopyWithImpl<$Res>
    implements $DistributionResultCopyWith<$Res> {
  _$DistributionResultCopyWithImpl(this._self, this._then);

  final DistributionResult _self;
  final $Res Function(DistributionResult) _then;

/// Create a copy of DistributionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? gapCount = null,Object? spacing = null,Object? pitch = null,Object? span = null,Object? positions = null,Object? centers = null,}) {
  return _then(DistributionResult(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,gapCount: null == gapCount ? _self.gapCount : gapCount // ignore: cast_nullable_to_non_nullable
as int,spacing: null == spacing ? _self.spacing : spacing // ignore: cast_nullable_to_non_nullable
as double,pitch: null == pitch ? _self.pitch : pitch // ignore: cast_nullable_to_non_nullable
as double,span: null == span ? _self.span : span // ignore: cast_nullable_to_non_nullable
as double,positions: null == positions ? _self.positions : positions // ignore: cast_nullable_to_non_nullable
as List<double>,centers: null == centers ? _self.centers : centers // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}

}


/// Adds pattern-matching-related methods to [DistributionResult].
extension DistributionResultPatterns on DistributionResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DistributionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DistributionResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DistributionResult value)  $default,){
final _that = this;
switch (_that) {
case _DistributionResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DistributionResult value)?  $default,){
final _that = this;
switch (_that) {
case _DistributionResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  int gapCount,  double spacing,  double pitch,  double span,  List<double> positions,  List<double> centers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DistributionResult() when $default != null:
return $default(_that.count,_that.gapCount,_that.spacing,_that.pitch,_that.span,_that.positions,_that.centers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  int gapCount,  double spacing,  double pitch,  double span,  List<double> positions,  List<double> centers)  $default,) {final _that = this;
switch (_that) {
case _DistributionResult():
return $default(_that.count,_that.gapCount,_that.spacing,_that.pitch,_that.span,_that.positions,_that.centers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  int gapCount,  double spacing,  double pitch,  double span,  List<double> positions,  List<double> centers)?  $default,) {final _that = this;
switch (_that) {
case _DistributionResult() when $default != null:
return $default(_that.count,_that.gapCount,_that.spacing,_that.pitch,_that.span,_that.positions,_that.centers);case _:
  return null;

}
}

}

/// @nodoc


class _DistributionResult implements DistributionResult {
  const _DistributionResult({required this.count, required this.gapCount, required this.spacing, required this.pitch, required this.span, required  List<double> positions, required  List<double> centers}): _positions = positions,_centers = centers;
  

/// Nombre d'éléments effectivement répartis. Redondant avec la saisie dans
/// le premier mode, mais c'est *le* résultat cherché dans le second.
@override final  int count;
/// Nombre de jeux. C'est la règle de l'outil, rendue explicite : `N + 1`
/// bordé de deux écarts, `N - 1` bordé de deux éléments.
@override final  int gapCount;
/// Jeu libre entre deux éléments voisins, en mm.
@override final  double spacing;
/// Entraxe : `spacing + elementWidth`. C'est lui que l'on reporte au
/// crayon — le jeu, on ne le mesure jamais directement.
@override final  double pitch;
/// Largeur réellement répartie : `length` moins les deux marges.
@override final  double span;
/// Bord d'attaque de chaque élément depuis l'origine, en mm. Pour une
/// largeur nulle, c'est la position du point.
 final  List<double> _positions;
/// Bord d'attaque de chaque élément depuis l'origine, en mm. Pour une
/// largeur nulle, c'est la position du point.
@override List<double> get positions {
  if (_positions is EqualUnmodifiableListView) return _positions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_positions);
}

/// Centre de chaque élément, en mm — l'axe de perçage ou de vissage.
 final  List<double> _centers;
/// Centre de chaque élément, en mm — l'axe de perçage ou de vissage.
@override List<double> get centers {
  if (_centers is EqualUnmodifiableListView) return _centers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_centers);
}


/// Create a copy of DistributionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DistributionResultCopyWith<_DistributionResult> get copyWith => __$DistributionResultCopyWithImpl<_DistributionResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DistributionResult&&(identical(other.count, count) || other.count == count)&&(identical(other.gapCount, gapCount) || other.gapCount == gapCount)&&(identical(other.spacing, spacing) || other.spacing == spacing)&&(identical(other.pitch, pitch) || other.pitch == pitch)&&(identical(other.span, span) || other.span == span)&&const DeepCollectionEquality().equals(other.positions, _positions)&&const DeepCollectionEquality().equals(other.centers, _centers));
}


@override
int get hashCode {
    return Object.hash(runtimeType,count,gapCount,spacing,pitch,span,const DeepCollectionEquality().hash(_positions),const DeepCollectionEquality().hash(_centers));
}

@override
String toString() {
    return 'DistributionResult(count: $count, gapCount: $gapCount, spacing: $spacing, pitch: $pitch, span: $span, positions: $positions, centers: $centers)';
}


}

/// @nodoc
abstract mixin class _$DistributionResultCopyWith<$Res> implements $DistributionResultCopyWith<$Res> {
  factory _$DistributionResultCopyWith(_DistributionResult value, $Res Function(_DistributionResult) _then) = __$DistributionResultCopyWithImpl;
@override @useResult
$Res call({
 int count, int gapCount, double spacing, double pitch, double span, List<double> positions, List<double> centers
});




}
/// @nodoc
class __$DistributionResultCopyWithImpl<$Res>
    implements _$DistributionResultCopyWith<$Res> {
  __$DistributionResultCopyWithImpl(this._self, this._then);

  final _DistributionResult _self;
  final $Res Function(_DistributionResult) _then;

/// Create a copy of DistributionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? gapCount = null,Object? spacing = null,Object? pitch = null,Object? span = null,Object? positions = null,Object? centers = null,}) {
  return _then(_DistributionResult(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,gapCount: null == gapCount ? _self.gapCount : gapCount // ignore: cast_nullable_to_non_nullable
as int,spacing: null == spacing ? _self.spacing : spacing // ignore: cast_nullable_to_non_nullable
as double,pitch: null == pitch ? _self.pitch : pitch // ignore: cast_nullable_to_non_nullable
as double,span: null == span ? _self.span : span // ignore: cast_nullable_to_non_nullable
as double,positions: null == positions ? _self._positions : positions // ignore: cast_nullable_to_non_nullable
as List<double>,centers: null == centers ? _self._centers : centers // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}


}

/// @nodoc
mixin _$DistributionTargetResult {

/// Celle dont l'écart réel est le plus proche de la cible.
 DistributionResult get best;/// L'autre borne, de l'autre côté de la cible. `null` quand la cible tombe
/// juste, ou quand ce voisin n'est pas réalisable.
 DistributionResult? get other;
/// Create a copy of DistributionTargetResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DistributionTargetResultCopyWith<DistributionTargetResult> get copyWith => _$DistributionTargetResultCopyWithImpl<DistributionTargetResult>(this as DistributionTargetResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DistributionTargetResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DistributionTargetResult&&(identical(other.best, _this.best) || other.best == _this.best)&&(identical(other.other, _this.other) || other.other == _this.other));
}


@override
int get hashCode {
  final _this = this as DistributionTargetResult;
  return Object.hash(runtimeType,_this.best,_this.other);
}

@override
String toString() {
  final _this = this as DistributionTargetResult;
  return 'DistributionTargetResult(best: ${_this.best}, other: ${_this.other})';
}


}

/// @nodoc
abstract mixin class $DistributionTargetResultCopyWith<$Res>  {
  factory $DistributionTargetResultCopyWith(DistributionTargetResult value, $Res Function(DistributionTargetResult) _then) = _$DistributionTargetResultCopyWithImpl;
@useResult
$Res call({
 DistributionResult best, DistributionResult? other
});


$DistributionResultCopyWith<$Res> get best;$DistributionResultCopyWith<$Res>? get other;

}
/// @nodoc
class _$DistributionTargetResultCopyWithImpl<$Res>
    implements $DistributionTargetResultCopyWith<$Res> {
  _$DistributionTargetResultCopyWithImpl(this._self, this._then);

  final DistributionTargetResult _self;
  final $Res Function(DistributionTargetResult) _then;

/// Create a copy of DistributionTargetResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? best = null,Object? other = freezed,}) {
  return _then(DistributionTargetResult(
best: null == best ? _self.best : best // ignore: cast_nullable_to_non_nullable
as DistributionResult,other: freezed == other ? _self.other : other // ignore: cast_nullable_to_non_nullable
as DistributionResult?,
  ));
}
/// Create a copy of DistributionTargetResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DistributionResultCopyWith<$Res> get best {
  
  return $DistributionResultCopyWith<$Res>(_self.best, (value) {
    return _then(_self.copyWith(best: value));
  });
}/// Create a copy of DistributionTargetResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DistributionResultCopyWith<$Res>? get other {
    if (_self.other == null) {
    return null;
  }

  return $DistributionResultCopyWith<$Res>(_self.other!, (value) {
    return _then(_self.copyWith(other: value));
  });
}
}


/// Adds pattern-matching-related methods to [DistributionTargetResult].
extension DistributionTargetResultPatterns on DistributionTargetResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DistributionTargetResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DistributionTargetResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DistributionTargetResult value)  $default,){
final _that = this;
switch (_that) {
case _DistributionTargetResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DistributionTargetResult value)?  $default,){
final _that = this;
switch (_that) {
case _DistributionTargetResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DistributionResult best,  DistributionResult? other)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DistributionTargetResult() when $default != null:
return $default(_that.best,_that.other);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DistributionResult best,  DistributionResult? other)  $default,) {final _that = this;
switch (_that) {
case _DistributionTargetResult():
return $default(_that.best,_that.other);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DistributionResult best,  DistributionResult? other)?  $default,) {final _that = this;
switch (_that) {
case _DistributionTargetResult() when $default != null:
return $default(_that.best,_that.other);case _:
  return null;

}
}

}

/// @nodoc


class _DistributionTargetResult implements DistributionTargetResult {
  const _DistributionTargetResult({required this.best, required this.other});
  

/// Celle dont l'écart réel est le plus proche de la cible.
@override final  DistributionResult best;
/// L'autre borne, de l'autre côté de la cible. `null` quand la cible tombe
/// juste, ou quand ce voisin n'est pas réalisable.
@override final  DistributionResult? other;

/// Create a copy of DistributionTargetResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DistributionTargetResultCopyWith<_DistributionTargetResult> get copyWith => __$DistributionTargetResultCopyWithImpl<_DistributionTargetResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DistributionTargetResult&&(identical(other.best, best) || other.best == best)&&(identical(other.other, this.other) || other.other == this.other));
}


@override
int get hashCode {
    return Object.hash(runtimeType,best,other);
}

@override
String toString() {
    return 'DistributionTargetResult(best: $best, other: $other)';
}


}

/// @nodoc
abstract mixin class _$DistributionTargetResultCopyWith<$Res> implements $DistributionTargetResultCopyWith<$Res> {
  factory _$DistributionTargetResultCopyWith(_DistributionTargetResult value, $Res Function(_DistributionTargetResult) _then) = __$DistributionTargetResultCopyWithImpl;
@override @useResult
$Res call({
 DistributionResult best, DistributionResult? other
});


@override $DistributionResultCopyWith<$Res> get best;@override $DistributionResultCopyWith<$Res>? get other;

}
/// @nodoc
class __$DistributionTargetResultCopyWithImpl<$Res>
    implements _$DistributionTargetResultCopyWith<$Res> {
  __$DistributionTargetResultCopyWithImpl(this._self, this._then);

  final _DistributionTargetResult _self;
  final $Res Function(_DistributionTargetResult) _then;

/// Create a copy of DistributionTargetResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? best = null,Object? other = freezed,}) {
  return _then(_DistributionTargetResult(
best: null == best ? _self.best : best // ignore: cast_nullable_to_non_nullable
as DistributionResult,other: freezed == other ? _self.other : other // ignore: cast_nullable_to_non_nullable
as DistributionResult?,
  ));
}

/// Create a copy of DistributionTargetResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DistributionResultCopyWith<$Res> get best {
  
  return $DistributionResultCopyWith<$Res>(_self.best, (value) {
    return _then(_self.copyWith(best: value));
  });
}/// Create a copy of DistributionTargetResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DistributionResultCopyWith<$Res>? get other {
    if (_self.other == null) {
    return null;
  }

  return $DistributionResultCopyWith<$Res>(_self.other!, (value) {
    return _then(_self.copyWith(other: value));
  });
}
}

// dart format on
