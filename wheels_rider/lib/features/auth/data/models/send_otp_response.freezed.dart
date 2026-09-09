// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_otp_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendOtpResponse {

 bool get success; String get message; SendOtpData get data; dynamic get error; dynamic get meta;
/// Create a copy of SendOtpResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendOtpResponseCopyWith<SendOtpResponse> get copyWith => _$SendOtpResponseCopyWithImpl<SendOtpResponse>(this as SendOtpResponse, _$identity);

  /// Serializes this SendOtpResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendOtpResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.error, error)&&const DeepCollectionEquality().equals(other.meta, meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(error),const DeepCollectionEquality().hash(meta));

@override
String toString() {
  return 'SendOtpResponse(success: $success, message: $message, data: $data, error: $error, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $SendOtpResponseCopyWith<$Res>  {
  factory $SendOtpResponseCopyWith(SendOtpResponse value, $Res Function(SendOtpResponse) _then) = _$SendOtpResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, SendOtpData data, dynamic error, dynamic meta
});


$SendOtpDataCopyWith<$Res> get data;

}
/// @nodoc
class _$SendOtpResponseCopyWithImpl<$Res>
    implements $SendOtpResponseCopyWith<$Res> {
  _$SendOtpResponseCopyWithImpl(this._self, this._then);

  final SendOtpResponse _self;
  final $Res Function(SendOtpResponse) _then;

/// Create a copy of SendOtpResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = null,Object? error = freezed,Object? meta = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as SendOtpData,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}
/// Create a copy of SendOtpResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SendOtpDataCopyWith<$Res> get data {
  
  return $SendOtpDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [SendOtpResponse].
extension SendOtpResponsePatterns on SendOtpResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendOtpResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendOtpResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendOtpResponse value)  $default,){
final _that = this;
switch (_that) {
case _SendOtpResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendOtpResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SendOtpResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  SendOtpData data,  dynamic error,  dynamic meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendOtpResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  SendOtpData data,  dynamic error,  dynamic meta)  $default,) {final _that = this;
switch (_that) {
case _SendOtpResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  SendOtpData data,  dynamic error,  dynamic meta)?  $default,) {final _that = this;
switch (_that) {
case _SendOtpResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.error,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendOtpResponse implements SendOtpResponse {
  const _SendOtpResponse({required this.success, required this.message, required this.data, this.error, this.meta});
  factory _SendOtpResponse.fromJson(Map<String, dynamic> json) => _$SendOtpResponseFromJson(json);

@override final  bool success;
@override final  String message;
@override final  SendOtpData data;
@override final  dynamic error;
@override final  dynamic meta;

/// Create a copy of SendOtpResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendOtpResponseCopyWith<_SendOtpResponse> get copyWith => __$SendOtpResponseCopyWithImpl<_SendOtpResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendOtpResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendOtpResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.error, error)&&const DeepCollectionEquality().equals(other.meta, meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(error),const DeepCollectionEquality().hash(meta));

@override
String toString() {
  return 'SendOtpResponse(success: $success, message: $message, data: $data, error: $error, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$SendOtpResponseCopyWith<$Res> implements $SendOtpResponseCopyWith<$Res> {
  factory _$SendOtpResponseCopyWith(_SendOtpResponse value, $Res Function(_SendOtpResponse) _then) = __$SendOtpResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, SendOtpData data, dynamic error, dynamic meta
});


@override $SendOtpDataCopyWith<$Res> get data;

}
/// @nodoc
class __$SendOtpResponseCopyWithImpl<$Res>
    implements _$SendOtpResponseCopyWith<$Res> {
  __$SendOtpResponseCopyWithImpl(this._self, this._then);

  final _SendOtpResponse _self;
  final $Res Function(_SendOtpResponse) _then;

/// Create a copy of SendOtpResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = null,Object? error = freezed,Object? meta = freezed,}) {
  return _then(_SendOtpResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as SendOtpData,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as dynamic,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

/// Create a copy of SendOtpResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SendOtpDataCopyWith<$Res> get data {
  
  return $SendOtpDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$SendOtpData {

 String get phone;@JsonKey(name: 'otp_sent') bool get otpSent;@JsonKey(name: 'dev_otp') String? get devOtp;
/// Create a copy of SendOtpData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendOtpDataCopyWith<SendOtpData> get copyWith => _$SendOtpDataCopyWithImpl<SendOtpData>(this as SendOtpData, _$identity);

  /// Serializes this SendOtpData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendOtpData&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.otpSent, otpSent) || other.otpSent == otpSent)&&(identical(other.devOtp, devOtp) || other.devOtp == devOtp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phone,otpSent,devOtp);

@override
String toString() {
  return 'SendOtpData(phone: $phone, otpSent: $otpSent, devOtp: $devOtp)';
}


}

/// @nodoc
abstract mixin class $SendOtpDataCopyWith<$Res>  {
  factory $SendOtpDataCopyWith(SendOtpData value, $Res Function(SendOtpData) _then) = _$SendOtpDataCopyWithImpl;
@useResult
$Res call({
 String phone,@JsonKey(name: 'otp_sent') bool otpSent,@JsonKey(name: 'dev_otp') String? devOtp
});




}
/// @nodoc
class _$SendOtpDataCopyWithImpl<$Res>
    implements $SendOtpDataCopyWith<$Res> {
  _$SendOtpDataCopyWithImpl(this._self, this._then);

  final SendOtpData _self;
  final $Res Function(SendOtpData) _then;

/// Create a copy of SendOtpData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phone = null,Object? otpSent = null,Object? devOtp = freezed,}) {
  return _then(_self.copyWith(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,otpSent: null == otpSent ? _self.otpSent : otpSent // ignore: cast_nullable_to_non_nullable
as bool,devOtp: freezed == devOtp ? _self.devOtp : devOtp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SendOtpData].
extension SendOtpDataPatterns on SendOtpData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendOtpData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendOtpData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendOtpData value)  $default,){
final _that = this;
switch (_that) {
case _SendOtpData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendOtpData value)?  $default,){
final _that = this;
switch (_that) {
case _SendOtpData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phone, @JsonKey(name: 'otp_sent')  bool otpSent, @JsonKey(name: 'dev_otp')  String? devOtp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendOtpData() when $default != null:
return $default(_that.phone,_that.otpSent,_that.devOtp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phone, @JsonKey(name: 'otp_sent')  bool otpSent, @JsonKey(name: 'dev_otp')  String? devOtp)  $default,) {final _that = this;
switch (_that) {
case _SendOtpData():
return $default(_that.phone,_that.otpSent,_that.devOtp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phone, @JsonKey(name: 'otp_sent')  bool otpSent, @JsonKey(name: 'dev_otp')  String? devOtp)?  $default,) {final _that = this;
switch (_that) {
case _SendOtpData() when $default != null:
return $default(_that.phone,_that.otpSent,_that.devOtp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendOtpData implements SendOtpData {
  const _SendOtpData({required this.phone, @JsonKey(name: 'otp_sent') required this.otpSent, @JsonKey(name: 'dev_otp') this.devOtp});
  factory _SendOtpData.fromJson(Map<String, dynamic> json) => _$SendOtpDataFromJson(json);

@override final  String phone;
@override@JsonKey(name: 'otp_sent') final  bool otpSent;
@override@JsonKey(name: 'dev_otp') final  String? devOtp;

/// Create a copy of SendOtpData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendOtpDataCopyWith<_SendOtpData> get copyWith => __$SendOtpDataCopyWithImpl<_SendOtpData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendOtpDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendOtpData&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.otpSent, otpSent) || other.otpSent == otpSent)&&(identical(other.devOtp, devOtp) || other.devOtp == devOtp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phone,otpSent,devOtp);

@override
String toString() {
  return 'SendOtpData(phone: $phone, otpSent: $otpSent, devOtp: $devOtp)';
}


}

/// @nodoc
abstract mixin class _$SendOtpDataCopyWith<$Res> implements $SendOtpDataCopyWith<$Res> {
  factory _$SendOtpDataCopyWith(_SendOtpData value, $Res Function(_SendOtpData) _then) = __$SendOtpDataCopyWithImpl;
@override @useResult
$Res call({
 String phone,@JsonKey(name: 'otp_sent') bool otpSent,@JsonKey(name: 'dev_otp') String? devOtp
});




}
/// @nodoc
class __$SendOtpDataCopyWithImpl<$Res>
    implements _$SendOtpDataCopyWith<$Res> {
  __$SendOtpDataCopyWithImpl(this._self, this._then);

  final _SendOtpData _self;
  final $Res Function(_SendOtpData) _then;

/// Create a copy of SendOtpData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? otpSent = null,Object? devOtp = freezed,}) {
  return _then(_SendOtpData(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,otpSent: null == otpSent ? _self.otpSent : otpSent // ignore: cast_nullable_to_non_nullable
as bool,devOtp: freezed == devOtp ? _self.devOtp : devOtp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
