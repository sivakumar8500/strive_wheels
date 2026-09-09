// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginEvent()';
}


}

/// @nodoc
class $LoginEventCopyWith<$Res>  {
$LoginEventCopyWith(LoginEvent _, $Res Function(LoginEvent) __);
}


/// Adds pattern-matching-related methods to [LoginEvent].
extension LoginEventPatterns on LoginEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PhoneNumberChangedEvent value)?  phoneNumberChanged,TResult Function( CountryCodeChangedEvent value)?  countryCodeChanged,TResult Function( SubmitLoginEvent value)?  submitLogin,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PhoneNumberChangedEvent() when phoneNumberChanged != null:
return phoneNumberChanged(_that);case CountryCodeChangedEvent() when countryCodeChanged != null:
return countryCodeChanged(_that);case SubmitLoginEvent() when submitLogin != null:
return submitLogin(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PhoneNumberChangedEvent value)  phoneNumberChanged,required TResult Function( CountryCodeChangedEvent value)  countryCodeChanged,required TResult Function( SubmitLoginEvent value)  submitLogin,}){
final _that = this;
switch (_that) {
case PhoneNumberChangedEvent():
return phoneNumberChanged(_that);case CountryCodeChangedEvent():
return countryCodeChanged(_that);case SubmitLoginEvent():
return submitLogin(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PhoneNumberChangedEvent value)?  phoneNumberChanged,TResult? Function( CountryCodeChangedEvent value)?  countryCodeChanged,TResult? Function( SubmitLoginEvent value)?  submitLogin,}){
final _that = this;
switch (_that) {
case PhoneNumberChangedEvent() when phoneNumberChanged != null:
return phoneNumberChanged(_that);case CountryCodeChangedEvent() when countryCodeChanged != null:
return countryCodeChanged(_that);case SubmitLoginEvent() when submitLogin != null:
return submitLogin(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String phoneNumber)?  phoneNumberChanged,TResult Function( String countryCode)?  countryCodeChanged,TResult Function()?  submitLogin,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PhoneNumberChangedEvent() when phoneNumberChanged != null:
return phoneNumberChanged(_that.phoneNumber);case CountryCodeChangedEvent() when countryCodeChanged != null:
return countryCodeChanged(_that.countryCode);case SubmitLoginEvent() when submitLogin != null:
return submitLogin();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String phoneNumber)  phoneNumberChanged,required TResult Function( String countryCode)  countryCodeChanged,required TResult Function()  submitLogin,}) {final _that = this;
switch (_that) {
case PhoneNumberChangedEvent():
return phoneNumberChanged(_that.phoneNumber);case CountryCodeChangedEvent():
return countryCodeChanged(_that.countryCode);case SubmitLoginEvent():
return submitLogin();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String phoneNumber)?  phoneNumberChanged,TResult? Function( String countryCode)?  countryCodeChanged,TResult? Function()?  submitLogin,}) {final _that = this;
switch (_that) {
case PhoneNumberChangedEvent() when phoneNumberChanged != null:
return phoneNumberChanged(_that.phoneNumber);case CountryCodeChangedEvent() when countryCodeChanged != null:
return countryCodeChanged(_that.countryCode);case SubmitLoginEvent() when submitLogin != null:
return submitLogin();case _:
  return null;

}
}

}

/// @nodoc


class PhoneNumberChangedEvent implements LoginEvent {
  const PhoneNumberChangedEvent(this.phoneNumber);
  

 final  String phoneNumber;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneNumberChangedEventCopyWith<PhoneNumberChangedEvent> get copyWith => _$PhoneNumberChangedEventCopyWithImpl<PhoneNumberChangedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneNumberChangedEvent&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber);

@override
String toString() {
  return 'LoginEvent.phoneNumberChanged(phoneNumber: $phoneNumber)';
}


}

/// @nodoc
abstract mixin class $PhoneNumberChangedEventCopyWith<$Res> implements $LoginEventCopyWith<$Res> {
  factory $PhoneNumberChangedEventCopyWith(PhoneNumberChangedEvent value, $Res Function(PhoneNumberChangedEvent) _then) = _$PhoneNumberChangedEventCopyWithImpl;
@useResult
$Res call({
 String phoneNumber
});




}
/// @nodoc
class _$PhoneNumberChangedEventCopyWithImpl<$Res>
    implements $PhoneNumberChangedEventCopyWith<$Res> {
  _$PhoneNumberChangedEventCopyWithImpl(this._self, this._then);

  final PhoneNumberChangedEvent _self;
  final $Res Function(PhoneNumberChangedEvent) _then;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phoneNumber = null,}) {
  return _then(PhoneNumberChangedEvent(
null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CountryCodeChangedEvent implements LoginEvent {
  const CountryCodeChangedEvent(this.countryCode);
  

 final  String countryCode;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountryCodeChangedEventCopyWith<CountryCodeChangedEvent> get copyWith => _$CountryCodeChangedEventCopyWithImpl<CountryCodeChangedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CountryCodeChangedEvent&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}


@override
int get hashCode => Object.hash(runtimeType,countryCode);

@override
String toString() {
  return 'LoginEvent.countryCodeChanged(countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class $CountryCodeChangedEventCopyWith<$Res> implements $LoginEventCopyWith<$Res> {
  factory $CountryCodeChangedEventCopyWith(CountryCodeChangedEvent value, $Res Function(CountryCodeChangedEvent) _then) = _$CountryCodeChangedEventCopyWithImpl;
@useResult
$Res call({
 String countryCode
});




}
/// @nodoc
class _$CountryCodeChangedEventCopyWithImpl<$Res>
    implements $CountryCodeChangedEventCopyWith<$Res> {
  _$CountryCodeChangedEventCopyWithImpl(this._self, this._then);

  final CountryCodeChangedEvent _self;
  final $Res Function(CountryCodeChangedEvent) _then;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? countryCode = null,}) {
  return _then(CountryCodeChangedEvent(
null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SubmitLoginEvent implements LoginEvent {
  const SubmitLoginEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitLoginEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginEvent.submitLogin()';
}


}




// dart format on
