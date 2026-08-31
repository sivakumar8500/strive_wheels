// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ride_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RideRequestModel {

@JsonKey(name: 'id') int? get id;@JsonKey(name: 'pickup_address') String? get pickupAddress;@JsonKey(name: 'drop_address') String? get dropAddress;@JsonKey(name: 'estimated_fare') double? get estimatedFare;@JsonKey(name: 'pickup_lat') double? get pickupLat;@JsonKey(name: 'pickup_lng') double? get pickupLng;@JsonKey(name: 'drop_lat') double? get dropLat;@JsonKey(name: 'drop_lng') double? get dropLng;
/// Create a copy of RideRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RideRequestModelCopyWith<RideRequestModel> get copyWith => _$RideRequestModelCopyWithImpl<RideRequestModel>(this as RideRequestModel, _$identity);

  /// Serializes this RideRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RideRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.pickupAddress, pickupAddress) || other.pickupAddress == pickupAddress)&&(identical(other.dropAddress, dropAddress) || other.dropAddress == dropAddress)&&(identical(other.estimatedFare, estimatedFare) || other.estimatedFare == estimatedFare)&&(identical(other.pickupLat, pickupLat) || other.pickupLat == pickupLat)&&(identical(other.pickupLng, pickupLng) || other.pickupLng == pickupLng)&&(identical(other.dropLat, dropLat) || other.dropLat == dropLat)&&(identical(other.dropLng, dropLng) || other.dropLng == dropLng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pickupAddress,dropAddress,estimatedFare,pickupLat,pickupLng,dropLat,dropLng);

@override
String toString() {
  return 'RideRequestModel(id: $id, pickupAddress: $pickupAddress, dropAddress: $dropAddress, estimatedFare: $estimatedFare, pickupLat: $pickupLat, pickupLng: $pickupLng, dropLat: $dropLat, dropLng: $dropLng)';
}


}

/// @nodoc
abstract mixin class $RideRequestModelCopyWith<$Res>  {
  factory $RideRequestModelCopyWith(RideRequestModel value, $Res Function(RideRequestModel) _then) = _$RideRequestModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int? id,@JsonKey(name: 'pickup_address') String? pickupAddress,@JsonKey(name: 'drop_address') String? dropAddress,@JsonKey(name: 'estimated_fare') double? estimatedFare,@JsonKey(name: 'pickup_lat') double? pickupLat,@JsonKey(name: 'pickup_lng') double? pickupLng,@JsonKey(name: 'drop_lat') double? dropLat,@JsonKey(name: 'drop_lng') double? dropLng
});




}
/// @nodoc
class _$RideRequestModelCopyWithImpl<$Res>
    implements $RideRequestModelCopyWith<$Res> {
  _$RideRequestModelCopyWithImpl(this._self, this._then);

  final RideRequestModel _self;
  final $Res Function(RideRequestModel) _then;

/// Create a copy of RideRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? pickupAddress = freezed,Object? dropAddress = freezed,Object? estimatedFare = freezed,Object? pickupLat = freezed,Object? pickupLng = freezed,Object? dropLat = freezed,Object? dropLng = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,pickupAddress: freezed == pickupAddress ? _self.pickupAddress : pickupAddress // ignore: cast_nullable_to_non_nullable
as String?,dropAddress: freezed == dropAddress ? _self.dropAddress : dropAddress // ignore: cast_nullable_to_non_nullable
as String?,estimatedFare: freezed == estimatedFare ? _self.estimatedFare : estimatedFare // ignore: cast_nullable_to_non_nullable
as double?,pickupLat: freezed == pickupLat ? _self.pickupLat : pickupLat // ignore: cast_nullable_to_non_nullable
as double?,pickupLng: freezed == pickupLng ? _self.pickupLng : pickupLng // ignore: cast_nullable_to_non_nullable
as double?,dropLat: freezed == dropLat ? _self.dropLat : dropLat // ignore: cast_nullable_to_non_nullable
as double?,dropLng: freezed == dropLng ? _self.dropLng : dropLng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [RideRequestModel].
extension RideRequestModelPatterns on RideRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RideRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RideRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RideRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _RideRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RideRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _RideRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int? id, @JsonKey(name: 'pickup_address')  String? pickupAddress, @JsonKey(name: 'drop_address')  String? dropAddress, @JsonKey(name: 'estimated_fare')  double? estimatedFare, @JsonKey(name: 'pickup_lat')  double? pickupLat, @JsonKey(name: 'pickup_lng')  double? pickupLng, @JsonKey(name: 'drop_lat')  double? dropLat, @JsonKey(name: 'drop_lng')  double? dropLng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RideRequestModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int? id, @JsonKey(name: 'pickup_address')  String? pickupAddress, @JsonKey(name: 'drop_address')  String? dropAddress, @JsonKey(name: 'estimated_fare')  double? estimatedFare, @JsonKey(name: 'pickup_lat')  double? pickupLat, @JsonKey(name: 'pickup_lng')  double? pickupLng, @JsonKey(name: 'drop_lat')  double? dropLat, @JsonKey(name: 'drop_lng')  double? dropLng)  $default,) {final _that = this;
switch (_that) {
case _RideRequestModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int? id, @JsonKey(name: 'pickup_address')  String? pickupAddress, @JsonKey(name: 'drop_address')  String? dropAddress, @JsonKey(name: 'estimated_fare')  double? estimatedFare, @JsonKey(name: 'pickup_lat')  double? pickupLat, @JsonKey(name: 'pickup_lng')  double? pickupLng, @JsonKey(name: 'drop_lat')  double? dropLat, @JsonKey(name: 'drop_lng')  double? dropLng)?  $default,) {final _that = this;
switch (_that) {
case _RideRequestModel() when $default != null:
return $default(_that.id,_that.pickupAddress,_that.dropAddress,_that.estimatedFare,_that.pickupLat,_that.pickupLng,_that.dropLat,_that.dropLng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RideRequestModel extends RideRequestModel {
  const _RideRequestModel({@JsonKey(name: 'id') this.id, @JsonKey(name: 'pickup_address') this.pickupAddress, @JsonKey(name: 'drop_address') this.dropAddress, @JsonKey(name: 'estimated_fare') this.estimatedFare, @JsonKey(name: 'pickup_lat') this.pickupLat, @JsonKey(name: 'pickup_lng') this.pickupLng, @JsonKey(name: 'drop_lat') this.dropLat, @JsonKey(name: 'drop_lng') this.dropLng}): super._();
  factory _RideRequestModel.fromJson(Map<String, dynamic> json) => _$RideRequestModelFromJson(json);

@override@JsonKey(name: 'id') final  int? id;
@override@JsonKey(name: 'pickup_address') final  String? pickupAddress;
@override@JsonKey(name: 'drop_address') final  String? dropAddress;
@override@JsonKey(name: 'estimated_fare') final  double? estimatedFare;
@override@JsonKey(name: 'pickup_lat') final  double? pickupLat;
@override@JsonKey(name: 'pickup_lng') final  double? pickupLng;
@override@JsonKey(name: 'drop_lat') final  double? dropLat;
@override@JsonKey(name: 'drop_lng') final  double? dropLng;

/// Create a copy of RideRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RideRequestModelCopyWith<_RideRequestModel> get copyWith => __$RideRequestModelCopyWithImpl<_RideRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RideRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RideRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.pickupAddress, pickupAddress) || other.pickupAddress == pickupAddress)&&(identical(other.dropAddress, dropAddress) || other.dropAddress == dropAddress)&&(identical(other.estimatedFare, estimatedFare) || other.estimatedFare == estimatedFare)&&(identical(other.pickupLat, pickupLat) || other.pickupLat == pickupLat)&&(identical(other.pickupLng, pickupLng) || other.pickupLng == pickupLng)&&(identical(other.dropLat, dropLat) || other.dropLat == dropLat)&&(identical(other.dropLng, dropLng) || other.dropLng == dropLng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pickupAddress,dropAddress,estimatedFare,pickupLat,pickupLng,dropLat,dropLng);

@override
String toString() {
  return 'RideRequestModel(id: $id, pickupAddress: $pickupAddress, dropAddress: $dropAddress, estimatedFare: $estimatedFare, pickupLat: $pickupLat, pickupLng: $pickupLng, dropLat: $dropLat, dropLng: $dropLng)';
}


}

/// @nodoc
abstract mixin class _$RideRequestModelCopyWith<$Res> implements $RideRequestModelCopyWith<$Res> {
  factory _$RideRequestModelCopyWith(_RideRequestModel value, $Res Function(_RideRequestModel) _then) = __$RideRequestModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int? id,@JsonKey(name: 'pickup_address') String? pickupAddress,@JsonKey(name: 'drop_address') String? dropAddress,@JsonKey(name: 'estimated_fare') double? estimatedFare,@JsonKey(name: 'pickup_lat') double? pickupLat,@JsonKey(name: 'pickup_lng') double? pickupLng,@JsonKey(name: 'drop_lat') double? dropLat,@JsonKey(name: 'drop_lng') double? dropLng
});




}
/// @nodoc
class __$RideRequestModelCopyWithImpl<$Res>
    implements _$RideRequestModelCopyWith<$Res> {
  __$RideRequestModelCopyWithImpl(this._self, this._then);

  final _RideRequestModel _self;
  final $Res Function(_RideRequestModel) _then;

/// Create a copy of RideRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? pickupAddress = freezed,Object? dropAddress = freezed,Object? estimatedFare = freezed,Object? pickupLat = freezed,Object? pickupLng = freezed,Object? dropLat = freezed,Object? dropLng = freezed,}) {
  return _then(_RideRequestModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,pickupAddress: freezed == pickupAddress ? _self.pickupAddress : pickupAddress // ignore: cast_nullable_to_non_nullable
as String?,dropAddress: freezed == dropAddress ? _self.dropAddress : dropAddress // ignore: cast_nullable_to_non_nullable
as String?,estimatedFare: freezed == estimatedFare ? _self.estimatedFare : estimatedFare // ignore: cast_nullable_to_non_nullable
as double?,pickupLat: freezed == pickupLat ? _self.pickupLat : pickupLat // ignore: cast_nullable_to_non_nullable
as double?,pickupLng: freezed == pickupLng ? _self.pickupLng : pickupLng // ignore: cast_nullable_to_non_nullable
as double?,dropLat: freezed == dropLat ? _self.dropLat : dropLat // ignore: cast_nullable_to_non_nullable
as double?,dropLng: freezed == dropLng ? _self.dropLng : dropLng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
