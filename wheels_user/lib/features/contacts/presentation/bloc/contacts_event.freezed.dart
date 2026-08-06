// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contacts_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContactsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContactsEvent()';
}


}

/// @nodoc
class $ContactsEventCopyWith<$Res>  {
$ContactsEventCopyWith(ContactsEvent _, $Res Function(ContactsEvent) __);
}


/// Adds pattern-matching-related methods to [ContactsEvent].
extension ContactsEventPatterns on ContactsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AllowContactsEvent value)?  allowContacts,TResult Function( SkipContactsEvent value)?  skipContacts,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AllowContactsEvent() when allowContacts != null:
return allowContacts(_that);case SkipContactsEvent() when skipContacts != null:
return skipContacts(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AllowContactsEvent value)  allowContacts,required TResult Function( SkipContactsEvent value)  skipContacts,}){
final _that = this;
switch (_that) {
case AllowContactsEvent():
return allowContacts(_that);case SkipContactsEvent():
return skipContacts(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AllowContactsEvent value)?  allowContacts,TResult? Function( SkipContactsEvent value)?  skipContacts,}){
final _that = this;
switch (_that) {
case AllowContactsEvent() when allowContacts != null:
return allowContacts(_that);case SkipContactsEvent() when skipContacts != null:
return skipContacts(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  allowContacts,TResult Function()?  skipContacts,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AllowContactsEvent() when allowContacts != null:
return allowContacts();case SkipContactsEvent() when skipContacts != null:
return skipContacts();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  allowContacts,required TResult Function()  skipContacts,}) {final _that = this;
switch (_that) {
case AllowContactsEvent():
return allowContacts();case SkipContactsEvent():
return skipContacts();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  allowContacts,TResult? Function()?  skipContacts,}) {final _that = this;
switch (_that) {
case AllowContactsEvent() when allowContacts != null:
return allowContacts();case SkipContactsEvent() when skipContacts != null:
return skipContacts();case _:
  return null;

}
}

}

/// @nodoc


class AllowContactsEvent implements ContactsEvent {
  const AllowContactsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AllowContactsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContactsEvent.allowContacts()';
}


}




/// @nodoc


class SkipContactsEvent implements ContactsEvent {
  const SkipContactsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkipContactsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContactsEvent.skipContacts()';
}


}




// dart format on
