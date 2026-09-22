// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'distribution_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DistributionFormState {

 DistributionMode get mode; double get length;/// `0` = répartition de points purs.
 double get elementWidth; int get count; double get targetSpacing; DistributionEdge get startEdge; DistributionEdge get endEdge;/// Les deux décalages sont-ils liés ? N'a d'effet que sur la saisie : le
/// calcul ne voit jamais que [startOffset] et [endOffset].
 bool get symmetricOffsets; double get startOffset; double get endOffset;
/// Create a copy of DistributionFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DistributionFormStateCopyWith<DistributionFormState> get copyWith => _$DistributionFormStateCopyWithImpl<DistributionFormState>(this as DistributionFormState, _$identity);

  /// Serializes this DistributionFormState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DistributionFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DistributionFormState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.length, _this.length) || other.length == _this.length)&&(identical(other.elementWidth, _this.elementWidth) || other.elementWidth == _this.elementWidth)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.targetSpacing, _this.targetSpacing) || other.targetSpacing == _this.targetSpacing)&&(identical(other.startEdge, _this.startEdge) || other.startEdge == _this.startEdge)&&(identical(other.endEdge, _this.endEdge) || other.endEdge == _this.endEdge)&&(identical(other.symmetricOffsets, _this.symmetricOffsets) || other.symmetricOffsets == _this.symmetricOffsets)&&(identical(other.startOffset, _this.startOffset) || other.startOffset == _this.startOffset)&&(identical(other.endOffset, _this.endOffset) || other.endOffset == _this.endOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DistributionFormState;
  return Object.hash(runtimeType,_this.mode,_this.length,_this.elementWidth,_this.count,_this.targetSpacing,_this.startEdge,_this.endEdge,_this.symmetricOffsets,_this.startOffset,_this.endOffset);
}

@override
String toString() {
  final _this = this as DistributionFormState;
  return 'DistributionFormState(mode: ${_this.mode}, length: ${_this.length}, elementWidth: ${_this.elementWidth}, count: ${_this.count}, targetSpacing: ${_this.targetSpacing}, startEdge: ${_this.startEdge}, endEdge: ${_this.endEdge}, symmetricOffsets: ${_this.symmetricOffsets}, startOffset: ${_this.startOffset}, endOffset: ${_this.endOffset})';
}


}

/// @nodoc
abstract mixin class $DistributionFormStateCopyWith<$Res>  {
  factory $DistributionFormStateCopyWith(DistributionFormState value, $Res Function(DistributionFormState) _then) = _$DistributionFormStateCopyWithImpl;
@useResult
$Res call({
 DistributionMode mode, double length, double elementWidth, int count, double targetSpacing, DistributionEdge startEdge, DistributionEdge endEdge, bool symmetricOffsets, double startOffset, double endOffset
});




}
/// @nodoc
class _$DistributionFormStateCopyWithImpl<$Res>
    implements $DistributionFormStateCopyWith<$Res> {
  _$DistributionFormStateCopyWithImpl(this._self, this._then);

  final DistributionFormState _self;
  final $Res Function(DistributionFormState) _then;

/// Create a copy of DistributionFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? length = null,Object? elementWidth = null,Object? count = null,Object? targetSpacing = null,Object? startEdge = null,Object? endEdge = null,Object? symmetricOffsets = null,Object? startOffset = null,Object? endOffset = null,}) {
  return _then(DistributionFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as DistributionMode,length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as double,elementWidth: null == elementWidth ? _self.elementWidth : elementWidth // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,targetSpacing: null == targetSpacing ? _self.targetSpacing : targetSpacing // ignore: cast_nullable_to_non_nullable
as double,startEdge: null == startEdge ? _self.startEdge : startEdge // ignore: cast_nullable_to_non_nullable
as DistributionEdge,endEdge: null == endEdge ? _self.endEdge : endEdge // ignore: cast_nullable_to_non_nullable
as DistributionEdge,symmetricOffsets: null == symmetricOffsets ? _self.symmetricOffsets : symmetricOffsets // ignore: cast_nullable_to_non_nullable
as bool,startOffset: null == startOffset ? _self.startOffset : startOffset // ignore: cast_nullable_to_non_nullable
as double,endOffset: null == endOffset ? _self.endOffset : endOffset // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DistributionFormState].
extension DistributionFormStatePatterns on DistributionFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DistributionFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DistributionFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DistributionFormState value)  $default,){
final _that = this;
switch (_that) {
case _DistributionFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DistributionFormState value)?  $default,){
final _that = this;
switch (_that) {
case _DistributionFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DistributionMode mode,  double length,  double elementWidth,  int count,  double targetSpacing,  DistributionEdge startEdge,  DistributionEdge endEdge,  bool symmetricOffsets,  double startOffset,  double endOffset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DistributionFormState() when $default != null:
return $default(_that.mode,_that.length,_that.elementWidth,_that.count,_that.targetSpacing,_that.startEdge,_that.endEdge,_that.symmetricOffsets,_that.startOffset,_that.endOffset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DistributionMode mode,  double length,  double elementWidth,  int count,  double targetSpacing,  DistributionEdge startEdge,  DistributionEdge endEdge,  bool symmetricOffsets,  double startOffset,  double endOffset)  $default,) {final _that = this;
switch (_that) {
case _DistributionFormState():
return $default(_that.mode,_that.length,_that.elementWidth,_that.count,_that.targetSpacing,_that.startEdge,_that.endEdge,_that.symmetricOffsets,_that.startOffset,_that.endOffset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DistributionMode mode,  double length,  double elementWidth,  int count,  double targetSpacing,  DistributionEdge startEdge,  DistributionEdge endEdge,  bool symmetricOffsets,  double startOffset,  double endOffset)?  $default,) {final _that = this;
switch (_that) {
case _DistributionFormState() when $default != null:
return $default(_that.mode,_that.length,_that.elementWidth,_that.count,_that.targetSpacing,_that.startEdge,_that.endEdge,_that.symmetricOffsets,_that.startOffset,_that.endOffset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DistributionFormState extends DistributionFormState {
  const _DistributionFormState({this.mode = DistributionMode.spacing, this.length = 1000, this.elementWidth = 20, this.count = 5, this.targetSpacing = 150, this.startEdge = DistributionEdge.gap, this.endEdge = DistributionEdge.gap, this.symmetricOffsets = true, this.startOffset = 0, this.endOffset = 0}): super._();
  factory _DistributionFormState.fromJson(Map<String, dynamic> json) => _$DistributionFormStateFromJson(json);

@override@JsonKey() final  DistributionMode mode;
@override@JsonKey() final  double length;
/// `0` = répartition de points purs.
@override@JsonKey() final  double elementWidth;
@override@JsonKey() final  int count;
@override@JsonKey() final  double targetSpacing;
@override@JsonKey() final  DistributionEdge startEdge;
@override@JsonKey() final  DistributionEdge endEdge;
/// Les deux décalages sont-ils liés ? N'a d'effet que sur la saisie : le
/// calcul ne voit jamais que [startOffset] et [endOffset].
@override@JsonKey() final  bool symmetricOffsets;
@override@JsonKey() final  double startOffset;
@override@JsonKey() final  double endOffset;

/// Create a copy of DistributionFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DistributionFormStateCopyWith<_DistributionFormState> get copyWith => __$DistributionFormStateCopyWithImpl<_DistributionFormState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DistributionFormStateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DistributionFormState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.length, length) || other.length == length)&&(identical(other.elementWidth, elementWidth) || other.elementWidth == elementWidth)&&(identical(other.count, count) || other.count == count)&&(identical(other.targetSpacing, targetSpacing) || other.targetSpacing == targetSpacing)&&(identical(other.startEdge, startEdge) || other.startEdge == startEdge)&&(identical(other.endEdge, endEdge) || other.endEdge == endEdge)&&(identical(other.symmetricOffsets, symmetricOffsets) || other.symmetricOffsets == symmetricOffsets)&&(identical(other.startOffset, startOffset) || other.startOffset == startOffset)&&(identical(other.endOffset, endOffset) || other.endOffset == endOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,mode,length,elementWidth,count,targetSpacing,startEdge,endEdge,symmetricOffsets,startOffset,endOffset);
}

@override
String toString() {
    return 'DistributionFormState(mode: $mode, length: $length, elementWidth: $elementWidth, count: $count, targetSpacing: $targetSpacing, startEdge: $startEdge, endEdge: $endEdge, symmetricOffsets: $symmetricOffsets, startOffset: $startOffset, endOffset: $endOffset)';
}


}

/// @nodoc
abstract mixin class _$DistributionFormStateCopyWith<$Res> implements $DistributionFormStateCopyWith<$Res> {
  factory _$DistributionFormStateCopyWith(_DistributionFormState value, $Res Function(_DistributionFormState) _then) = __$DistributionFormStateCopyWithImpl;
@override @useResult
$Res call({
 DistributionMode mode, double length, double elementWidth, int count, double targetSpacing, DistributionEdge startEdge, DistributionEdge endEdge, bool symmetricOffsets, double startOffset, double endOffset
});




}
/// @nodoc
class __$DistributionFormStateCopyWithImpl<$Res>
    implements _$DistributionFormStateCopyWith<$Res> {
  __$DistributionFormStateCopyWithImpl(this._self, this._then);

  final _DistributionFormState _self;
  final $Res Function(_DistributionFormState) _then;

/// Create a copy of DistributionFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? length = null,Object? elementWidth = null,Object? count = null,Object? targetSpacing = null,Object? startEdge = null,Object? endEdge = null,Object? symmetricOffsets = null,Object? startOffset = null,Object? endOffset = null,}) {
  return _then(_DistributionFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as DistributionMode,length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as double,elementWidth: null == elementWidth ? _self.elementWidth : elementWidth // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,targetSpacing: null == targetSpacing ? _self.targetSpacing : targetSpacing // ignore: cast_nullable_to_non_nullable
as double,startEdge: null == startEdge ? _self.startEdge : startEdge // ignore: cast_nullable_to_non_nullable
as DistributionEdge,endEdge: null == endEdge ? _self.endEdge : endEdge // ignore: cast_nullable_to_non_nullable
as DistributionEdge,symmetricOffsets: null == symmetricOffsets ? _self.symmetricOffsets : symmetricOffsets // ignore: cast_nullable_to_non_nullable
as bool,startOffset: null == startOffset ? _self.startOffset : startOffset // ignore: cast_nullable_to_non_nullable
as double,endOffset: null == endOffset ? _self.endOffset : endOffset // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
