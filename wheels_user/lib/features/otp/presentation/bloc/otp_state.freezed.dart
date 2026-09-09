// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtpState {

 String get fullPhoneNumber; String get otpCode; bool get isOtpValid; int get countdownSeconds; bool get isSubmitting; bool get isSuccess; bool get isResending; String? get errorMessage;
/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpStateCopyWith<OtpState> get copyWith => _$OtpStateCopyWithImpl<OtpState>(this as OtpState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpState&&(identical(other.fullPhoneNumber, fullPhoneNumber) || other.fullPhoneNumber == fullPhoneNumber)&&(identical(other.otpCode, otpCode) || other.otpCode == otpCode)&&(identical(other.isOtpValid, isOtpValid) || other.isOtpValid == isOtpValid)&&(identical(other.countdownSeconds, countdownSeconds) || other.countdownSeconds == countdownSeconds)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.isResending, isResending) || other.isResending == isResending)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,fullPhoneNumber,otpCode,isOtpValid,countdownSeconds,isSubmitting,isSuccess,isResending,errorMessage);

@override
String toString() {
  return 'OtpState(fullPhoneNumber: $fullPhoneNumber, otpCode: $otpCode, isOtpValid: $isOtpValid, countdownSeconds: $countdownSeconds, isSubmitting: $isSubmitting, isSuccess: $isSuccess, isResending: $isResending, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $OtpStateCopyWith<$Res>  {
  factory $OtpStateCopyWith(OtpState value, $Res Function(OtpState) _then) = _$OtpStateCopyWithImpl;
@useResult
$Res call({
 String fullPhoneNumber, String otpCode, bool isOtpValid, int countdownSeconds, bool isSubmitting, bool isSuccess, bool isResending, String? errorMessage
});




}
/// @nodoc
class _$OtpStateCopyWithImpl<$Res>
    implements $OtpStateCopyWith<$Res> {
  _$OtpStateCopyWithImpl(this._self, this._then);

  final OtpState _self;
  final $Res Function(OtpState) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullPhoneNumber = null,Object? otpCode = null,Object? isOtpValid = null,Object? countdownSeconds = null,Object? isSubmitting = null,Object? isSuccess = null,Object? isResending = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
fullPhoneNumber: null == fullPhoneNumber ? _self.fullPhoneNumber : fullPhoneNumber // ignore: cast_nullable_to_non_nullable
as String,otpCode: null == otpCode ? _self.otpCode : otpCode // ignore: cast_nullable_to_non_nullable
as String,isOtpValid: null == isOtpValid ? _self.isOtpValid : isOtpValid // ignore: cast_nullable_to_non_nullable
as bool,countdownSeconds: null == countdownSeconds ? _self.countdownSeconds : countdownSeconds // ignore: cast_nullable_to_non_nullable
as int,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,isResending: null == isResending ? _self.isResending : isResending // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OtpState].
extension OtpStatePatterns on OtpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtpState value)  $default,){
final _that = this;
switch (_that) {
case _OtpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtpState value)?  $default,){
final _that = this;
switch (_that) {
case _OtpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fullPhoneNumber,  String otpCode,  bool isOtpValid,  int countdownSeconds,  bool isSubmitting,  bool isSuccess,  bool isResending,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtpState() when $default != null:
return $default(_that.fullPhoneNumber,_that.otpCode,_that.isOtpValid,_that.countdownSeconds,_that.isSubmitting,_that.isSuccess,_that.isResending,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fullPhoneNumber,  String otpCode,  bool isOtpValid,  int countdownSeconds,  bool isSubmitting,  bool isSuccess,  bool isResending,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _OtpState():
return $default(_that.fullPhoneNumber,_that.otpCode,_that.isOtpValid,_that.countdownSeconds,_that.isSubmitting,_that.isSuccess,_that.isResending,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fullPhoneNumber,  String otpCode,  bool isOtpValid,  int countdownSeconds,  bool isSubmitting,  bool isSuccess,  bool isResending,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _OtpState() when $default != null:
return $default(_that.fullPhoneNumber,_that.otpCode,_that.isOtpValid,_that.countdownSeconds,_that.isSubmitting,_that.isSuccess,_that.isResending,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _OtpState extends OtpState {
  const _OtpState({required this.fullPhoneNumber, this.otpCode = '', this.isOtpValid = false, this.countdownSeconds = 30, this.isSubmitting = false, this.isSuccess = false, this.isResending = false, this.errorMessage}): super._();
  

@override final  String fullPhoneNumber;
@override@JsonKey() final  String otpCode;
@override@JsonKey() final  bool isOtpValid;
@override@JsonKey() final  int countdownSeconds;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool isSuccess;
@override@JsonKey() final  bool isResending;
@override final  String? errorMessage;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpStateCopyWith<_OtpState> get copyWith => __$OtpStateCopyWithImpl<_OtpState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpState&&(identical(other.fullPhoneNumber, fullPhoneNumber) || other.fullPhoneNumber == fullPhoneNumber)&&(identical(other.otpCode, otpCode) || other.otpCode == otpCode)&&(identical(other.isOtpValid, isOtpValid) || other.isOtpValid == isOtpValid)&&(identical(other.countdownSeconds, countdownSeconds) || other.countdownSeconds == countdownSeconds)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.isResending, isResending) || other.isResending == isResending)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,fullPhoneNumber,otpCode,isOtpValid,countdownSeconds,isSubmitting,isSuccess,isResending,errorMessage);

@override
String toString() {
  return 'OtpState(fullPhoneNumber: $fullPhoneNumber, otpCode: $otpCode, isOtpValid: $isOtpValid, countdownSeconds: $countdownSeconds, isSubmitting: $isSubmitting, isSuccess: $isSuccess, isResending: $isResending, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$OtpStateCopyWith<$Res> implements $OtpStateCopyWith<$Res> {
  factory _$OtpStateCopyWith(_OtpState value, $Res Function(_OtpState) _then) = __$OtpStateCopyWithImpl;
@override @useResult
$Res call({
 String fullPhoneNumber, String otpCode, bool isOtpValid, int countdownSeconds, bool isSubmitting, bool isSuccess, bool isResending, String? errorMessage
});




}
/// @nodoc
class __$OtpStateCopyWithImpl<$Res>
    implements _$OtpStateCopyWith<$Res> {
  __$OtpStateCopyWithImpl(this._self, this._then);

  final _OtpState _self;
  final $Res Function(_OtpState) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullPhoneNumber = null,Object? otpCode = null,Object? isOtpValid = null,Object? countdownSeconds = null,Object? isSubmitting = null,Object? isSuccess = null,Object? isResending = null,Object? errorMessage = freezed,}) {
  return _then(_OtpState(
fullPhoneNumber: null == fullPhoneNumber ? _self.fullPhoneNumber : fullPhoneNumber // ignore: cast_nullable_to_non_nullable
as String,otpCode: null == otpCode ? _self.otpCode : otpCode // ignore: cast_nullable_to_non_nullable
as String,isOtpValid: null == isOtpValid ? _self.isOtpValid : isOtpValid // ignore: cast_nullable_to_non_nullable
as bool,countdownSeconds: null == countdownSeconds ? _self.countdownSeconds : countdownSeconds // ignore: cast_nullable_to_non_nullable
as int,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,isResending: null == isResending ? _self.isResending : isResending // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
