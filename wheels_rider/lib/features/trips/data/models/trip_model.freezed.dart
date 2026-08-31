// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingModel {

 String get id;@JsonKey(name: 'client_name') String get clientName;@JsonKey(name: 'client_rating') double get clientRating; String get tag; double get price;@JsonKey(name: 'pickup_location') String get pickupLocation;@JsonKey(name: 'dropoff_location') String get dropoffLocation; DateTime get timestamp; String get status;
/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingModelCopyWith<BookingModel> get copyWith => _$BookingModelCopyWithImpl<BookingModel>(this as BookingModel, _$identity);

  /// Serializes this BookingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientRating, clientRating) || other.clientRating == clientRating)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.price, price) || other.price == price)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.dropoffLocation, dropoffLocation) || other.dropoffLocation == dropoffLocation)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientName,clientRating,tag,price,pickupLocation,dropoffLocation,timestamp,status);

@override
String toString() {
  return 'BookingModel(id: $id, clientName: $clientName, clientRating: $clientRating, tag: $tag, price: $price, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, timestamp: $timestamp, status: $status)';
}


}

/// @nodoc
abstract mixin class $BookingModelCopyWith<$Res>  {
  factory $BookingModelCopyWith(BookingModel value, $Res Function(BookingModel) _then) = _$BookingModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'client_name') String clientName,@JsonKey(name: 'client_rating') double clientRating, String tag, double price,@JsonKey(name: 'pickup_location') String pickupLocation,@JsonKey(name: 'dropoff_location') String dropoffLocation, DateTime timestamp, String status
});




}
/// @nodoc
class _$BookingModelCopyWithImpl<$Res>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._self, this._then);

  final BookingModel _self;
  final $Res Function(BookingModel) _then;

/// Create a copy of BookingModel
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


/// Adds pattern-matching-related methods to [BookingModel].
extension BookingModelPatterns on BookingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingModel value)  $default,){
final _that = this;
switch (_that) {
case _BookingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'client_name')  String clientName, @JsonKey(name: 'client_rating')  double clientRating,  String tag,  double price, @JsonKey(name: 'pickup_location')  String pickupLocation, @JsonKey(name: 'dropoff_location')  String dropoffLocation,  DateTime timestamp,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'client_name')  String clientName, @JsonKey(name: 'client_rating')  double clientRating,  String tag,  double price, @JsonKey(name: 'pickup_location')  String pickupLocation, @JsonKey(name: 'dropoff_location')  String dropoffLocation,  DateTime timestamp,  String status)  $default,) {final _that = this;
switch (_that) {
case _BookingModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'client_name')  String clientName, @JsonKey(name: 'client_rating')  double clientRating,  String tag,  double price, @JsonKey(name: 'pickup_location')  String pickupLocation, @JsonKey(name: 'dropoff_location')  String dropoffLocation,  DateTime timestamp,  String status)?  $default,) {final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
return $default(_that.id,_that.clientName,_that.clientRating,_that.tag,_that.price,_that.pickupLocation,_that.dropoffLocation,_that.timestamp,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingModel extends BookingModel {
  const _BookingModel({required this.id, @JsonKey(name: 'client_name') required this.clientName, @JsonKey(name: 'client_rating') required this.clientRating, required this.tag, required this.price, @JsonKey(name: 'pickup_location') required this.pickupLocation, @JsonKey(name: 'dropoff_location') required this.dropoffLocation, required this.timestamp, required this.status}): super._();
  factory _BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'client_name') final  String clientName;
@override@JsonKey(name: 'client_rating') final  double clientRating;
@override final  String tag;
@override final  double price;
@override@JsonKey(name: 'pickup_location') final  String pickupLocation;
@override@JsonKey(name: 'dropoff_location') final  String dropoffLocation;
@override final  DateTime timestamp;
@override final  String status;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingModelCopyWith<_BookingModel> get copyWith => __$BookingModelCopyWithImpl<_BookingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientRating, clientRating) || other.clientRating == clientRating)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.price, price) || other.price == price)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.dropoffLocation, dropoffLocation) || other.dropoffLocation == dropoffLocation)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientName,clientRating,tag,price,pickupLocation,dropoffLocation,timestamp,status);

@override
String toString() {
  return 'BookingModel(id: $id, clientName: $clientName, clientRating: $clientRating, tag: $tag, price: $price, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, timestamp: $timestamp, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BookingModelCopyWith<$Res> implements $BookingModelCopyWith<$Res> {
  factory _$BookingModelCopyWith(_BookingModel value, $Res Function(_BookingModel) _then) = __$BookingModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'client_name') String clientName,@JsonKey(name: 'client_rating') double clientRating, String tag, double price,@JsonKey(name: 'pickup_location') String pickupLocation,@JsonKey(name: 'dropoff_location') String dropoffLocation, DateTime timestamp, String status
});




}
/// @nodoc
class __$BookingModelCopyWithImpl<$Res>
    implements _$BookingModelCopyWith<$Res> {
  __$BookingModelCopyWithImpl(this._self, this._then);

  final _BookingModel _self;
  final $Res Function(_BookingModel) _then;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clientName = null,Object? clientRating = null,Object? tag = null,Object? price = null,Object? pickupLocation = null,Object? dropoffLocation = null,Object? timestamp = null,Object? status = null,}) {
  return _then(_BookingModel(
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
mixin _$TripModel {

@JsonKey(name: 'total_mileage') double get totalMileage;@JsonKey(name: 'total_rides') int get totalRides;@JsonKey(name: 'avg_rating') double get avgRating; List<BookingModel> get bookings;
/// Create a copy of TripModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripModelCopyWith<TripModel> get copyWith => _$TripModelCopyWithImpl<TripModel>(this as TripModel, _$identity);

  /// Serializes this TripModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripModel&&(identical(other.totalMileage, totalMileage) || other.totalMileage == totalMileage)&&(identical(other.totalRides, totalRides) || other.totalRides == totalRides)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&const DeepCollectionEquality().equals(other.bookings, bookings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalMileage,totalRides,avgRating,const DeepCollectionEquality().hash(bookings));

@override
String toString() {
  return 'TripModel(totalMileage: $totalMileage, totalRides: $totalRides, avgRating: $avgRating, bookings: $bookings)';
}


}

/// @nodoc
abstract mixin class $TripModelCopyWith<$Res>  {
  factory $TripModelCopyWith(TripModel value, $Res Function(TripModel) _then) = _$TripModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_mileage') double totalMileage,@JsonKey(name: 'total_rides') int totalRides,@JsonKey(name: 'avg_rating') double avgRating, List<BookingModel> bookings
});




}
/// @nodoc
class _$TripModelCopyWithImpl<$Res>
    implements $TripModelCopyWith<$Res> {
  _$TripModelCopyWithImpl(this._self, this._then);

  final TripModel _self;
  final $Res Function(TripModel) _then;

/// Create a copy of TripModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalMileage = null,Object? totalRides = null,Object? avgRating = null,Object? bookings = null,}) {
  return _then(_self.copyWith(
totalMileage: null == totalMileage ? _self.totalMileage : totalMileage // ignore: cast_nullable_to_non_nullable
as double,totalRides: null == totalRides ? _self.totalRides : totalRides // ignore: cast_nullable_to_non_nullable
as int,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as double,bookings: null == bookings ? _self.bookings : bookings // ignore: cast_nullable_to_non_nullable
as List<BookingModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [TripModel].
extension TripModelPatterns on TripModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripModel value)  $default,){
final _that = this;
switch (_that) {
case _TripModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripModel value)?  $default,){
final _that = this;
switch (_that) {
case _TripModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_mileage')  double totalMileage, @JsonKey(name: 'total_rides')  int totalRides, @JsonKey(name: 'avg_rating')  double avgRating,  List<BookingModel> bookings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_mileage')  double totalMileage, @JsonKey(name: 'total_rides')  int totalRides, @JsonKey(name: 'avg_rating')  double avgRating,  List<BookingModel> bookings)  $default,) {final _that = this;
switch (_that) {
case _TripModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_mileage')  double totalMileage, @JsonKey(name: 'total_rides')  int totalRides, @JsonKey(name: 'avg_rating')  double avgRating,  List<BookingModel> bookings)?  $default,) {final _that = this;
switch (_that) {
case _TripModel() when $default != null:
return $default(_that.totalMileage,_that.totalRides,_that.avgRating,_that.bookings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripModel extends TripModel {
  const _TripModel({@JsonKey(name: 'total_mileage') required this.totalMileage, @JsonKey(name: 'total_rides') required this.totalRides, @JsonKey(name: 'avg_rating') required this.avgRating, required final  List<BookingModel> bookings}): _bookings = bookings,super._();
  factory _TripModel.fromJson(Map<String, dynamic> json) => _$TripModelFromJson(json);

@override@JsonKey(name: 'total_mileage') final  double totalMileage;
@override@JsonKey(name: 'total_rides') final  int totalRides;
@override@JsonKey(name: 'avg_rating') final  double avgRating;
 final  List<BookingModel> _bookings;
@override List<BookingModel> get bookings {
  if (_bookings is EqualUnmodifiableListView) return _bookings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookings);
}


/// Create a copy of TripModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripModelCopyWith<_TripModel> get copyWith => __$TripModelCopyWithImpl<_TripModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripModel&&(identical(other.totalMileage, totalMileage) || other.totalMileage == totalMileage)&&(identical(other.totalRides, totalRides) || other.totalRides == totalRides)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&const DeepCollectionEquality().equals(other._bookings, _bookings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalMileage,totalRides,avgRating,const DeepCollectionEquality().hash(_bookings));

@override
String toString() {
  return 'TripModel(totalMileage: $totalMileage, totalRides: $totalRides, avgRating: $avgRating, bookings: $bookings)';
}


}

/// @nodoc
abstract mixin class _$TripModelCopyWith<$Res> implements $TripModelCopyWith<$Res> {
  factory _$TripModelCopyWith(_TripModel value, $Res Function(_TripModel) _then) = __$TripModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_mileage') double totalMileage,@JsonKey(name: 'total_rides') int totalRides,@JsonKey(name: 'avg_rating') double avgRating, List<BookingModel> bookings
});




}
/// @nodoc
class __$TripModelCopyWithImpl<$Res>
    implements _$TripModelCopyWith<$Res> {
  __$TripModelCopyWithImpl(this._self, this._then);

  final _TripModel _self;
  final $Res Function(_TripModel) _then;

/// Create a copy of TripModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalMileage = null,Object? totalRides = null,Object? avgRating = null,Object? bookings = null,}) {
  return _then(_TripModel(
totalMileage: null == totalMileage ? _self.totalMileage : totalMileage // ignore: cast_nullable_to_non_nullable
as double,totalRides: null == totalRides ? _self.totalRides : totalRides // ignore: cast_nullable_to_non_nullable
as int,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as double,bookings: null == bookings ? _self._bookings : bookings // ignore: cast_nullable_to_non_nullable
as List<BookingModel>,
  ));
}


}

// dart format on
