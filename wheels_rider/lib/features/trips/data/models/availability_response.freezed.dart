// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'availability_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AvailabilityResponse {

 bool get success; AvailabilityData get data;
/// Create a copy of AvailabilityResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailabilityResponseCopyWith<AvailabilityResponse> get copyWith => _$AvailabilityResponseCopyWithImpl<AvailabilityResponse>(this as AvailabilityResponse, _$identity);

  /// Serializes this AvailabilityResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvailabilityResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data);

@override
String toString() {
  return 'AvailabilityResponse(success: $success, data: $data)';
}


}

/// @nodoc
abstract mixin class $AvailabilityResponseCopyWith<$Res>  {
  factory $AvailabilityResponseCopyWith(AvailabilityResponse value, $Res Function(AvailabilityResponse) _then) = _$AvailabilityResponseCopyWithImpl;
@useResult
$Res call({
 bool success, AvailabilityData data
});


$AvailabilityDataCopyWith<$Res> get data;

}
/// @nodoc
class _$AvailabilityResponseCopyWithImpl<$Res>
    implements $AvailabilityResponseCopyWith<$Res> {
  _$AvailabilityResponseCopyWithImpl(this._self, this._then);

  final AvailabilityResponse _self;
  final $Res Function(AvailabilityResponse) _then;

/// Create a copy of AvailabilityResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AvailabilityData,
  ));
}
/// Create a copy of AvailabilityResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AvailabilityDataCopyWith<$Res> get data {
  
  return $AvailabilityDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AvailabilityResponse].
extension AvailabilityResponsePatterns on AvailabilityResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvailabilityResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvailabilityResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvailabilityResponse value)  $default,){
final _that = this;
switch (_that) {
case _AvailabilityResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvailabilityResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AvailabilityResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  AvailabilityData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvailabilityResponse() when $default != null:
return $default(_that.success,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  AvailabilityData data)  $default,) {final _that = this;
switch (_that) {
case _AvailabilityResponse():
return $default(_that.success,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  AvailabilityData data)?  $default,) {final _that = this;
switch (_that) {
case _AvailabilityResponse() when $default != null:
return $default(_that.success,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvailabilityResponse implements AvailabilityResponse {
  const _AvailabilityResponse({required this.success, required this.data});
  factory _AvailabilityResponse.fromJson(Map<String, dynamic> json) => _$AvailabilityResponseFromJson(json);

@override final  bool success;
@override final  AvailabilityData data;

/// Create a copy of AvailabilityResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailabilityResponseCopyWith<_AvailabilityResponse> get copyWith => __$AvailabilityResponseCopyWithImpl<_AvailabilityResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvailabilityResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvailabilityResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data);

@override
String toString() {
  return 'AvailabilityResponse(success: $success, data: $data)';
}


}

/// @nodoc
abstract mixin class _$AvailabilityResponseCopyWith<$Res> implements $AvailabilityResponseCopyWith<$Res> {
  factory _$AvailabilityResponseCopyWith(_AvailabilityResponse value, $Res Function(_AvailabilityResponse) _then) = __$AvailabilityResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, AvailabilityData data
});


@override $AvailabilityDataCopyWith<$Res> get data;

}
/// @nodoc
class __$AvailabilityResponseCopyWithImpl<$Res>
    implements _$AvailabilityResponseCopyWith<$Res> {
  __$AvailabilityResponseCopyWithImpl(this._self, this._then);

  final _AvailabilityResponse _self;
  final $Res Function(_AvailabilityResponse) _then;

/// Create a copy of AvailabilityResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,}) {
  return _then(_AvailabilityResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AvailabilityData,
  ));
}

/// Create a copy of AvailabilityResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AvailabilityDataCopyWith<$Res> get data {
  
  return $AvailabilityDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$AvailabilityData {

@JsonKey(name: 'availability_mode') String get availabilityMode;@JsonKey(name: 'is_online') bool get isOnline;
/// Create a copy of AvailabilityData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailabilityDataCopyWith<AvailabilityData> get copyWith => _$AvailabilityDataCopyWithImpl<AvailabilityData>(this as AvailabilityData, _$identity);

  /// Serializes this AvailabilityData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvailabilityData&&(identical(other.availabilityMode, availabilityMode) || other.availabilityMode == availabilityMode)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,availabilityMode,isOnline);

@override
String toString() {
  return 'AvailabilityData(availabilityMode: $availabilityMode, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class $AvailabilityDataCopyWith<$Res>  {
  factory $AvailabilityDataCopyWith(AvailabilityData value, $Res Function(AvailabilityData) _then) = _$AvailabilityDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'availability_mode') String availabilityMode,@JsonKey(name: 'is_online') bool isOnline
});




}
/// @nodoc
class _$AvailabilityDataCopyWithImpl<$Res>
    implements $AvailabilityDataCopyWith<$Res> {
  _$AvailabilityDataCopyWithImpl(this._self, this._then);

  final AvailabilityData _self;
  final $Res Function(AvailabilityData) _then;

/// Create a copy of AvailabilityData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? availabilityMode = null,Object? isOnline = null,}) {
  return _then(_self.copyWith(
availabilityMode: null == availabilityMode ? _self.availabilityMode : availabilityMode // ignore: cast_nullable_to_non_nullable
as String,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AvailabilityData].
extension AvailabilityDataPatterns on AvailabilityData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvailabilityData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvailabilityData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvailabilityData value)  $default,){
final _that = this;
switch (_that) {
case _AvailabilityData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvailabilityData value)?  $default,){
final _that = this;
switch (_that) {
case _AvailabilityData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'availability_mode')  String availabilityMode, @JsonKey(name: 'is_online')  bool isOnline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvailabilityData() when $default != null:
return $default(_that.availabilityMode,_that.isOnline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'availability_mode')  String availabilityMode, @JsonKey(name: 'is_online')  bool isOnline)  $default,) {final _that = this;
switch (_that) {
case _AvailabilityData():
return $default(_that.availabilityMode,_that.isOnline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'availability_mode')  String availabilityMode, @JsonKey(name: 'is_online')  bool isOnline)?  $default,) {final _that = this;
switch (_that) {
case _AvailabilityData() when $default != null:
return $default(_that.availabilityMode,_that.isOnline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvailabilityData implements AvailabilityData {
  const _AvailabilityData({@JsonKey(name: 'availability_mode') required this.availabilityMode, @JsonKey(name: 'is_online') required this.isOnline});
  factory _AvailabilityData.fromJson(Map<String, dynamic> json) => _$AvailabilityDataFromJson(json);

@override@JsonKey(name: 'availability_mode') final  String availabilityMode;
@override@JsonKey(name: 'is_online') final  bool isOnline;

/// Create a copy of AvailabilityData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailabilityDataCopyWith<_AvailabilityData> get copyWith => __$AvailabilityDataCopyWithImpl<_AvailabilityData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvailabilityDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvailabilityData&&(identical(other.availabilityMode, availabilityMode) || other.availabilityMode == availabilityMode)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,availabilityMode,isOnline);

@override
String toString() {
  return 'AvailabilityData(availabilityMode: $availabilityMode, isOnline: $isOnline)';
}


}

/// @nodoc
abstract mixin class _$AvailabilityDataCopyWith<$Res> implements $AvailabilityDataCopyWith<$Res> {
  factory _$AvailabilityDataCopyWith(_AvailabilityData value, $Res Function(_AvailabilityData) _then) = __$AvailabilityDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'availability_mode') String availabilityMode,@JsonKey(name: 'is_online') bool isOnline
});




}
/// @nodoc
class __$AvailabilityDataCopyWithImpl<$Res>
    implements _$AvailabilityDataCopyWith<$Res> {
  __$AvailabilityDataCopyWithImpl(this._self, this._then);

  final _AvailabilityData _self;
  final $Res Function(_AvailabilityData) _then;

/// Create a copy of AvailabilityData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? availabilityMode = null,Object? isOnline = null,}) {
  return _then(_AvailabilityData(
availabilityMode: null == availabilityMode ? _self.availabilityMode : availabilityMode // ignore: cast_nullable_to_non_nullable
as String,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
