// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_action_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingActionResponse {

 bool get success; BookingActionData get data;
/// Create a copy of BookingActionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingActionResponseCopyWith<BookingActionResponse> get copyWith => _$BookingActionResponseCopyWithImpl<BookingActionResponse>(this as BookingActionResponse, _$identity);

  /// Serializes this BookingActionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingActionResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data);

@override
String toString() {
  return 'BookingActionResponse(success: $success, data: $data)';
}


}

/// @nodoc
abstract mixin class $BookingActionResponseCopyWith<$Res>  {
  factory $BookingActionResponseCopyWith(BookingActionResponse value, $Res Function(BookingActionResponse) _then) = _$BookingActionResponseCopyWithImpl;
@useResult
$Res call({
 bool success, BookingActionData data
});


$BookingActionDataCopyWith<$Res> get data;

}
/// @nodoc
class _$BookingActionResponseCopyWithImpl<$Res>
    implements $BookingActionResponseCopyWith<$Res> {
  _$BookingActionResponseCopyWithImpl(this._self, this._then);

  final BookingActionResponse _self;
  final $Res Function(BookingActionResponse) _then;

/// Create a copy of BookingActionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BookingActionData,
  ));
}
/// Create a copy of BookingActionResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingActionDataCopyWith<$Res> get data {
  
  return $BookingActionDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookingActionResponse].
extension BookingActionResponsePatterns on BookingActionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingActionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingActionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingActionResponse value)  $default,){
final _that = this;
switch (_that) {
case _BookingActionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingActionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BookingActionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  BookingActionData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingActionResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  BookingActionData data)  $default,) {final _that = this;
switch (_that) {
case _BookingActionResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  BookingActionData data)?  $default,) {final _that = this;
switch (_that) {
case _BookingActionResponse() when $default != null:
return $default(_that.success,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingActionResponse implements BookingActionResponse {
  const _BookingActionResponse({required this.success, required this.data});
  factory _BookingActionResponse.fromJson(Map<String, dynamic> json) => _$BookingActionResponseFromJson(json);

@override final  bool success;
@override final  BookingActionData data;

/// Create a copy of BookingActionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingActionResponseCopyWith<_BookingActionResponse> get copyWith => __$BookingActionResponseCopyWithImpl<_BookingActionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingActionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingActionResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data);

@override
String toString() {
  return 'BookingActionResponse(success: $success, data: $data)';
}


}

/// @nodoc
abstract mixin class _$BookingActionResponseCopyWith<$Res> implements $BookingActionResponseCopyWith<$Res> {
  factory _$BookingActionResponseCopyWith(_BookingActionResponse value, $Res Function(_BookingActionResponse) _then) = __$BookingActionResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, BookingActionData data
});


@override $BookingActionDataCopyWith<$Res> get data;

}
/// @nodoc
class __$BookingActionResponseCopyWithImpl<$Res>
    implements _$BookingActionResponseCopyWith<$Res> {
  __$BookingActionResponseCopyWithImpl(this._self, this._then);

  final _BookingActionResponse _self;
  final $Res Function(_BookingActionResponse) _then;

/// Create a copy of BookingActionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,}) {
  return _then(_BookingActionResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BookingActionData,
  ));
}

/// Create a copy of BookingActionResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingActionDataCopyWith<$Res> get data {
  
  return $BookingActionDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$BookingActionData {

 int get id; String get status;@JsonKey(name: 'final_fare') double? get finalFare;
/// Create a copy of BookingActionData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingActionDataCopyWith<BookingActionData> get copyWith => _$BookingActionDataCopyWithImpl<BookingActionData>(this as BookingActionData, _$identity);

  /// Serializes this BookingActionData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingActionData&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.finalFare, finalFare) || other.finalFare == finalFare));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,finalFare);

@override
String toString() {
  return 'BookingActionData(id: $id, status: $status, finalFare: $finalFare)';
}


}

/// @nodoc
abstract mixin class $BookingActionDataCopyWith<$Res>  {
  factory $BookingActionDataCopyWith(BookingActionData value, $Res Function(BookingActionData) _then) = _$BookingActionDataCopyWithImpl;
@useResult
$Res call({
 int id, String status,@JsonKey(name: 'final_fare') double? finalFare
});




}
/// @nodoc
class _$BookingActionDataCopyWithImpl<$Res>
    implements $BookingActionDataCopyWith<$Res> {
  _$BookingActionDataCopyWithImpl(this._self, this._then);

  final BookingActionData _self;
  final $Res Function(BookingActionData) _then;

/// Create a copy of BookingActionData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? finalFare = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,finalFare: freezed == finalFare ? _self.finalFare : finalFare // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingActionData].
extension BookingActionDataPatterns on BookingActionData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingActionData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingActionData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingActionData value)  $default,){
final _that = this;
switch (_that) {
case _BookingActionData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingActionData value)?  $default,){
final _that = this;
switch (_that) {
case _BookingActionData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String status, @JsonKey(name: 'final_fare')  double? finalFare)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingActionData() when $default != null:
return $default(_that.id,_that.status,_that.finalFare);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String status, @JsonKey(name: 'final_fare')  double? finalFare)  $default,) {final _that = this;
switch (_that) {
case _BookingActionData():
return $default(_that.id,_that.status,_that.finalFare);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String status, @JsonKey(name: 'final_fare')  double? finalFare)?  $default,) {final _that = this;
switch (_that) {
case _BookingActionData() when $default != null:
return $default(_that.id,_that.status,_that.finalFare);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingActionData implements BookingActionData {
  const _BookingActionData({required this.id, required this.status, @JsonKey(name: 'final_fare') this.finalFare});
  factory _BookingActionData.fromJson(Map<String, dynamic> json) => _$BookingActionDataFromJson(json);

@override final  int id;
@override final  String status;
@override@JsonKey(name: 'final_fare') final  double? finalFare;

/// Create a copy of BookingActionData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingActionDataCopyWith<_BookingActionData> get copyWith => __$BookingActionDataCopyWithImpl<_BookingActionData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingActionDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingActionData&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.finalFare, finalFare) || other.finalFare == finalFare));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,finalFare);

@override
String toString() {
  return 'BookingActionData(id: $id, status: $status, finalFare: $finalFare)';
}


}

/// @nodoc
abstract mixin class _$BookingActionDataCopyWith<$Res> implements $BookingActionDataCopyWith<$Res> {
  factory _$BookingActionDataCopyWith(_BookingActionData value, $Res Function(_BookingActionData) _then) = __$BookingActionDataCopyWithImpl;
@override @useResult
$Res call({
 int id, String status,@JsonKey(name: 'final_fare') double? finalFare
});




}
/// @nodoc
class __$BookingActionDataCopyWithImpl<$Res>
    implements _$BookingActionDataCopyWith<$Res> {
  __$BookingActionDataCopyWithImpl(this._self, this._then);

  final _BookingActionData _self;
  final $Res Function(_BookingActionData) _then;

/// Create a copy of BookingActionData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? finalFare = freezed,}) {
  return _then(_BookingActionData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,finalFare: freezed == finalFare ? _self.finalFare : finalFare // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
