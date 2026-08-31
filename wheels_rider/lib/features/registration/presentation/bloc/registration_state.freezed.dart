// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegistrationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistrationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RegistrationState()';
}


}

/// @nodoc
class $RegistrationStateCopyWith<$Res>  {
$RegistrationStateCopyWith(RegistrationState _, $Res Function(RegistrationState) __);
}


/// Adds pattern-matching-related methods to [RegistrationState].
extension RegistrationStatePatterns on RegistrationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,TResult Function( _Submitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _Submitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,required TResult Function( _Submitted value)  submitted,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);case _Submitted():
return submitted(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,TResult? Function( _Submitted value)?  submitted,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _Submitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( RegistrationStep? currentStep)?  loading,TResult Function( RegistrationEntity registrationData,  RegistrationStep currentStep)?  loaded,TResult Function( String message,  RegistrationStep? currentStep,  RegistrationEntity? previousData)?  error,TResult Function( RegistrationEntity registrationData)?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading(_that.currentStep);case _Loaded() when loaded != null:
return loaded(_that.registrationData,_that.currentStep);case _Error() when error != null:
return error(_that.message,_that.currentStep,_that.previousData);case _Submitted() when submitted != null:
return submitted(_that.registrationData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( RegistrationStep? currentStep)  loading,required TResult Function( RegistrationEntity registrationData,  RegistrationStep currentStep)  loaded,required TResult Function( String message,  RegistrationStep? currentStep,  RegistrationEntity? previousData)  error,required TResult Function( RegistrationEntity registrationData)  submitted,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading(_that.currentStep);case _Loaded():
return loaded(_that.registrationData,_that.currentStep);case _Error():
return error(_that.message,_that.currentStep,_that.previousData);case _Submitted():
return submitted(_that.registrationData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( RegistrationStep? currentStep)?  loading,TResult? Function( RegistrationEntity registrationData,  RegistrationStep currentStep)?  loaded,TResult? Function( String message,  RegistrationStep? currentStep,  RegistrationEntity? previousData)?  error,TResult? Function( RegistrationEntity registrationData)?  submitted,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading(_that.currentStep);case _Loaded() when loaded != null:
return loaded(_that.registrationData,_that.currentStep);case _Error() when error != null:
return error(_that.message,_that.currentStep,_that.previousData);case _Submitted() when submitted != null:
return submitted(_that.registrationData);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements RegistrationState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RegistrationState.initial()';
}


}




/// @nodoc


class _Loading implements RegistrationState {
  const _Loading({this.currentStep});
  

 final  RegistrationStep? currentStep;

/// Create a copy of RegistrationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadingCopyWith<_Loading> get copyWith => __$LoadingCopyWithImpl<_Loading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep));
}


@override
int get hashCode => Object.hash(runtimeType,currentStep);

@override
String toString() {
  return 'RegistrationState.loading(currentStep: $currentStep)';
}


}

/// @nodoc
abstract mixin class _$LoadingCopyWith<$Res> implements $RegistrationStateCopyWith<$Res> {
  factory _$LoadingCopyWith(_Loading value, $Res Function(_Loading) _then) = __$LoadingCopyWithImpl;
@useResult
$Res call({
 RegistrationStep? currentStep
});




}
/// @nodoc
class __$LoadingCopyWithImpl<$Res>
    implements _$LoadingCopyWith<$Res> {
  __$LoadingCopyWithImpl(this._self, this._then);

  final _Loading _self;
  final $Res Function(_Loading) _then;

/// Create a copy of RegistrationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currentStep = freezed,}) {
  return _then(_Loading(
currentStep: freezed == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as RegistrationStep?,
  ));
}


}

/// @nodoc


class _Loaded implements RegistrationState {
  const _Loaded({required this.registrationData, required this.currentStep});
  

 final  RegistrationEntity registrationData;
 final  RegistrationStep currentStep;

/// Create a copy of RegistrationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.registrationData, registrationData) || other.registrationData == registrationData)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep));
}


@override
int get hashCode => Object.hash(runtimeType,registrationData,currentStep);

@override
String toString() {
  return 'RegistrationState.loaded(registrationData: $registrationData, currentStep: $currentStep)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $RegistrationStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 RegistrationEntity registrationData, RegistrationStep currentStep
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of RegistrationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? registrationData = null,Object? currentStep = null,}) {
  return _then(_Loaded(
registrationData: null == registrationData ? _self.registrationData : registrationData // ignore: cast_nullable_to_non_nullable
as RegistrationEntity,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as RegistrationStep,
  ));
}


}

/// @nodoc


class _Error implements RegistrationState {
  const _Error({required this.message, this.currentStep, this.previousData});
  

 final  String message;
 final  RegistrationStep? currentStep;
 final  RegistrationEntity? previousData;

/// Create a copy of RegistrationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.previousData, previousData) || other.previousData == previousData));
}


@override
int get hashCode => Object.hash(runtimeType,message,currentStep,previousData);

@override
String toString() {
  return 'RegistrationState.error(message: $message, currentStep: $currentStep, previousData: $previousData)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $RegistrationStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message, RegistrationStep? currentStep, RegistrationEntity? previousData
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of RegistrationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? currentStep = freezed,Object? previousData = freezed,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,currentStep: freezed == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as RegistrationStep?,previousData: freezed == previousData ? _self.previousData : previousData // ignore: cast_nullable_to_non_nullable
as RegistrationEntity?,
  ));
}


}

/// @nodoc


class _Submitted implements RegistrationState {
  const _Submitted({required this.registrationData});
  

 final  RegistrationEntity registrationData;

/// Create a copy of RegistrationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmittedCopyWith<_Submitted> get copyWith => __$SubmittedCopyWithImpl<_Submitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submitted&&(identical(other.registrationData, registrationData) || other.registrationData == registrationData));
}


@override
int get hashCode => Object.hash(runtimeType,registrationData);

@override
String toString() {
  return 'RegistrationState.submitted(registrationData: $registrationData)';
}


}

/// @nodoc
abstract mixin class _$SubmittedCopyWith<$Res> implements $RegistrationStateCopyWith<$Res> {
  factory _$SubmittedCopyWith(_Submitted value, $Res Function(_Submitted) _then) = __$SubmittedCopyWithImpl;
@useResult
$Res call({
 RegistrationEntity registrationData
});




}
/// @nodoc
class __$SubmittedCopyWithImpl<$Res>
    implements _$SubmittedCopyWith<$Res> {
  __$SubmittedCopyWithImpl(this._self, this._then);

  final _Submitted _self;
  final $Res Function(_Submitted) _then;

/// Create a copy of RegistrationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? registrationData = null,}) {
  return _then(_Submitted(
registrationData: null == registrationData ? _self.registrationData : registrationData // ignore: cast_nullable_to_non_nullable
as RegistrationEntity,
  ));
}


}

// dart format on
