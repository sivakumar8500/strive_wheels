// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VehicleDetailsModel {

 String get id; String get vehicleName; String get operatorName; bool get isEcoFriendly; bool get isTopRated; String get capacity; String get luggage; String get amenities; String get climate; String get driverName; String get driverRating; String get driverTrips; String get driverBio; String get estimatedDuration; String get pickupLocation; String get dropoffLocation; String get price; String get imagePath;
/// Create a copy of VehicleDetailsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleDetailsModelCopyWith<VehicleDetailsModel> get copyWith => _$VehicleDetailsModelCopyWithImpl<VehicleDetailsModel>(this as VehicleDetailsModel, _$identity);

  /// Serializes this VehicleDetailsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleDetailsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleName, vehicleName) || other.vehicleName == vehicleName)&&(identical(other.operatorName, operatorName) || other.operatorName == operatorName)&&(identical(other.isEcoFriendly, isEcoFriendly) || other.isEcoFriendly == isEcoFriendly)&&(identical(other.isTopRated, isTopRated) || other.isTopRated == isTopRated)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.luggage, luggage) || other.luggage == luggage)&&(identical(other.amenities, amenities) || other.amenities == amenities)&&(identical(other.climate, climate) || other.climate == climate)&&(identical(other.driverName, driverName) || other.driverName == driverName)&&(identical(other.driverRating, driverRating) || other.driverRating == driverRating)&&(identical(other.driverTrips, driverTrips) || other.driverTrips == driverTrips)&&(identical(other.driverBio, driverBio) || other.driverBio == driverBio)&&(identical(other.estimatedDuration, estimatedDuration) || other.estimatedDuration == estimatedDuration)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.dropoffLocation, dropoffLocation) || other.dropoffLocation == dropoffLocation)&&(identical(other.price, price) || other.price == price)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vehicleName,operatorName,isEcoFriendly,isTopRated,capacity,luggage,amenities,climate,driverName,driverRating,driverTrips,driverBio,estimatedDuration,pickupLocation,dropoffLocation,price,imagePath);

@override
String toString() {
  return 'VehicleDetailsModel(id: $id, vehicleName: $vehicleName, operatorName: $operatorName, isEcoFriendly: $isEcoFriendly, isTopRated: $isTopRated, capacity: $capacity, luggage: $luggage, amenities: $amenities, climate: $climate, driverName: $driverName, driverRating: $driverRating, driverTrips: $driverTrips, driverBio: $driverBio, estimatedDuration: $estimatedDuration, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, price: $price, imagePath: $imagePath)';
}


}

/// @nodoc
abstract mixin class $VehicleDetailsModelCopyWith<$Res>  {
  factory $VehicleDetailsModelCopyWith(VehicleDetailsModel value, $Res Function(VehicleDetailsModel) _then) = _$VehicleDetailsModelCopyWithImpl;
@useResult
$Res call({
 String id, String vehicleName, String operatorName, bool isEcoFriendly, bool isTopRated, String capacity, String luggage, String amenities, String climate, String driverName, String driverRating, String driverTrips, String driverBio, String estimatedDuration, String pickupLocation, String dropoffLocation, String price, String imagePath
});




}
/// @nodoc
class _$VehicleDetailsModelCopyWithImpl<$Res>
    implements $VehicleDetailsModelCopyWith<$Res> {
  _$VehicleDetailsModelCopyWithImpl(this._self, this._then);

  final VehicleDetailsModel _self;
  final $Res Function(VehicleDetailsModel) _then;

/// Create a copy of VehicleDetailsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vehicleName = null,Object? operatorName = null,Object? isEcoFriendly = null,Object? isTopRated = null,Object? capacity = null,Object? luggage = null,Object? amenities = null,Object? climate = null,Object? driverName = null,Object? driverRating = null,Object? driverTrips = null,Object? driverBio = null,Object? estimatedDuration = null,Object? pickupLocation = null,Object? dropoffLocation = null,Object? price = null,Object? imagePath = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vehicleName: null == vehicleName ? _self.vehicleName : vehicleName // ignore: cast_nullable_to_non_nullable
as String,operatorName: null == operatorName ? _self.operatorName : operatorName // ignore: cast_nullable_to_non_nullable
as String,isEcoFriendly: null == isEcoFriendly ? _self.isEcoFriendly : isEcoFriendly // ignore: cast_nullable_to_non_nullable
as bool,isTopRated: null == isTopRated ? _self.isTopRated : isTopRated // ignore: cast_nullable_to_non_nullable
as bool,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as String,luggage: null == luggage ? _self.luggage : luggage // ignore: cast_nullable_to_non_nullable
as String,amenities: null == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as String,climate: null == climate ? _self.climate : climate // ignore: cast_nullable_to_non_nullable
as String,driverName: null == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String,driverRating: null == driverRating ? _self.driverRating : driverRating // ignore: cast_nullable_to_non_nullable
as String,driverTrips: null == driverTrips ? _self.driverTrips : driverTrips // ignore: cast_nullable_to_non_nullable
as String,driverBio: null == driverBio ? _self.driverBio : driverBio // ignore: cast_nullable_to_non_nullable
as String,estimatedDuration: null == estimatedDuration ? _self.estimatedDuration : estimatedDuration // ignore: cast_nullable_to_non_nullable
as String,pickupLocation: null == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String,dropoffLocation: null == dropoffLocation ? _self.dropoffLocation : dropoffLocation // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VehicleDetailsModel].
extension VehicleDetailsModelPatterns on VehicleDetailsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleDetailsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleDetailsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleDetailsModel value)  $default,){
final _that = this;
switch (_that) {
case _VehicleDetailsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleDetailsModel value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleDetailsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String vehicleName,  String operatorName,  bool isEcoFriendly,  bool isTopRated,  String capacity,  String luggage,  String amenities,  String climate,  String driverName,  String driverRating,  String driverTrips,  String driverBio,  String estimatedDuration,  String pickupLocation,  String dropoffLocation,  String price,  String imagePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleDetailsModel() when $default != null:
return $default(_that.id,_that.vehicleName,_that.operatorName,_that.isEcoFriendly,_that.isTopRated,_that.capacity,_that.luggage,_that.amenities,_that.climate,_that.driverName,_that.driverRating,_that.driverTrips,_that.driverBio,_that.estimatedDuration,_that.pickupLocation,_that.dropoffLocation,_that.price,_that.imagePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String vehicleName,  String operatorName,  bool isEcoFriendly,  bool isTopRated,  String capacity,  String luggage,  String amenities,  String climate,  String driverName,  String driverRating,  String driverTrips,  String driverBio,  String estimatedDuration,  String pickupLocation,  String dropoffLocation,  String price,  String imagePath)  $default,) {final _that = this;
switch (_that) {
case _VehicleDetailsModel():
return $default(_that.id,_that.vehicleName,_that.operatorName,_that.isEcoFriendly,_that.isTopRated,_that.capacity,_that.luggage,_that.amenities,_that.climate,_that.driverName,_that.driverRating,_that.driverTrips,_that.driverBio,_that.estimatedDuration,_that.pickupLocation,_that.dropoffLocation,_that.price,_that.imagePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String vehicleName,  String operatorName,  bool isEcoFriendly,  bool isTopRated,  String capacity,  String luggage,  String amenities,  String climate,  String driverName,  String driverRating,  String driverTrips,  String driverBio,  String estimatedDuration,  String pickupLocation,  String dropoffLocation,  String price,  String imagePath)?  $default,) {final _that = this;
switch (_that) {
case _VehicleDetailsModel() when $default != null:
return $default(_that.id,_that.vehicleName,_that.operatorName,_that.isEcoFriendly,_that.isTopRated,_that.capacity,_that.luggage,_that.amenities,_that.climate,_that.driverName,_that.driverRating,_that.driverTrips,_that.driverBio,_that.estimatedDuration,_that.pickupLocation,_that.dropoffLocation,_that.price,_that.imagePath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VehicleDetailsModel implements VehicleDetailsModel {
  const _VehicleDetailsModel({required this.id, required this.vehicleName, required this.operatorName, required this.isEcoFriendly, required this.isTopRated, required this.capacity, required this.luggage, required this.amenities, required this.climate, required this.driverName, required this.driverRating, required this.driverTrips, required this.driverBio, required this.estimatedDuration, required this.pickupLocation, required this.dropoffLocation, required this.price, required this.imagePath});
  factory _VehicleDetailsModel.fromJson(Map<String, dynamic> json) => _$VehicleDetailsModelFromJson(json);

@override final  String id;
@override final  String vehicleName;
@override final  String operatorName;
@override final  bool isEcoFriendly;
@override final  bool isTopRated;
@override final  String capacity;
@override final  String luggage;
@override final  String amenities;
@override final  String climate;
@override final  String driverName;
@override final  String driverRating;
@override final  String driverTrips;
@override final  String driverBio;
@override final  String estimatedDuration;
@override final  String pickupLocation;
@override final  String dropoffLocation;
@override final  String price;
@override final  String imagePath;

/// Create a copy of VehicleDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleDetailsModelCopyWith<_VehicleDetailsModel> get copyWith => __$VehicleDetailsModelCopyWithImpl<_VehicleDetailsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleDetailsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleDetailsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleName, vehicleName) || other.vehicleName == vehicleName)&&(identical(other.operatorName, operatorName) || other.operatorName == operatorName)&&(identical(other.isEcoFriendly, isEcoFriendly) || other.isEcoFriendly == isEcoFriendly)&&(identical(other.isTopRated, isTopRated) || other.isTopRated == isTopRated)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.luggage, luggage) || other.luggage == luggage)&&(identical(other.amenities, amenities) || other.amenities == amenities)&&(identical(other.climate, climate) || other.climate == climate)&&(identical(other.driverName, driverName) || other.driverName == driverName)&&(identical(other.driverRating, driverRating) || other.driverRating == driverRating)&&(identical(other.driverTrips, driverTrips) || other.driverTrips == driverTrips)&&(identical(other.driverBio, driverBio) || other.driverBio == driverBio)&&(identical(other.estimatedDuration, estimatedDuration) || other.estimatedDuration == estimatedDuration)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.dropoffLocation, dropoffLocation) || other.dropoffLocation == dropoffLocation)&&(identical(other.price, price) || other.price == price)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vehicleName,operatorName,isEcoFriendly,isTopRated,capacity,luggage,amenities,climate,driverName,driverRating,driverTrips,driverBio,estimatedDuration,pickupLocation,dropoffLocation,price,imagePath);

@override
String toString() {
  return 'VehicleDetailsModel(id: $id, vehicleName: $vehicleName, operatorName: $operatorName, isEcoFriendly: $isEcoFriendly, isTopRated: $isTopRated, capacity: $capacity, luggage: $luggage, amenities: $amenities, climate: $climate, driverName: $driverName, driverRating: $driverRating, driverTrips: $driverTrips, driverBio: $driverBio, estimatedDuration: $estimatedDuration, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, price: $price, imagePath: $imagePath)';
}


}

/// @nodoc
abstract mixin class _$VehicleDetailsModelCopyWith<$Res> implements $VehicleDetailsModelCopyWith<$Res> {
  factory _$VehicleDetailsModelCopyWith(_VehicleDetailsModel value, $Res Function(_VehicleDetailsModel) _then) = __$VehicleDetailsModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String vehicleName, String operatorName, bool isEcoFriendly, bool isTopRated, String capacity, String luggage, String amenities, String climate, String driverName, String driverRating, String driverTrips, String driverBio, String estimatedDuration, String pickupLocation, String dropoffLocation, String price, String imagePath
});




}
/// @nodoc
class __$VehicleDetailsModelCopyWithImpl<$Res>
    implements _$VehicleDetailsModelCopyWith<$Res> {
  __$VehicleDetailsModelCopyWithImpl(this._self, this._then);

  final _VehicleDetailsModel _self;
  final $Res Function(_VehicleDetailsModel) _then;

/// Create a copy of VehicleDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vehicleName = null,Object? operatorName = null,Object? isEcoFriendly = null,Object? isTopRated = null,Object? capacity = null,Object? luggage = null,Object? amenities = null,Object? climate = null,Object? driverName = null,Object? driverRating = null,Object? driverTrips = null,Object? driverBio = null,Object? estimatedDuration = null,Object? pickupLocation = null,Object? dropoffLocation = null,Object? price = null,Object? imagePath = null,}) {
  return _then(_VehicleDetailsModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vehicleName: null == vehicleName ? _self.vehicleName : vehicleName // ignore: cast_nullable_to_non_nullable
as String,operatorName: null == operatorName ? _self.operatorName : operatorName // ignore: cast_nullable_to_non_nullable
as String,isEcoFriendly: null == isEcoFriendly ? _self.isEcoFriendly : isEcoFriendly // ignore: cast_nullable_to_non_nullable
as bool,isTopRated: null == isTopRated ? _self.isTopRated : isTopRated // ignore: cast_nullable_to_non_nullable
as bool,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as String,luggage: null == luggage ? _self.luggage : luggage // ignore: cast_nullable_to_non_nullable
as String,amenities: null == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as String,climate: null == climate ? _self.climate : climate // ignore: cast_nullable_to_non_nullable
as String,driverName: null == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String,driverRating: null == driverRating ? _self.driverRating : driverRating // ignore: cast_nullable_to_non_nullable
as String,driverTrips: null == driverTrips ? _self.driverTrips : driverTrips // ignore: cast_nullable_to_non_nullable
as String,driverBio: null == driverBio ? _self.driverBio : driverBio // ignore: cast_nullable_to_non_nullable
as String,estimatedDuration: null == estimatedDuration ? _self.estimatedDuration : estimatedDuration // ignore: cast_nullable_to_non_nullable
as String,pickupLocation: null == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String,dropoffLocation: null == dropoffLocation ? _self.dropoffLocation : dropoffLocation // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
