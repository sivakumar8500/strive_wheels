// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ride_request_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RideRequestEntity {

 int get id; String get pickupAddress; String get dropAddress; double get estimatedFare; double get pickupLat; double get pickupLng; double get dropLat; double get dropLng;
/// Create a copy of RideRequestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RideRequestEntityCopyWith<RideRequestEntity> get copyWith => _$RideRequestEntityCopyWithImpl<RideRequestEntity>(this as RideRequestEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RideRequestEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.pickupAddress, pickupAddress) || other.pickupAddress == pickupAddress)&&(identical(other.dropAddress, dropAddress) || other.dropAddress == dropAddress)&&(identical(other.estimatedFare, estimatedFare) || other.estimatedFare == estimatedFare)&&(identical(other.pickupLat, pickupLat) || other.pickupLat == pickupLat)&&(identical(other.pickupLng, pickupLng) || other.pickupLng == pickupLng)&&(identical(other.dropLat, dropLat) || other.dropLat == dropLat)&&(identical(other.dropLng, dropLng) || other.dropLng == dropLng));
}


@override
int get hashCode => Object.hash(runtimeType,id,pickupAddress,dropAddress,estimatedFare,pickupLat,pickupLng,dropLat,dropLng);

@override
String toString() {
  return 'RideRequestEntity(id: $id, pickupAddress: $pickupAddress, dropAddress: $dropAddress, estimatedFare: $estimatedFare, pickupLat: $pickupLat, pickupLng: $pickupLng, dropLat: $dropLat, dropLng: $dropLng)';
}


}

/// @nodoc
abstract mixin class $RideRequestEntityCopyWith<$Res>  {
  factory $RideRequestEntityCopyWith(RideRequestEntity value, $Res Function(RideRequestEntity) _then) = _$RideRequestEntityCopyWithImpl;
@useResult
$Res call({
 int id, String pickupAddress, String dropAddress, double estimatedFare, double pickupLat, double pickupLng, double dropLat, double dropLng
});




}
/// @nodoc
class _$RideRequestEntityCopyWithImpl<$Res>
    implements $RideRequestEntityCopyWith<$Res> {
  _$RideRequestEntityCopyWithImpl(this._self, this._then);

  final RideRequestEntity _self;
  final $Res Function(RideRequestEntity) _then;

/// Create a copy of RideRequestEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pickupAddress = null,Object? dropAddress = null,Object? estimatedFare = null,Object? pickupLat = null,Object? pickupLng = null,Object? dropLat = null,Object? dropLng = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,pickupAddress: null == pickupAddress ? _self.pickupAddress : pickupAddress // ignore: cast_nullable_to_non_nullable
as String,dropAddress: null == dropAddress ? _self.dropAddress : dropAddress // ignore: cast_nullable_to_non_nullable
as String,estimatedFare: null == estimatedFare ? _self.estimatedFare : estimatedFare // ignore: cast_nullable_to_non_nullable
as double,pickupLat: null == pickupLat ? _self.pickupLat : pickupLat // ignore: cast_nullable_to_non_nullable
as double,pickupLng: null == pickupLng ? _self.pickupLng : pickupLng // ignore: cast_nullable_to_non_nullable
as double,dropLat: null == dropLat ? _self.dropLat : dropLat // ignore: cast_nullable_to_non_nullable
as double,dropLng: null == dropLng ? _self.dropLng : dropLng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RideRequestEntity].
extension RideRequestEntityPatterns on RideRequestEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RideRequestEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RideRequestEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RideRequestEntity value)  $default,){
final _that = this;
switch (_that) {
case _RideRequestEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RideRequestEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RideRequestEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String pickupAddress,  String dropAddress,  double estimatedFare,  double pickupLat,  double pickupLng,  double dropLat,  double dropLng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RideRequestEntity() when $default != null:
return $default(_that.id,_that.pickupAddress,_that.dropAddress,_that.estimatedFare,_that.pickupLat,_that.pickupLng,_that.dropLat,_that.dropLng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String pickupAddress,  String dropAddress,  double estimatedFare,  double pickupLat,  double pickupLng,  double dropLat,  double dropLng)  $default,) {final _that = this;
switch (_that) {
case _RideRequestEntity():
return $default(_that.id,_that.pickupAddress,_that.dropAddress,_that.estimatedFare,_that.pickupLat,_that.pickupLng,_that.dropLat,_that.dropLng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String pickupAddress,  String dropAddress,  double estimatedFare,  double pickupLat,  double pickupLng,  double dropLat,  double dropLng)?  $default,) {final _that = this;
switch (_that) {
case _RideRequestEntity() when $default != null:
return $default(_that.id,_that.pickupAddress,_that.dropAddress,_that.estimatedFare,_that.pickupLat,_that.pickupLng,_that.dropLat,_that.dropLng);case _:
  return null;

}
}

}

/// @nodoc


class _RideRequestEntity implements RideRequestEntity {
  const _RideRequestEntity({required this.id, required this.pickupAddress, required this.dropAddress, required this.estimatedFare, required this.pickupLat, required this.pickupLng, required this.dropLat, required this.dropLng});
  

@override final  int id;
@override final  String pickupAddress;
@override final  String dropAddress;
@override final  double estimatedFare;
@override final  double pickupLat;
@override final  double pickupLng;
@override final  double dropLat;
@override final  double dropLng;

/// Create a copy of RideRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RideRequestEntityCopyWith<_RideRequestEntity> get copyWith => __$RideRequestEntityCopyWithImpl<_RideRequestEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RideRequestEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.pickupAddress, pickupAddress) || other.pickupAddress == pickupAddress)&&(identical(other.dropAddress, dropAddress) || other.dropAddress == dropAddress)&&(identical(other.estimatedFare, estimatedFare) || other.estimatedFare == estimatedFare)&&(identical(other.pickupLat, pickupLat) || other.pickupLat == pickupLat)&&(identical(other.pickupLng, pickupLng) || other.pickupLng == pickupLng)&&(identical(other.dropLat, dropLat) || other.dropLat == dropLat)&&(identical(other.dropLng, dropLng) || other.dropLng == dropLng));
}


@override
int get hashCode => Object.hash(runtimeType,id,pickupAddress,dropAddress,estimatedFare,pickupLat,pickupLng,dropLat,dropLng);

@override
String toString() {
  return 'RideRequestEntity(id: $id, pickupAddress: $pickupAddress, dropAddress: $dropAddress, estimatedFare: $estimatedFare, pickupLat: $pickupLat, pickupLng: $pickupLng, dropLat: $dropLat, dropLng: $dropLng)';
}


}

/// @nodoc
abstract mixin class _$RideRequestEntityCopyWith<$Res> implements $RideRequestEntityCopyWith<$Res> {
  factory _$RideRequestEntityCopyWith(_RideRequestEntity value, $Res Function(_RideRequestEntity) _then) = __$RideRequestEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String pickupAddress, String dropAddress, double estimatedFare, double pickupLat, double pickupLng, double dropLat, double dropLng
});




}
/// @nodoc
class __$RideRequestEntityCopyWithImpl<$Res>
    implements _$RideRequestEntityCopyWith<$Res> {
  __$RideRequestEntityCopyWithImpl(this._self, this._then);

  final _RideRequestEntity _self;
  final $Res Function(_RideRequestEntity) _then;

/// Create a copy of RideRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pickupAddress = null,Object? dropAddress = null,Object? estimatedFare = null,Object? pickupLat = null,Object? pickupLng = null,Object? dropLat = null,Object? dropLng = null,}) {
  return _then(_RideRequestEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,pickupAddress: null == pickupAddress ? _self.pickupAddress : pickupAddress // ignore: cast_nullable_to_non_nullable
as String,dropAddress: null == dropAddress ? _self.dropAddress : dropAddress // ignore: cast_nullable_to_non_nullable
as String,estimatedFare: null == estimatedFare ? _self.estimatedFare : estimatedFare // ignore: cast_nullable_to_non_nullable
as double,pickupLat: null == pickupLat ? _self.pickupLat : pickupLat // ignore: cast_nullable_to_non_nullable
as double,pickupLng: null == pickupLng ? _self.pickupLng : pickupLng // ignore: cast_nullable_to_non_nullable
as double,dropLat: null == dropLat ? _self.dropLat : dropLat // ignore: cast_nullable_to_non_nullable
as double,dropLng: null == dropLng ? _self.dropLng : dropLng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
