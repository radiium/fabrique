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
 double? get bottomRecess;/// Place laissée sous la caisse, dans son compartiment.
 double get clearanceBelow;/// Place laissée au-dessus de la caisse : de quoi l'engager dans la
/// glissière, ou le coulisseau du tiroir du dessus en bois sur bois.
 double get clearanceAbove;
/// Create a copy of SlideSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlideSpecCopyWith<SlideSpec> get copyWith => _$SlideSpecCopyWithImpl<SlideSpec>(this as SlideSpec, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SlideSpec;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlideSpec&&(identical(other.sideClearance, _this.sideClearance) || other.sideClearance == _this.sideClearance)&&(identical(other.lengthReduction, _this.lengthReduction) || other.lengthReduction == _this.lengthReduction)&&const DeepCollectionEquality().equals(other.nominalLengths, _this.nominalLengths)&&(identical(other.bottomRecess, _this.bottomRecess) || other.bottomRecess == _this.bottomRecess)&&(identical(other.clearanceBelow, _this.clearanceBelow) || other.clearanceBelow == _this.clearanceBelow)&&(identical(other.clearanceAbove, _this.clearanceAbove) || other.clearanceAbove == _this.clearanceAbove));
}


@override
int get hashCode {
  final _this = this as SlideSpec;
  return Object.hash(runtimeType,_this.sideClearance,_this.lengthReduction,const DeepCollectionEquality().hash(_this.nominalLengths),_this.bottomRecess,_this.clearanceBelow,_this.clearanceAbove);
}

@override
String toString() {
  final _this = this as SlideSpec;
  return 'SlideSpec(sideClearance: ${_this.sideClearance}, lengthReduction: ${_this.lengthReduction}, nominalLengths: ${_this.nominalLengths}, bottomRecess: ${_this.bottomRecess}, clearanceBelow: ${_this.clearanceBelow}, clearanceAbove: ${_this.clearanceAbove})';
}


}

/// @nodoc
abstract mixin class $SlideSpecCopyWith<$Res>  {
  factory $SlideSpecCopyWith(SlideSpec value, $Res Function(SlideSpec) _then) = _$SlideSpecCopyWithImpl;
@useResult
$Res call({
 double sideClearance, double lengthReduction, List<double> nominalLengths, double? bottomRecess, double clearanceBelow, double clearanceAbove
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
@pragma('vm:prefer-inline') @override $Res call({Object? sideClearance = null,Object? lengthReduction = null,Object? nominalLengths = null,Object? bottomRecess = freezed,Object? clearanceBelow = null,Object? clearanceAbove = null,}) {
  return _then(SlideSpec(
sideClearance: null == sideClearance ? _self.sideClearance : sideClearance // ignore: cast_nullable_to_non_nullable
as double,lengthReduction: null == lengthReduction ? _self.lengthReduction : lengthReduction // ignore: cast_nullable_to_non_nullable
as double,nominalLengths: null == nominalLengths ? _self.nominalLengths : nominalLengths // ignore: cast_nullable_to_non_nullable
as List<double>,bottomRecess: freezed == bottomRecess ? _self.bottomRecess : bottomRecess // ignore: cast_nullable_to_non_nullable
as double?,clearanceBelow: null == clearanceBelow ? _self.clearanceBelow : clearanceBelow // ignore: cast_nullable_to_non_nullable
as double,clearanceAbove: null == clearanceAbove ? _self.clearanceAbove : clearanceAbove // ignore: cast_nullable_to_non_nullable
as double,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double sideClearance,  double lengthReduction,  List<double> nominalLengths,  double? bottomRecess,  double clearanceBelow,  double clearanceAbove)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlideSpec() when $default != null:
return $default(_that.sideClearance,_that.lengthReduction,_that.nominalLengths,_that.bottomRecess,_that.clearanceBelow,_that.clearanceAbove);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double sideClearance,  double lengthReduction,  List<double> nominalLengths,  double? bottomRecess,  double clearanceBelow,  double clearanceAbove)  $default,) {final _that = this;
switch (_that) {
case _SlideSpec():
return $default(_that.sideClearance,_that.lengthReduction,_that.nominalLengths,_that.bottomRecess,_that.clearanceBelow,_that.clearanceAbove);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double sideClearance,  double lengthReduction,  List<double> nominalLengths,  double? bottomRecess,  double clearanceBelow,  double clearanceAbove)?  $default,) {final _that = this;
switch (_that) {
case _SlideSpec() when $default != null:
return $default(_that.sideClearance,_that.lengthReduction,_that.nominalLengths,_that.bottomRecess,_that.clearanceBelow,_that.clearanceAbove);case _:
  return null;

}
}

}

/// @nodoc


class _SlideSpec implements SlideSpec {
  const _SlideSpec({required this.sideClearance, this.lengthReduction = 0,  List<double> nominalLengths = const <double>[], this.bottomRecess, required this.clearanceBelow, required this.clearanceAbove}): _nominalLengths = nominalLengths;
  

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
/// Place laissée sous la caisse, dans son compartiment.
@override final  double clearanceBelow;
/// Place laissée au-dessus de la caisse : de quoi l'engager dans la
/// glissière, ou le coulisseau du tiroir du dessus en bois sur bois.
@override final  double clearanceAbove;

/// Create a copy of SlideSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlideSpecCopyWith<_SlideSpec> get copyWith => __$SlideSpecCopyWithImpl<_SlideSpec>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlideSpec&&(identical(other.sideClearance, sideClearance) || other.sideClearance == sideClearance)&&(identical(other.lengthReduction, lengthReduction) || other.lengthReduction == lengthReduction)&&const DeepCollectionEquality().equals(other.nominalLengths, _nominalLengths)&&(identical(other.bottomRecess, bottomRecess) || other.bottomRecess == bottomRecess)&&(identical(other.clearanceBelow, clearanceBelow) || other.clearanceBelow == clearanceBelow)&&(identical(other.clearanceAbove, clearanceAbove) || other.clearanceAbove == clearanceAbove));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sideClearance,lengthReduction,const DeepCollectionEquality().hash(_nominalLengths),bottomRecess,clearanceBelow,clearanceAbove);
}

@override
String toString() {
    return 'SlideSpec(sideClearance: $sideClearance, lengthReduction: $lengthReduction, nominalLengths: $nominalLengths, bottomRecess: $bottomRecess, clearanceBelow: $clearanceBelow, clearanceAbove: $clearanceAbove)';
}


}

/// @nodoc
abstract mixin class _$SlideSpecCopyWith<$Res> implements $SlideSpecCopyWith<$Res> {
  factory _$SlideSpecCopyWith(_SlideSpec value, $Res Function(_SlideSpec) _then) = __$SlideSpecCopyWithImpl;
@override @useResult
$Res call({
 double sideClearance, double lengthReduction, List<double> nominalLengths, double? bottomRecess, double clearanceBelow, double clearanceAbove
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
@override @pragma('vm:prefer-inline') $Res call({Object? sideClearance = null,Object? lengthReduction = null,Object? nominalLengths = null,Object? bottomRecess = freezed,Object? clearanceBelow = null,Object? clearanceAbove = null,}) {
  return _then(_SlideSpec(
sideClearance: null == sideClearance ? _self.sideClearance : sideClearance // ignore: cast_nullable_to_non_nullable
as double,lengthReduction: null == lengthReduction ? _self.lengthReduction : lengthReduction // ignore: cast_nullable_to_non_nullable
as double,nominalLengths: null == nominalLengths ? _self._nominalLengths : nominalLengths // ignore: cast_nullable_to_non_nullable
as List<double>,bottomRecess: freezed == bottomRecess ? _self.bottomRecess : bottomRecess // ignore: cast_nullable_to_non_nullable
as double?,clearanceBelow: null == clearanceBelow ? _self.clearanceBelow : clearanceBelow // ignore: cast_nullable_to_non_nullable
as double,clearanceAbove: null == clearanceAbove ? _self.clearanceAbove : clearanceAbove // ignore: cast_nullable_to_non_nullable
as double,
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
mixin _$SectionRect {

 double get x0; double get y0; double get x1; double get y1;
/// Create a copy of SectionRect
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionRectCopyWith<SectionRect> get copyWith => _$SectionRectCopyWithImpl<SectionRect>(this as SectionRect, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SectionRect;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionRect&&(identical(other.x0, _this.x0) || other.x0 == _this.x0)&&(identical(other.y0, _this.y0) || other.y0 == _this.y0)&&(identical(other.x1, _this.x1) || other.x1 == _this.x1)&&(identical(other.y1, _this.y1) || other.y1 == _this.y1));
}


@override
int get hashCode {
  final _this = this as SectionRect;
  return Object.hash(runtimeType,_this.x0,_this.y0,_this.x1,_this.y1);
}

@override
String toString() {
  final _this = this as SectionRect;
  return 'SectionRect(x0: ${_this.x0}, y0: ${_this.y0}, x1: ${_this.x1}, y1: ${_this.y1})';
}


}

/// @nodoc
abstract mixin class $SectionRectCopyWith<$Res>  {
  factory $SectionRectCopyWith(SectionRect value, $Res Function(SectionRect) _then) = _$SectionRectCopyWithImpl;
@useResult
$Res call({
 double x0, double y0, double x1, double y1
});




}
/// @nodoc
class _$SectionRectCopyWithImpl<$Res>
    implements $SectionRectCopyWith<$Res> {
  _$SectionRectCopyWithImpl(this._self, this._then);

  final SectionRect _self;
  final $Res Function(SectionRect) _then;

/// Create a copy of SectionRect
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x0 = null,Object? y0 = null,Object? x1 = null,Object? y1 = null,}) {
  return _then(SectionRect(
x0: null == x0 ? _self.x0 : x0 // ignore: cast_nullable_to_non_nullable
as double,y0: null == y0 ? _self.y0 : y0 // ignore: cast_nullable_to_non_nullable
as double,x1: null == x1 ? _self.x1 : x1 // ignore: cast_nullable_to_non_nullable
as double,y1: null == y1 ? _self.y1 : y1 // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SectionRect].
extension SectionRectPatterns on SectionRect {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SectionRect value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SectionRect() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SectionRect value)  $default,){
final _that = this;
switch (_that) {
case _SectionRect():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SectionRect value)?  $default,){
final _that = this;
switch (_that) {
case _SectionRect() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double x0,  double y0,  double x1,  double y1)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SectionRect() when $default != null:
return $default(_that.x0,_that.y0,_that.x1,_that.y1);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double x0,  double y0,  double x1,  double y1)  $default,) {final _that = this;
switch (_that) {
case _SectionRect():
return $default(_that.x0,_that.y0,_that.x1,_that.y1);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double x0,  double y0,  double x1,  double y1)?  $default,) {final _that = this;
switch (_that) {
case _SectionRect() when $default != null:
return $default(_that.x0,_that.y0,_that.x1,_that.y1);case _:
  return null;

}
}

}

/// @nodoc


class _SectionRect implements SectionRect {
  const _SectionRect({required this.x0, required this.y0, required this.x1, required this.y1});
  

@override final  double x0;
@override final  double y0;
@override final  double x1;
@override final  double y1;

/// Create a copy of SectionRect
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionRectCopyWith<_SectionRect> get copyWith => __$SectionRectCopyWithImpl<_SectionRect>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SectionRect&&(identical(other.x0, x0) || other.x0 == x0)&&(identical(other.y0, y0) || other.y0 == y0)&&(identical(other.x1, x1) || other.x1 == x1)&&(identical(other.y1, y1) || other.y1 == y1));
}


@override
int get hashCode {
    return Object.hash(runtimeType,x0,y0,x1,y1);
}

@override
String toString() {
    return 'SectionRect(x0: $x0, y0: $y0, x1: $x1, y1: $y1)';
}


}

/// @nodoc
abstract mixin class _$SectionRectCopyWith<$Res> implements $SectionRectCopyWith<$Res> {
  factory _$SectionRectCopyWith(_SectionRect value, $Res Function(_SectionRect) _then) = __$SectionRectCopyWithImpl;
@override @useResult
$Res call({
 double x0, double y0, double x1, double y1
});




}
/// @nodoc
class __$SectionRectCopyWithImpl<$Res>
    implements _$SectionRectCopyWith<$Res> {
  __$SectionRectCopyWithImpl(this._self, this._then);

  final _SectionRect _self;
  final $Res Function(_SectionRect) _then;

/// Create a copy of SectionRect
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x0 = null,Object? y0 = null,Object? x1 = null,Object? y1 = null,}) {
  return _then(_SectionRect(
x0: null == x0 ? _self.x0 : x0 // ignore: cast_nullable_to_non_nullable
as double,y0: null == y0 ? _self.y0 : y0 // ignore: cast_nullable_to_non_nullable
as double,x1: null == x1 ? _self.x1 : x1 // ignore: cast_nullable_to_non_nullable
as double,y1: null == y1 ? _self.y1 : y1 // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$SectionPoint {

 double get x; double get y;
/// Create a copy of SectionPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionPointCopyWith<SectionPoint> get copyWith => _$SectionPointCopyWithImpl<SectionPoint>(this as SectionPoint, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SectionPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionPoint&&(identical(other.x, _this.x) || other.x == _this.x)&&(identical(other.y, _this.y) || other.y == _this.y));
}


@override
int get hashCode {
  final _this = this as SectionPoint;
  return Object.hash(runtimeType,_this.x,_this.y);
}

@override
String toString() {
  final _this = this as SectionPoint;
  return 'SectionPoint(x: ${_this.x}, y: ${_this.y})';
}


}

/// @nodoc
abstract mixin class $SectionPointCopyWith<$Res>  {
  factory $SectionPointCopyWith(SectionPoint value, $Res Function(SectionPoint) _then) = _$SectionPointCopyWithImpl;
@useResult
$Res call({
 double x, double y
});




}
/// @nodoc
class _$SectionPointCopyWithImpl<$Res>
    implements $SectionPointCopyWith<$Res> {
  _$SectionPointCopyWithImpl(this._self, this._then);

  final SectionPoint _self;
  final $Res Function(SectionPoint) _then;

/// Create a copy of SectionPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x = null,Object? y = null,}) {
  return _then(SectionPoint(
null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SectionPoint].
extension SectionPointPatterns on SectionPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SectionPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SectionPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SectionPoint value)  $default,){
final _that = this;
switch (_that) {
case _SectionPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SectionPoint value)?  $default,){
final _that = this;
switch (_that) {
case _SectionPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double x,  double y)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SectionPoint() when $default != null:
return $default(_that.x,_that.y);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double x,  double y)  $default,) {final _that = this;
switch (_that) {
case _SectionPoint():
return $default(_that.x,_that.y);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double x,  double y)?  $default,) {final _that = this;
switch (_that) {
case _SectionPoint() when $default != null:
return $default(_that.x,_that.y);case _:
  return null;

}
}

}

/// @nodoc


class _SectionPoint implements SectionPoint {
  const _SectionPoint(this.x, this.y);
  

@override final  double x;
@override final  double y;

/// Create a copy of SectionPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionPointCopyWith<_SectionPoint> get copyWith => __$SectionPointCopyWithImpl<_SectionPoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SectionPoint&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y));
}


@override
int get hashCode {
    return Object.hash(runtimeType,x,y);
}

@override
String toString() {
    return 'SectionPoint(x: $x, y: $y)';
}


}

/// @nodoc
abstract mixin class _$SectionPointCopyWith<$Res> implements $SectionPointCopyWith<$Res> {
  factory _$SectionPointCopyWith(_SectionPoint value, $Res Function(_SectionPoint) _then) = __$SectionPointCopyWithImpl;
@override @useResult
$Res call({
 double x, double y
});




}
/// @nodoc
class __$SectionPointCopyWithImpl<$Res>
    implements _$SectionPointCopyWith<$Res> {
  __$SectionPointCopyWithImpl(this._self, this._then);

  final _SectionPoint _self;
  final $Res Function(_SectionPoint) _then;

/// Create a copy of SectionPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x = null,Object? y = null,}) {
  return _then(_SectionPoint(
null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$SectionPolygon {

 List<SectionPoint> get points;
/// Create a copy of SectionPolygon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionPolygonCopyWith<SectionPolygon> get copyWith => _$SectionPolygonCopyWithImpl<SectionPolygon>(this as SectionPolygon, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SectionPolygon;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionPolygon&&const DeepCollectionEquality().equals(other.points, _this.points));
}


@override
int get hashCode {
  final _this = this as SectionPolygon;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.points));
}

@override
String toString() {
  final _this = this as SectionPolygon;
  return 'SectionPolygon(points: ${_this.points})';
}


}

/// @nodoc
abstract mixin class $SectionPolygonCopyWith<$Res>  {
  factory $SectionPolygonCopyWith(SectionPolygon value, $Res Function(SectionPolygon) _then) = _$SectionPolygonCopyWithImpl;
@useResult
$Res call({
 List<SectionPoint> points
});




}
/// @nodoc
class _$SectionPolygonCopyWithImpl<$Res>
    implements $SectionPolygonCopyWith<$Res> {
  _$SectionPolygonCopyWithImpl(this._self, this._then);

  final SectionPolygon _self;
  final $Res Function(SectionPolygon) _then;

/// Create a copy of SectionPolygon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? points = null,}) {
  return _then(SectionPolygon(
null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<SectionPoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [SectionPolygon].
extension SectionPolygonPatterns on SectionPolygon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SectionPolygon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SectionPolygon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SectionPolygon value)  $default,){
final _that = this;
switch (_that) {
case _SectionPolygon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SectionPolygon value)?  $default,){
final _that = this;
switch (_that) {
case _SectionPolygon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SectionPoint> points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SectionPolygon() when $default != null:
return $default(_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SectionPoint> points)  $default,) {final _that = this;
switch (_that) {
case _SectionPolygon():
return $default(_that.points);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SectionPoint> points)?  $default,) {final _that = this;
switch (_that) {
case _SectionPolygon() when $default != null:
return $default(_that.points);case _:
  return null;

}
}

}

/// @nodoc


class _SectionPolygon extends SectionPolygon {
  const _SectionPolygon( List<SectionPoint> points): _points = points,super._();
  

 final  List<SectionPoint> _points;
@override List<SectionPoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}


/// Create a copy of SectionPolygon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionPolygonCopyWith<_SectionPolygon> get copyWith => __$SectionPolygonCopyWithImpl<_SectionPolygon>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SectionPolygon&&const DeepCollectionEquality().equals(other.points, _points));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_points));
}

@override
String toString() {
    return 'SectionPolygon(points: $points)';
}


}

/// @nodoc
abstract mixin class _$SectionPolygonCopyWith<$Res> implements $SectionPolygonCopyWith<$Res> {
  factory _$SectionPolygonCopyWith(_SectionPolygon value, $Res Function(_SectionPolygon) _then) = __$SectionPolygonCopyWithImpl;
@override @useResult
$Res call({
 List<SectionPoint> points
});




}
/// @nodoc
class __$SectionPolygonCopyWithImpl<$Res>
    implements _$SectionPolygonCopyWith<$Res> {
  __$SectionPolygonCopyWithImpl(this._self, this._then);

  final _SectionPolygon _self;
  final $Res Function(_SectionPolygon) _then;

/// Create a copy of SectionPolygon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,}) {
  return _then(_SectionPolygon(
null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<SectionPoint>,
  ));
}


}

/// @nodoc
mixin _$DrawerFaceSection {

/// Entaillés par la rainure quand le fond y entre.
 List<SectionPolygon> get sides; SectionRect get bottom;/// Vides en bois sur bois. Un L en sous tiroir.
 List<SectionPolygon> get slides;
/// Create a copy of DrawerFaceSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrawerFaceSectionCopyWith<DrawerFaceSection> get copyWith => _$DrawerFaceSectionCopyWithImpl<DrawerFaceSection>(this as DrawerFaceSection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DrawerFaceSection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrawerFaceSection&&const DeepCollectionEquality().equals(other.sides, _this.sides)&&(identical(other.bottom, _this.bottom) || other.bottom == _this.bottom)&&const DeepCollectionEquality().equals(other.slides, _this.slides));
}


@override
int get hashCode {
  final _this = this as DrawerFaceSection;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.sides),_this.bottom,const DeepCollectionEquality().hash(_this.slides));
}

@override
String toString() {
  final _this = this as DrawerFaceSection;
  return 'DrawerFaceSection(sides: ${_this.sides}, bottom: ${_this.bottom}, slides: ${_this.slides})';
}


}

/// @nodoc
abstract mixin class $DrawerFaceSectionCopyWith<$Res>  {
  factory $DrawerFaceSectionCopyWith(DrawerFaceSection value, $Res Function(DrawerFaceSection) _then) = _$DrawerFaceSectionCopyWithImpl;
@useResult
$Res call({
 List<SectionPolygon> sides, SectionRect bottom, List<SectionPolygon> slides
});


$SectionRectCopyWith<$Res> get bottom;

}
/// @nodoc
class _$DrawerFaceSectionCopyWithImpl<$Res>
    implements $DrawerFaceSectionCopyWith<$Res> {
  _$DrawerFaceSectionCopyWithImpl(this._self, this._then);

  final DrawerFaceSection _self;
  final $Res Function(DrawerFaceSection) _then;

/// Create a copy of DrawerFaceSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sides = null,Object? bottom = null,Object? slides = null,}) {
  return _then(DrawerFaceSection(
sides: null == sides ? _self.sides : sides // ignore: cast_nullable_to_non_nullable
as List<SectionPolygon>,bottom: null == bottom ? _self.bottom : bottom // ignore: cast_nullable_to_non_nullable
as SectionRect,slides: null == slides ? _self.slides : slides // ignore: cast_nullable_to_non_nullable
as List<SectionPolygon>,
  ));
}
/// Create a copy of DrawerFaceSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionRectCopyWith<$Res> get bottom {
  
  return $SectionRectCopyWith<$Res>(_self.bottom, (value) {
    return _then(_self.copyWith(bottom: value));
  });
}
}


/// Adds pattern-matching-related methods to [DrawerFaceSection].
extension DrawerFaceSectionPatterns on DrawerFaceSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrawerFaceSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrawerFaceSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrawerFaceSection value)  $default,){
final _that = this;
switch (_that) {
case _DrawerFaceSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrawerFaceSection value)?  $default,){
final _that = this;
switch (_that) {
case _DrawerFaceSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SectionPolygon> sides,  SectionRect bottom,  List<SectionPolygon> slides)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrawerFaceSection() when $default != null:
return $default(_that.sides,_that.bottom,_that.slides);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SectionPolygon> sides,  SectionRect bottom,  List<SectionPolygon> slides)  $default,) {final _that = this;
switch (_that) {
case _DrawerFaceSection():
return $default(_that.sides,_that.bottom,_that.slides);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SectionPolygon> sides,  SectionRect bottom,  List<SectionPolygon> slides)?  $default,) {final _that = this;
switch (_that) {
case _DrawerFaceSection() when $default != null:
return $default(_that.sides,_that.bottom,_that.slides);case _:
  return null;

}
}

}

/// @nodoc


class _DrawerFaceSection implements DrawerFaceSection {
  const _DrawerFaceSection({required  List<SectionPolygon> sides, required this.bottom, required  List<SectionPolygon> slides}): _sides = sides,_slides = slides;
  

/// Entaillés par la rainure quand le fond y entre.
 final  List<SectionPolygon> _sides;
/// Entaillés par la rainure quand le fond y entre.
@override List<SectionPolygon> get sides {
  if (_sides is EqualUnmodifiableListView) return _sides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sides);
}

@override final  SectionRect bottom;
/// Vides en bois sur bois. Un L en sous tiroir.
 final  List<SectionPolygon> _slides;
/// Vides en bois sur bois. Un L en sous tiroir.
@override List<SectionPolygon> get slides {
  if (_slides is EqualUnmodifiableListView) return _slides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slides);
}


/// Create a copy of DrawerFaceSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrawerFaceSectionCopyWith<_DrawerFaceSection> get copyWith => __$DrawerFaceSectionCopyWithImpl<_DrawerFaceSection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrawerFaceSection&&const DeepCollectionEquality().equals(other.sides, _sides)&&(identical(other.bottom, bottom) || other.bottom == bottom)&&const DeepCollectionEquality().equals(other.slides, _slides));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_sides),bottom,const DeepCollectionEquality().hash(_slides));
}

@override
String toString() {
    return 'DrawerFaceSection(sides: $sides, bottom: $bottom, slides: $slides)';
}


}

/// @nodoc
abstract mixin class _$DrawerFaceSectionCopyWith<$Res> implements $DrawerFaceSectionCopyWith<$Res> {
  factory _$DrawerFaceSectionCopyWith(_DrawerFaceSection value, $Res Function(_DrawerFaceSection) _then) = __$DrawerFaceSectionCopyWithImpl;
@override @useResult
$Res call({
 List<SectionPolygon> sides, SectionRect bottom, List<SectionPolygon> slides
});


@override $SectionRectCopyWith<$Res> get bottom;

}
/// @nodoc
class __$DrawerFaceSectionCopyWithImpl<$Res>
    implements _$DrawerFaceSectionCopyWith<$Res> {
  __$DrawerFaceSectionCopyWithImpl(this._self, this._then);

  final _DrawerFaceSection _self;
  final $Res Function(_DrawerFaceSection) _then;

/// Create a copy of DrawerFaceSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sides = null,Object? bottom = null,Object? slides = null,}) {
  return _then(_DrawerFaceSection(
sides: null == sides ? _self._sides : sides // ignore: cast_nullable_to_non_nullable
as List<SectionPolygon>,bottom: null == bottom ? _self.bottom : bottom // ignore: cast_nullable_to_non_nullable
as SectionRect,slides: null == slides ? _self._slides : slides // ignore: cast_nullable_to_non_nullable
as List<SectionPolygon>,
  ));
}

/// Create a copy of DrawerFaceSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionRectCopyWith<$Res> get bottom {
  
  return $SectionRectCopyWith<$Res>(_self.bottom, (value) {
    return _then(_self.copyWith(bottom: value));
  });
}
}

/// @nodoc
mixin _$DrawerTopSection {

/// Les flancs du caisson, de part et d'autre de l'ouverture.
 List<SectionRect> get flanks;/// Côtés, devant et dos, chacun tel que l'assemblage le coupe.
 List<SectionRect> get walls;/// Vides sans glissière latérale : une glissière sous tiroir est cachée
/// sous le fond.
 List<SectionRect> get slides; SectionRect get front;
/// Create a copy of DrawerTopSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrawerTopSectionCopyWith<DrawerTopSection> get copyWith => _$DrawerTopSectionCopyWithImpl<DrawerTopSection>(this as DrawerTopSection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DrawerTopSection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrawerTopSection&&const DeepCollectionEquality().equals(other.flanks, _this.flanks)&&const DeepCollectionEquality().equals(other.walls, _this.walls)&&const DeepCollectionEquality().equals(other.slides, _this.slides)&&(identical(other.front, _this.front) || other.front == _this.front));
}


@override
int get hashCode {
  final _this = this as DrawerTopSection;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.flanks),const DeepCollectionEquality().hash(_this.walls),const DeepCollectionEquality().hash(_this.slides),_this.front);
}

@override
String toString() {
  final _this = this as DrawerTopSection;
  return 'DrawerTopSection(flanks: ${_this.flanks}, walls: ${_this.walls}, slides: ${_this.slides}, front: ${_this.front})';
}


}

/// @nodoc
abstract mixin class $DrawerTopSectionCopyWith<$Res>  {
  factory $DrawerTopSectionCopyWith(DrawerTopSection value, $Res Function(DrawerTopSection) _then) = _$DrawerTopSectionCopyWithImpl;
@useResult
$Res call({
 List<SectionRect> flanks, List<SectionRect> walls, List<SectionRect> slides, SectionRect front
});


$SectionRectCopyWith<$Res> get front;

}
/// @nodoc
class _$DrawerTopSectionCopyWithImpl<$Res>
    implements $DrawerTopSectionCopyWith<$Res> {
  _$DrawerTopSectionCopyWithImpl(this._self, this._then);

  final DrawerTopSection _self;
  final $Res Function(DrawerTopSection) _then;

/// Create a copy of DrawerTopSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flanks = null,Object? walls = null,Object? slides = null,Object? front = null,}) {
  return _then(DrawerTopSection(
flanks: null == flanks ? _self.flanks : flanks // ignore: cast_nullable_to_non_nullable
as List<SectionRect>,walls: null == walls ? _self.walls : walls // ignore: cast_nullable_to_non_nullable
as List<SectionRect>,slides: null == slides ? _self.slides : slides // ignore: cast_nullable_to_non_nullable
as List<SectionRect>,front: null == front ? _self.front : front // ignore: cast_nullable_to_non_nullable
as SectionRect,
  ));
}
/// Create a copy of DrawerTopSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionRectCopyWith<$Res> get front {
  
  return $SectionRectCopyWith<$Res>(_self.front, (value) {
    return _then(_self.copyWith(front: value));
  });
}
}


/// Adds pattern-matching-related methods to [DrawerTopSection].
extension DrawerTopSectionPatterns on DrawerTopSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrawerTopSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrawerTopSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrawerTopSection value)  $default,){
final _that = this;
switch (_that) {
case _DrawerTopSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrawerTopSection value)?  $default,){
final _that = this;
switch (_that) {
case _DrawerTopSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SectionRect> flanks,  List<SectionRect> walls,  List<SectionRect> slides,  SectionRect front)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrawerTopSection() when $default != null:
return $default(_that.flanks,_that.walls,_that.slides,_that.front);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SectionRect> flanks,  List<SectionRect> walls,  List<SectionRect> slides,  SectionRect front)  $default,) {final _that = this;
switch (_that) {
case _DrawerTopSection():
return $default(_that.flanks,_that.walls,_that.slides,_that.front);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SectionRect> flanks,  List<SectionRect> walls,  List<SectionRect> slides,  SectionRect front)?  $default,) {final _that = this;
switch (_that) {
case _DrawerTopSection() when $default != null:
return $default(_that.flanks,_that.walls,_that.slides,_that.front);case _:
  return null;

}
}

}

/// @nodoc


class _DrawerTopSection implements DrawerTopSection {
  const _DrawerTopSection({required  List<SectionRect> flanks, required  List<SectionRect> walls, required  List<SectionRect> slides, required this.front}): _flanks = flanks,_walls = walls,_slides = slides;
  

/// Les flancs du caisson, de part et d'autre de l'ouverture.
 final  List<SectionRect> _flanks;
/// Les flancs du caisson, de part et d'autre de l'ouverture.
@override List<SectionRect> get flanks {
  if (_flanks is EqualUnmodifiableListView) return _flanks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_flanks);
}

/// Côtés, devant et dos, chacun tel que l'assemblage le coupe.
 final  List<SectionRect> _walls;
/// Côtés, devant et dos, chacun tel que l'assemblage le coupe.
@override List<SectionRect> get walls {
  if (_walls is EqualUnmodifiableListView) return _walls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_walls);
}

/// Vides sans glissière latérale : une glissière sous tiroir est cachée
/// sous le fond.
 final  List<SectionRect> _slides;
/// Vides sans glissière latérale : une glissière sous tiroir est cachée
/// sous le fond.
@override List<SectionRect> get slides {
  if (_slides is EqualUnmodifiableListView) return _slides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slides);
}

@override final  SectionRect front;

/// Create a copy of DrawerTopSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrawerTopSectionCopyWith<_DrawerTopSection> get copyWith => __$DrawerTopSectionCopyWithImpl<_DrawerTopSection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrawerTopSection&&const DeepCollectionEquality().equals(other.flanks, _flanks)&&const DeepCollectionEquality().equals(other.walls, _walls)&&const DeepCollectionEquality().equals(other.slides, _slides)&&(identical(other.front, front) || other.front == front));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_flanks),const DeepCollectionEquality().hash(_walls),const DeepCollectionEquality().hash(_slides),front);
}

@override
String toString() {
    return 'DrawerTopSection(flanks: $flanks, walls: $walls, slides: $slides, front: $front)';
}


}

/// @nodoc
abstract mixin class _$DrawerTopSectionCopyWith<$Res> implements $DrawerTopSectionCopyWith<$Res> {
  factory _$DrawerTopSectionCopyWith(_DrawerTopSection value, $Res Function(_DrawerTopSection) _then) = __$DrawerTopSectionCopyWithImpl;
@override @useResult
$Res call({
 List<SectionRect> flanks, List<SectionRect> walls, List<SectionRect> slides, SectionRect front
});


@override $SectionRectCopyWith<$Res> get front;

}
/// @nodoc
class __$DrawerTopSectionCopyWithImpl<$Res>
    implements _$DrawerTopSectionCopyWith<$Res> {
  __$DrawerTopSectionCopyWithImpl(this._self, this._then);

  final _DrawerTopSection _self;
  final $Res Function(_DrawerTopSection) _then;

/// Create a copy of DrawerTopSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flanks = null,Object? walls = null,Object? slides = null,Object? front = null,}) {
  return _then(_DrawerTopSection(
flanks: null == flanks ? _self._flanks : flanks // ignore: cast_nullable_to_non_nullable
as List<SectionRect>,walls: null == walls ? _self._walls : walls // ignore: cast_nullable_to_non_nullable
as List<SectionRect>,slides: null == slides ? _self._slides : slides // ignore: cast_nullable_to_non_nullable
as List<SectionRect>,front: null == front ? _self.front : front // ignore: cast_nullable_to_non_nullable
as SectionRect,
  ));
}

/// Create a copy of DrawerTopSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionRectCopyWith<$Res> get front {
  
  return $SectionRectCopyWith<$Res>(_self.front, (value) {
    return _then(_self.copyWith(front: value));
  });
}
}

/// @nodoc
mixin _$DrawersResult {

/// Façades de haut en bas, toutes de largeur [frontWidth].
 List<DrawerFrontSlot> get fronts; double get frontWidth;/// Bord gauche des façades, depuis le flanc gauche de l'ouverture.
/// Négatif en applique.
 double get frontLeft;/// Jeu effectivement laissé entre flanc et côté, de chaque côté.
 double get sideClearance;/// Caisson hors tout, face : l'ouverture plus un flanc de chaque côté.
///
/// La profondeur n'y figure pas : elle dépend de la pose du dos, que
/// l'outil ne connaît pas.
 double get carcassWidth; double get carcassHeight;/// Caisse hors tout.
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
 List<CutPiece> get cutList;/// Chaque tiroir dans la coupe de face, de haut en bas.
 List<DrawerFaceSection> get faceSections;/// Un tiroir dans la coupe de dessus : ils sont tous pareils vus d'en
/// haut.
 DrawerTopSection get topSection;
/// Create a copy of DrawersResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrawersResultCopyWith<DrawersResult> get copyWith => _$DrawersResultCopyWithImpl<DrawersResult>(this as DrawersResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DrawersResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrawersResult&&const DeepCollectionEquality().equals(other.fronts, _this.fronts)&&(identical(other.frontWidth, _this.frontWidth) || other.frontWidth == _this.frontWidth)&&(identical(other.frontLeft, _this.frontLeft) || other.frontLeft == _this.frontLeft)&&(identical(other.sideClearance, _this.sideClearance) || other.sideClearance == _this.sideClearance)&&(identical(other.carcassWidth, _this.carcassWidth) || other.carcassWidth == _this.carcassWidth)&&(identical(other.carcassHeight, _this.carcassHeight) || other.carcassHeight == _this.carcassHeight)&&(identical(other.boxWidth, _this.boxWidth) || other.boxWidth == _this.boxWidth)&&(identical(other.boxLength, _this.boxLength) || other.boxLength == _this.boxLength)&&(identical(other.boxSetback, _this.boxSetback) || other.boxSetback == _this.boxSetback)&&const DeepCollectionEquality().equals(other.boxHeights, _this.boxHeights)&&const DeepCollectionEquality().equals(other.boxBottoms, _this.boxBottoms)&&(identical(other.bottomLift, _this.bottomLift) || other.bottomLift == _this.bottomLift)&&(identical(other.slideLength, _this.slideLength) || other.slideLength == _this.slideLength)&&(identical(other.isSlideLengthAuto, _this.isSlideLengthAuto) || other.isSlideLengthAuto == _this.isSlideLengthAuto)&&const DeepCollectionEquality().equals(other.slideAxes, _this.slideAxes)&&const DeepCollectionEquality().equals(other.cutList, _this.cutList)&&const DeepCollectionEquality().equals(other.faceSections, _this.faceSections)&&(identical(other.topSection, _this.topSection) || other.topSection == _this.topSection));
}


@override
int get hashCode {
  final _this = this as DrawersResult;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.fronts),_this.frontWidth,_this.frontLeft,_this.sideClearance,_this.carcassWidth,_this.carcassHeight,_this.boxWidth,_this.boxLength,_this.boxSetback,const DeepCollectionEquality().hash(_this.boxHeights),const DeepCollectionEquality().hash(_this.boxBottoms),_this.bottomLift,_this.slideLength,_this.isSlideLengthAuto,const DeepCollectionEquality().hash(_this.slideAxes),const DeepCollectionEquality().hash(_this.cutList),const DeepCollectionEquality().hash(_this.faceSections),_this.topSection);
}

@override
String toString() {
  final _this = this as DrawersResult;
  return 'DrawersResult(fronts: ${_this.fronts}, frontWidth: ${_this.frontWidth}, frontLeft: ${_this.frontLeft}, sideClearance: ${_this.sideClearance}, carcassWidth: ${_this.carcassWidth}, carcassHeight: ${_this.carcassHeight}, boxWidth: ${_this.boxWidth}, boxLength: ${_this.boxLength}, boxSetback: ${_this.boxSetback}, boxHeights: ${_this.boxHeights}, boxBottoms: ${_this.boxBottoms}, bottomLift: ${_this.bottomLift}, slideLength: ${_this.slideLength}, isSlideLengthAuto: ${_this.isSlideLengthAuto}, slideAxes: ${_this.slideAxes}, cutList: ${_this.cutList}, faceSections: ${_this.faceSections}, topSection: ${_this.topSection})';
}


}

/// @nodoc
abstract mixin class $DrawersResultCopyWith<$Res>  {
  factory $DrawersResultCopyWith(DrawersResult value, $Res Function(DrawersResult) _then) = _$DrawersResultCopyWithImpl;
@useResult
$Res call({
 List<DrawerFrontSlot> fronts, double frontWidth, double frontLeft, double sideClearance, double carcassWidth, double carcassHeight, double boxWidth, double boxLength, double boxSetback, List<double> boxHeights, List<double> boxBottoms, double bottomLift, double? slideLength, bool isSlideLengthAuto, List<double> slideAxes, List<CutPiece> cutList, List<DrawerFaceSection> faceSections, DrawerTopSection topSection
});


$DrawerTopSectionCopyWith<$Res> get topSection;

}
/// @nodoc
class _$DrawersResultCopyWithImpl<$Res>
    implements $DrawersResultCopyWith<$Res> {
  _$DrawersResultCopyWithImpl(this._self, this._then);

  final DrawersResult _self;
  final $Res Function(DrawersResult) _then;

/// Create a copy of DrawersResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fronts = null,Object? frontWidth = null,Object? frontLeft = null,Object? sideClearance = null,Object? carcassWidth = null,Object? carcassHeight = null,Object? boxWidth = null,Object? boxLength = null,Object? boxSetback = null,Object? boxHeights = null,Object? boxBottoms = null,Object? bottomLift = null,Object? slideLength = freezed,Object? isSlideLengthAuto = null,Object? slideAxes = null,Object? cutList = null,Object? faceSections = null,Object? topSection = null,}) {
  return _then(DrawersResult(
fronts: null == fronts ? _self.fronts : fronts // ignore: cast_nullable_to_non_nullable
as List<DrawerFrontSlot>,frontWidth: null == frontWidth ? _self.frontWidth : frontWidth // ignore: cast_nullable_to_non_nullable
as double,frontLeft: null == frontLeft ? _self.frontLeft : frontLeft // ignore: cast_nullable_to_non_nullable
as double,sideClearance: null == sideClearance ? _self.sideClearance : sideClearance // ignore: cast_nullable_to_non_nullable
as double,carcassWidth: null == carcassWidth ? _self.carcassWidth : carcassWidth // ignore: cast_nullable_to_non_nullable
as double,carcassHeight: null == carcassHeight ? _self.carcassHeight : carcassHeight // ignore: cast_nullable_to_non_nullable
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
as List<CutPiece>,faceSections: null == faceSections ? _self.faceSections : faceSections // ignore: cast_nullable_to_non_nullable
as List<DrawerFaceSection>,topSection: null == topSection ? _self.topSection : topSection // ignore: cast_nullable_to_non_nullable
as DrawerTopSection,
  ));
}
/// Create a copy of DrawersResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrawerTopSectionCopyWith<$Res> get topSection {
  
  return $DrawerTopSectionCopyWith<$Res>(_self.topSection, (value) {
    return _then(_self.copyWith(topSection: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DrawerFrontSlot> fronts,  double frontWidth,  double frontLeft,  double sideClearance,  double carcassWidth,  double carcassHeight,  double boxWidth,  double boxLength,  double boxSetback,  List<double> boxHeights,  List<double> boxBottoms,  double bottomLift,  double? slideLength,  bool isSlideLengthAuto,  List<double> slideAxes,  List<CutPiece> cutList,  List<DrawerFaceSection> faceSections,  DrawerTopSection topSection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrawersResult() when $default != null:
return $default(_that.fronts,_that.frontWidth,_that.frontLeft,_that.sideClearance,_that.carcassWidth,_that.carcassHeight,_that.boxWidth,_that.boxLength,_that.boxSetback,_that.boxHeights,_that.boxBottoms,_that.bottomLift,_that.slideLength,_that.isSlideLengthAuto,_that.slideAxes,_that.cutList,_that.faceSections,_that.topSection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DrawerFrontSlot> fronts,  double frontWidth,  double frontLeft,  double sideClearance,  double carcassWidth,  double carcassHeight,  double boxWidth,  double boxLength,  double boxSetback,  List<double> boxHeights,  List<double> boxBottoms,  double bottomLift,  double? slideLength,  bool isSlideLengthAuto,  List<double> slideAxes,  List<CutPiece> cutList,  List<DrawerFaceSection> faceSections,  DrawerTopSection topSection)  $default,) {final _that = this;
switch (_that) {
case _DrawersResult():
return $default(_that.fronts,_that.frontWidth,_that.frontLeft,_that.sideClearance,_that.carcassWidth,_that.carcassHeight,_that.boxWidth,_that.boxLength,_that.boxSetback,_that.boxHeights,_that.boxBottoms,_that.bottomLift,_that.slideLength,_that.isSlideLengthAuto,_that.slideAxes,_that.cutList,_that.faceSections,_that.topSection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DrawerFrontSlot> fronts,  double frontWidth,  double frontLeft,  double sideClearance,  double carcassWidth,  double carcassHeight,  double boxWidth,  double boxLength,  double boxSetback,  List<double> boxHeights,  List<double> boxBottoms,  double bottomLift,  double? slideLength,  bool isSlideLengthAuto,  List<double> slideAxes,  List<CutPiece> cutList,  List<DrawerFaceSection> faceSections,  DrawerTopSection topSection)?  $default,) {final _that = this;
switch (_that) {
case _DrawersResult() when $default != null:
return $default(_that.fronts,_that.frontWidth,_that.frontLeft,_that.sideClearance,_that.carcassWidth,_that.carcassHeight,_that.boxWidth,_that.boxLength,_that.boxSetback,_that.boxHeights,_that.boxBottoms,_that.bottomLift,_that.slideLength,_that.isSlideLengthAuto,_that.slideAxes,_that.cutList,_that.faceSections,_that.topSection);case _:
  return null;

}
}

}

/// @nodoc


class _DrawersResult implements DrawersResult {
  const _DrawersResult({required  List<DrawerFrontSlot> fronts, required this.frontWidth, required this.frontLeft, required this.sideClearance, required this.carcassWidth, required this.carcassHeight, required this.boxWidth, required this.boxLength, this.boxSetback = 0, required  List<double> boxHeights, required  List<double> boxBottoms, this.bottomLift = 0, this.slideLength, this.isSlideLengthAuto = true, required  List<double> slideAxes, required  List<CutPiece> cutList, required  List<DrawerFaceSection> faceSections, required this.topSection}): _fronts = fronts,_boxHeights = boxHeights,_boxBottoms = boxBottoms,_slideAxes = slideAxes,_cutList = cutList,_faceSections = faceSections;
  

/// Façades de haut en bas, toutes de largeur [frontWidth].
 final  List<DrawerFrontSlot> _fronts;
/// Façades de haut en bas, toutes de largeur [frontWidth].
@override List<DrawerFrontSlot> get fronts {
  if (_fronts is EqualUnmodifiableListView) return _fronts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fronts);
}

@override final  double frontWidth;
/// Bord gauche des façades, depuis le flanc gauche de l'ouverture.
/// Négatif en applique.
@override final  double frontLeft;
/// Jeu effectivement laissé entre flanc et côté, de chaque côté.
@override final  double sideClearance;
/// Caisson hors tout, face : l'ouverture plus un flanc de chaque côté.
///
/// La profondeur n'y figure pas : elle dépend de la pose du dos, que
/// l'outil ne connaît pas.
@override final  double carcassWidth;
@override final  double carcassHeight;
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

/// Chaque tiroir dans la coupe de face, de haut en bas.
 final  List<DrawerFaceSection> _faceSections;
/// Chaque tiroir dans la coupe de face, de haut en bas.
@override List<DrawerFaceSection> get faceSections {
  if (_faceSections is EqualUnmodifiableListView) return _faceSections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_faceSections);
}

/// Un tiroir dans la coupe de dessus : ils sont tous pareils vus d'en
/// haut.
@override final  DrawerTopSection topSection;

/// Create a copy of DrawersResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrawersResultCopyWith<_DrawersResult> get copyWith => __$DrawersResultCopyWithImpl<_DrawersResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrawersResult&&const DeepCollectionEquality().equals(other.fronts, _fronts)&&(identical(other.frontWidth, frontWidth) || other.frontWidth == frontWidth)&&(identical(other.frontLeft, frontLeft) || other.frontLeft == frontLeft)&&(identical(other.sideClearance, sideClearance) || other.sideClearance == sideClearance)&&(identical(other.carcassWidth, carcassWidth) || other.carcassWidth == carcassWidth)&&(identical(other.carcassHeight, carcassHeight) || other.carcassHeight == carcassHeight)&&(identical(other.boxWidth, boxWidth) || other.boxWidth == boxWidth)&&(identical(other.boxLength, boxLength) || other.boxLength == boxLength)&&(identical(other.boxSetback, boxSetback) || other.boxSetback == boxSetback)&&const DeepCollectionEquality().equals(other.boxHeights, _boxHeights)&&const DeepCollectionEquality().equals(other.boxBottoms, _boxBottoms)&&(identical(other.bottomLift, bottomLift) || other.bottomLift == bottomLift)&&(identical(other.slideLength, slideLength) || other.slideLength == slideLength)&&(identical(other.isSlideLengthAuto, isSlideLengthAuto) || other.isSlideLengthAuto == isSlideLengthAuto)&&const DeepCollectionEquality().equals(other.slideAxes, _slideAxes)&&const DeepCollectionEquality().equals(other.cutList, _cutList)&&const DeepCollectionEquality().equals(other.faceSections, _faceSections)&&(identical(other.topSection, topSection) || other.topSection == topSection));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_fronts),frontWidth,frontLeft,sideClearance,carcassWidth,carcassHeight,boxWidth,boxLength,boxSetback,const DeepCollectionEquality().hash(_boxHeights),const DeepCollectionEquality().hash(_boxBottoms),bottomLift,slideLength,isSlideLengthAuto,const DeepCollectionEquality().hash(_slideAxes),const DeepCollectionEquality().hash(_cutList),const DeepCollectionEquality().hash(_faceSections),topSection);
}

@override
String toString() {
    return 'DrawersResult(fronts: $fronts, frontWidth: $frontWidth, frontLeft: $frontLeft, sideClearance: $sideClearance, carcassWidth: $carcassWidth, carcassHeight: $carcassHeight, boxWidth: $boxWidth, boxLength: $boxLength, boxSetback: $boxSetback, boxHeights: $boxHeights, boxBottoms: $boxBottoms, bottomLift: $bottomLift, slideLength: $slideLength, isSlideLengthAuto: $isSlideLengthAuto, slideAxes: $slideAxes, cutList: $cutList, faceSections: $faceSections, topSection: $topSection)';
}


}

/// @nodoc
abstract mixin class _$DrawersResultCopyWith<$Res> implements $DrawersResultCopyWith<$Res> {
  factory _$DrawersResultCopyWith(_DrawersResult value, $Res Function(_DrawersResult) _then) = __$DrawersResultCopyWithImpl;
@override @useResult
$Res call({
 List<DrawerFrontSlot> fronts, double frontWidth, double frontLeft, double sideClearance, double carcassWidth, double carcassHeight, double boxWidth, double boxLength, double boxSetback, List<double> boxHeights, List<double> boxBottoms, double bottomLift, double? slideLength, bool isSlideLengthAuto, List<double> slideAxes, List<CutPiece> cutList, List<DrawerFaceSection> faceSections, DrawerTopSection topSection
});


@override $DrawerTopSectionCopyWith<$Res> get topSection;

}
/// @nodoc
class __$DrawersResultCopyWithImpl<$Res>
    implements _$DrawersResultCopyWith<$Res> {
  __$DrawersResultCopyWithImpl(this._self, this._then);

  final _DrawersResult _self;
  final $Res Function(_DrawersResult) _then;

/// Create a copy of DrawersResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fronts = null,Object? frontWidth = null,Object? frontLeft = null,Object? sideClearance = null,Object? carcassWidth = null,Object? carcassHeight = null,Object? boxWidth = null,Object? boxLength = null,Object? boxSetback = null,Object? boxHeights = null,Object? boxBottoms = null,Object? bottomLift = null,Object? slideLength = freezed,Object? isSlideLengthAuto = null,Object? slideAxes = null,Object? cutList = null,Object? faceSections = null,Object? topSection = null,}) {
  return _then(_DrawersResult(
fronts: null == fronts ? _self._fronts : fronts // ignore: cast_nullable_to_non_nullable
as List<DrawerFrontSlot>,frontWidth: null == frontWidth ? _self.frontWidth : frontWidth // ignore: cast_nullable_to_non_nullable
as double,frontLeft: null == frontLeft ? _self.frontLeft : frontLeft // ignore: cast_nullable_to_non_nullable
as double,sideClearance: null == sideClearance ? _self.sideClearance : sideClearance // ignore: cast_nullable_to_non_nullable
as double,carcassWidth: null == carcassWidth ? _self.carcassWidth : carcassWidth // ignore: cast_nullable_to_non_nullable
as double,carcassHeight: null == carcassHeight ? _self.carcassHeight : carcassHeight // ignore: cast_nullable_to_non_nullable
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
as List<CutPiece>,faceSections: null == faceSections ? _self._faceSections : faceSections // ignore: cast_nullable_to_non_nullable
as List<DrawerFaceSection>,topSection: null == topSection ? _self.topSection : topSection // ignore: cast_nullable_to_non_nullable
as DrawerTopSection,
  ));
}

/// Create a copy of DrawersResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrawerTopSectionCopyWith<$Res> get topSection {
  
  return $DrawerTopSectionCopyWith<$Res>(_self.topSection, (value) {
    return _then(_self.copyWith(topSection: value));
  });
}
}

// dart format on
