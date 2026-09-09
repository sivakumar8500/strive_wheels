// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_otp_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerifyOtpResponse {

 bool get success; String get message; VerifyOtpData get data; dynamic get error; dynamic get meta;
/// Create a copy of VerifyOtpResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyOtpResponseCopyWith<VerifyOtpResponse> get copyWith => _$VerifyOtpResponseCopyWithImpl<VerifyOtpResponse>(this as VerifyOtpResponse, _$identity);

  /// Serializes this VerifyOtpResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyOtpResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.error, error)&&const DeepCollectionEquality().equals(other.meta, meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(error),const DeepCollectionEquality().hash(meta));

@override
String toString() {
  return 'VerifyOtpResponse(success: $success, message: $message, data: $data, error: $error, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $VerifyOtpResponseCopyWith<$Res>  {
  factory $VerifyOtpResponseCopyWith(VerifyOtpResponse value, $Res Function(VerifyOtpResponse) _then) = _$VerifyOtpResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, VerifyOtpData data, dynamic error, dynamic meta
});


$VerifyOtpDataCopyWith<$Res> get data;

}
/// @nodoc
class _$VerifyOtpResponseCopyWithImpl<$Res>
    implements $VerifyOtpResponseCopyWith<$Res> {
  _$VerifyOtpResponseCopyWithImpl(this._self, this._then);

  final VerifyOtpResponse _self;
  final $Res Function(VerifyOtpResponse) _then;

/// Create a copy of VerifyOtpResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = null,Object? error = freezed,Object? meta = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as VerifyOtpData,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}
/// Create a copy of VerifyOtpResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerifyOtpDataCopyWith<$Res> get data {
  
  return $VerifyOtpDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [VerifyOtpResponse].
extension VerifyOtpResponsePatterns on VerifyOtpResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerifyOtpResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerifyOtpResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerifyOtpResponse value)  $default,){
final _that = this;
switch (_that) {
case _VerifyOtpResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerifyOtpResponse value)?  $default,){
final _that = this;
switch (_that) {
case _VerifyOtpResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  VerifyOtpData data,  dynamic error,  dynamic meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerifyOtpResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.error,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  VerifyOtpData data,  dynamic error,  dynamic meta)  $default,) {final _that = this;
switch (_that) {
case _VerifyOtpResponse():
return $default(_that.success,_that.message,_that.data,_that.error,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  VerifyOtpData data,  dynamic error,  dynamic meta)?  $default,) {final _that = this;
switch (_that) {
case _VerifyOtpResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.error,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerifyOtpResponse implements VerifyOtpResponse {
  const _VerifyOtpResponse({required this.success, required this.message, required this.data, this.error, this.meta});
  factory _VerifyOtpResponse.fromJson(Map<String, dynamic> json) => _$VerifyOtpResponseFromJson(json);

@override final  bool success;
@override final  String message;
@override final  VerifyOtpData data;
@override final  dynamic error;
@override final  dynamic meta;

/// Create a copy of VerifyOtpResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerifyOtpResponseCopyWith<_VerifyOtpResponse> get copyWith => __$VerifyOtpResponseCopyWithImpl<_VerifyOtpResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerifyOtpResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyOtpResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.error, error)&&const DeepCollectionEquality().equals(other.meta, meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(error),const DeepCollectionEquality().hash(meta));

@override
String toString() {
  return 'VerifyOtpResponse(success: $success, message: $message, data: $data, error: $error, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$VerifyOtpResponseCopyWith<$Res> implements $VerifyOtpResponseCopyWith<$Res> {
  factory _$VerifyOtpResponseCopyWith(_VerifyOtpResponse value, $Res Function(_VerifyOtpResponse) _then) = __$VerifyOtpResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, VerifyOtpData data, dynamic error, dynamic meta
});


@override $VerifyOtpDataCopyWith<$Res> get data;

}
/// @nodoc
class __$VerifyOtpResponseCopyWithImpl<$Res>
    implements _$VerifyOtpResponseCopyWith<$Res> {
  __$VerifyOtpResponseCopyWithImpl(this._self, this._then);

  final _VerifyOtpResponse _self;
  final $Res Function(_VerifyOtpResponse) _then;

/// Create a copy of VerifyOtpResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = null,Object? error = freezed,Object? meta = freezed,}) {
  return _then(_VerifyOtpResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as VerifyOtpData,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

/// Create a copy of VerifyOtpResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerifyOtpDataCopyWith<$Res> get data {
  
  return $VerifyOtpDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$VerifyOtpData {

@JsonKey(name: 'access_token') String get accessToken;@JsonKey(name: 'refresh_token') String get refreshToken;@JsonKey(name: 'token_type') String get tokenType;@JsonKey(name: 'user_id') int get userId; String get phone; List<String> get roles;@JsonKey(name: 'rider_profile') RiderProfile? get riderProfile;@JsonKey(name: 'customer_profile') dynamic get customerProfile;@JsonKey(name: 'driver_registration') DriverRegistration? get driverRegistration;
/// Create a copy of VerifyOtpData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyOtpDataCopyWith<VerifyOtpData> get copyWith => _$VerifyOtpDataCopyWithImpl<VerifyOtpData>(this as VerifyOtpData, _$identity);

  /// Serializes this VerifyOtpData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyOtpData&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.tokenType, tokenType) || other.tokenType == tokenType)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.phone, phone) || other.phone == phone)&&const DeepCollectionEquality().equals(other.roles, roles)&&(identical(other.riderProfile, riderProfile) || other.riderProfile == riderProfile)&&const DeepCollectionEquality().equals(other.customerProfile, customerProfile)&&(identical(other.driverRegistration, driverRegistration) || other.driverRegistration == driverRegistration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,tokenType,userId,phone,const DeepCollectionEquality().hash(roles),riderProfile,const DeepCollectionEquality().hash(customerProfile),driverRegistration);

@override
String toString() {
  return 'VerifyOtpData(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, userId: $userId, phone: $phone, roles: $roles, riderProfile: $riderProfile, customerProfile: $customerProfile, driverRegistration: $driverRegistration)';
}


}

/// @nodoc
abstract mixin class $VerifyOtpDataCopyWith<$Res>  {
  factory $VerifyOtpDataCopyWith(VerifyOtpData value, $Res Function(VerifyOtpData) _then) = _$VerifyOtpDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'refresh_token') String refreshToken,@JsonKey(name: 'token_type') String tokenType,@JsonKey(name: 'user_id') int userId, String phone, List<String> roles,@JsonKey(name: 'rider_profile') RiderProfile? riderProfile,@JsonKey(name: 'customer_profile') dynamic customerProfile,@JsonKey(name: 'driver_registration') DriverRegistration? driverRegistration
});


$RiderProfileCopyWith<$Res>? get riderProfile;$DriverRegistrationCopyWith<$Res>? get driverRegistration;

}
/// @nodoc
class _$VerifyOtpDataCopyWithImpl<$Res>
    implements $VerifyOtpDataCopyWith<$Res> {
  _$VerifyOtpDataCopyWithImpl(this._self, this._then);

  final VerifyOtpData _self;
  final $Res Function(VerifyOtpData) _then;

/// Create a copy of VerifyOtpData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? tokenType = null,Object? userId = null,Object? phone = null,Object? roles = null,Object? riderProfile = freezed,Object? customerProfile = freezed,Object? driverRegistration = freezed,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,tokenType: null == tokenType ? _self.tokenType : tokenType // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,riderProfile: freezed == riderProfile ? _self.riderProfile : riderProfile // ignore: cast_nullable_to_non_nullable
as RiderProfile?,customerProfile: freezed == customerProfile ? _self.customerProfile : customerProfile // ignore: cast_nullable_to_non_nullable
as dynamic,driverRegistration: freezed == driverRegistration ? _self.driverRegistration : driverRegistration // ignore: cast_nullable_to_non_nullable
as DriverRegistration?,
  ));
}
/// Create a copy of VerifyOtpData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RiderProfileCopyWith<$Res>? get riderProfile {
    if (_self.riderProfile == null) {
    return null;
  }

  return $RiderProfileCopyWith<$Res>(_self.riderProfile!, (value) {
    return _then(_self.copyWith(riderProfile: value));
  });
}/// Create a copy of VerifyOtpData
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


/// Adds pattern-matching-related methods to [VerifyOtpData].
extension VerifyOtpDataPatterns on VerifyOtpData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerifyOtpData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerifyOtpData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerifyOtpData value)  $default,){
final _that = this;
switch (_that) {
case _VerifyOtpData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerifyOtpData value)?  $default,){
final _that = this;
switch (_that) {
case _VerifyOtpData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'refresh_token')  String refreshToken, @JsonKey(name: 'token_type')  String tokenType, @JsonKey(name: 'user_id')  int userId,  String phone,  List<String> roles, @JsonKey(name: 'rider_profile')  RiderProfile? riderProfile, @JsonKey(name: 'customer_profile')  dynamic customerProfile, @JsonKey(name: 'driver_registration')  DriverRegistration? driverRegistration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerifyOtpData() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.tokenType,_that.userId,_that.phone,_that.roles,_that.riderProfile,_that.customerProfile,_that.driverRegistration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'refresh_token')  String refreshToken, @JsonKey(name: 'token_type')  String tokenType, @JsonKey(name: 'user_id')  int userId,  String phone,  List<String> roles, @JsonKey(name: 'rider_profile')  RiderProfile? riderProfile, @JsonKey(name: 'customer_profile')  dynamic customerProfile, @JsonKey(name: 'driver_registration')  DriverRegistration? driverRegistration)  $default,) {final _that = this;
switch (_that) {
case _VerifyOtpData():
return $default(_that.accessToken,_that.refreshToken,_that.tokenType,_that.userId,_that.phone,_that.roles,_that.riderProfile,_that.customerProfile,_that.driverRegistration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'refresh_token')  String refreshToken, @JsonKey(name: 'token_type')  String tokenType, @JsonKey(name: 'user_id')  int userId,  String phone,  List<String> roles, @JsonKey(name: 'rider_profile')  RiderProfile? riderProfile, @JsonKey(name: 'customer_profile')  dynamic customerProfile, @JsonKey(name: 'driver_registration')  DriverRegistration? driverRegistration)?  $default,) {final _that = this;
switch (_that) {
case _VerifyOtpData() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.tokenType,_that.userId,_that.phone,_that.roles,_that.riderProfile,_that.customerProfile,_that.driverRegistration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerifyOtpData implements VerifyOtpData {
  const _VerifyOtpData({@JsonKey(name: 'access_token') required this.accessToken, @JsonKey(name: 'refresh_token') required this.refreshToken, @JsonKey(name: 'token_type') required this.tokenType, @JsonKey(name: 'user_id') required this.userId, required this.phone, required final  List<String> roles, @JsonKey(name: 'rider_profile') this.riderProfile, @JsonKey(name: 'customer_profile') this.customerProfile, @JsonKey(name: 'driver_registration') this.driverRegistration}): _roles = roles;
  factory _VerifyOtpData.fromJson(Map<String, dynamic> json) => _$VerifyOtpDataFromJson(json);

@override@JsonKey(name: 'access_token') final  String accessToken;
@override@JsonKey(name: 'refresh_token') final  String refreshToken;
@override@JsonKey(name: 'token_type') final  String tokenType;
@override@JsonKey(name: 'user_id') final  int userId;
@override final  String phone;
 final  List<String> _roles;
@override List<String> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}

@override@JsonKey(name: 'rider_profile') final  RiderProfile? riderProfile;
@override@JsonKey(name: 'customer_profile') final  dynamic customerProfile;
@override@JsonKey(name: 'driver_registration') final  DriverRegistration? driverRegistration;

/// Create a copy of VerifyOtpData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerifyOtpDataCopyWith<_VerifyOtpData> get copyWith => __$VerifyOtpDataCopyWithImpl<_VerifyOtpData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerifyOtpDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyOtpData&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.tokenType, tokenType) || other.tokenType == tokenType)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.phone, phone) || other.phone == phone)&&const DeepCollectionEquality().equals(other._roles, _roles)&&(identical(other.riderProfile, riderProfile) || other.riderProfile == riderProfile)&&const DeepCollectionEquality().equals(other.customerProfile, customerProfile)&&(identical(other.driverRegistration, driverRegistration) || other.driverRegistration == driverRegistration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,tokenType,userId,phone,const DeepCollectionEquality().hash(_roles),riderProfile,const DeepCollectionEquality().hash(customerProfile),driverRegistration);

@override
String toString() {
  return 'VerifyOtpData(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, userId: $userId, phone: $phone, roles: $roles, riderProfile: $riderProfile, customerProfile: $customerProfile, driverRegistration: $driverRegistration)';
}


}

/// @nodoc
abstract mixin class _$VerifyOtpDataCopyWith<$Res> implements $VerifyOtpDataCopyWith<$Res> {
  factory _$VerifyOtpDataCopyWith(_VerifyOtpData value, $Res Function(_VerifyOtpData) _then) = __$VerifyOtpDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'refresh_token') String refreshToken,@JsonKey(name: 'token_type') String tokenType,@JsonKey(name: 'user_id') int userId, String phone, List<String> roles,@JsonKey(name: 'rider_profile') RiderProfile? riderProfile,@JsonKey(name: 'customer_profile') dynamic customerProfile,@JsonKey(name: 'driver_registration') DriverRegistration? driverRegistration
});


@override $RiderProfileCopyWith<$Res>? get riderProfile;@override $DriverRegistrationCopyWith<$Res>? get driverRegistration;

}
/// @nodoc
class __$VerifyOtpDataCopyWithImpl<$Res>
    implements _$VerifyOtpDataCopyWith<$Res> {
  __$VerifyOtpDataCopyWithImpl(this._self, this._then);

  final _VerifyOtpData _self;
  final $Res Function(_VerifyOtpData) _then;

/// Create a copy of VerifyOtpData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? tokenType = null,Object? userId = null,Object? phone = null,Object? roles = null,Object? riderProfile = freezed,Object? customerProfile = freezed,Object? driverRegistration = freezed,}) {
  return _then(_VerifyOtpData(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,tokenType: null == tokenType ? _self.tokenType : tokenType // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,riderProfile: freezed == riderProfile ? _self.riderProfile : riderProfile // ignore: cast_nullable_to_non_nullable
as RiderProfile?,customerProfile: freezed == customerProfile ? _self.customerProfile : customerProfile // ignore: cast_nullable_to_non_nullable
as dynamic,driverRegistration: freezed == driverRegistration ? _self.driverRegistration : driverRegistration // ignore: cast_nullable_to_non_nullable
as DriverRegistration?,
  ));
}

/// Create a copy of VerifyOtpData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RiderProfileCopyWith<$Res>? get riderProfile {
    if (_self.riderProfile == null) {
    return null;
  }

  return $RiderProfileCopyWith<$Res>(_self.riderProfile!, (value) {
    return _then(_self.copyWith(riderProfile: value));
  });
}/// Create a copy of VerifyOtpData
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
