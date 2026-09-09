// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingEntity {

 String get id; String get clientName; double get clientRating; String get tag; double get price; String get pickupLocation; String get dropoffLocation; DateTime get timestamp; String get status;
/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingEntityCopyWith<BookingEntity> get copyWith => _$BookingEntityCopyWithImpl<BookingEntity>(this as BookingEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientRating, clientRating) || other.clientRating == clientRating)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.price, price) || other.price == price)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.dropoffLocation, dropoffLocation) || other.dropoffLocation == dropoffLocation)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,clientName,clientRating,tag,price,pickupLocation,dropoffLocation,timestamp,status);

@override
String toString() {
  return 'BookingEntity(id: $id, clientName: $clientName, clientRating: $clientRating, tag: $tag, price: $price, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, timestamp: $timestamp, status: $status)';
}


}

/// @nodoc
abstract mixin class $BookingEntityCopyWith<$Res>  {
  factory $BookingEntityCopyWith(BookingEntity value, $Res Function(BookingEntity) _then) = _$BookingEntityCopyWithImpl;
@useResult
$Res call({
 String id, String clientName, double clientRating, String tag, double price, String pickupLocation, String dropoffLocation, DateTime timestamp, String status
});




}
/// @nodoc
class _$BookingEntityCopyWithImpl<$Res>
    implements $BookingEntityCopyWith<$Res> {
  _$BookingEntityCopyWithImpl(this._self, this._then);

  final BookingEntity _self;
  final $Res Function(BookingEntity) _then;

/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clientName = null,Object? clientRating = null,Object? tag = null,Object? price = null,Object? pickupLocation = null,Object? dropoffLocation = null,Object? timestamp = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,clientRating: null == clientRating ? _self.clientRating : clientRating // ignore: cast_nullable_to_non_nullable
as double,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,pickupLocation: null == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String,dropoffLocation: null == dropoffLocation ? _self.dropoffLocation : dropoffLocation // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingEntity].
extension BookingEntityPatterns on BookingEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingEntity value)  $default,){
final _that = this;
switch (_that) {
case _BookingEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BookingEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String clientName,  double clientRating,  String tag,  double price,  String pickupLocation,  String dropoffLocation,  DateTime timestamp,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingEntity() when $default != null:
return $default(_that.id,_that.clientName,_that.clientRating,_that.tag,_that.price,_that.pickupLocation,_that.dropoffLocation,_that.timestamp,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String clientName,  double clientRating,  String tag,  double price,  String pickupLocation,  String dropoffLocation,  DateTime timestamp,  String status)  $default,) {final _that = this;
switch (_that) {
case _BookingEntity():
return $default(_that.id,_that.clientName,_that.clientRating,_that.tag,_that.price,_that.pickupLocation,_that.dropoffLocation,_that.timestamp,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String clientName,  double clientRating,  String tag,  double price,  String pickupLocation,  String dropoffLocation,  DateTime timestamp,  String status)?  $default,) {final _that = this;
switch (_that) {
case _BookingEntity() when $default != null:
return $default(_that.id,_that.clientName,_that.clientRating,_that.tag,_that.price,_that.pickupLocation,_that.dropoffLocation,_that.timestamp,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _BookingEntity implements BookingEntity {
  const _BookingEntity({required this.id, required this.clientName, required this.clientRating, required this.tag, required this.price, required this.pickupLocation, required this.dropoffLocation, required this.timestamp, required this.status});
  

@override final  String id;
@override final  String clientName;
@override final  double clientRating;
@override final  String tag;
@override final  double price;
@override final  String pickupLocation;
@override final  String dropoffLocation;
@override final  DateTime timestamp;
@override final  String status;

/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingEntityCopyWith<_BookingEntity> get copyWith => __$BookingEntityCopyWithImpl<_BookingEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientRating, clientRating) || other.clientRating == clientRating)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.price, price) || other.price == price)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.dropoffLocation, dropoffLocation) || other.dropoffLocation == dropoffLocation)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,clientName,clientRating,tag,price,pickupLocation,dropoffLocation,timestamp,status);

@override
String toString() {
  return 'BookingEntity(id: $id, clientName: $clientName, clientRating: $clientRating, tag: $tag, price: $price, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, timestamp: $timestamp, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BookingEntityCopyWith<$Res> implements $BookingEntityCopyWith<$Res> {
  factory _$BookingEntityCopyWith(_BookingEntity value, $Res Function(_BookingEntity) _then) = __$BookingEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String clientName, double clientRating, String tag, double price, String pickupLocation, String dropoffLocation, DateTime timestamp, String status
});




}
/// @nodoc
class __$BookingEntityCopyWithImpl<$Res>
    implements _$BookingEntityCopyWith<$Res> {
  __$BookingEntityCopyWithImpl(this._self, this._then);

  final _BookingEntity _self;
  final $Res Function(_BookingEntity) _then;

/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clientName = null,Object? clientRating = null,Object? tag = null,Object? price = null,Object? pickupLocation = null,Object? dropoffLocation = null,Object? timestamp = null,Object? status = null,}) {
  return _then(_BookingEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,clientRating: null == clientRating ? _self.clientRating : clientRating // ignore: cast_nullable_to_non_nullable
as double,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,pickupLocation: null == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String,dropoffLocation: null == dropoffLocation ? _self.dropoffLocation : dropoffLocation // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TripEntity {

 double get totalMileage; int get totalRides; double get avgRating; List<BookingEntity> get bookings;
/// Create a copy of TripEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripEntityCopyWith<TripEntity> get copyWith => _$TripEntityCopyWithImpl<TripEntity>(this as TripEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripEntity&&(identical(other.totalMileage, totalMileage) || other.totalMileage == totalMileage)&&(identical(other.totalRides, totalRides) || other.totalRides == totalRides)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&const DeepCollectionEquality().equals(other.bookings, bookings));
}


@override
int get hashCode => Object.hash(runtimeType,totalMileage,totalRides,avgRating,const DeepCollectionEquality().hash(bookings));

@override
String toString() {
  return 'TripEntity(totalMileage: $totalMileage, totalRides: $totalRides, avgRating: $avgRating, bookings: $bookings)';
}


}

/// @nodoc
abstract mixin class $TripEntityCopyWith<$Res>  {
  factory $TripEntityCopyWith(TripEntity value, $Res Function(TripEntity) _then) = _$TripEntityCopyWithImpl;
@useResult
$Res call({
 double totalMileage, int totalRides, double avgRating, List<BookingEntity> bookings
});




}
/// @nodoc
class _$TripEntityCopyWithImpl<$Res>
    implements $TripEntityCopyWith<$Res> {
  _$TripEntityCopyWithImpl(this._self, this._then);

  final TripEntity _self;
  final $Res Function(TripEntity) _then;

/// Create a copy of TripEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalMileage = null,Object? totalRides = null,Object? avgRating = null,Object? bookings = null,}) {
  return _then(_self.copyWith(
totalMileage: null == totalMileage ? _self.totalMileage : totalMileage // ignore: cast_nullable_to_non_nullable
as double,totalRides: null == totalRides ? _self.totalRides : totalRides // ignore: cast_nullable_to_non_nullable
as int,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as double,bookings: null == bookings ? _self.bookings : bookings // ignore: cast_nullable_to_non_nullable
as List<BookingEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [TripEntity].
extension TripEntityPatterns on TripEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripEntity value)  $default,){
final _that = this;
switch (_that) {
case _TripEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TripEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalMileage,  int totalRides,  double avgRating,  List<BookingEntity> bookings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripEntity() when $default != null:
return $default(_that.totalMileage,_that.totalRides,_that.avgRating,_that.bookings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalMileage,  int totalRides,  double avgRating,  List<BookingEntity> bookings)  $default,) {final _that = this;
switch (_that) {
case _TripEntity():
return $default(_that.totalMileage,_that.totalRides,_that.avgRating,_that.bookings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalMileage,  int totalRides,  double avgRating,  List<BookingEntity> bookings)?  $default,) {final _that = this;
switch (_that) {
case _TripEntity() when $default != null:
return $default(_that.totalMileage,_that.totalRides,_that.avgRating,_that.bookings);case _:
  return null;

}
}

}

/// @nodoc


class _TripEntity implements TripEntity {
  const _TripEntity({required this.totalMileage, required this.totalRides, required this.avgRating, required final  List<BookingEntity> bookings}): _bookings = bookings;
  

@override final  double totalMileage;
@override final  int totalRides;
@override final  double avgRating;
 final  List<BookingEntity> _bookings;
@override List<BookingEntity> get bookings {
  if (_bookings is EqualUnmodifiableListView) return _bookings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookings);
}


/// Create a copy of TripEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripEntityCopyWith<_TripEntity> get copyWith => __$TripEntityCopyWithImpl<_TripEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripEntity&&(identical(other.totalMileage, totalMileage) || other.totalMileage == totalMileage)&&(identical(other.totalRides, totalRides) || other.totalRides == totalRides)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&const DeepCollectionEquality().equals(other._bookings, _bookings));
}


@override
int get hashCode => Object.hash(runtimeType,totalMileage,totalRides,avgRating,const DeepCollectionEquality().hash(_bookings));

@override
String toString() {
  return 'TripEntity(totalMileage: $totalMileage, totalRides: $totalRides, avgRating: $avgRating, bookings: $bookings)';
}


}

/// @nodoc
abstract mixin class _$TripEntityCopyWith<$Res> implements $TripEntityCopyWith<$Res> {
  factory _$TripEntityCopyWith(_TripEntity value, $Res Function(_TripEntity) _then) = __$TripEntityCopyWithImpl;
@override @useResult
$Res call({
 double totalMileage, int totalRides, double avgRating, List<BookingEntity> bookings
});




}
/// @nodoc
class __$TripEntityCopyWithImpl<$Res>
    implements _$TripEntityCopyWith<$Res> {
  __$TripEntityCopyWithImpl(this._self, this._then);

  final _TripEntity _self;
  final $Res Function(_TripEntity) _then;

/// Create a copy of TripEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalMileage = null,Object? totalRides = null,Object? avgRating = null,Object? bookings = null,}) {
  return _then(_TripEntity(
totalMileage: null == totalMileage ? _self.totalMileage : totalMileage // ignore: cast_nullable_to_non_nullable
as double,totalRides: null == totalRides ? _self.totalRides : totalRides // ignore: cast_nullable_to_non_nullable
as int,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as double,bookings: null == bookings ? _self._bookings : bookings // ignore: cast_nullable_to_non_nullable
as List<BookingEntity>,
  ));
}


}

// dart format on
