// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favourites_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FavouritesModel {

 String get shortcutTitle; String get shortcutSubtitle; List<FavoritePlaceModel> get places;
/// Create a copy of FavouritesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavouritesModelCopyWith<FavouritesModel> get copyWith => _$FavouritesModelCopyWithImpl<FavouritesModel>(this as FavouritesModel, _$identity);

  /// Serializes this FavouritesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavouritesModel&&(identical(other.shortcutTitle, shortcutTitle) || other.shortcutTitle == shortcutTitle)&&(identical(other.shortcutSubtitle, shortcutSubtitle) || other.shortcutSubtitle == shortcutSubtitle)&&const DeepCollectionEquality().equals(other.places, places));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shortcutTitle,shortcutSubtitle,const DeepCollectionEquality().hash(places));

@override
String toString() {
  return 'FavouritesModel(shortcutTitle: $shortcutTitle, shortcutSubtitle: $shortcutSubtitle, places: $places)';
}


}

/// @nodoc
abstract mixin class $FavouritesModelCopyWith<$Res>  {
  factory $FavouritesModelCopyWith(FavouritesModel value, $Res Function(FavouritesModel) _then) = _$FavouritesModelCopyWithImpl;
@useResult
$Res call({
 String shortcutTitle, String shortcutSubtitle, List<FavoritePlaceModel> places
});




}
/// @nodoc
class _$FavouritesModelCopyWithImpl<$Res>
    implements $FavouritesModelCopyWith<$Res> {
  _$FavouritesModelCopyWithImpl(this._self, this._then);

  final FavouritesModel _self;
  final $Res Function(FavouritesModel) _then;

/// Create a copy of FavouritesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shortcutTitle = null,Object? shortcutSubtitle = null,Object? places = null,}) {
  return _then(_self.copyWith(
shortcutTitle: null == shortcutTitle ? _self.shortcutTitle : shortcutTitle // ignore: cast_nullable_to_non_nullable
as String,shortcutSubtitle: null == shortcutSubtitle ? _self.shortcutSubtitle : shortcutSubtitle // ignore: cast_nullable_to_non_nullable
as String,places: null == places ? _self.places : places // ignore: cast_nullable_to_non_nullable
as List<FavoritePlaceModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [FavouritesModel].
extension FavouritesModelPatterns on FavouritesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavouritesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavouritesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavouritesModel value)  $default,){
final _that = this;
switch (_that) {
case _FavouritesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavouritesModel value)?  $default,){
final _that = this;
switch (_that) {
case _FavouritesModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String shortcutTitle,  String shortcutSubtitle,  List<FavoritePlaceModel> places)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavouritesModel() when $default != null:
return $default(_that.shortcutTitle,_that.shortcutSubtitle,_that.places);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String shortcutTitle,  String shortcutSubtitle,  List<FavoritePlaceModel> places)  $default,) {final _that = this;
switch (_that) {
case _FavouritesModel():
return $default(_that.shortcutTitle,_that.shortcutSubtitle,_that.places);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String shortcutTitle,  String shortcutSubtitle,  List<FavoritePlaceModel> places)?  $default,) {final _that = this;
switch (_that) {
case _FavouritesModel() when $default != null:
return $default(_that.shortcutTitle,_that.shortcutSubtitle,_that.places);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FavouritesModel implements FavouritesModel {
  const _FavouritesModel({required this.shortcutTitle, required this.shortcutSubtitle, required final  List<FavoritePlaceModel> places}): _places = places;
  factory _FavouritesModel.fromJson(Map<String, dynamic> json) => _$FavouritesModelFromJson(json);

@override final  String shortcutTitle;
@override final  String shortcutSubtitle;
 final  List<FavoritePlaceModel> _places;
@override List<FavoritePlaceModel> get places {
  if (_places is EqualUnmodifiableListView) return _places;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_places);
}


/// Create a copy of FavouritesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavouritesModelCopyWith<_FavouritesModel> get copyWith => __$FavouritesModelCopyWithImpl<_FavouritesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavouritesModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavouritesModel&&(identical(other.shortcutTitle, shortcutTitle) || other.shortcutTitle == shortcutTitle)&&(identical(other.shortcutSubtitle, shortcutSubtitle) || other.shortcutSubtitle == shortcutSubtitle)&&const DeepCollectionEquality().equals(other._places, _places));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shortcutTitle,shortcutSubtitle,const DeepCollectionEquality().hash(_places));

@override
String toString() {
  return 'FavouritesModel(shortcutTitle: $shortcutTitle, shortcutSubtitle: $shortcutSubtitle, places: $places)';
}


}

/// @nodoc
abstract mixin class _$FavouritesModelCopyWith<$Res> implements $FavouritesModelCopyWith<$Res> {
  factory _$FavouritesModelCopyWith(_FavouritesModel value, $Res Function(_FavouritesModel) _then) = __$FavouritesModelCopyWithImpl;
@override @useResult
$Res call({
 String shortcutTitle, String shortcutSubtitle, List<FavoritePlaceModel> places
});




}
/// @nodoc
class __$FavouritesModelCopyWithImpl<$Res>
    implements _$FavouritesModelCopyWith<$Res> {
  __$FavouritesModelCopyWithImpl(this._self, this._then);

  final _FavouritesModel _self;
  final $Res Function(_FavouritesModel) _then;

/// Create a copy of FavouritesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shortcutTitle = null,Object? shortcutSubtitle = null,Object? places = null,}) {
  return _then(_FavouritesModel(
shortcutTitle: null == shortcutTitle ? _self.shortcutTitle : shortcutTitle // ignore: cast_nullable_to_non_nullable
as String,shortcutSubtitle: null == shortcutSubtitle ? _self.shortcutSubtitle : shortcutSubtitle // ignore: cast_nullable_to_non_nullable
as String,places: null == places ? _self._places : places // ignore: cast_nullable_to_non_nullable
as List<FavoritePlaceModel>,
  ));
}


}

// dart format on
