// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permissions_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PermissionsState {

 bool get notificationsAllowed; bool get contactsAllowed; bool get locationAllowed; bool get isLoading; bool get isSubmitting; bool get isSuccess; String? get errorMessage;
/// Create a copy of PermissionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionsStateCopyWith<PermissionsState> get copyWith => _$PermissionsStateCopyWithImpl<PermissionsState>(this as PermissionsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionsState&&(identical(other.notificationsAllowed, notificationsAllowed) || other.notificationsAllowed == notificationsAllowed)&&(identical(other.contactsAllowed, contactsAllowed) || other.contactsAllowed == contactsAllowed)&&(identical(other.locationAllowed, locationAllowed) || other.locationAllowed == locationAllowed)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,notificationsAllowed,contactsAllowed,locationAllowed,isLoading,isSubmitting,isSuccess,errorMessage);

@override
String toString() {
  return 'PermissionsState(notificationsAllowed: $notificationsAllowed, contactsAllowed: $contactsAllowed, locationAllowed: $locationAllowed, isLoading: $isLoading, isSubmitting: $isSubmitting, isSuccess: $isSuccess, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PermissionsStateCopyWith<$Res>  {
  factory $PermissionsStateCopyWith(PermissionsState value, $Res Function(PermissionsState) _then) = _$PermissionsStateCopyWithImpl;
@useResult
$Res call({
 bool notificationsAllowed, bool contactsAllowed, bool locationAllowed, bool isLoading, bool isSubmitting, bool isSuccess, String? errorMessage
});




}
/// @nodoc
class _$PermissionsStateCopyWithImpl<$Res>
    implements $PermissionsStateCopyWith<$Res> {
  _$PermissionsStateCopyWithImpl(this._self, this._then);

  final PermissionsState _self;
  final $Res Function(PermissionsState) _then;

/// Create a copy of PermissionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notificationsAllowed = null,Object? contactsAllowed = null,Object? locationAllowed = null,Object? isLoading = null,Object? isSubmitting = null,Object? isSuccess = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
notificationsAllowed: null == notificationsAllowed ? _self.notificationsAllowed : notificationsAllowed // ignore: cast_nullable_to_non_nullable
as bool,contactsAllowed: null == contactsAllowed ? _self.contactsAllowed : contactsAllowed // ignore: cast_nullable_to_non_nullable
as bool,locationAllowed: null == locationAllowed ? _self.locationAllowed : locationAllowed // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PermissionsState].
extension PermissionsStatePatterns on PermissionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PermissionsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermissionsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PermissionsState value)  $default,){
final _that = this;
switch (_that) {
case _PermissionsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PermissionsState value)?  $default,){
final _that = this;
switch (_that) {
case _PermissionsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool notificationsAllowed,  bool contactsAllowed,  bool locationAllowed,  bool isLoading,  bool isSubmitting,  bool isSuccess,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermissionsState() when $default != null:
return $default(_that.notificationsAllowed,_that.contactsAllowed,_that.locationAllowed,_that.isLoading,_that.isSubmitting,_that.isSuccess,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool notificationsAllowed,  bool contactsAllowed,  bool locationAllowed,  bool isLoading,  bool isSubmitting,  bool isSuccess,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PermissionsState():
return $default(_that.notificationsAllowed,_that.contactsAllowed,_that.locationAllowed,_that.isLoading,_that.isSubmitting,_that.isSuccess,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool notificationsAllowed,  bool contactsAllowed,  bool locationAllowed,  bool isLoading,  bool isSubmitting,  bool isSuccess,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PermissionsState() when $default != null:
return $default(_that.notificationsAllowed,_that.contactsAllowed,_that.locationAllowed,_that.isLoading,_that.isSubmitting,_that.isSuccess,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PermissionsState extends PermissionsState {
  const _PermissionsState({this.notificationsAllowed = false, this.contactsAllowed = false, this.locationAllowed = false, this.isLoading = false, this.isSubmitting = false, this.isSuccess = false, this.errorMessage}): super._();
  

@override@JsonKey() final  bool notificationsAllowed;
@override@JsonKey() final  bool contactsAllowed;
@override@JsonKey() final  bool locationAllowed;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool isSuccess;
@override final  String? errorMessage;

/// Create a copy of PermissionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionsStateCopyWith<_PermissionsState> get copyWith => __$PermissionsStateCopyWithImpl<_PermissionsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionsState&&(identical(other.notificationsAllowed, notificationsAllowed) || other.notificationsAllowed == notificationsAllowed)&&(identical(other.contactsAllowed, contactsAllowed) || other.contactsAllowed == contactsAllowed)&&(identical(other.locationAllowed, locationAllowed) || other.locationAllowed == locationAllowed)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,notificationsAllowed,contactsAllowed,locationAllowed,isLoading,isSubmitting,isSuccess,errorMessage);

@override
String toString() {
  return 'PermissionsState(notificationsAllowed: $notificationsAllowed, contactsAllowed: $contactsAllowed, locationAllowed: $locationAllowed, isLoading: $isLoading, isSubmitting: $isSubmitting, isSuccess: $isSuccess, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PermissionsStateCopyWith<$Res> implements $PermissionsStateCopyWith<$Res> {
  factory _$PermissionsStateCopyWith(_PermissionsState value, $Res Function(_PermissionsState) _then) = __$PermissionsStateCopyWithImpl;
@override @useResult
$Res call({
 bool notificationsAllowed, bool contactsAllowed, bool locationAllowed, bool isLoading, bool isSubmitting, bool isSuccess, String? errorMessage
});




}
/// @nodoc
class __$PermissionsStateCopyWithImpl<$Res>
    implements _$PermissionsStateCopyWith<$Res> {
  __$PermissionsStateCopyWithImpl(this._self, this._then);

  final _PermissionsState _self;
  final $Res Function(_PermissionsState) _then;

/// Create a copy of PermissionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notificationsAllowed = null,Object? contactsAllowed = null,Object? locationAllowed = null,Object? isLoading = null,Object? isSubmitting = null,Object? isSuccess = null,Object? errorMessage = freezed,}) {
  return _then(_PermissionsState(
notificationsAllowed: null == notificationsAllowed ? _self.notificationsAllowed : notificationsAllowed // ignore: cast_nullable_to_non_nullable
as bool,contactsAllowed: null == contactsAllowed ? _self.contactsAllowed : contactsAllowed // ignore: cast_nullable_to_non_nullable
as bool,locationAllowed: null == locationAllowed ? _self.locationAllowed : locationAllowed // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
