// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'layout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LayoutInput {

 double get surfaceX; double get surfaceY; double get elementX; double get elementY; double get gapX; double get gapY;/// Retrait sur les **quatre bords** avant de poser, en mm.
///
/// Joint de dilatation d'un parquet, joint au mur d'un carrelage, jeu au
/// sol d'une plaque : la pose recule, mais la pièce ne rétrécit pas —
/// [LayoutResult.surfaceArea] reste l'aire de la surface entière.
 double get perimeterGap;/// Ne jamais finir sur un filet.
///
/// Quand la dernière bande tombe sous un demi-élément, on sacrifie une
/// bande pleine et on partage son épaisseur avec le reliquat entre la
/// première et la dernière, qui deviennent identiques.
///
/// ⚠️ Cela **coûte de la matière** : deux bandes de bord coupées au lieu
/// d'une, donc [LayoutResult.cutCount] et la perte montent. C'est un
/// arbitrage esthétique, pas une amélioration gratuite.
 bool get balanceRows;/// Pivote le motif d'un quart de tour : l'élément se pose le long de Y et
/// les rangées s'empilent selon X.
///
/// Le décalage des joints **suit** la rotation — c'est tout l'intérêt :
/// décaler les joints d'un bardage vertical n'a de sens que le long des
/// lames, pas en travers.
 bool get flip; JointOffset get offset;
/// Create a copy of LayoutInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayoutInputCopyWith<LayoutInput> get copyWith => _$LayoutInputCopyWithImpl<LayoutInput>(this as LayoutInput, _$identity);

  /// Serializes this LayoutInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LayoutInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayoutInput&&(identical(other.surfaceX, _this.surfaceX) || other.surfaceX == _this.surfaceX)&&(identical(other.surfaceY, _this.surfaceY) || other.surfaceY == _this.surfaceY)&&(identical(other.elementX, _this.elementX) || other.elementX == _this.elementX)&&(identical(other.elementY, _this.elementY) || other.elementY == _this.elementY)&&(identical(other.gapX, _this.gapX) || other.gapX == _this.gapX)&&(identical(other.gapY, _this.gapY) || other.gapY == _this.gapY)&&(identical(other.perimeterGap, _this.perimeterGap) || other.perimeterGap == _this.perimeterGap)&&(identical(other.balanceRows, _this.balanceRows) || other.balanceRows == _this.balanceRows)&&(identical(other.flip, _this.flip) || other.flip == _this.flip)&&(identical(other.offset, _this.offset) || other.offset == _this.offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LayoutInput;
  return Object.hash(runtimeType,_this.surfaceX,_this.surfaceY,_this.elementX,_this.elementY,_this.gapX,_this.gapY,_this.perimeterGap,_this.balanceRows,_this.flip,_this.offset);
}

@override
String toString() {
  final _this = this as LayoutInput;
  return 'LayoutInput(surfaceX: ${_this.surfaceX}, surfaceY: ${_this.surfaceY}, elementX: ${_this.elementX}, elementY: ${_this.elementY}, gapX: ${_this.gapX}, gapY: ${_this.gapY}, perimeterGap: ${_this.perimeterGap}, balanceRows: ${_this.balanceRows}, flip: ${_this.flip}, offset: ${_this.offset})';
}


}

/// @nodoc
abstract mixin class $LayoutInputCopyWith<$Res>  {
  factory $LayoutInputCopyWith(LayoutInput value, $Res Function(LayoutInput) _then) = _$LayoutInputCopyWithImpl;
@useResult
$Res call({
 double surfaceX, double surfaceY, double elementX, double elementY, double gapX, double gapY, double perimeterGap, bool balanceRows, bool flip, JointOffset offset
});




}
/// @nodoc
class _$LayoutInputCopyWithImpl<$Res>
    implements $LayoutInputCopyWith<$Res> {
  _$LayoutInputCopyWithImpl(this._self, this._then);

  final LayoutInput _self;
  final $Res Function(LayoutInput) _then;

/// Create a copy of LayoutInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surfaceX = null,Object? surfaceY = null,Object? elementX = null,Object? elementY = null,Object? gapX = null,Object? gapY = null,Object? perimeterGap = null,Object? balanceRows = null,Object? flip = null,Object? offset = null,}) {
  return _then(LayoutInput(
surfaceX: null == surfaceX ? _self.surfaceX : surfaceX // ignore: cast_nullable_to_non_nullable
as double,surfaceY: null == surfaceY ? _self.surfaceY : surfaceY // ignore: cast_nullable_to_non_nullable
as double,elementX: null == elementX ? _self.elementX : elementX // ignore: cast_nullable_to_non_nullable
as double,elementY: null == elementY ? _self.elementY : elementY // ignore: cast_nullable_to_non_nullable
as double,gapX: null == gapX ? _self.gapX : gapX // ignore: cast_nullable_to_non_nullable
as double,gapY: null == gapY ? _self.gapY : gapY // ignore: cast_nullable_to_non_nullable
as double,perimeterGap: null == perimeterGap ? _self.perimeterGap : perimeterGap // ignore: cast_nullable_to_non_nullable
as double,balanceRows: null == balanceRows ? _self.balanceRows : balanceRows // ignore: cast_nullable_to_non_nullable
as bool,flip: null == flip ? _self.flip : flip // ignore: cast_nullable_to_non_nullable
as bool,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as JointOffset,
  ));
}

}


/// Adds pattern-matching-related methods to [LayoutInput].
extension LayoutInputPatterns on LayoutInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LayoutInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LayoutInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LayoutInput value)  $default,){
final _that = this;
switch (_that) {
case _LayoutInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LayoutInput value)?  $default,){
final _that = this;
switch (_that) {
case _LayoutInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double surfaceX,  double surfaceY,  double elementX,  double elementY,  double gapX,  double gapY,  double perimeterGap,  bool balanceRows,  bool flip,  JointOffset offset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LayoutInput() when $default != null:
return $default(_that.surfaceX,_that.surfaceY,_that.elementX,_that.elementY,_that.gapX,_that.gapY,_that.perimeterGap,_that.balanceRows,_that.flip,_that.offset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double surfaceX,  double surfaceY,  double elementX,  double elementY,  double gapX,  double gapY,  double perimeterGap,  bool balanceRows,  bool flip,  JointOffset offset)  $default,) {final _that = this;
switch (_that) {
case _LayoutInput():
return $default(_that.surfaceX,_that.surfaceY,_that.elementX,_that.elementY,_that.gapX,_that.gapY,_that.perimeterGap,_that.balanceRows,_that.flip,_that.offset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double surfaceX,  double surfaceY,  double elementX,  double elementY,  double gapX,  double gapY,  double perimeterGap,  bool balanceRows,  bool flip,  JointOffset offset)?  $default,) {final _that = this;
switch (_that) {
case _LayoutInput() when $default != null:
return $default(_that.surfaceX,_that.surfaceY,_that.elementX,_that.elementY,_that.gapX,_that.gapY,_that.perimeterGap,_that.balanceRows,_that.flip,_that.offset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LayoutInput implements LayoutInput {
  const _LayoutInput({required this.surfaceX, required this.surfaceY, required this.elementX, required this.elementY, this.gapX = 0.0, this.gapY = 0.0, this.perimeterGap = 0.0, this.balanceRows = false, this.flip = false, this.offset = JointOffset.half});
  factory _LayoutInput.fromJson(Map<String, dynamic> json) => _$LayoutInputFromJson(json);

@override final  double surfaceX;
@override final  double surfaceY;
@override final  double elementX;
@override final  double elementY;
@override@JsonKey() final  double gapX;
@override@JsonKey() final  double gapY;
/// Retrait sur les **quatre bords** avant de poser, en mm.
///
/// Joint de dilatation d'un parquet, joint au mur d'un carrelage, jeu au
/// sol d'une plaque : la pose recule, mais la pièce ne rétrécit pas —
/// [LayoutResult.surfaceArea] reste l'aire de la surface entière.
@override@JsonKey() final  double perimeterGap;
/// Ne jamais finir sur un filet.
///
/// Quand la dernière bande tombe sous un demi-élément, on sacrifie une
/// bande pleine et on partage son épaisseur avec le reliquat entre la
/// première et la dernière, qui deviennent identiques.
///
/// ⚠️ Cela **coûte de la matière** : deux bandes de bord coupées au lieu
/// d'une, donc [LayoutResult.cutCount] et la perte montent. C'est un
/// arbitrage esthétique, pas une amélioration gratuite.
@override@JsonKey() final  bool balanceRows;
/// Pivote le motif d'un quart de tour : l'élément se pose le long de Y et
/// les rangées s'empilent selon X.
///
/// Le décalage des joints **suit** la rotation — c'est tout l'intérêt :
/// décaler les joints d'un bardage vertical n'a de sens que le long des
/// lames, pas en travers.
@override@JsonKey() final  bool flip;
@override@JsonKey() final  JointOffset offset;

/// Create a copy of LayoutInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LayoutInputCopyWith<_LayoutInput> get copyWith => __$LayoutInputCopyWithImpl<_LayoutInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LayoutInputToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LayoutInput&&(identical(other.surfaceX, surfaceX) || other.surfaceX == surfaceX)&&(identical(other.surfaceY, surfaceY) || other.surfaceY == surfaceY)&&(identical(other.elementX, elementX) || other.elementX == elementX)&&(identical(other.elementY, elementY) || other.elementY == elementY)&&(identical(other.gapX, gapX) || other.gapX == gapX)&&(identical(other.gapY, gapY) || other.gapY == gapY)&&(identical(other.perimeterGap, perimeterGap) || other.perimeterGap == perimeterGap)&&(identical(other.balanceRows, balanceRows) || other.balanceRows == balanceRows)&&(identical(other.flip, flip) || other.flip == flip)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,surfaceX,surfaceY,elementX,elementY,gapX,gapY,perimeterGap,balanceRows,flip,offset);
}

@override
String toString() {
    return 'LayoutInput(surfaceX: $surfaceX, surfaceY: $surfaceY, elementX: $elementX, elementY: $elementY, gapX: $gapX, gapY: $gapY, perimeterGap: $perimeterGap, balanceRows: $balanceRows, flip: $flip, offset: $offset)';
}


}

/// @nodoc
abstract mixin class _$LayoutInputCopyWith<$Res> implements $LayoutInputCopyWith<$Res> {
  factory _$LayoutInputCopyWith(_LayoutInput value, $Res Function(_LayoutInput) _then) = __$LayoutInputCopyWithImpl;
@override @useResult
$Res call({
 double surfaceX, double surfaceY, double elementX, double elementY, double gapX, double gapY, double perimeterGap, bool balanceRows, bool flip, JointOffset offset
});




}
/// @nodoc
class __$LayoutInputCopyWithImpl<$Res>
    implements _$LayoutInputCopyWith<$Res> {
  __$LayoutInputCopyWithImpl(this._self, this._then);

  final _LayoutInput _self;
  final $Res Function(_LayoutInput) _then;

/// Create a copy of LayoutInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surfaceX = null,Object? surfaceY = null,Object? elementX = null,Object? elementY = null,Object? gapX = null,Object? gapY = null,Object? perimeterGap = null,Object? balanceRows = null,Object? flip = null,Object? offset = null,}) {
  return _then(_LayoutInput(
surfaceX: null == surfaceX ? _self.surfaceX : surfaceX // ignore: cast_nullable_to_non_nullable
as double,surfaceY: null == surfaceY ? _self.surfaceY : surfaceY // ignore: cast_nullable_to_non_nullable
as double,elementX: null == elementX ? _self.elementX : elementX // ignore: cast_nullable_to_non_nullable
as double,elementY: null == elementY ? _self.elementY : elementY // ignore: cast_nullable_to_non_nullable
as double,gapX: null == gapX ? _self.gapX : gapX // ignore: cast_nullable_to_non_nullable
as double,gapY: null == gapY ? _self.gapY : gapY // ignore: cast_nullable_to_non_nullable
as double,perimeterGap: null == perimeterGap ? _self.perimeterGap : perimeterGap // ignore: cast_nullable_to_non_nullable
as double,balanceRows: null == balanceRows ? _self.balanceRows : balanceRows // ignore: cast_nullable_to_non_nullable
as bool,flip: null == flip ? _self.flip : flip // ignore: cast_nullable_to_non_nullable
as bool,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as JointOffset,
  ));
}


}

/// @nodoc
mixin _$PlacedElement {

/// Coin haut-gauche.
 double get x; double get y;/// Dimensions réellement posées (rognées si pièce de bord).
 double get w; double get h;/// Pièce partielle, à surligner comme une coupe.
 bool get isCut;
/// Create a copy of PlacedElement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlacedElementCopyWith<PlacedElement> get copyWith => _$PlacedElementCopyWithImpl<PlacedElement>(this as PlacedElement, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PlacedElement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlacedElement&&(identical(other.x, _this.x) || other.x == _this.x)&&(identical(other.y, _this.y) || other.y == _this.y)&&(identical(other.w, _this.w) || other.w == _this.w)&&(identical(other.h, _this.h) || other.h == _this.h)&&(identical(other.isCut, _this.isCut) || other.isCut == _this.isCut));
}


@override
int get hashCode {
  final _this = this as PlacedElement;
  return Object.hash(runtimeType,_this.x,_this.y,_this.w,_this.h,_this.isCut);
}

@override
String toString() {
  final _this = this as PlacedElement;
  return 'PlacedElement(x: ${_this.x}, y: ${_this.y}, w: ${_this.w}, h: ${_this.h}, isCut: ${_this.isCut})';
}


}

/// @nodoc
abstract mixin class $PlacedElementCopyWith<$Res>  {
  factory $PlacedElementCopyWith(PlacedElement value, $Res Function(PlacedElement) _then) = _$PlacedElementCopyWithImpl;
@useResult
$Res call({
 double x, double y, double w, double h, bool isCut
});




}
/// @nodoc
class _$PlacedElementCopyWithImpl<$Res>
    implements $PlacedElementCopyWith<$Res> {
  _$PlacedElementCopyWithImpl(this._self, this._then);

  final PlacedElement _self;
  final $Res Function(PlacedElement) _then;

/// Create a copy of PlacedElement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? isCut = null,}) {
  return _then(PlacedElement(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,isCut: null == isCut ? _self.isCut : isCut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlacedElement].
extension PlacedElementPatterns on PlacedElement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlacedElement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlacedElement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlacedElement value)  $default,){
final _that = this;
switch (_that) {
case _PlacedElement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlacedElement value)?  $default,){
final _that = this;
switch (_that) {
case _PlacedElement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double x,  double y,  double w,  double h,  bool isCut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlacedElement() when $default != null:
return $default(_that.x,_that.y,_that.w,_that.h,_that.isCut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double x,  double y,  double w,  double h,  bool isCut)  $default,) {final _that = this;
switch (_that) {
case _PlacedElement():
return $default(_that.x,_that.y,_that.w,_that.h,_that.isCut);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double x,  double y,  double w,  double h,  bool isCut)?  $default,) {final _that = this;
switch (_that) {
case _PlacedElement() when $default != null:
return $default(_that.x,_that.y,_that.w,_that.h,_that.isCut);case _:
  return null;

}
}

}

/// @nodoc


class _PlacedElement implements PlacedElement {
  const _PlacedElement({required this.x, required this.y, required this.w, required this.h, required this.isCut});
  

/// Coin haut-gauche.
@override final  double x;
@override final  double y;
/// Dimensions réellement posées (rognées si pièce de bord).
@override final  double w;
@override final  double h;
/// Pièce partielle, à surligner comme une coupe.
@override final  bool isCut;

/// Create a copy of PlacedElement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlacedElementCopyWith<_PlacedElement> get copyWith => __$PlacedElementCopyWithImpl<_PlacedElement>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlacedElement&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.w, w) || other.w == w)&&(identical(other.h, h) || other.h == h)&&(identical(other.isCut, isCut) || other.isCut == isCut));
}


@override
int get hashCode {
    return Object.hash(runtimeType,x,y,w,h,isCut);
}

@override
String toString() {
    return 'PlacedElement(x: $x, y: $y, w: $w, h: $h, isCut: $isCut)';
}


}

/// @nodoc
abstract mixin class _$PlacedElementCopyWith<$Res> implements $PlacedElementCopyWith<$Res> {
  factory _$PlacedElementCopyWith(_PlacedElement value, $Res Function(_PlacedElement) _then) = __$PlacedElementCopyWithImpl;
@override @useResult
$Res call({
 double x, double y, double w, double h, bool isCut
});




}
/// @nodoc
class __$PlacedElementCopyWithImpl<$Res>
    implements _$PlacedElementCopyWith<$Res> {
  __$PlacedElementCopyWithImpl(this._self, this._then);

  final _PlacedElement _self;
  final $Res Function(_PlacedElement) _then;

/// Create a copy of PlacedElement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x = null,Object? y = null,Object? w = null,Object? h = null,Object? isCut = null,}) {
  return _then(_PlacedElement(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,w: null == w ? _self.w : w // ignore: cast_nullable_to_non_nullable
as double,h: null == h ? _self.h : h // ignore: cast_nullable_to_non_nullable
as double,isCut: null == isCut ? _self.isCut : isCut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$LayoutResult {

 List<PlacedElement> get elements; int get fullCount; int get cutCount;/// `fullCount + cutCount` — stock sans réemploi des chutes.
 int get totalCount; double get surfaceArea; double get coveredArea; double get wastePercent;/// Épaisseur commune des deux rangées de bord, si l'équilibrage a joué.
///
/// Nul quand la règle ne s'est pas appliquée — c'est ce qui permet à
/// l'écran de ne montrer sa tuile que lorsqu'il y a quelque chose à dire.
 double? get balancedRow;/// Longueur commune des deux pièces de bout, si l'équilibrage a joué sur
/// l'axe de pose. Nul sous tout décalage autre que droit.
 double? get balancedEnd;
/// Create a copy of LayoutResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayoutResultCopyWith<LayoutResult> get copyWith => _$LayoutResultCopyWithImpl<LayoutResult>(this as LayoutResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LayoutResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayoutResult&&const DeepCollectionEquality().equals(other.elements, _this.elements)&&(identical(other.fullCount, _this.fullCount) || other.fullCount == _this.fullCount)&&(identical(other.cutCount, _this.cutCount) || other.cutCount == _this.cutCount)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount)&&(identical(other.surfaceArea, _this.surfaceArea) || other.surfaceArea == _this.surfaceArea)&&(identical(other.coveredArea, _this.coveredArea) || other.coveredArea == _this.coveredArea)&&(identical(other.wastePercent, _this.wastePercent) || other.wastePercent == _this.wastePercent)&&(identical(other.balancedRow, _this.balancedRow) || other.balancedRow == _this.balancedRow)&&(identical(other.balancedEnd, _this.balancedEnd) || other.balancedEnd == _this.balancedEnd));
}


@override
int get hashCode {
  final _this = this as LayoutResult;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.elements),_this.fullCount,_this.cutCount,_this.totalCount,_this.surfaceArea,_this.coveredArea,_this.wastePercent,_this.balancedRow,_this.balancedEnd);
}

@override
String toString() {
  final _this = this as LayoutResult;
  return 'LayoutResult(elements: ${_this.elements}, fullCount: ${_this.fullCount}, cutCount: ${_this.cutCount}, totalCount: ${_this.totalCount}, surfaceArea: ${_this.surfaceArea}, coveredArea: ${_this.coveredArea}, wastePercent: ${_this.wastePercent}, balancedRow: ${_this.balancedRow}, balancedEnd: ${_this.balancedEnd})';
}


}

/// @nodoc
abstract mixin class $LayoutResultCopyWith<$Res>  {
  factory $LayoutResultCopyWith(LayoutResult value, $Res Function(LayoutResult) _then) = _$LayoutResultCopyWithImpl;
@useResult
$Res call({
 List<PlacedElement> elements, int fullCount, int cutCount, int totalCount, double surfaceArea, double coveredArea, double wastePercent, double? balancedRow, double? balancedEnd
});




}
/// @nodoc
class _$LayoutResultCopyWithImpl<$Res>
    implements $LayoutResultCopyWith<$Res> {
  _$LayoutResultCopyWithImpl(this._self, this._then);

  final LayoutResult _self;
  final $Res Function(LayoutResult) _then;

/// Create a copy of LayoutResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? elements = null,Object? fullCount = null,Object? cutCount = null,Object? totalCount = null,Object? surfaceArea = null,Object? coveredArea = null,Object? wastePercent = null,Object? balancedRow = freezed,Object? balancedEnd = freezed,}) {
  return _then(LayoutResult(
elements: null == elements ? _self.elements : elements // ignore: cast_nullable_to_non_nullable
as List<PlacedElement>,fullCount: null == fullCount ? _self.fullCount : fullCount // ignore: cast_nullable_to_non_nullable
as int,cutCount: null == cutCount ? _self.cutCount : cutCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,surfaceArea: null == surfaceArea ? _self.surfaceArea : surfaceArea // ignore: cast_nullable_to_non_nullable
as double,coveredArea: null == coveredArea ? _self.coveredArea : coveredArea // ignore: cast_nullable_to_non_nullable
as double,wastePercent: null == wastePercent ? _self.wastePercent : wastePercent // ignore: cast_nullable_to_non_nullable
as double,balancedRow: freezed == balancedRow ? _self.balancedRow : balancedRow // ignore: cast_nullable_to_non_nullable
as double?,balancedEnd: freezed == balancedEnd ? _self.balancedEnd : balancedEnd // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [LayoutResult].
extension LayoutResultPatterns on LayoutResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LayoutResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LayoutResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LayoutResult value)  $default,){
final _that = this;
switch (_that) {
case _LayoutResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LayoutResult value)?  $default,){
final _that = this;
switch (_that) {
case _LayoutResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PlacedElement> elements,  int fullCount,  int cutCount,  int totalCount,  double surfaceArea,  double coveredArea,  double wastePercent,  double? balancedRow,  double? balancedEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LayoutResult() when $default != null:
return $default(_that.elements,_that.fullCount,_that.cutCount,_that.totalCount,_that.surfaceArea,_that.coveredArea,_that.wastePercent,_that.balancedRow,_that.balancedEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PlacedElement> elements,  int fullCount,  int cutCount,  int totalCount,  double surfaceArea,  double coveredArea,  double wastePercent,  double? balancedRow,  double? balancedEnd)  $default,) {final _that = this;
switch (_that) {
case _LayoutResult():
return $default(_that.elements,_that.fullCount,_that.cutCount,_that.totalCount,_that.surfaceArea,_that.coveredArea,_that.wastePercent,_that.balancedRow,_that.balancedEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PlacedElement> elements,  int fullCount,  int cutCount,  int totalCount,  double surfaceArea,  double coveredArea,  double wastePercent,  double? balancedRow,  double? balancedEnd)?  $default,) {final _that = this;
switch (_that) {
case _LayoutResult() when $default != null:
return $default(_that.elements,_that.fullCount,_that.cutCount,_that.totalCount,_that.surfaceArea,_that.coveredArea,_that.wastePercent,_that.balancedRow,_that.balancedEnd);case _:
  return null;

}
}

}

/// @nodoc


class _LayoutResult implements LayoutResult {
  const _LayoutResult({required  List<PlacedElement> elements, required this.fullCount, required this.cutCount, required this.totalCount, required this.surfaceArea, required this.coveredArea, required this.wastePercent, this.balancedRow, this.balancedEnd}): _elements = elements;
  

 final  List<PlacedElement> _elements;
@override List<PlacedElement> get elements {
  if (_elements is EqualUnmodifiableListView) return _elements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_elements);
}

@override final  int fullCount;
@override final  int cutCount;
/// `fullCount + cutCount` — stock sans réemploi des chutes.
@override final  int totalCount;
@override final  double surfaceArea;
@override final  double coveredArea;
@override final  double wastePercent;
/// Épaisseur commune des deux rangées de bord, si l'équilibrage a joué.
///
/// Nul quand la règle ne s'est pas appliquée — c'est ce qui permet à
/// l'écran de ne montrer sa tuile que lorsqu'il y a quelque chose à dire.
@override final  double? balancedRow;
/// Longueur commune des deux pièces de bout, si l'équilibrage a joué sur
/// l'axe de pose. Nul sous tout décalage autre que droit.
@override final  double? balancedEnd;

/// Create a copy of LayoutResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LayoutResultCopyWith<_LayoutResult> get copyWith => __$LayoutResultCopyWithImpl<_LayoutResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LayoutResult&&const DeepCollectionEquality().equals(other.elements, _elements)&&(identical(other.fullCount, fullCount) || other.fullCount == fullCount)&&(identical(other.cutCount, cutCount) || other.cutCount == cutCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.surfaceArea, surfaceArea) || other.surfaceArea == surfaceArea)&&(identical(other.coveredArea, coveredArea) || other.coveredArea == coveredArea)&&(identical(other.wastePercent, wastePercent) || other.wastePercent == wastePercent)&&(identical(other.balancedRow, balancedRow) || other.balancedRow == balancedRow)&&(identical(other.balancedEnd, balancedEnd) || other.balancedEnd == balancedEnd));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_elements),fullCount,cutCount,totalCount,surfaceArea,coveredArea,wastePercent,balancedRow,balancedEnd);
}

@override
String toString() {
    return 'LayoutResult(elements: $elements, fullCount: $fullCount, cutCount: $cutCount, totalCount: $totalCount, surfaceArea: $surfaceArea, coveredArea: $coveredArea, wastePercent: $wastePercent, balancedRow: $balancedRow, balancedEnd: $balancedEnd)';
}


}

/// @nodoc
abstract mixin class _$LayoutResultCopyWith<$Res> implements $LayoutResultCopyWith<$Res> {
  factory _$LayoutResultCopyWith(_LayoutResult value, $Res Function(_LayoutResult) _then) = __$LayoutResultCopyWithImpl;
@override @useResult
$Res call({
 List<PlacedElement> elements, int fullCount, int cutCount, int totalCount, double surfaceArea, double coveredArea, double wastePercent, double? balancedRow, double? balancedEnd
});




}
/// @nodoc
class __$LayoutResultCopyWithImpl<$Res>
    implements _$LayoutResultCopyWith<$Res> {
  __$LayoutResultCopyWithImpl(this._self, this._then);

  final _LayoutResult _self;
  final $Res Function(_LayoutResult) _then;

/// Create a copy of LayoutResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? elements = null,Object? fullCount = null,Object? cutCount = null,Object? totalCount = null,Object? surfaceArea = null,Object? coveredArea = null,Object? wastePercent = null,Object? balancedRow = freezed,Object? balancedEnd = freezed,}) {
  return _then(_LayoutResult(
elements: null == elements ? _self._elements : elements // ignore: cast_nullable_to_non_nullable
as List<PlacedElement>,fullCount: null == fullCount ? _self.fullCount : fullCount // ignore: cast_nullable_to_non_nullable
as int,cutCount: null == cutCount ? _self.cutCount : cutCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,surfaceArea: null == surfaceArea ? _self.surfaceArea : surfaceArea // ignore: cast_nullable_to_non_nullable
as double,coveredArea: null == coveredArea ? _self.coveredArea : coveredArea // ignore: cast_nullable_to_non_nullable
as double,wastePercent: null == wastePercent ? _self.wastePercent : wastePercent // ignore: cast_nullable_to_non_nullable
as double,balancedRow: freezed == balancedRow ? _self.balancedRow : balancedRow // ignore: cast_nullable_to_non_nullable
as double?,balancedEnd: freezed == balancedEnd ? _self.balancedEnd : balancedEnd // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
