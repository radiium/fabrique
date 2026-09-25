// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drawers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SlideSpec {

/// Jeu entre le flanc du caisson et le côté du tiroir, de chaque côté.
 double get sideClearance;/// Ce que la caisse perd sur la longueur nominale de la glissière.
 double get lengthReduction;/// Longueurs nominales vendues, croissantes. Vide = pas de glissière à
/// choisir (bois sur bois) : la caisse prend la profondeur utile.
 List<double> get nominalLengths;/// Retrait du fond sous la caisse, quand la glissière l'impose. `null` =
/// montage du fond libre ([BottomMount]).
 double? get bottomRecess;
/// Create a copy of SlideSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlideSpecCopyWith<SlideSpec> get copyWith => _$SlideSpecCopyWithImpl<SlideSpec>(this as SlideSpec, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SlideSpec;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlideSpec&&(identical(other.sideClearance, _this.sideClearance) || other.sideClearance == _this.sideClearance)&&(identical(other.lengthReduction, _this.lengthReduction) || other.lengthReduction == _this.lengthReduction)&&const DeepCollectionEquality().equals(other.nominalLengths, _this.nominalLengths)&&(identical(other.bottomRecess, _this.bottomRecess) || other.bottomRecess == _this.bottomRecess));
}


@override
int get hashCode {
  final _this = this as SlideSpec;
  return Object.hash(runtimeType,_this.sideClearance,_this.lengthReduction,const DeepCollectionEquality().hash(_this.nominalLengths),_this.bottomRecess);
}

@override
String toString() {
  final _this = this as SlideSpec;
  return 'SlideSpec(sideClearance: ${_this.sideClearance}, lengthReduction: ${_this.lengthReduction}, nominalLengths: ${_this.nominalLengths}, bottomRecess: ${_this.bottomRecess})';
}


}

/// @nodoc
abstract mixin class $SlideSpecCopyWith<$Res>  {
  factory $SlideSpecCopyWith(SlideSpec value, $Res Function(SlideSpec) _then) = _$SlideSpecCopyWithImpl;
@useResult
$Res call({
 double sideClearance, double lengthReduction, List<double> nominalLengths, double? bottomRecess
});




}
/// @nodoc
class _$SlideSpecCopyWithImpl<$Res>
    implements $SlideSpecCopyWith<$Res> {
  _$SlideSpecCopyWithImpl(this._self, this._then);

  final SlideSpec _self;
  final $Res Function(SlideSpec) _then;

/// Create a copy of SlideSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sideClearance = null,Object? lengthReduction = null,Object? nominalLengths = null,Object? bottomRecess = freezed,}) {
  return _then(SlideSpec(
sideClearance: null == sideClearance ? _self.sideClearance : sideClearance // ignore: cast_nullable_to_non_nullable
as double,lengthReduction: null == lengthReduction ? _self.lengthReduction : lengthReduction // ignore: cast_nullable_to_non_nullable
as double,nominalLengths: null == nominalLengths ? _self.nominalLengths : nominalLengths // ignore: cast_nullable_to_non_nullable
as List<double>,bottomRecess: freezed == bottomRecess ? _self.bottomRecess : bottomRecess // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [SlideSpec].
extension SlideSpecPatterns on SlideSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SlideSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SlideSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SlideSpec value)  $default,){
final _that = this;
switch (_that) {
case _SlideSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SlideSpec value)?  $default,){
final _that = this;
switch (_that) {
case _SlideSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double sideClearance,  double lengthReduction,  List<double> nominalLengths,  double? bottomRecess)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlideSpec() when $default != null:
return $default(_that.sideClearance,_that.lengthReduction,_that.nominalLengths,_that.bottomRecess);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double sideClearance,  double lengthReduction,  List<double> nominalLengths,  double? bottomRecess)  $default,) {final _that = this;
switch (_that) {
case _SlideSpec():
return $default(_that.sideClearance,_that.lengthReduction,_that.nominalLengths,_that.bottomRecess);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double sideClearance,  double lengthReduction,  List<double> nominalLengths,  double? bottomRecess)?  $default,) {final _that = this;
switch (_that) {
case _SlideSpec() when $default != null:
return $default(_that.sideClearance,_that.lengthReduction,_that.nominalLengths,_that.bottomRecess);case _:
  return null;

}
}

}

/// @nodoc


class _SlideSpec implements SlideSpec {
  const _SlideSpec({required this.sideClearance, this.lengthReduction = 0,  List<double> nominalLengths = const <double>[], this.bottomRecess}): _nominalLengths = nominalLengths;
  

/// Jeu entre le flanc du caisson et le côté du tiroir, de chaque côté.
@override final  double sideClearance;
/// Ce que la caisse perd sur la longueur nominale de la glissière.
@override@JsonKey() final  double lengthReduction;
/// Longueurs nominales vendues, croissantes. Vide = pas de glissière à
/// choisir (bois sur bois) : la caisse prend la profondeur utile.
 final  List<double> _nominalLengths;
/// Longueurs nominales vendues, croissantes. Vide = pas de glissière à
/// choisir (bois sur bois) : la caisse prend la profondeur utile.
@override@JsonKey() List<double> get nominalLengths {
  if (_nominalLengths is EqualUnmodifiableListView) return _nominalLengths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nominalLengths);
}

/// Retrait du fond sous la caisse, quand la glissière l'impose. `null` =
/// montage du fond libre ([BottomMount]).
@override final  double? bottomRecess;

/// Create a copy of SlideSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlideSpecCopyWith<_SlideSpec> get copyWith => __$SlideSpecCopyWithImpl<_SlideSpec>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlideSpec&&(identical(other.sideClearance, sideClearance) || other.sideClearance == sideClearance)&&(identical(other.lengthReduction, lengthReduction) || other.lengthReduction == lengthReduction)&&const DeepCollectionEquality().equals(other.nominalLengths, _nominalLengths)&&(identical(other.bottomRecess, bottomRecess) || other.bottomRecess == bottomRecess));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sideClearance,lengthReduction,const DeepCollectionEquality().hash(_nominalLengths),bottomRecess);
}

@override
String toString() {
    return 'SlideSpec(sideClearance: $sideClearance, lengthReduction: $lengthReduction, nominalLengths: $nominalLengths, bottomRecess: $bottomRecess)';
}


}

/// @nodoc
abstract mixin class _$SlideSpecCopyWith<$Res> implements $SlideSpecCopyWith<$Res> {
  factory _$SlideSpecCopyWith(_SlideSpec value, $Res Function(_SlideSpec) _then) = __$SlideSpecCopyWithImpl;
@override @useResult
$Res call({
 double sideClearance, double lengthReduction, List<double> nominalLengths, double? bottomRecess
});




}
/// @nodoc
class __$SlideSpecCopyWithImpl<$Res>
    implements _$SlideSpecCopyWith<$Res> {
  __$SlideSpecCopyWithImpl(this._self, this._then);

  final _SlideSpec _self;
  final $Res Function(_SlideSpec) _then;

/// Create a copy of SlideSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sideClearance = null,Object? lengthReduction = null,Object? nominalLengths = null,Object? bottomRecess = freezed,}) {
  return _then(_SlideSpec(
sideClearance: null == sideClearance ? _self.sideClearance : sideClearance // ignore: cast_nullable_to_non_nullable
as double,lengthReduction: null == lengthReduction ? _self.lengthReduction : lengthReduction // ignore: cast_nullable_to_non_nullable
as double,nominalLengths: null == nominalLengths ? _self._nominalLengths : nominalLengths // ignore: cast_nullable_to_non_nullable
as List<double>,bottomRecess: freezed == bottomRecess ? _self.bottomRecess : bottomRecess // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$DrawersInput {

/// Cotes intérieures de l'ouverture, entre flancs, fond et dessus.
 double get openingWidth; double get openingHeight; double get openingDepth;/// Nombre de tiroirs de la colonne (>= 1).
 int get drawerCount;/// Hauteur de façade fixée, tiroir par tiroir, de haut en bas. `null` = le
/// tiroir partage à parts égales ce que les hauteurs fixées laissent.
 List<double?> get fixedFrontHeights; SlideKind get slide;/// Jeu latéral par côté, pour [SlideKind.custom] seulement.
 double get customSideClearance;/// Réduction de longueur, pour [SlideKind.custom] seulement.
 double get customLengthReduction;/// Longueur nominale imposée. `null` = la plus grande qui tient.
 double? get slideLength; FrontMount get frontMount;/// Jeu entre deux façades, et autour d'une façade encastrée.
 double get frontGap; double get sideThickness; double get bottomThickness;/// Épaisseur des flancs du caisson : fixe le recouvrement en applique.
 double get carcassThickness;/// Épaisseur de la façade : réduit la profondeur utile en pose encastrée.
 double get frontThickness; BoxJoint get boxJoint; BottomMount get bottomMount;/// Profondeur de la rainure du fond, pour [BottomMount.groove].
 double get grooveDepth;
/// Create a copy of DrawersInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrawersInputCopyWith<DrawersInput> get copyWith => _$DrawersInputCopyWithImpl<DrawersInput>(this as DrawersInput, _$identity);

  /// Serializes this DrawersInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DrawersInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrawersInput&&(identical(other.openingWidth, _this.openingWidth) || other.openingWidth == _this.openingWidth)&&(identical(other.openingHeight, _this.openingHeight) || other.openingHeight == _this.openingHeight)&&(identical(other.openingDepth, _this.openingDepth) || other.openingDepth == _this.openingDepth)&&(identical(other.drawerCount, _this.drawerCount) || other.drawerCount == _this.drawerCount)&&const DeepCollectionEquality().equals(other.fixedFrontHeights, _this.fixedFrontHeights)&&(identical(other.slide, _this.slide) || other.slide == _this.slide)&&(identical(other.customSideClearance, _this.customSideClearance) || other.customSideClearance == _this.customSideClearance)&&(identical(other.customLengthReduction, _this.customLengthReduction) || other.customLengthReduction == _this.customLengthReduction)&&(identical(other.slideLength, _this.slideLength) || other.slideLength == _this.slideLength)&&(identical(other.frontMount, _this.frontMount) || other.frontMount == _this.frontMount)&&(identical(other.frontGap, _this.frontGap) || other.frontGap == _this.frontGap)&&(identical(other.sideThickness, _this.sideThickness) || other.sideThickness == _this.sideThickness)&&(identical(other.bottomThickness, _this.bottomThickness) || other.bottomThickness == _this.bottomThickness)&&(identical(other.carcassThickness, _this.carcassThickness) || other.carcassThickness == _this.carcassThickness)&&(identical(other.frontThickness, _this.frontThickness) || other.frontThickness == _this.frontThickness)&&(identical(other.boxJoint, _this.boxJoint) || other.boxJoint == _this.boxJoint)&&(identical(other.bottomMount, _this.bottomMount) || other.bottomMount == _this.bottomMount)&&(identical(other.grooveDepth, _this.grooveDepth) || other.grooveDepth == _this.grooveDepth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DrawersInput;
  return Object.hash(runtimeType,_this.openingWidth,_this.openingHeight,_this.openingDepth,_this.drawerCount,const DeepCollectionEquality().hash(_this.fixedFrontHeights),_this.slide,_this.customSideClearance,_this.customLengthReduction,_this.slideLength,_this.frontMount,_this.frontGap,_this.sideThickness,_this.bottomThickness,_this.carcassThickness,_this.frontThickness,_this.boxJoint,_this.bottomMount,_this.grooveDepth);
}

@override
String toString() {
  final _this = this as DrawersInput;
  return 'DrawersInput(openingWidth: ${_this.openingWidth}, openingHeight: ${_this.openingHeight}, openingDepth: ${_this.openingDepth}, drawerCount: ${_this.drawerCount}, fixedFrontHeights: ${_this.fixedFrontHeights}, slide: ${_this.slide}, customSideClearance: ${_this.customSideClearance}, customLengthReduction: ${_this.customLengthReduction}, slideLength: ${_this.slideLength}, frontMount: ${_this.frontMount}, frontGap: ${_this.frontGap}, sideThickness: ${_this.sideThickness}, bottomThickness: ${_this.bottomThickness}, carcassThickness: ${_this.carcassThickness}, frontThickness: ${_this.frontThickness}, boxJoint: ${_this.boxJoint}, bottomMount: ${_this.bottomMount}, grooveDepth: ${_this.grooveDepth})';
}


}

/// @nodoc
abstract mixin class $DrawersInputCopyWith<$Res>  {
  factory $DrawersInputCopyWith(DrawersInput value, $Res Function(DrawersInput) _then) = _$DrawersInputCopyWithImpl;
@useResult
$Res call({
 double openingWidth, double openingHeight, double openingDepth, int drawerCount, List<double?> fixedFrontHeights, SlideKind slide, double customSideClearance, double customLengthReduction, double? slideLength, FrontMount frontMount, double frontGap, double sideThickness, double bottomThickness, double carcassThickness, double frontThickness, BoxJoint boxJoint, BottomMount bottomMount, double grooveDepth
});




}
/// @nodoc
class _$DrawersInputCopyWithImpl<$Res>
    implements $DrawersInputCopyWith<$Res> {
  _$DrawersInputCopyWithImpl(this._self, this._then);

  final DrawersInput _self;
  final $Res Function(DrawersInput) _then;

/// Create a copy of DrawersInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? openingWidth = null,Object? openingHeight = null,Object? openingDepth = null,Object? drawerCount = null,Object? fixedFrontHeights = null,Object? slide = null,Object? customSideClearance = null,Object? customLengthReduction = null,Object? slideLength = freezed,Object? frontMount = null,Object? frontGap = null,Object? sideThickness = null,Object? bottomThickness = null,Object? carcassThickness = null,Object? frontThickness = null,Object? boxJoint = null,Object? bottomMount = null,Object? grooveDepth = null,}) {
  return _then(DrawersInput(
openingWidth: null == openingWidth ? _self.openingWidth : openingWidth // ignore: cast_nullable_to_non_nullable
as double,openingHeight: null == openingHeight ? _self.openingHeight : openingHeight // ignore: cast_nullable_to_non_nullable
as double,openingDepth: null == openingDepth ? _self.openingDepth : openingDepth // ignore: cast_nullable_to_non_nullable
as double,drawerCount: null == drawerCount ? _self.drawerCount : drawerCount // ignore: cast_nullable_to_non_nullable
as int,fixedFrontHeights: null == fixedFrontHeights ? _self.fixedFrontHeights : fixedFrontHeights // ignore: cast_nullable_to_non_nullable
as List<double?>,slide: null == slide ? _self.slide : slide // ignore: cast_nullable_to_non_nullable
as SlideKind,customSideClearance: null == customSideClearance ? _self.customSideClearance : customSideClearance // ignore: cast_nullable_to_non_nullable
as double,customLengthReduction: null == customLengthReduction ? _self.customLengthReduction : customLengthReduction // ignore: cast_nullable_to_non_nullable
as double,slideLength: freezed == slideLength ? _self.slideLength : slideLength // ignore: cast_nullable_to_non_nullable
as double?,frontMount: null == frontMount ? _self.frontMount : frontMount // ignore: cast_nullable_to_non_nullable
as FrontMount,frontGap: null == frontGap ? _self.frontGap : frontGap // ignore: cast_nullable_to_non_nullable
as double,sideThickness: null == sideThickness ? _self.sideThickness : sideThickness // ignore: cast_nullable_to_non_nullable
as double,bottomThickness: null == bottomThickness ? _self.bottomThickness : bottomThickness // ignore: cast_nullable_to_non_nullable
as double,carcassThickness: null == carcassThickness ? _self.carcassThickness : carcassThickness // ignore: cast_nullable_to_non_nullable
as double,frontThickness: null == frontThickness ? _self.frontThickness : frontThickness // ignore: cast_nullable_to_non_nullable
as double,boxJoint: null == boxJoint ? _self.boxJoint : boxJoint // ignore: cast_nullable_to_non_nullable
as BoxJoint,bottomMount: null == bottomMount ? _self.bottomMount : bottomMount // ignore: cast_nullable_to_non_nullable
as BottomMount,grooveDepth: null == grooveDepth ? _self.grooveDepth : grooveDepth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DrawersInput].
extension DrawersInputPatterns on DrawersInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrawersInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrawersInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrawersInput value)  $default,){
final _that = this;
switch (_that) {
case _DrawersInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrawersInput value)?  $default,){
final _that = this;
switch (_that) {
case _DrawersInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double openingWidth,  double openingHeight,  double openingDepth,  int drawerCount,  List<double?> fixedFrontHeights,  SlideKind slide,  double customSideClearance,  double customLengthReduction,  double? slideLength,  FrontMount frontMount,  double frontGap,  double sideThickness,  double bottomThickness,  double carcassThickness,  double frontThickness,  BoxJoint boxJoint,  BottomMount bottomMount,  double grooveDepth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrawersInput() when $default != null:
return $default(_that.openingWidth,_that.openingHeight,_that.openingDepth,_that.drawerCount,_that.fixedFrontHeights,_that.slide,_that.customSideClearance,_that.customLengthReduction,_that.slideLength,_that.frontMount,_that.frontGap,_that.sideThickness,_that.bottomThickness,_that.carcassThickness,_that.frontThickness,_that.boxJoint,_that.bottomMount,_that.grooveDepth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double openingWidth,  double openingHeight,  double openingDepth,  int drawerCount,  List<double?> fixedFrontHeights,  SlideKind slide,  double customSideClearance,  double customLengthReduction,  double? slideLength,  FrontMount frontMount,  double frontGap,  double sideThickness,  double bottomThickness,  double carcassThickness,  double frontThickness,  BoxJoint boxJoint,  BottomMount bottomMount,  double grooveDepth)  $default,) {final _that = this;
switch (_that) {
case _DrawersInput():
return $default(_that.openingWidth,_that.openingHeight,_that.openingDepth,_that.drawerCount,_that.fixedFrontHeights,_that.slide,_that.customSideClearance,_that.customLengthReduction,_that.slideLength,_that.frontMount,_that.frontGap,_that.sideThickness,_that.bottomThickness,_that.carcassThickness,_that.frontThickness,_that.boxJoint,_that.bottomMount,_that.grooveDepth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double openingWidth,  double openingHeight,  double openingDepth,  int drawerCount,  List<double?> fixedFrontHeights,  SlideKind slide,  double customSideClearance,  double customLengthReduction,  double? slideLength,  FrontMount frontMount,  double frontGap,  double sideThickness,  double bottomThickness,  double carcassThickness,  double frontThickness,  BoxJoint boxJoint,  BottomMount bottomMount,  double grooveDepth)?  $default,) {final _that = this;
switch (_that) {
case _DrawersInput() when $default != null:
return $default(_that.openingWidth,_that.openingHeight,_that.openingDepth,_that.drawerCount,_that.fixedFrontHeights,_that.slide,_that.customSideClearance,_that.customLengthReduction,_that.slideLength,_that.frontMount,_that.frontGap,_that.sideThickness,_that.bottomThickness,_that.carcassThickness,_that.frontThickness,_that.boxJoint,_that.bottomMount,_that.grooveDepth);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrawersInput implements DrawersInput {
  const _DrawersInput({required this.openingWidth, required this.openingHeight, required this.openingDepth, required this.drawerCount,  List<double?> fixedFrontHeights = const <double?>[], this.slide = SlideKind.ballBearing, this.customSideClearance = 12.7, this.customLengthReduction = 0, this.slideLength, this.frontMount = FrontMount.overlay, this.frontGap = 3, this.sideThickness = 15, this.bottomThickness = 8, this.carcassThickness = 19, this.frontThickness = 19, this.boxJoint = BoxJoint.sidesOverlap, this.bottomMount = BottomMount.groove, this.grooveDepth = 6}): _fixedFrontHeights = fixedFrontHeights;
  factory _DrawersInput.fromJson(Map<String, dynamic> json) => _$DrawersInputFromJson(json);

/// Cotes intérieures de l'ouverture, entre flancs, fond et dessus.
@override final  double openingWidth;
@override final  double openingHeight;
@override final  double openingDepth;
/// Nombre de tiroirs de la colonne (>= 1).
@override final  int drawerCount;
/// Hauteur de façade fixée, tiroir par tiroir, de haut en bas. `null` = le
/// tiroir partage à parts égales ce que les hauteurs fixées laissent.
 final  List<double?> _fixedFrontHeights;
/// Hauteur de façade fixée, tiroir par tiroir, de haut en bas. `null` = le
/// tiroir partage à parts égales ce que les hauteurs fixées laissent.
@override@JsonKey() List<double?> get fixedFrontHeights {
  if (_fixedFrontHeights is EqualUnmodifiableListView) return _fixedFrontHeights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fixedFrontHeights);
}

@override@JsonKey() final  SlideKind slide;
/// Jeu latéral par côté, pour [SlideKind.custom] seulement.
@override@JsonKey() final  double customSideClearance;
/// Réduction de longueur, pour [SlideKind.custom] seulement.
@override@JsonKey() final  double customLengthReduction;
/// Longueur nominale imposée. `null` = la plus grande qui tient.
@override final  double? slideLength;
@override@JsonKey() final  FrontMount frontMount;
/// Jeu entre deux façades, et autour d'une façade encastrée.
@override@JsonKey() final  double frontGap;
@override@JsonKey() final  double sideThickness;
@override@JsonKey() final  double bottomThickness;
/// Épaisseur des flancs du caisson : fixe le recouvrement en applique.
@override@JsonKey() final  double carcassThickness;
/// Épaisseur de la façade : réduit la profondeur utile en pose encastrée.
@override@JsonKey() final  double frontThickness;
@override@JsonKey() final  BoxJoint boxJoint;
@override@JsonKey() final  BottomMount bottomMount;
/// Profondeur de la rainure du fond, pour [BottomMount.groove].
@override@JsonKey() final  double grooveDepth;

/// Create a copy of DrawersInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrawersInputCopyWith<_DrawersInput> get copyWith => __$DrawersInputCopyWithImpl<_DrawersInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrawersInputToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrawersInput&&(identical(other.openingWidth, openingWidth) || other.openingWidth == openingWidth)&&(identical(other.openingHeight, openingHeight) || other.openingHeight == openingHeight)&&(identical(other.openingDepth, openingDepth) || other.openingDepth == openingDepth)&&(identical(other.drawerCount, drawerCount) || other.drawerCount == drawerCount)&&const DeepCollectionEquality().equals(other.fixedFrontHeights, _fixedFrontHeights)&&(identical(other.slide, slide) || other.slide == slide)&&(identical(other.customSideClearance, customSideClearance) || other.customSideClearance == customSideClearance)&&(identical(other.customLengthReduction, customLengthReduction) || other.customLengthReduction == customLengthReduction)&&(identical(other.slideLength, slideLength) || other.slideLength == slideLength)&&(identical(other.frontMount, frontMount) || other.frontMount == frontMount)&&(identical(other.frontGap, frontGap) || other.frontGap == frontGap)&&(identical(other.sideThickness, sideThickness) || other.sideThickness == sideThickness)&&(identical(other.bottomThickness, bottomThickness) || other.bottomThickness == bottomThickness)&&(identical(other.carcassThickness, carcassThickness) || other.carcassThickness == carcassThickness)&&(identical(other.frontThickness, frontThickness) || other.frontThickness == frontThickness)&&(identical(other.boxJoint, boxJoint) || other.boxJoint == boxJoint)&&(identical(other.bottomMount, bottomMount) || other.bottomMount == bottomMount)&&(identical(other.grooveDepth, grooveDepth) || other.grooveDepth == grooveDepth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,openingWidth,openingHeight,openingDepth,drawerCount,const DeepCollectionEquality().hash(_fixedFrontHeights),slide,customSideClearance,customLengthReduction,slideLength,frontMount,frontGap,sideThickness,bottomThickness,carcassThickness,frontThickness,boxJoint,bottomMount,grooveDepth);
}

@override
String toString() {
    return 'DrawersInput(openingWidth: $openingWidth, openingHeight: $openingHeight, openingDepth: $openingDepth, drawerCount: $drawerCount, fixedFrontHeights: $fixedFrontHeights, slide: $slide, customSideClearance: $customSideClearance, customLengthReduction: $customLengthReduction, slideLength: $slideLength, frontMount: $frontMount, frontGap: $frontGap, sideThickness: $sideThickness, bottomThickness: $bottomThickness, carcassThickness: $carcassThickness, frontThickness: $frontThickness, boxJoint: $boxJoint, bottomMount: $bottomMount, grooveDepth: $grooveDepth)';
}


}

/// @nodoc
abstract mixin class _$DrawersInputCopyWith<$Res> implements $DrawersInputCopyWith<$Res> {
  factory _$DrawersInputCopyWith(_DrawersInput value, $Res Function(_DrawersInput) _then) = __$DrawersInputCopyWithImpl;
@override @useResult
$Res call({
 double openingWidth, double openingHeight, double openingDepth, int drawerCount, List<double?> fixedFrontHeights, SlideKind slide, double customSideClearance, double customLengthReduction, double? slideLength, FrontMount frontMount, double frontGap, double sideThickness, double bottomThickness, double carcassThickness, double frontThickness, BoxJoint boxJoint, BottomMount bottomMount, double grooveDepth
});




}
/// @nodoc
class __$DrawersInputCopyWithImpl<$Res>
    implements _$DrawersInputCopyWith<$Res> {
  __$DrawersInputCopyWithImpl(this._self, this._then);

  final _DrawersInput _self;
  final $Res Function(_DrawersInput) _then;

/// Create a copy of DrawersInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? openingWidth = null,Object? openingHeight = null,Object? openingDepth = null,Object? drawerCount = null,Object? fixedFrontHeights = null,Object? slide = null,Object? customSideClearance = null,Object? customLengthReduction = null,Object? slideLength = freezed,Object? frontMount = null,Object? frontGap = null,Object? sideThickness = null,Object? bottomThickness = null,Object? carcassThickness = null,Object? frontThickness = null,Object? boxJoint = null,Object? bottomMount = null,Object? grooveDepth = null,}) {
  return _then(_DrawersInput(
openingWidth: null == openingWidth ? _self.openingWidth : openingWidth // ignore: cast_nullable_to_non_nullable
as double,openingHeight: null == openingHeight ? _self.openingHeight : openingHeight // ignore: cast_nullable_to_non_nullable
as double,openingDepth: null == openingDepth ? _self.openingDepth : openingDepth // ignore: cast_nullable_to_non_nullable
as double,drawerCount: null == drawerCount ? _self.drawerCount : drawerCount // ignore: cast_nullable_to_non_nullable
as int,fixedFrontHeights: null == fixedFrontHeights ? _self._fixedFrontHeights : fixedFrontHeights // ignore: cast_nullable_to_non_nullable
as List<double?>,slide: null == slide ? _self.slide : slide // ignore: cast_nullable_to_non_nullable
as SlideKind,customSideClearance: null == customSideClearance ? _self.customSideClearance : customSideClearance // ignore: cast_nullable_to_non_nullable
as double,customLengthReduction: null == customLengthReduction ? _self.customLengthReduction : customLengthReduction // ignore: cast_nullable_to_non_nullable
as double,slideLength: freezed == slideLength ? _self.slideLength : slideLength // ignore: cast_nullable_to_non_nullable
as double?,frontMount: null == frontMount ? _self.frontMount : frontMount // ignore: cast_nullable_to_non_nullable
as FrontMount,frontGap: null == frontGap ? _self.frontGap : frontGap // ignore: cast_nullable_to_non_nullable
as double,sideThickness: null == sideThickness ? _self.sideThickness : sideThickness // ignore: cast_nullable_to_non_nullable
as double,bottomThickness: null == bottomThickness ? _self.bottomThickness : bottomThickness // ignore: cast_nullable_to_non_nullable
as double,carcassThickness: null == carcassThickness ? _self.carcassThickness : carcassThickness // ignore: cast_nullable_to_non_nullable
as double,frontThickness: null == frontThickness ? _self.frontThickness : frontThickness // ignore: cast_nullable_to_non_nullable
as double,boxJoint: null == boxJoint ? _self.boxJoint : boxJoint // ignore: cast_nullable_to_non_nullable
as BoxJoint,bottomMount: null == bottomMount ? _self.bottomMount : bottomMount // ignore: cast_nullable_to_non_nullable
as BottomMount,grooveDepth: null == grooveDepth ? _self.grooveDepth : grooveDepth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$DrawerFrontSlot {

/// Bas de la façade, depuis le bas de l'ouverture. Négatif en applique :
/// la façade descend sur le chant du caisson.
 double get bottom; double get height;/// La hauteur a-t-elle été fixée à la main, ou vient-elle du partage ?
 bool get isFixed;
/// Create a copy of DrawerFrontSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrawerFrontSlotCopyWith<DrawerFrontSlot> get copyWith => _$DrawerFrontSlotCopyWithImpl<DrawerFrontSlot>(this as DrawerFrontSlot, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DrawerFrontSlot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrawerFrontSlot&&(identical(other.bottom, _this.bottom) || other.bottom == _this.bottom)&&(identical(other.height, _this.height) || other.height == _this.height)&&(identical(other.isFixed, _this.isFixed) || other.isFixed == _this.isFixed));
}


@override
int get hashCode {
  final _this = this as DrawerFrontSlot;
  return Object.hash(runtimeType,_this.bottom,_this.height,_this.isFixed);
}

@override
String toString() {
  final _this = this as DrawerFrontSlot;
  return 'DrawerFrontSlot(bottom: ${_this.bottom}, height: ${_this.height}, isFixed: ${_this.isFixed})';
}


}

/// @nodoc
abstract mixin class $DrawerFrontSlotCopyWith<$Res>  {
  factory $DrawerFrontSlotCopyWith(DrawerFrontSlot value, $Res Function(DrawerFrontSlot) _then) = _$DrawerFrontSlotCopyWithImpl;
@useResult
$Res call({
 double bottom, double height, bool isFixed
});




}
/// @nodoc
class _$DrawerFrontSlotCopyWithImpl<$Res>
    implements $DrawerFrontSlotCopyWith<$Res> {
  _$DrawerFrontSlotCopyWithImpl(this._self, this._then);

  final DrawerFrontSlot _self;
  final $Res Function(DrawerFrontSlot) _then;

/// Create a copy of DrawerFrontSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bottom = null,Object? height = null,Object? isFixed = null,}) {
  return _then(DrawerFrontSlot(
bottom: null == bottom ? _self.bottom : bottom // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,isFixed: null == isFixed ? _self.isFixed : isFixed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DrawerFrontSlot].
extension DrawerFrontSlotPatterns on DrawerFrontSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrawerFrontSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrawerFrontSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrawerFrontSlot value)  $default,){
final _that = this;
switch (_that) {
case _DrawerFrontSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrawerFrontSlot value)?  $default,){
final _that = this;
switch (_that) {
case _DrawerFrontSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double bottom,  double height,  bool isFixed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrawerFrontSlot() when $default != null:
return $default(_that.bottom,_that.height,_that.isFixed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double bottom,  double height,  bool isFixed)  $default,) {final _that = this;
switch (_that) {
case _DrawerFrontSlot():
return $default(_that.bottom,_that.height,_that.isFixed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double bottom,  double height,  bool isFixed)?  $default,) {final _that = this;
switch (_that) {
case _DrawerFrontSlot() when $default != null:
return $default(_that.bottom,_that.height,_that.isFixed);case _:
  return null;

}
}

}

/// @nodoc


class _DrawerFrontSlot implements DrawerFrontSlot {
  const _DrawerFrontSlot({required this.bottom, required this.height, this.isFixed = false});
  

/// Bas de la façade, depuis le bas de l'ouverture. Négatif en applique :
/// la façade descend sur le chant du caisson.
@override final  double bottom;
@override final  double height;
/// La hauteur a-t-elle été fixée à la main, ou vient-elle du partage ?
@override@JsonKey() final  bool isFixed;

/// Create a copy of DrawerFrontSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrawerFrontSlotCopyWith<_DrawerFrontSlot> get copyWith => __$DrawerFrontSlotCopyWithImpl<_DrawerFrontSlot>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrawerFrontSlot&&(identical(other.bottom, bottom) || other.bottom == bottom)&&(identical(other.height, height) || other.height == height)&&(identical(other.isFixed, isFixed) || other.isFixed == isFixed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,bottom,height,isFixed);
}

@override
String toString() {
    return 'DrawerFrontSlot(bottom: $bottom, height: $height, isFixed: $isFixed)';
}


}

/// @nodoc
abstract mixin class _$DrawerFrontSlotCopyWith<$Res> implements $DrawerFrontSlotCopyWith<$Res> {
  factory _$DrawerFrontSlotCopyWith(_DrawerFrontSlot value, $Res Function(_DrawerFrontSlot) _then) = __$DrawerFrontSlotCopyWithImpl;
@override @useResult
$Res call({
 double bottom, double height, bool isFixed
});




}
/// @nodoc
class __$DrawerFrontSlotCopyWithImpl<$Res>
    implements _$DrawerFrontSlotCopyWith<$Res> {
  __$DrawerFrontSlotCopyWithImpl(this._self, this._then);

  final _DrawerFrontSlot _self;
  final $Res Function(_DrawerFrontSlot) _then;

/// Create a copy of DrawerFrontSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bottom = null,Object? height = null,Object? isFixed = null,}) {
  return _then(_DrawerFrontSlot(
bottom: null == bottom ? _self.bottom : bottom // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,isFixed: null == isFixed ? _self.isFixed : isFixed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$CutPiece {

 DrawerPart get part; int get quantity;/// Longueur, dans le sens du fil.
 double get length; double get width; double get thickness;
/// Create a copy of CutPiece
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CutPieceCopyWith<CutPiece> get copyWith => _$CutPieceCopyWithImpl<CutPiece>(this as CutPiece, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CutPiece;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CutPiece&&(identical(other.part, _this.part) || other.part == _this.part)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.length, _this.length) || other.length == _this.length)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.thickness, _this.thickness) || other.thickness == _this.thickness));
}


@override
int get hashCode {
  final _this = this as CutPiece;
  return Object.hash(runtimeType,_this.part,_this.quantity,_this.length,_this.width,_this.thickness);
}

@override
String toString() {
  final _this = this as CutPiece;
  return 'CutPiece(part: ${_this.part}, quantity: ${_this.quantity}, length: ${_this.length}, width: ${_this.width}, thickness: ${_this.thickness})';
}


}

/// @nodoc
abstract mixin class $CutPieceCopyWith<$Res>  {
  factory $CutPieceCopyWith(CutPiece value, $Res Function(CutPiece) _then) = _$CutPieceCopyWithImpl;
@useResult
$Res call({
 DrawerPart part, int quantity, double length, double width, double thickness
});




}
/// @nodoc
class _$CutPieceCopyWithImpl<$Res>
    implements $CutPieceCopyWith<$Res> {
  _$CutPieceCopyWithImpl(this._self, this._then);

  final CutPiece _self;
  final $Res Function(CutPiece) _then;

/// Create a copy of CutPiece
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? part = null,Object? quantity = null,Object? length = null,Object? width = null,Object? thickness = null,}) {
  return _then(CutPiece(
part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as DrawerPart,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,thickness: null == thickness ? _self.thickness : thickness // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CutPiece].
extension CutPiecePatterns on CutPiece {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CutPiece value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CutPiece() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CutPiece value)  $default,){
final _that = this;
switch (_that) {
case _CutPiece():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CutPiece value)?  $default,){
final _that = this;
switch (_that) {
case _CutPiece() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DrawerPart part,  int quantity,  double length,  double width,  double thickness)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CutPiece() when $default != null:
return $default(_that.part,_that.quantity,_that.length,_that.width,_that.thickness);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DrawerPart part,  int quantity,  double length,  double width,  double thickness)  $default,) {final _that = this;
switch (_that) {
case _CutPiece():
return $default(_that.part,_that.quantity,_that.length,_that.width,_that.thickness);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DrawerPart part,  int quantity,  double length,  double width,  double thickness)?  $default,) {final _that = this;
switch (_that) {
case _CutPiece() when $default != null:
return $default(_that.part,_that.quantity,_that.length,_that.width,_that.thickness);case _:
  return null;

}
}

}

/// @nodoc


class _CutPiece implements CutPiece {
  const _CutPiece({required this.part, required this.quantity, required this.length, required this.width, required this.thickness});
  

@override final  DrawerPart part;
@override final  int quantity;
/// Longueur, dans le sens du fil.
@override final  double length;
@override final  double width;
@override final  double thickness;

/// Create a copy of CutPiece
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CutPieceCopyWith<_CutPiece> get copyWith => __$CutPieceCopyWithImpl<_CutPiece>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CutPiece&&(identical(other.part, part) || other.part == part)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.length, length) || other.length == length)&&(identical(other.width, width) || other.width == width)&&(identical(other.thickness, thickness) || other.thickness == thickness));
}


@override
int get hashCode {
    return Object.hash(runtimeType,part,quantity,length,width,thickness);
}

@override
String toString() {
    return 'CutPiece(part: $part, quantity: $quantity, length: $length, width: $width, thickness: $thickness)';
}


}

/// @nodoc
abstract mixin class _$CutPieceCopyWith<$Res> implements $CutPieceCopyWith<$Res> {
  factory _$CutPieceCopyWith(_CutPiece value, $Res Function(_CutPiece) _then) = __$CutPieceCopyWithImpl;
@override @useResult
$Res call({
 DrawerPart part, int quantity, double length, double width, double thickness
});




}
/// @nodoc
class __$CutPieceCopyWithImpl<$Res>
    implements _$CutPieceCopyWith<$Res> {
  __$CutPieceCopyWithImpl(this._self, this._then);

  final _CutPiece _self;
  final $Res Function(_CutPiece) _then;

/// Create a copy of CutPiece
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? part = null,Object? quantity = null,Object? length = null,Object? width = null,Object? thickness = null,}) {
  return _then(_CutPiece(
part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as DrawerPart,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,thickness: null == thickness ? _self.thickness : thickness // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$DrawersResult {

/// Façades de haut en bas, toutes de largeur [frontWidth].
 List<DrawerFrontSlot> get fronts; double get frontWidth;/// Jeu effectivement laissé entre flanc et côté, de chaque côté.
 double get sideClearance;/// Caisse hors tout.
 double get boxWidth; double get boxLength;/// Retrait de la caisse derrière le chant du caisson : l'épaisseur de la
/// façade en pose encastrée, zéro en applique.
 double get boxSetback;/// Hauteur de caisse de chaque tiroir, de haut en bas.
 List<double> get boxHeights;/// Bas de chaque caisse, depuis le bas de l'ouverture, de haut en bas.
 List<double> get boxBottoms;/// Hauteur du dessous du fond au-dessus du bas de la caisse : la position
/// de la rainure, le retrait imposé par une glissière sous tiroir, zéro
/// sinon.
 double get bottomLift;/// Longueur nominale retenue. `null` sans glissière (bois sur bois).
 double? get slideLength;/// La longueur a-t-elle été choisie par l'outil ?
 bool get isSlideLengthAuto;/// Axe de chaque glissière, depuis le bas de l'ouverture, de haut en bas.
 List<double> get slideAxes;/// Fiche de débit, pièces identiques regroupées.
 List<CutPiece> get cutList;
/// Create a copy of DrawersResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrawersResultCopyWith<DrawersResult> get copyWith => _$DrawersResultCopyWithImpl<DrawersResult>(this as DrawersResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DrawersResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrawersResult&&const DeepCollectionEquality().equals(other.fronts, _this.fronts)&&(identical(other.frontWidth, _this.frontWidth) || other.frontWidth == _this.frontWidth)&&(identical(other.sideClearance, _this.sideClearance) || other.sideClearance == _this.sideClearance)&&(identical(other.boxWidth, _this.boxWidth) || other.boxWidth == _this.boxWidth)&&(identical(other.boxLength, _this.boxLength) || other.boxLength == _this.boxLength)&&(identical(other.boxSetback, _this.boxSetback) || other.boxSetback == _this.boxSetback)&&const DeepCollectionEquality().equals(other.boxHeights, _this.boxHeights)&&const DeepCollectionEquality().equals(other.boxBottoms, _this.boxBottoms)&&(identical(other.bottomLift, _this.bottomLift) || other.bottomLift == _this.bottomLift)&&(identical(other.slideLength, _this.slideLength) || other.slideLength == _this.slideLength)&&(identical(other.isSlideLengthAuto, _this.isSlideLengthAuto) || other.isSlideLengthAuto == _this.isSlideLengthAuto)&&const DeepCollectionEquality().equals(other.slideAxes, _this.slideAxes)&&const DeepCollectionEquality().equals(other.cutList, _this.cutList));
}


@override
int get hashCode {
  final _this = this as DrawersResult;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.fronts),_this.frontWidth,_this.sideClearance,_this.boxWidth,_this.boxLength,_this.boxSetback,const DeepCollectionEquality().hash(_this.boxHeights),const DeepCollectionEquality().hash(_this.boxBottoms),_this.bottomLift,_this.slideLength,_this.isSlideLengthAuto,const DeepCollectionEquality().hash(_this.slideAxes),const DeepCollectionEquality().hash(_this.cutList));
}

@override
String toString() {
  final _this = this as DrawersResult;
  return 'DrawersResult(fronts: ${_this.fronts}, frontWidth: ${_this.frontWidth}, sideClearance: ${_this.sideClearance}, boxWidth: ${_this.boxWidth}, boxLength: ${_this.boxLength}, boxSetback: ${_this.boxSetback}, boxHeights: ${_this.boxHeights}, boxBottoms: ${_this.boxBottoms}, bottomLift: ${_this.bottomLift}, slideLength: ${_this.slideLength}, isSlideLengthAuto: ${_this.isSlideLengthAuto}, slideAxes: ${_this.slideAxes}, cutList: ${_this.cutList})';
}


}

/// @nodoc
abstract mixin class $DrawersResultCopyWith<$Res>  {
  factory $DrawersResultCopyWith(DrawersResult value, $Res Function(DrawersResult) _then) = _$DrawersResultCopyWithImpl;
@useResult
$Res call({
 List<DrawerFrontSlot> fronts, double frontWidth, double sideClearance, double boxWidth, double boxLength, double boxSetback, List<double> boxHeights, List<double> boxBottoms, double bottomLift, double? slideLength, bool isSlideLengthAuto, List<double> slideAxes, List<CutPiece> cutList
});




}
/// @nodoc
class _$DrawersResultCopyWithImpl<$Res>
    implements $DrawersResultCopyWith<$Res> {
  _$DrawersResultCopyWithImpl(this._self, this._then);

  final DrawersResult _self;
  final $Res Function(DrawersResult) _then;

/// Create a copy of DrawersResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fronts = null,Object? frontWidth = null,Object? sideClearance = null,Object? boxWidth = null,Object? boxLength = null,Object? boxSetback = null,Object? boxHeights = null,Object? boxBottoms = null,Object? bottomLift = null,Object? slideLength = freezed,Object? isSlideLengthAuto = null,Object? slideAxes = null,Object? cutList = null,}) {
  return _then(DrawersResult(
fronts: null == fronts ? _self.fronts : fronts // ignore: cast_nullable_to_non_nullable
as List<DrawerFrontSlot>,frontWidth: null == frontWidth ? _self.frontWidth : frontWidth // ignore: cast_nullable_to_non_nullable
as double,sideClearance: null == sideClearance ? _self.sideClearance : sideClearance // ignore: cast_nullable_to_non_nullable
as double,boxWidth: null == boxWidth ? _self.boxWidth : boxWidth // ignore: cast_nullable_to_non_nullable
as double,boxLength: null == boxLength ? _self.boxLength : boxLength // ignore: cast_nullable_to_non_nullable
as double,boxSetback: null == boxSetback ? _self.boxSetback : boxSetback // ignore: cast_nullable_to_non_nullable
as double,boxHeights: null == boxHeights ? _self.boxHeights : boxHeights // ignore: cast_nullable_to_non_nullable
as List<double>,boxBottoms: null == boxBottoms ? _self.boxBottoms : boxBottoms // ignore: cast_nullable_to_non_nullable
as List<double>,bottomLift: null == bottomLift ? _self.bottomLift : bottomLift // ignore: cast_nullable_to_non_nullable
as double,slideLength: freezed == slideLength ? _self.slideLength : slideLength // ignore: cast_nullable_to_non_nullable
as double?,isSlideLengthAuto: null == isSlideLengthAuto ? _self.isSlideLengthAuto : isSlideLengthAuto // ignore: cast_nullable_to_non_nullable
as bool,slideAxes: null == slideAxes ? _self.slideAxes : slideAxes // ignore: cast_nullable_to_non_nullable
as List<double>,cutList: null == cutList ? _self.cutList : cutList // ignore: cast_nullable_to_non_nullable
as List<CutPiece>,
  ));
}

}


/// Adds pattern-matching-related methods to [DrawersResult].
extension DrawersResultPatterns on DrawersResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrawersResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrawersResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrawersResult value)  $default,){
final _that = this;
switch (_that) {
case _DrawersResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrawersResult value)?  $default,){
final _that = this;
switch (_that) {
case _DrawersResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DrawerFrontSlot> fronts,  double frontWidth,  double sideClearance,  double boxWidth,  double boxLength,  double boxSetback,  List<double> boxHeights,  List<double> boxBottoms,  double bottomLift,  double? slideLength,  bool isSlideLengthAuto,  List<double> slideAxes,  List<CutPiece> cutList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrawersResult() when $default != null:
return $default(_that.fronts,_that.frontWidth,_that.sideClearance,_that.boxWidth,_that.boxLength,_that.boxSetback,_that.boxHeights,_that.boxBottoms,_that.bottomLift,_that.slideLength,_that.isSlideLengthAuto,_that.slideAxes,_that.cutList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DrawerFrontSlot> fronts,  double frontWidth,  double sideClearance,  double boxWidth,  double boxLength,  double boxSetback,  List<double> boxHeights,  List<double> boxBottoms,  double bottomLift,  double? slideLength,  bool isSlideLengthAuto,  List<double> slideAxes,  List<CutPiece> cutList)  $default,) {final _that = this;
switch (_that) {
case _DrawersResult():
return $default(_that.fronts,_that.frontWidth,_that.sideClearance,_that.boxWidth,_that.boxLength,_that.boxSetback,_that.boxHeights,_that.boxBottoms,_that.bottomLift,_that.slideLength,_that.isSlideLengthAuto,_that.slideAxes,_that.cutList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DrawerFrontSlot> fronts,  double frontWidth,  double sideClearance,  double boxWidth,  double boxLength,  double boxSetback,  List<double> boxHeights,  List<double> boxBottoms,  double bottomLift,  double? slideLength,  bool isSlideLengthAuto,  List<double> slideAxes,  List<CutPiece> cutList)?  $default,) {final _that = this;
switch (_that) {
case _DrawersResult() when $default != null:
return $default(_that.fronts,_that.frontWidth,_that.sideClearance,_that.boxWidth,_that.boxLength,_that.boxSetback,_that.boxHeights,_that.boxBottoms,_that.bottomLift,_that.slideLength,_that.isSlideLengthAuto,_that.slideAxes,_that.cutList);case _:
  return null;

}
}

}

/// @nodoc


class _DrawersResult implements DrawersResult {
  const _DrawersResult({required  List<DrawerFrontSlot> fronts, required this.frontWidth, required this.sideClearance, required this.boxWidth, required this.boxLength, this.boxSetback = 0, required  List<double> boxHeights, required  List<double> boxBottoms, this.bottomLift = 0, this.slideLength, this.isSlideLengthAuto = true, required  List<double> slideAxes, required  List<CutPiece> cutList}): _fronts = fronts,_boxHeights = boxHeights,_boxBottoms = boxBottoms,_slideAxes = slideAxes,_cutList = cutList;
  

/// Façades de haut en bas, toutes de largeur [frontWidth].
 final  List<DrawerFrontSlot> _fronts;
/// Façades de haut en bas, toutes de largeur [frontWidth].
@override List<DrawerFrontSlot> get fronts {
  if (_fronts is EqualUnmodifiableListView) return _fronts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fronts);
}

@override final  double frontWidth;
/// Jeu effectivement laissé entre flanc et côté, de chaque côté.
@override final  double sideClearance;
/// Caisse hors tout.
@override final  double boxWidth;
@override final  double boxLength;
/// Retrait de la caisse derrière le chant du caisson : l'épaisseur de la
/// façade en pose encastrée, zéro en applique.
@override@JsonKey() final  double boxSetback;
/// Hauteur de caisse de chaque tiroir, de haut en bas.
 final  List<double> _boxHeights;
/// Hauteur de caisse de chaque tiroir, de haut en bas.
@override List<double> get boxHeights {
  if (_boxHeights is EqualUnmodifiableListView) return _boxHeights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_boxHeights);
}

/// Bas de chaque caisse, depuis le bas de l'ouverture, de haut en bas.
 final  List<double> _boxBottoms;
/// Bas de chaque caisse, depuis le bas de l'ouverture, de haut en bas.
@override List<double> get boxBottoms {
  if (_boxBottoms is EqualUnmodifiableListView) return _boxBottoms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_boxBottoms);
}

/// Hauteur du dessous du fond au-dessus du bas de la caisse : la position
/// de la rainure, le retrait imposé par une glissière sous tiroir, zéro
/// sinon.
@override@JsonKey() final  double bottomLift;
/// Longueur nominale retenue. `null` sans glissière (bois sur bois).
@override final  double? slideLength;
/// La longueur a-t-elle été choisie par l'outil ?
@override@JsonKey() final  bool isSlideLengthAuto;
/// Axe de chaque glissière, depuis le bas de l'ouverture, de haut en bas.
 final  List<double> _slideAxes;
/// Axe de chaque glissière, depuis le bas de l'ouverture, de haut en bas.
@override List<double> get slideAxes {
  if (_slideAxes is EqualUnmodifiableListView) return _slideAxes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slideAxes);
}

/// Fiche de débit, pièces identiques regroupées.
 final  List<CutPiece> _cutList;
/// Fiche de débit, pièces identiques regroupées.
@override List<CutPiece> get cutList {
  if (_cutList is EqualUnmodifiableListView) return _cutList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cutList);
}


/// Create a copy of DrawersResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrawersResultCopyWith<_DrawersResult> get copyWith => __$DrawersResultCopyWithImpl<_DrawersResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrawersResult&&const DeepCollectionEquality().equals(other.fronts, _fronts)&&(identical(other.frontWidth, frontWidth) || other.frontWidth == frontWidth)&&(identical(other.sideClearance, sideClearance) || other.sideClearance == sideClearance)&&(identical(other.boxWidth, boxWidth) || other.boxWidth == boxWidth)&&(identical(other.boxLength, boxLength) || other.boxLength == boxLength)&&(identical(other.boxSetback, boxSetback) || other.boxSetback == boxSetback)&&const DeepCollectionEquality().equals(other.boxHeights, _boxHeights)&&const DeepCollectionEquality().equals(other.boxBottoms, _boxBottoms)&&(identical(other.bottomLift, bottomLift) || other.bottomLift == bottomLift)&&(identical(other.slideLength, slideLength) || other.slideLength == slideLength)&&(identical(other.isSlideLengthAuto, isSlideLengthAuto) || other.isSlideLengthAuto == isSlideLengthAuto)&&const DeepCollectionEquality().equals(other.slideAxes, _slideAxes)&&const DeepCollectionEquality().equals(other.cutList, _cutList));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_fronts),frontWidth,sideClearance,boxWidth,boxLength,boxSetback,const DeepCollectionEquality().hash(_boxHeights),const DeepCollectionEquality().hash(_boxBottoms),bottomLift,slideLength,isSlideLengthAuto,const DeepCollectionEquality().hash(_slideAxes),const DeepCollectionEquality().hash(_cutList));
}

@override
String toString() {
    return 'DrawersResult(fronts: $fronts, frontWidth: $frontWidth, sideClearance: $sideClearance, boxWidth: $boxWidth, boxLength: $boxLength, boxSetback: $boxSetback, boxHeights: $boxHeights, boxBottoms: $boxBottoms, bottomLift: $bottomLift, slideLength: $slideLength, isSlideLengthAuto: $isSlideLengthAuto, slideAxes: $slideAxes, cutList: $cutList)';
}


}

/// @nodoc
abstract mixin class _$DrawersResultCopyWith<$Res> implements $DrawersResultCopyWith<$Res> {
  factory _$DrawersResultCopyWith(_DrawersResult value, $Res Function(_DrawersResult) _then) = __$DrawersResultCopyWithImpl;
@override @useResult
$Res call({
 List<DrawerFrontSlot> fronts, double frontWidth, double sideClearance, double boxWidth, double boxLength, double boxSetback, List<double> boxHeights, List<double> boxBottoms, double bottomLift, double? slideLength, bool isSlideLengthAuto, List<double> slideAxes, List<CutPiece> cutList
});




}
/// @nodoc
class __$DrawersResultCopyWithImpl<$Res>
    implements _$DrawersResultCopyWith<$Res> {
  __$DrawersResultCopyWithImpl(this._self, this._then);

  final _DrawersResult _self;
  final $Res Function(_DrawersResult) _then;

/// Create a copy of DrawersResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fronts = null,Object? frontWidth = null,Object? sideClearance = null,Object? boxWidth = null,Object? boxLength = null,Object? boxSetback = null,Object? boxHeights = null,Object? boxBottoms = null,Object? bottomLift = null,Object? slideLength = freezed,Object? isSlideLengthAuto = null,Object? slideAxes = null,Object? cutList = null,}) {
  return _then(_DrawersResult(
fronts: null == fronts ? _self._fronts : fronts // ignore: cast_nullable_to_non_nullable
as List<DrawerFrontSlot>,frontWidth: null == frontWidth ? _self.frontWidth : frontWidth // ignore: cast_nullable_to_non_nullable
as double,sideClearance: null == sideClearance ? _self.sideClearance : sideClearance // ignore: cast_nullable_to_non_nullable
as double,boxWidth: null == boxWidth ? _self.boxWidth : boxWidth // ignore: cast_nullable_to_non_nullable
as double,boxLength: null == boxLength ? _self.boxLength : boxLength // ignore: cast_nullable_to_non_nullable
as double,boxSetback: null == boxSetback ? _self.boxSetback : boxSetback // ignore: cast_nullable_to_non_nullable
as double,boxHeights: null == boxHeights ? _self._boxHeights : boxHeights // ignore: cast_nullable_to_non_nullable
as List<double>,boxBottoms: null == boxBottoms ? _self._boxBottoms : boxBottoms // ignore: cast_nullable_to_non_nullable
as List<double>,bottomLift: null == bottomLift ? _self.bottomLift : bottomLift // ignore: cast_nullable_to_non_nullable
as double,slideLength: freezed == slideLength ? _self.slideLength : slideLength // ignore: cast_nullable_to_non_nullable
as double?,isSlideLengthAuto: null == isSlideLengthAuto ? _self.isSlideLengthAuto : isSlideLengthAuto // ignore: cast_nullable_to_non_nullable
as bool,slideAxes: null == slideAxes ? _self._slideAxes : slideAxes // ignore: cast_nullable_to_non_nullable
as List<double>,cutList: null == cutList ? _self._cutList : cutList // ignore: cast_nullable_to_non_nullable
as List<CutPiece>,
  ));
}


}

// dart format on
