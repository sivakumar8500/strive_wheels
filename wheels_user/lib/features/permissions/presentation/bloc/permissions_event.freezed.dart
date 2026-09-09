// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permissions_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PermissionsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PermissionsEvent()';
}


}

/// @nodoc
class $PermissionsEventCopyWith<$Res>  {
$PermissionsEventCopyWith(PermissionsEvent _, $Res Function(PermissionsEvent) __);
}


/// Adds pattern-matching-related methods to [PermissionsEvent].
extension PermissionsEventPatterns on PermissionsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadPermissionsEvent value)?  loadPermissions,TResult Function( ToggleNotificationEvent value)?  toggleNotification,TResult Function( ToggleContactsEvent value)?  toggleContacts,TResult Function( ToggleLocationEvent value)?  toggleLocation,TResult Function( SubmitPermissionsEvent value)?  submitPermissions,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadPermissionsEvent() when loadPermissions != null:
return loadPermissions(_that);case ToggleNotificationEvent() when toggleNotification != null:
return toggleNotification(_that);case ToggleContactsEvent() when toggleContacts != null:
return toggleContacts(_that);case ToggleLocationEvent() when toggleLocation != null:
return toggleLocation(_that);case SubmitPermissionsEvent() when submitPermissions != null:
return submitPermissions(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadPermissionsEvent value)  loadPermissions,required TResult Function( ToggleNotificationEvent value)  toggleNotification,required TResult Function( ToggleContactsEvent value)  toggleContacts,required TResult Function( ToggleLocationEvent value)  toggleLocation,required TResult Function( SubmitPermissionsEvent value)  submitPermissions,}){
final _that = this;
switch (_that) {
case LoadPermissionsEvent():
return loadPermissions(_that);case ToggleNotificationEvent():
return toggleNotification(_that);case ToggleContactsEvent():
return toggleContacts(_that);case ToggleLocationEvent():
return toggleLocation(_that);case SubmitPermissionsEvent():
return submitPermissions(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadPermissionsEvent value)?  loadPermissions,TResult? Function( ToggleNotificationEvent value)?  toggleNotification,TResult? Function( ToggleContactsEvent value)?  toggleContacts,TResult? Function( ToggleLocationEvent value)?  toggleLocation,TResult? Function( SubmitPermissionsEvent value)?  submitPermissions,}){
final _that = this;
switch (_that) {
case LoadPermissionsEvent() when loadPermissions != null:
return loadPermissions(_that);case ToggleNotificationEvent() when toggleNotification != null:
return toggleNotification(_that);case ToggleContactsEvent() when toggleContacts != null:
return toggleContacts(_that);case ToggleLocationEvent() when toggleLocation != null:
return toggleLocation(_that);case SubmitPermissionsEvent() when submitPermissions != null:
return submitPermissions(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadPermissions,TResult Function( bool value)?  toggleNotification,TResult Function( bool value)?  toggleContacts,TResult Function( bool value)?  toggleLocation,TResult Function()?  submitPermissions,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadPermissionsEvent() when loadPermissions != null:
return loadPermissions();case ToggleNotificationEvent() when toggleNotification != null:
return toggleNotification(_that.value);case ToggleContactsEvent() when toggleContacts != null:
return toggleContacts(_that.value);case ToggleLocationEvent() when toggleLocation != null:
return toggleLocation(_that.value);case SubmitPermissionsEvent() when submitPermissions != null:
return submitPermissions();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadPermissions,required TResult Function( bool value)  toggleNotification,required TResult Function( bool value)  toggleContacts,required TResult Function( bool value)  toggleLocation,required TResult Function()  submitPermissions,}) {final _that = this;
switch (_that) {
case LoadPermissionsEvent():
return loadPermissions();case ToggleNotificationEvent():
return toggleNotification(_that.value);case ToggleContactsEvent():
return toggleContacts(_that.value);case ToggleLocationEvent():
return toggleLocation(_that.value);case SubmitPermissionsEvent():
return submitPermissions();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadPermissions,TResult? Function( bool value)?  toggleNotification,TResult? Function( bool value)?  toggleContacts,TResult? Function( bool value)?  toggleLocation,TResult? Function()?  submitPermissions,}) {final _that = this;
switch (_that) {
case LoadPermissionsEvent() when loadPermissions != null:
return loadPermissions();case ToggleNotificationEvent() when toggleNotification != null:
return toggleNotification(_that.value);case ToggleContactsEvent() when toggleContacts != null:
return toggleContacts(_that.value);case ToggleLocationEvent() when toggleLocation != null:
return toggleLocation(_that.value);case SubmitPermissionsEvent() when submitPermissions != null:
return submitPermissions();case _:
  return null;

}
}

}

/// @nodoc


class LoadPermissionsEvent extends PermissionsEvent {
  const LoadPermissionsEvent(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadPermissionsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PermissionsEvent.loadPermissions()';
}


}




/// @nodoc


class ToggleNotificationEvent extends PermissionsEvent {
  const ToggleNotificationEvent(this.value): super._();
  

 final  bool value;

/// Create a copy of PermissionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleNotificationEventCopyWith<ToggleNotificationEvent> get copyWith => _$ToggleNotificationEventCopyWithImpl<ToggleNotificationEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleNotificationEvent&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'PermissionsEvent.toggleNotification(value: $value)';
}


}

/// @nodoc
abstract mixin class $ToggleNotificationEventCopyWith<$Res> implements $PermissionsEventCopyWith<$Res> {
  factory $ToggleNotificationEventCopyWith(ToggleNotificationEvent value, $Res Function(ToggleNotificationEvent) _then) = _$ToggleNotificationEventCopyWithImpl;
@useResult
$Res call({
 bool value
});




}
/// @nodoc
class _$ToggleNotificationEventCopyWithImpl<$Res>
    implements $ToggleNotificationEventCopyWith<$Res> {
  _$ToggleNotificationEventCopyWithImpl(this._self, this._then);

  final ToggleNotificationEvent _self;
  final $Res Function(ToggleNotificationEvent) _then;

/// Create a copy of PermissionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(ToggleNotificationEvent(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ToggleContactsEvent extends PermissionsEvent {
  const ToggleContactsEvent(this.value): super._();
  

 final  bool value;

/// Create a copy of PermissionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleContactsEventCopyWith<ToggleContactsEvent> get copyWith => _$ToggleContactsEventCopyWithImpl<ToggleContactsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleContactsEvent&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'PermissionsEvent.toggleContacts(value: $value)';
}


}

/// @nodoc
abstract mixin class $ToggleContactsEventCopyWith<$Res> implements $PermissionsEventCopyWith<$Res> {
  factory $ToggleContactsEventCopyWith(ToggleContactsEvent value, $Res Function(ToggleContactsEvent) _then) = _$ToggleContactsEventCopyWithImpl;
@useResult
$Res call({
 bool value
});




}
/// @nodoc
class _$ToggleContactsEventCopyWithImpl<$Res>
    implements $ToggleContactsEventCopyWith<$Res> {
  _$ToggleContactsEventCopyWithImpl(this._self, this._then);

  final ToggleContactsEvent _self;
  final $Res Function(ToggleContactsEvent) _then;

/// Create a copy of PermissionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(ToggleContactsEvent(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ToggleLocationEvent extends PermissionsEvent {
  const ToggleLocationEvent(this.value): super._();
  

 final  bool value;

/// Create a copy of PermissionsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleLocationEventCopyWith<ToggleLocationEvent> get copyWith => _$ToggleLocationEventCopyWithImpl<ToggleLocationEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleLocationEvent&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'PermissionsEvent.toggleLocation(value: $value)';
}


}

/// @nodoc
abstract mixin class $ToggleLocationEventCopyWith<$Res> implements $PermissionsEventCopyWith<$Res> {
  factory $ToggleLocationEventCopyWith(ToggleLocationEvent value, $Res Function(ToggleLocationEvent) _then) = _$ToggleLocationEventCopyWithImpl;
@useResult
$Res call({
 bool value
});




}
/// @nodoc
class _$ToggleLocationEventCopyWithImpl<$Res>
    implements $ToggleLocationEventCopyWith<$Res> {
  _$ToggleLocationEventCopyWithImpl(this._self, this._then);

  final ToggleLocationEvent _self;
  final $Res Function(ToggleLocationEvent) _then;

/// Create a copy of PermissionsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(ToggleLocationEvent(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SubmitPermissionsEvent extends PermissionsEvent {
  const SubmitPermissionsEvent(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitPermissionsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PermissionsEvent.submitPermissions()';
}


}




// dart format on
