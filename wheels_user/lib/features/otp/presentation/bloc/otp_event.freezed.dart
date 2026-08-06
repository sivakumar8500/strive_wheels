// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtpEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpEvent()';
}


}

/// @nodoc
class $OtpEventCopyWith<$Res>  {
$OtpEventCopyWith(OtpEvent _, $Res Function(OtpEvent) __);
}


/// Adds pattern-matching-related methods to [OtpEvent].
extension OtpEventPatterns on OtpEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OtpCodeChangedEvent value)?  otpCodeChanged,TResult Function( SubmitOtpEvent value)?  submitOtp,TResult Function( ResendOtpEvent value)?  resendOtp,TResult Function( StartTimerEvent value)?  startTimer,TResult Function( TimerTickEvent value)?  timerTick,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OtpCodeChangedEvent() when otpCodeChanged != null:
return otpCodeChanged(_that);case SubmitOtpEvent() when submitOtp != null:
return submitOtp(_that);case ResendOtpEvent() when resendOtp != null:
return resendOtp(_that);case StartTimerEvent() when startTimer != null:
return startTimer(_that);case TimerTickEvent() when timerTick != null:
return timerTick(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OtpCodeChangedEvent value)  otpCodeChanged,required TResult Function( SubmitOtpEvent value)  submitOtp,required TResult Function( ResendOtpEvent value)  resendOtp,required TResult Function( StartTimerEvent value)  startTimer,required TResult Function( TimerTickEvent value)  timerTick,}){
final _that = this;
switch (_that) {
case OtpCodeChangedEvent():
return otpCodeChanged(_that);case SubmitOtpEvent():
return submitOtp(_that);case ResendOtpEvent():
return resendOtp(_that);case StartTimerEvent():
return startTimer(_that);case TimerTickEvent():
return timerTick(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OtpCodeChangedEvent value)?  otpCodeChanged,TResult? Function( SubmitOtpEvent value)?  submitOtp,TResult? Function( ResendOtpEvent value)?  resendOtp,TResult? Function( StartTimerEvent value)?  startTimer,TResult? Function( TimerTickEvent value)?  timerTick,}){
final _that = this;
switch (_that) {
case OtpCodeChangedEvent() when otpCodeChanged != null:
return otpCodeChanged(_that);case SubmitOtpEvent() when submitOtp != null:
return submitOtp(_that);case ResendOtpEvent() when resendOtp != null:
return resendOtp(_that);case StartTimerEvent() when startTimer != null:
return startTimer(_that);case TimerTickEvent() when timerTick != null:
return timerTick(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String code)?  otpCodeChanged,TResult Function()?  submitOtp,TResult Function()?  resendOtp,TResult Function()?  startTimer,TResult Function( int secondsRemaining)?  timerTick,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OtpCodeChangedEvent() when otpCodeChanged != null:
return otpCodeChanged(_that.code);case SubmitOtpEvent() when submitOtp != null:
return submitOtp();case ResendOtpEvent() when resendOtp != null:
return resendOtp();case StartTimerEvent() when startTimer != null:
return startTimer();case TimerTickEvent() when timerTick != null:
return timerTick(_that.secondsRemaining);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String code)  otpCodeChanged,required TResult Function()  submitOtp,required TResult Function()  resendOtp,required TResult Function()  startTimer,required TResult Function( int secondsRemaining)  timerTick,}) {final _that = this;
switch (_that) {
case OtpCodeChangedEvent():
return otpCodeChanged(_that.code);case SubmitOtpEvent():
return submitOtp();case ResendOtpEvent():
return resendOtp();case StartTimerEvent():
return startTimer();case TimerTickEvent():
return timerTick(_that.secondsRemaining);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String code)?  otpCodeChanged,TResult? Function()?  submitOtp,TResult? Function()?  resendOtp,TResult? Function()?  startTimer,TResult? Function( int secondsRemaining)?  timerTick,}) {final _that = this;
switch (_that) {
case OtpCodeChangedEvent() when otpCodeChanged != null:
return otpCodeChanged(_that.code);case SubmitOtpEvent() when submitOtp != null:
return submitOtp();case ResendOtpEvent() when resendOtp != null:
return resendOtp();case StartTimerEvent() when startTimer != null:
return startTimer();case TimerTickEvent() when timerTick != null:
return timerTick(_that.secondsRemaining);case _:
  return null;

}
}

}

/// @nodoc


class OtpCodeChangedEvent implements OtpEvent {
  const OtpCodeChangedEvent(this.code);
  

 final  String code;

/// Create a copy of OtpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpCodeChangedEventCopyWith<OtpCodeChangedEvent> get copyWith => _$OtpCodeChangedEventCopyWithImpl<OtpCodeChangedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpCodeChangedEvent&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,code);

@override
String toString() {
  return 'OtpEvent.otpCodeChanged(code: $code)';
}


}

/// @nodoc
abstract mixin class $OtpCodeChangedEventCopyWith<$Res> implements $OtpEventCopyWith<$Res> {
  factory $OtpCodeChangedEventCopyWith(OtpCodeChangedEvent value, $Res Function(OtpCodeChangedEvent) _then) = _$OtpCodeChangedEventCopyWithImpl;
@useResult
$Res call({
 String code
});




}
/// @nodoc
class _$OtpCodeChangedEventCopyWithImpl<$Res>
    implements $OtpCodeChangedEventCopyWith<$Res> {
  _$OtpCodeChangedEventCopyWithImpl(this._self, this._then);

  final OtpCodeChangedEvent _self;
  final $Res Function(OtpCodeChangedEvent) _then;

/// Create a copy of OtpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,}) {
  return _then(OtpCodeChangedEvent(
null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SubmitOtpEvent implements OtpEvent {
  const SubmitOtpEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitOtpEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpEvent.submitOtp()';
}


}




/// @nodoc


class ResendOtpEvent implements OtpEvent {
  const ResendOtpEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResendOtpEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpEvent.resendOtp()';
}


}




/// @nodoc


class StartTimerEvent implements OtpEvent {
  const StartTimerEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartTimerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpEvent.startTimer()';
}


}




/// @nodoc


class TimerTickEvent implements OtpEvent {
  const TimerTickEvent(this.secondsRemaining);
  

 final  int secondsRemaining;

/// Create a copy of OtpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimerTickEventCopyWith<TimerTickEvent> get copyWith => _$TimerTickEventCopyWithImpl<TimerTickEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimerTickEvent&&(identical(other.secondsRemaining, secondsRemaining) || other.secondsRemaining == secondsRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,secondsRemaining);

@override
String toString() {
  return 'OtpEvent.timerTick(secondsRemaining: $secondsRemaining)';
}


}

/// @nodoc
abstract mixin class $TimerTickEventCopyWith<$Res> implements $OtpEventCopyWith<$Res> {
  factory $TimerTickEventCopyWith(TimerTickEvent value, $Res Function(TimerTickEvent) _then) = _$TimerTickEventCopyWithImpl;
@useResult
$Res call({
 int secondsRemaining
});




}
/// @nodoc
class _$TimerTickEventCopyWithImpl<$Res>
    implements $TimerTickEventCopyWith<$Res> {
  _$TimerTickEventCopyWithImpl(this._self, this._then);

  final TimerTickEvent _self;
  final $Res Function(TimerTickEvent) _then;

/// Create a copy of OtpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? secondsRemaining = null,}) {
  return _then(TimerTickEvent(
null == secondsRemaining ? _self.secondsRemaining : secondsRemaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
