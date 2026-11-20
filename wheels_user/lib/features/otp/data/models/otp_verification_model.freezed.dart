// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_verification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OtpVerificationModel {

 String get fullPhoneNumber; String get otpCode;
/// Create a copy of OtpVerificationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpVerificationModelCopyWith<OtpVerificationModel> get copyWith => _$OtpVerificationModelCopyWithImpl<OtpVerificationModel>(this as OtpVerificationModel, _$identity);

  /// Serializes this OtpVerificationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpVerificationModel&&(identical(other.fullPhoneNumber, fullPhoneNumber) || other.fullPhoneNumber == fullPhoneNumber)&&(identical(other.otpCode, otpCode) || other.otpCode == otpCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullPhoneNumber,otpCode);

@override
String toString() {
  return 'OtpVerificationModel(fullPhoneNumber: $fullPhoneNumber, otpCode: $otpCode)';
}


}

/// @nodoc
abstract mixin class $OtpVerificationModelCopyWith<$Res>  {
  factory $OtpVerificationModelCopyWith(OtpVerificationModel value, $Res Function(OtpVerificationModel) _then) = _$OtpVerificationModelCopyWithImpl;
@useResult
$Res call({
 String fullPhoneNumber, String otpCode
});




}
/// @nodoc
class _$OtpVerificationModelCopyWithImpl<$Res>
    implements $OtpVerificationModelCopyWith<$Res> {
  _$OtpVerificationModelCopyWithImpl(this._self, this._then);

  final OtpVerificationModel _self;
  final $Res Function(OtpVerificationModel) _then;

/// Create a copy of OtpVerificationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullPhoneNumber = null,Object? otpCode = null,}) {
  return _then(_self.copyWith(
fullPhoneNumber: null == fullPhoneNumber ? _self.fullPhoneNumber : fullPhoneNumber // ignore: cast_nullable_to_non_nullable
as String,otpCode: null == otpCode ? _self.otpCode : otpCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OtpVerificationModel].
extension OtpVerificationModelPatterns on OtpVerificationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtpVerificationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtpVerificationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtpVerificationModel value)  $default,){
final _that = this;
switch (_that) {
case _OtpVerificationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtpVerificationModel value)?  $default,){
final _that = this;
switch (_that) {
case _OtpVerificationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fullPhoneNumber,  String otpCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtpVerificationModel() when $default != null:
return $default(_that.fullPhoneNumber,_that.otpCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fullPhoneNumber,  String otpCode)  $default,) {final _that = this;
switch (_that) {
case _OtpVerificationModel():
return $default(_that.fullPhoneNumber,_that.otpCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fullPhoneNumber,  String otpCode)?  $default,) {final _that = this;
switch (_that) {
case _OtpVerificationModel() when $default != null:
return $default(_that.fullPhoneNumber,_that.otpCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OtpVerificationModel extends OtpVerificationModel {
  const _OtpVerificationModel({required this.fullPhoneNumber, required this.otpCode}): super._();
  factory _OtpVerificationModel.fromJson(Map<String, dynamic> json) => _$OtpVerificationModelFromJson(json);

@override final  String fullPhoneNumber;
@override final  String otpCode;

/// Create a copy of OtpVerificationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpVerificationModelCopyWith<_OtpVerificationModel> get copyWith => __$OtpVerificationModelCopyWithImpl<_OtpVerificationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OtpVerificationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpVerificationModel&&(identical(other.fullPhoneNumber, fullPhoneNumber) || other.fullPhoneNumber == fullPhoneNumber)&&(identical(other.otpCode, otpCode) || other.otpCode == otpCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullPhoneNumber,otpCode);

@override
String toString() {
  return 'OtpVerificationModel(fullPhoneNumber: $fullPhoneNumber, otpCode: $otpCode)';
}


}

/// @nodoc
abstract mixin class _$OtpVerificationModelCopyWith<$Res> implements $OtpVerificationModelCopyWith<$Res> {
  factory _$OtpVerificationModelCopyWith(_OtpVerificationModel value, $Res Function(_OtpVerificationModel) _then) = __$OtpVerificationModelCopyWithImpl;
@override @useResult
$Res call({
 String fullPhoneNumber, String otpCode
});




}
/// @nodoc
class __$OtpVerificationModelCopyWithImpl<$Res>
    implements _$OtpVerificationModelCopyWith<$Res> {
  __$OtpVerificationModelCopyWithImpl(this._self, this._then);

  final _OtpVerificationModel _self;
  final $Res Function(_OtpVerificationModel) _then;

/// Create a copy of OtpVerificationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullPhoneNumber = null,Object? otpCode = null,}) {
  return _then(_OtpVerificationModel(
fullPhoneNumber: null == fullPhoneNumber ? _self.fullPhoneNumber : fullPhoneNumber // ignore: cast_nullable_to_non_nullable
as String,otpCode: null == otpCode ? _self.otpCode : otpCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
