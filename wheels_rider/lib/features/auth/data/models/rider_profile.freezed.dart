// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rider_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RiderProfile {

 int? get id;@JsonKey(name: 'verification_status') String? get verificationStatus;@JsonKey(name: 'availability_mode') String? get availabilityMode;@JsonKey(name: 'is_online') bool? get isOnline;@JsonKey(name: 'is_driver') bool? get isDriver;@JsonKey(name: 'driver_registration') DriverRegistration? get driverRegistration;
/// Create a copy of RiderProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RiderProfileCopyWith<RiderProfile> get copyWith => _$RiderProfileCopyWithImpl<RiderProfile>(this as RiderProfile, _$identity);

  /// Serializes this RiderProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RiderProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.availabilityMode, availabilityMode) || other.availabilityMode == availabilityMode)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.isDriver, isDriver) || other.isDriver == isDriver)&&(identical(other.driverRegistration, driverRegistration) || other.driverRegistration == driverRegistration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,verificationStatus,availabilityMode,isOnline,isDriver,driverRegistration);

@override
String toString() {
  return 'RiderProfile(id: $id, verificationStatus: $verificationStatus, availabilityMode: $availabilityMode, isOnline: $isOnline, isDriver: $isDriver, driverRegistration: $driverRegistration)';
}


}

/// @nodoc
abstract mixin class $RiderProfileCopyWith<$Res>  {
  factory $RiderProfileCopyWith(RiderProfile value, $Res Function(RiderProfile) _then) = _$RiderProfileCopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(name: 'verification_status') String? verificationStatus,@JsonKey(name: 'availability_mode') String? availabilityMode,@JsonKey(name: 'is_online') bool? isOnline,@JsonKey(name: 'is_driver') bool? isDriver,@JsonKey(name: 'driver_registration') DriverRegistration? driverRegistration
});


$DriverRegistrationCopyWith<$Res>? get driverRegistration;

}
/// @nodoc
class _$RiderProfileCopyWithImpl<$Res>
    implements $RiderProfileCopyWith<$Res> {
  _$RiderProfileCopyWithImpl(this._self, this._then);

  final RiderProfile _self;
  final $Res Function(RiderProfile) _then;

/// Create a copy of RiderProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? verificationStatus = freezed,Object? availabilityMode = freezed,Object? isOnline = freezed,Object? isDriver = freezed,Object? driverRegistration = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,verificationStatus: freezed == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as String?,availabilityMode: freezed == availabilityMode ? _self.availabilityMode : availabilityMode // ignore: cast_nullable_to_non_nullable
as String?,isOnline: freezed == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool?,isDriver: freezed == isDriver ? _self.isDriver : isDriver // ignore: cast_nullable_to_non_nullable
as bool?,driverRegistration: freezed == driverRegistration ? _self.driverRegistration : driverRegistration // ignore: cast_nullable_to_non_nullable
as DriverRegistration?,
  ));
}
/// Create a copy of RiderProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriverRegistrationCopyWith<$Res>? get driverRegistration {
    if (_self.driverRegistration == null) {
    return null;
  }

  return $DriverRegistrationCopyWith<$Res>(_self.driverRegistration!, (value) {
    return _then(_self.copyWith(driverRegistration: value));
  });
}
}


/// Adds pattern-matching-related methods to [RiderProfile].
extension RiderProfilePatterns on RiderProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RiderProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RiderProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RiderProfile value)  $default,){
final _that = this;
switch (_that) {
case _RiderProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RiderProfile value)?  $default,){
final _that = this;
switch (_that) {
case _RiderProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'verification_status')  String? verificationStatus, @JsonKey(name: 'availability_mode')  String? availabilityMode, @JsonKey(name: 'is_online')  bool? isOnline, @JsonKey(name: 'is_driver')  bool? isDriver, @JsonKey(name: 'driver_registration')  DriverRegistration? driverRegistration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RiderProfile() when $default != null:
return $default(_that.id,_that.verificationStatus,_that.availabilityMode,_that.isOnline,_that.isDriver,_that.driverRegistration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: 'verification_status')  String? verificationStatus, @JsonKey(name: 'availability_mode')  String? availabilityMode, @JsonKey(name: 'is_online')  bool? isOnline, @JsonKey(name: 'is_driver')  bool? isDriver, @JsonKey(name: 'driver_registration')  DriverRegistration? driverRegistration)  $default,) {final _that = this;
switch (_that) {
case _RiderProfile():
return $default(_that.id,_that.verificationStatus,_that.availabilityMode,_that.isOnline,_that.isDriver,_that.driverRegistration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id, @JsonKey(name: 'verification_status')  String? verificationStatus, @JsonKey(name: 'availability_mode')  String? availabilityMode, @JsonKey(name: 'is_online')  bool? isOnline, @JsonKey(name: 'is_driver')  bool? isDriver, @JsonKey(name: 'driver_registration')  DriverRegistration? driverRegistration)?  $default,) {final _that = this;
switch (_that) {
case _RiderProfile() when $default != null:
return $default(_that.id,_that.verificationStatus,_that.availabilityMode,_that.isOnline,_that.isDriver,_that.driverRegistration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RiderProfile implements RiderProfile {
  const _RiderProfile({this.id, @JsonKey(name: 'verification_status') this.verificationStatus, @JsonKey(name: 'availability_mode') this.availabilityMode, @JsonKey(name: 'is_online') this.isOnline, @JsonKey(name: 'is_driver') this.isDriver, @JsonKey(name: 'driver_registration') this.driverRegistration});
  factory _RiderProfile.fromJson(Map<String, dynamic> json) => _$RiderProfileFromJson(json);

@override final  int? id;
@override@JsonKey(name: 'verification_status') final  String? verificationStatus;
@override@JsonKey(name: 'availability_mode') final  String? availabilityMode;
@override@JsonKey(name: 'is_online') final  bool? isOnline;
@override@JsonKey(name: 'is_driver') final  bool? isDriver;
@override@JsonKey(name: 'driver_registration') final  DriverRegistration? driverRegistration;

/// Create a copy of RiderProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RiderProfileCopyWith<_RiderProfile> get copyWith => __$RiderProfileCopyWithImpl<_RiderProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RiderProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RiderProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.availabilityMode, availabilityMode) || other.availabilityMode == availabilityMode)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.isDriver, isDriver) || other.isDriver == isDriver)&&(identical(other.driverRegistration, driverRegistration) || other.driverRegistration == driverRegistration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,verificationStatus,availabilityMode,isOnline,isDriver,driverRegistration);

@override
String toString() {
  return 'RiderProfile(id: $id, verificationStatus: $verificationStatus, availabilityMode: $availabilityMode, isOnline: $isOnline, isDriver: $isDriver, driverRegistration: $driverRegistration)';
}


}

/// @nodoc
abstract mixin class _$RiderProfileCopyWith<$Res> implements $RiderProfileCopyWith<$Res> {
  factory _$RiderProfileCopyWith(_RiderProfile value, $Res Function(_RiderProfile) _then) = __$RiderProfileCopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(name: 'verification_status') String? verificationStatus,@JsonKey(name: 'availability_mode') String? availabilityMode,@JsonKey(name: 'is_online') bool? isOnline,@JsonKey(name: 'is_driver') bool? isDriver,@JsonKey(name: 'driver_registration') DriverRegistration? driverRegistration
});


@override $DriverRegistrationCopyWith<$Res>? get driverRegistration;

}
/// @nodoc
class __$RiderProfileCopyWithImpl<$Res>
    implements _$RiderProfileCopyWith<$Res> {
  __$RiderProfileCopyWithImpl(this._self, this._then);

  final _RiderProfile _self;
  final $Res Function(_RiderProfile) _then;

/// Create a copy of RiderProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? verificationStatus = freezed,Object? availabilityMode = freezed,Object? isOnline = freezed,Object? isDriver = freezed,Object? driverRegistration = freezed,}) {
  return _then(_RiderProfile(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,verificationStatus: freezed == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as String?,availabilityMode: freezed == availabilityMode ? _self.availabilityMode : availabilityMode // ignore: cast_nullable_to_non_nullable
as String?,isOnline: freezed == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool?,isDriver: freezed == isDriver ? _self.isDriver : isDriver // ignore: cast_nullable_to_non_nullable
as bool?,driverRegistration: freezed == driverRegistration ? _self.driverRegistration : driverRegistration // ignore: cast_nullable_to_non_nullable
as DriverRegistration?,
  ));
}

/// Create a copy of RiderProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DriverRegistrationCopyWith<$Res>? get driverRegistration {
    if (_self.driverRegistration == null) {
    return null;
  }

  return $DriverRegistrationCopyWith<$Res>(_self.driverRegistration!, (value) {
    return _then(_self.copyWith(driverRegistration: value));
  });
}
}

// dart format on
