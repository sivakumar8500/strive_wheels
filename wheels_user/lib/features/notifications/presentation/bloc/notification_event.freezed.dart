// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationEvent()';
}


}

/// @nodoc
class $NotificationEventCopyWith<$Res>  {
$NotificationEventCopyWith(NotificationEvent _, $Res Function(NotificationEvent) __);
}


/// Adds pattern-matching-related methods to [NotificationEvent].
extension NotificationEventPatterns on NotificationEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EnableNotificationsEvent value)?  enableNotifications,TResult Function( SkipNotificationsEvent value)?  skipNotifications,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EnableNotificationsEvent() when enableNotifications != null:
return enableNotifications(_that);case SkipNotificationsEvent() when skipNotifications != null:
return skipNotifications(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EnableNotificationsEvent value)  enableNotifications,required TResult Function( SkipNotificationsEvent value)  skipNotifications,}){
final _that = this;
switch (_that) {
case EnableNotificationsEvent():
return enableNotifications(_that);case SkipNotificationsEvent():
return skipNotifications(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EnableNotificationsEvent value)?  enableNotifications,TResult? Function( SkipNotificationsEvent value)?  skipNotifications,}){
final _that = this;
switch (_that) {
case EnableNotificationsEvent() when enableNotifications != null:
return enableNotifications(_that);case SkipNotificationsEvent() when skipNotifications != null:
return skipNotifications(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  enableNotifications,TResult Function()?  skipNotifications,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EnableNotificationsEvent() when enableNotifications != null:
return enableNotifications();case SkipNotificationsEvent() when skipNotifications != null:
return skipNotifications();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  enableNotifications,required TResult Function()  skipNotifications,}) {final _that = this;
switch (_that) {
case EnableNotificationsEvent():
return enableNotifications();case SkipNotificationsEvent():
return skipNotifications();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  enableNotifications,TResult? Function()?  skipNotifications,}) {final _that = this;
switch (_that) {
case EnableNotificationsEvent() when enableNotifications != null:
return enableNotifications();case SkipNotificationsEvent() when skipNotifications != null:
return skipNotifications();case _:
  return null;

}
}

}

/// @nodoc


class EnableNotificationsEvent implements NotificationEvent {
  const EnableNotificationsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnableNotificationsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationEvent.enableNotifications()';
}


}




/// @nodoc


class SkipNotificationsEvent implements NotificationEvent {
  const SkipNotificationsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkipNotificationsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationEvent.skipNotifications()';
}


}




// dart format on
