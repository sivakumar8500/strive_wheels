// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DriverRegistration {

@JsonKey(name: 'registration_id') int? get registrationId; String? get status;@JsonKey(name: 'is_completed') bool? get isCompleted;@JsonKey(name: 'current_step') int? get currentStep;
/// Create a copy of DriverRegistration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverRegistrationCopyWith<DriverRegistration> get copyWith => _$DriverRegistrationCopyWithImpl<DriverRegistration>(this as DriverRegistration, _$identity);

  /// Serializes this DriverRegistration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverRegistration&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,registrationId,status,isCompleted,currentStep);

@override
String toString() {
  return 'DriverRegistration(registrationId: $registrationId, status: $status, isCompleted: $isCompleted, currentStep: $currentStep)';
}


}

/// @nodoc
abstract mixin class $DriverRegistrationCopyWith<$Res>  {
  factory $DriverRegistrationCopyWith(DriverRegistration value, $Res Function(DriverRegistration) _then) = _$DriverRegistrationCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'registration_id') int? registrationId, String? status,@JsonKey(name: 'is_completed') bool? isCompleted,@JsonKey(name: 'current_step') int? currentStep
});




}
/// @nodoc
class _$DriverRegistrationCopyWithImpl<$Res>
    implements $DriverRegistrationCopyWith<$Res> {
  _$DriverRegistrationCopyWithImpl(this._self, this._then);

  final DriverRegistration _self;
  final $Res Function(DriverRegistration) _then;

/// Create a copy of DriverRegistration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? registrationId = freezed,Object? status = freezed,Object? isCompleted = freezed,Object? currentStep = freezed,}) {
  return _then(_self.copyWith(
registrationId: freezed == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: freezed == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool?,currentStep: freezed == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DriverRegistration].
extension DriverRegistrationPatterns on DriverRegistration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverRegistration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverRegistration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverRegistration value)  $default,){
final _that = this;
switch (_that) {
case _DriverRegistration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverRegistration value)?  $default,){
final _that = this;
switch (_that) {
case _DriverRegistration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'registration_id')  int? registrationId,  String? status, @JsonKey(name: 'is_completed')  bool? isCompleted, @JsonKey(name: 'current_step')  int? currentStep)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverRegistration() when $default != null:
return $default(_that.registrationId,_that.status,_that.isCompleted,_that.currentStep);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'registration_id')  int? registrationId,  String? status, @JsonKey(name: 'is_completed')  bool? isCompleted, @JsonKey(name: 'current_step')  int? currentStep)  $default,) {final _that = this;
switch (_that) {
case _DriverRegistration():
return $default(_that.registrationId,_that.status,_that.isCompleted,_that.currentStep);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'registration_id')  int? registrationId,  String? status, @JsonKey(name: 'is_completed')  bool? isCompleted, @JsonKey(name: 'current_step')  int? currentStep)?  $default,) {final _that = this;
switch (_that) {
case _DriverRegistration() when $default != null:
return $default(_that.registrationId,_that.status,_that.isCompleted,_that.currentStep);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DriverRegistration implements DriverRegistration {
  const _DriverRegistration({@JsonKey(name: 'registration_id') this.registrationId, this.status, @JsonKey(name: 'is_completed') this.isCompleted, @JsonKey(name: 'current_step') this.currentStep});
  factory _DriverRegistration.fromJson(Map<String, dynamic> json) => _$DriverRegistrationFromJson(json);

@override@JsonKey(name: 'registration_id') final  int? registrationId;
@override final  String? status;
@override@JsonKey(name: 'is_completed') final  bool? isCompleted;
@override@JsonKey(name: 'current_step') final  int? currentStep;

/// Create a copy of DriverRegistration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverRegistrationCopyWith<_DriverRegistration> get copyWith => __$DriverRegistrationCopyWithImpl<_DriverRegistration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DriverRegistrationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverRegistration&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,registrationId,status,isCompleted,currentStep);

@override
String toString() {
  return 'DriverRegistration(registrationId: $registrationId, status: $status, isCompleted: $isCompleted, currentStep: $currentStep)';
}


}

/// @nodoc
abstract mixin class _$DriverRegistrationCopyWith<$Res> implements $DriverRegistrationCopyWith<$Res> {
  factory _$DriverRegistrationCopyWith(_DriverRegistration value, $Res Function(_DriverRegistration) _then) = __$DriverRegistrationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'registration_id') int? registrationId, String? status,@JsonKey(name: 'is_completed') bool? isCompleted,@JsonKey(name: 'current_step') int? currentStep
});




}
/// @nodoc
class __$DriverRegistrationCopyWithImpl<$Res>
    implements _$DriverRegistrationCopyWith<$Res> {
  __$DriverRegistrationCopyWithImpl(this._self, this._then);

  final _DriverRegistration _self;
  final $Res Function(_DriverRegistration) _then;

/// Create a copy of DriverRegistration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? registrationId = freezed,Object? status = freezed,Object? isCompleted = freezed,Object? currentStep = freezed,}) {
  return _then(_DriverRegistration(
registrationId: freezed == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: freezed == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool?,currentStep: freezed == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
