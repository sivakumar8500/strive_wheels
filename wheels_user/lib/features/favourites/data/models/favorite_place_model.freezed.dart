// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_place_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FavoritePlaceModel {

@JsonKey(readValue: _readId) int get id;@JsonKey(defaultValue: 'Unknown') String get title;@JsonKey(defaultValue: '') String get address; double? get latitude; double? get longitude;
/// Create a copy of FavoritePlaceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoritePlaceModelCopyWith<FavoritePlaceModel> get copyWith => _$FavoritePlaceModelCopyWithImpl<FavoritePlaceModel>(this as FavoritePlaceModel, _$identity);

  /// Serializes this FavoritePlaceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritePlaceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,address,latitude,longitude);

@override
String toString() {
  return 'FavoritePlaceModel(id: $id, title: $title, address: $address, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $FavoritePlaceModelCopyWith<$Res>  {
  factory $FavoritePlaceModelCopyWith(FavoritePlaceModel value, $Res Function(FavoritePlaceModel) _then) = _$FavoritePlaceModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: _readId) int id,@JsonKey(defaultValue: 'Unknown') String title,@JsonKey(defaultValue: '') String address, double? latitude, double? longitude
});




}
/// @nodoc
class _$FavoritePlaceModelCopyWithImpl<$Res>
    implements $FavoritePlaceModelCopyWith<$Res> {
  _$FavoritePlaceModelCopyWithImpl(this._self, this._then);

  final FavoritePlaceModel _self;
  final $Res Function(FavoritePlaceModel) _then;

/// Create a copy of FavoritePlaceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? address = null,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoritePlaceModel].
extension FavoritePlaceModelPatterns on FavoritePlaceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoritePlaceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoritePlaceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoritePlaceModel value)  $default,){
final _that = this;
switch (_that) {
case _FavoritePlaceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoritePlaceModel value)?  $default,){
final _that = this;
switch (_that) {
case _FavoritePlaceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: _readId)  int id, @JsonKey(defaultValue: 'Unknown')  String title, @JsonKey(defaultValue: '')  String address,  double? latitude,  double? longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoritePlaceModel() when $default != null:
return $default(_that.id,_that.title,_that.address,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: _readId)  int id, @JsonKey(defaultValue: 'Unknown')  String title, @JsonKey(defaultValue: '')  String address,  double? latitude,  double? longitude)  $default,) {final _that = this;
switch (_that) {
case _FavoritePlaceModel():
return $default(_that.id,_that.title,_that.address,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: _readId)  int id, @JsonKey(defaultValue: 'Unknown')  String title, @JsonKey(defaultValue: '')  String address,  double? latitude,  double? longitude)?  $default,) {final _that = this;
switch (_that) {
case _FavoritePlaceModel() when $default != null:
return $default(_that.id,_that.title,_that.address,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FavoritePlaceModel implements FavoritePlaceModel {
  const _FavoritePlaceModel({@JsonKey(readValue: _readId) required this.id, @JsonKey(defaultValue: 'Unknown') required this.title, @JsonKey(defaultValue: '') required this.address, this.latitude, this.longitude});
  factory _FavoritePlaceModel.fromJson(Map<String, dynamic> json) => _$FavoritePlaceModelFromJson(json);

@override@JsonKey(readValue: _readId) final  int id;
@override@JsonKey(defaultValue: 'Unknown') final  String title;
@override@JsonKey(defaultValue: '') final  String address;
@override final  double? latitude;
@override final  double? longitude;

/// Create a copy of FavoritePlaceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoritePlaceModelCopyWith<_FavoritePlaceModel> get copyWith => __$FavoritePlaceModelCopyWithImpl<_FavoritePlaceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoritePlaceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoritePlaceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,address,latitude,longitude);

@override
String toString() {
  return 'FavoritePlaceModel(id: $id, title: $title, address: $address, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$FavoritePlaceModelCopyWith<$Res> implements $FavoritePlaceModelCopyWith<$Res> {
  factory _$FavoritePlaceModelCopyWith(_FavoritePlaceModel value, $Res Function(_FavoritePlaceModel) _then) = __$FavoritePlaceModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: _readId) int id,@JsonKey(defaultValue: 'Unknown') String title,@JsonKey(defaultValue: '') String address, double? latitude, double? longitude
});




}
/// @nodoc
class __$FavoritePlaceModelCopyWithImpl<$Res>
    implements _$FavoritePlaceModelCopyWith<$Res> {
  __$FavoritePlaceModelCopyWithImpl(this._self, this._then);

  final _FavoritePlaceModel _self;
  final $Res Function(_FavoritePlaceModel) _then;

/// Create a copy of FavoritePlaceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? address = null,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_FavoritePlaceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
