// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent()';
}


}

/// @nodoc
class $HomeEventCopyWith<$Res>  {
$HomeEventCopyWith(HomeEvent _, $Res Function(HomeEvent) __);
}


/// Adds pattern-matching-related methods to [HomeEvent].
extension HomeEventPatterns on HomeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _UpdateLocation value)?  updateLocation,TResult Function( _UpdateAvailability value)?  updateAvailability,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateLocation() when updateLocation != null:
return updateLocation(_that);case _UpdateAvailability() when updateAvailability != null:
return updateAvailability(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _UpdateLocation value)  updateLocation,required TResult Function( _UpdateAvailability value)  updateAvailability,}){
final _that = this;
switch (_that) {
case _UpdateLocation():
return updateLocation(_that);case _UpdateAvailability():
return updateAvailability(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _UpdateLocation value)?  updateLocation,TResult? Function( _UpdateAvailability value)?  updateAvailability,}){
final _that = this;
switch (_that) {
case _UpdateLocation() when updateLocation != null:
return updateLocation(_that);case _UpdateAvailability() when updateAvailability != null:
return updateAvailability(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( double lat,  double lng)?  updateLocation,TResult Function( String availabilityMode,  bool isOnline)?  updateAvailability,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateLocation() when updateLocation != null:
return updateLocation(_that.lat,_that.lng);case _UpdateAvailability() when updateAvailability != null:
return updateAvailability(_that.availabilityMode,_that.isOnline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( double lat,  double lng)  updateLocation,required TResult Function( String availabilityMode,  bool isOnline)  updateAvailability,}) {final _that = this;
switch (_that) {
case _UpdateLocation():
return updateLocation(_that.lat,_that.lng);case _UpdateAvailability():
return updateAvailability(_that.availabilityMode,_that.isOnline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( double lat,  double lng)?  updateLocation,TResult? Function( String availabilityMode,  bool isOnline)?  updateAvailability,}) {final _that = this;
switch (_that) {
case _UpdateLocation() when updateLocation != null:
return updateLocation(_that.lat,_that.lng);case _UpdateAvailability() when updateAvailability != null:
return updateAvailability(_that.availabilityMode,_that.isOnline);case _:
  return null;

}
}

}

/// @nodoc


class _UpdateLocation implements HomeEvent {
  const _UpdateLocation({required this.lat, required this.lng});
  

 final  double lat;
 final  double lng;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateLocationCopyWith<_UpdateLocation> get copyWith => __$UpdateLocationCopyWithImpl<_UpdateLocation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateLocation&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}


@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'HomeEvent.updateLocation(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$UpdateLocationCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory _$UpdateLocationCopyWith(_UpdateLocation value, $Res Function(_UpdateLocation) _then) = __$UpdateLocationCopyWithImpl;
@useResult
$Res call({
 double lat, double lng
});




}
/// @nodoc
class __$UpdateLocationCopyWithImpl<$Res>
    implements _$UpdateLocationCopyWith<$Res> {
  __$UpdateLocationCopyWithImpl(this._self, this._then);

  final _UpdateLocation _self;
  final $Res Function(_UpdateLocation) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,}) {
  return _then(_UpdateLocation(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _UpdateAvailability implements HomeEvent {
  const _UpdateAvailability({required this.availabilityMode, required this.isOnline});
  

 final  String availabilityMode;
 final  bool isOnline;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateAvailabilityCopyWith<_UpdateAvailability> get copyWith => __$UpdateAvailabilityCopyWithImpl<_UpdateAvailability>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateAvailability&&(identical(other.availabilityMode, availabilityMode) || other.availabilityMode == availabilityMode)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}


@override
int get hashCode => Object.hash(runtimeType,availabilityMode,isOnline);

@override
String toString() {
  return 'HomeEvent.updateAvailability(availabilityMode: $availabilityMode, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class _$UpdateAvailabilityCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory _$UpdateAvailabilityCopyWith(_UpdateAvailability value, $Res Function(_UpdateAvailability) _then) = __$UpdateAvailabilityCopyWithImpl;
@useResult
$Res call({
 String availabilityMode, bool isOnline
});




}
/// @nodoc
class __$UpdateAvailabilityCopyWithImpl<$Res>
    implements _$UpdateAvailabilityCopyWith<$Res> {
  __$UpdateAvailabilityCopyWithImpl(this._self, this._then);

  final _UpdateAvailability _self;
  final $Res Function(_UpdateAvailability) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? availabilityMode = null,Object? isOnline = null,}) {
  return _then(_UpdateAvailability(
availabilityMode: null == availabilityMode ? _self.availabilityMode : availabilityMode // ignore: cast_nullable_to_non_nullable
as String,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
