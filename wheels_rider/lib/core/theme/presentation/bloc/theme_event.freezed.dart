// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ThemeEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeEvent()';
}


}

/// @nodoc
class $ThemeEventCopyWith<$Res>  {
$ThemeEventCopyWith(ThemeEvent _, $Res Function(ThemeEvent) __);
}


/// Adds pattern-matching-related methods to [ThemeEvent].
extension ThemeEventPatterns on ThemeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadTheme value)?  loadTheme,TResult Function( _ChangeTheme value)?  changeTheme,TResult Function( _ToggleTheme value)?  toggleTheme,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadTheme() when loadTheme != null:
return loadTheme(_that);case _ChangeTheme() when changeTheme != null:
return changeTheme(_that);case _ToggleTheme() when toggleTheme != null:
return toggleTheme(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadTheme value)  loadTheme,required TResult Function( _ChangeTheme value)  changeTheme,required TResult Function( _ToggleTheme value)  toggleTheme,}){
final _that = this;
switch (_that) {
case _LoadTheme():
return loadTheme(_that);case _ChangeTheme():
return changeTheme(_that);case _ToggleTheme():
return toggleTheme(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadTheme value)?  loadTheme,TResult? Function( _ChangeTheme value)?  changeTheme,TResult? Function( _ToggleTheme value)?  toggleTheme,}){
final _that = this;
switch (_that) {
case _LoadTheme() when loadTheme != null:
return loadTheme(_that);case _ChangeTheme() when changeTheme != null:
return changeTheme(_that);case _ToggleTheme() when toggleTheme != null:
return toggleTheme(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadTheme,TResult Function( ThemeMode themeMode)?  changeTheme,TResult Function()?  toggleTheme,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadTheme() when loadTheme != null:
return loadTheme();case _ChangeTheme() when changeTheme != null:
return changeTheme(_that.themeMode);case _ToggleTheme() when toggleTheme != null:
return toggleTheme();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadTheme,required TResult Function( ThemeMode themeMode)  changeTheme,required TResult Function()  toggleTheme,}) {final _that = this;
switch (_that) {
case _LoadTheme():
return loadTheme();case _ChangeTheme():
return changeTheme(_that.themeMode);case _ToggleTheme():
return toggleTheme();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadTheme,TResult? Function( ThemeMode themeMode)?  changeTheme,TResult? Function()?  toggleTheme,}) {final _that = this;
switch (_that) {
case _LoadTheme() when loadTheme != null:
return loadTheme();case _ChangeTheme() when changeTheme != null:
return changeTheme(_that.themeMode);case _ToggleTheme() when toggleTheme != null:
return toggleTheme();case _:
  return null;

}
}

}

/// @nodoc


class _LoadTheme implements ThemeEvent {
  const _LoadTheme();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadTheme);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeEvent.loadTheme()';
}


}




/// @nodoc


class _ChangeTheme implements ThemeEvent {
  const _ChangeTheme(this.themeMode);
  

 final  ThemeMode themeMode;

/// Create a copy of ThemeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangeThemeCopyWith<_ChangeTheme> get copyWith => __$ChangeThemeCopyWithImpl<_ChangeTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangeTheme&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode);

@override
String toString() {
  return 'ThemeEvent.changeTheme(themeMode: $themeMode)';
}


}

/// @nodoc
abstract mixin class _$ChangeThemeCopyWith<$Res> implements $ThemeEventCopyWith<$Res> {
  factory _$ChangeThemeCopyWith(_ChangeTheme value, $Res Function(_ChangeTheme) _then) = __$ChangeThemeCopyWithImpl;
@useResult
$Res call({
 ThemeMode themeMode
});




}
/// @nodoc
class __$ChangeThemeCopyWithImpl<$Res>
    implements _$ChangeThemeCopyWith<$Res> {
  __$ChangeThemeCopyWithImpl(this._self, this._then);

  final _ChangeTheme _self;
  final $Res Function(_ChangeTheme) _then;

/// Create a copy of ThemeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? themeMode = null,}) {
  return _then(_ChangeTheme(
null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}


}

/// @nodoc


class _ToggleTheme implements ThemeEvent {
  const _ToggleTheme();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleTheme);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeEvent.toggleTheme()';
}


}




// dart format on
