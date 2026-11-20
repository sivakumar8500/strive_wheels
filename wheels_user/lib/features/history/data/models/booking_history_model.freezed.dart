// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingHistoryModel {

@JsonKey(name: '_id') String get id; String get title; String get dateAndVehicle; String get status; String get amount; String get serviceType; String get serviceMode; String get pickupAddress; String get dropAddress; double? get pickupLat; double? get pickupLng; double? get dropLat; double? get dropLng;
/// Create a copy of BookingHistoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingHistoryModelCopyWith<BookingHistoryModel> get copyWith => _$BookingHistoryModelCopyWithImpl<BookingHistoryModel>(this as BookingHistoryModel, _$identity);

  /// Serializes this BookingHistoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingHistoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dateAndVehicle, dateAndVehicle) || other.dateAndVehicle == dateAndVehicle)&&(identical(other.status, status) || other.status == status)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.serviceMode, serviceMode) || other.serviceMode == serviceMode)&&(identical(other.pickupAddress, pickupAddress) || other.pickupAddress == pickupAddress)&&(identical(other.dropAddress, dropAddress) || other.dropAddress == dropAddress)&&(identical(other.pickupLat, pickupLat) || other.pickupLat == pickupLat)&&(identical(other.pickupLng, pickupLng) || other.pickupLng == pickupLng)&&(identical(other.dropLat, dropLat) || other.dropLat == dropLat)&&(identical(other.dropLng, dropLng) || other.dropLng == dropLng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,dateAndVehicle,status,amount,serviceType,serviceMode,pickupAddress,dropAddress,pickupLat,pickupLng,dropLat,dropLng);

@override
String toString() {
  return 'BookingHistoryModel(id: $id, title: $title, dateAndVehicle: $dateAndVehicle, status: $status, amount: $amount, serviceType: $serviceType, serviceMode: $serviceMode, pickupAddress: $pickupAddress, dropAddress: $dropAddress, pickupLat: $pickupLat, pickupLng: $pickupLng, dropLat: $dropLat, dropLng: $dropLng)';
}


}

/// @nodoc
abstract mixin class $BookingHistoryModelCopyWith<$Res>  {
  factory $BookingHistoryModelCopyWith(BookingHistoryModel value, $Res Function(BookingHistoryModel) _then) = _$BookingHistoryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String title, String dateAndVehicle, String status, String amount, String serviceType, String serviceMode, String pickupAddress, String dropAddress, double? pickupLat, double? pickupLng, double? dropLat, double? dropLng
});




}
/// @nodoc
class _$BookingHistoryModelCopyWithImpl<$Res>
    implements $BookingHistoryModelCopyWith<$Res> {
  _$BookingHistoryModelCopyWithImpl(this._self, this._then);

  final BookingHistoryModel _self;
  final $Res Function(BookingHistoryModel) _then;

/// Create a copy of BookingHistoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? dateAndVehicle = null,Object? status = null,Object? amount = null,Object? serviceType = null,Object? serviceMode = null,Object? pickupAddress = null,Object? dropAddress = null,Object? pickupLat = freezed,Object? pickupLng = freezed,Object? dropLat = freezed,Object? dropLng = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dateAndVehicle: null == dateAndVehicle ? _self.dateAndVehicle : dateAndVehicle // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as String,serviceMode: null == serviceMode ? _self.serviceMode : serviceMode // ignore: cast_nullable_to_non_nullable
as String,pickupAddress: null == pickupAddress ? _self.pickupAddress : pickupAddress // ignore: cast_nullable_to_non_nullable
as String,dropAddress: null == dropAddress ? _self.dropAddress : dropAddress // ignore: cast_nullable_to_non_nullable
as String,pickupLat: freezed == pickupLat ? _self.pickupLat : pickupLat // ignore: cast_nullable_to_non_nullable
as double?,pickupLng: freezed == pickupLng ? _self.pickupLng : pickupLng // ignore: cast_nullable_to_non_nullable
as double?,dropLat: freezed == dropLat ? _self.dropLat : dropLat // ignore: cast_nullable_to_non_nullable
as double?,dropLng: freezed == dropLng ? _self.dropLng : dropLng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingHistoryModel].
extension BookingHistoryModelPatterns on BookingHistoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingHistoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingHistoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingHistoryModel value)  $default,){
final _that = this;
switch (_that) {
case _BookingHistoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingHistoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookingHistoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String title,  String dateAndVehicle,  String status,  String amount,  String serviceType,  String serviceMode,  String pickupAddress,  String dropAddress,  double? pickupLat,  double? pickupLng,  double? dropLat,  double? dropLng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingHistoryModel() when $default != null:
return $default(_that.id,_that.title,_that.dateAndVehicle,_that.status,_that.amount,_that.serviceType,_that.serviceMode,_that.pickupAddress,_that.dropAddress,_that.pickupLat,_that.pickupLng,_that.dropLat,_that.dropLng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String title,  String dateAndVehicle,  String status,  String amount,  String serviceType,  String serviceMode,  String pickupAddress,  String dropAddress,  double? pickupLat,  double? pickupLng,  double? dropLat,  double? dropLng)  $default,) {final _that = this;
switch (_that) {
case _BookingHistoryModel():
return $default(_that.id,_that.title,_that.dateAndVehicle,_that.status,_that.amount,_that.serviceType,_that.serviceMode,_that.pickupAddress,_that.dropAddress,_that.pickupLat,_that.pickupLng,_that.dropLat,_that.dropLng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String title,  String dateAndVehicle,  String status,  String amount,  String serviceType,  String serviceMode,  String pickupAddress,  String dropAddress,  double? pickupLat,  double? pickupLng,  double? dropLat,  double? dropLng)?  $default,) {final _that = this;
switch (_that) {
case _BookingHistoryModel() when $default != null:
return $default(_that.id,_that.title,_that.dateAndVehicle,_that.status,_that.amount,_that.serviceType,_that.serviceMode,_that.pickupAddress,_that.dropAddress,_that.pickupLat,_that.pickupLng,_that.dropLat,_that.dropLng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingHistoryModel implements BookingHistoryModel {
  const _BookingHistoryModel({@JsonKey(name: '_id') required this.id, required this.title, required this.dateAndVehicle, required this.status, required this.amount, required this.serviceType, this.serviceMode = 'SELF', this.pickupAddress = '', this.dropAddress = '', this.pickupLat, this.pickupLng, this.dropLat, this.dropLng});
  factory _BookingHistoryModel.fromJson(Map<String, dynamic> json) => _$BookingHistoryModelFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String title;
@override final  String dateAndVehicle;
@override final  String status;
@override final  String amount;
@override final  String serviceType;
@override@JsonKey() final  String serviceMode;
@override@JsonKey() final  String pickupAddress;
@override@JsonKey() final  String dropAddress;
@override final  double? pickupLat;
@override final  double? pickupLng;
@override final  double? dropLat;
@override final  double? dropLng;

/// Create a copy of BookingHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingHistoryModelCopyWith<_BookingHistoryModel> get copyWith => __$BookingHistoryModelCopyWithImpl<_BookingHistoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingHistoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingHistoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dateAndVehicle, dateAndVehicle) || other.dateAndVehicle == dateAndVehicle)&&(identical(other.status, status) || other.status == status)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.serviceMode, serviceMode) || other.serviceMode == serviceMode)&&(identical(other.pickupAddress, pickupAddress) || other.pickupAddress == pickupAddress)&&(identical(other.dropAddress, dropAddress) || other.dropAddress == dropAddress)&&(identical(other.pickupLat, pickupLat) || other.pickupLat == pickupLat)&&(identical(other.pickupLng, pickupLng) || other.pickupLng == pickupLng)&&(identical(other.dropLat, dropLat) || other.dropLat == dropLat)&&(identical(other.dropLng, dropLng) || other.dropLng == dropLng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,dateAndVehicle,status,amount,serviceType,serviceMode,pickupAddress,dropAddress,pickupLat,pickupLng,dropLat,dropLng);

@override
String toString() {
  return 'BookingHistoryModel(id: $id, title: $title, dateAndVehicle: $dateAndVehicle, status: $status, amount: $amount, serviceType: $serviceType, serviceMode: $serviceMode, pickupAddress: $pickupAddress, dropAddress: $dropAddress, pickupLat: $pickupLat, pickupLng: $pickupLng, dropLat: $dropLat, dropLng: $dropLng)';
}


}

/// @nodoc
abstract mixin class _$BookingHistoryModelCopyWith<$Res> implements $BookingHistoryModelCopyWith<$Res> {
  factory _$BookingHistoryModelCopyWith(_BookingHistoryModel value, $Res Function(_BookingHistoryModel) _then) = __$BookingHistoryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String title, String dateAndVehicle, String status, String amount, String serviceType, String serviceMode, String pickupAddress, String dropAddress, double? pickupLat, double? pickupLng, double? dropLat, double? dropLng
});




}
/// @nodoc
class __$BookingHistoryModelCopyWithImpl<$Res>
    implements _$BookingHistoryModelCopyWith<$Res> {
  __$BookingHistoryModelCopyWithImpl(this._self, this._then);

  final _BookingHistoryModel _self;
  final $Res Function(_BookingHistoryModel) _then;

/// Create a copy of BookingHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? dateAndVehicle = null,Object? status = null,Object? amount = null,Object? serviceType = null,Object? serviceMode = null,Object? pickupAddress = null,Object? dropAddress = null,Object? pickupLat = freezed,Object? pickupLng = freezed,Object? dropLat = freezed,Object? dropLng = freezed,}) {
  return _then(_BookingHistoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dateAndVehicle: null == dateAndVehicle ? _self.dateAndVehicle : dateAndVehicle // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as String,serviceMode: null == serviceMode ? _self.serviceMode : serviceMode // ignore: cast_nullable_to_non_nullable
as String,pickupAddress: null == pickupAddress ? _self.pickupAddress : pickupAddress // ignore: cast_nullable_to_non_nullable
as String,dropAddress: null == dropAddress ? _self.dropAddress : dropAddress // ignore: cast_nullable_to_non_nullable
as String,pickupLat: freezed == pickupLat ? _self.pickupLat : pickupLat // ignore: cast_nullable_to_non_nullable
as double?,pickupLng: freezed == pickupLng ? _self.pickupLng : pickupLng // ignore: cast_nullable_to_non_nullable
as double?,dropLat: freezed == dropLat ? _self.dropLat : dropLat // ignore: cast_nullable_to_non_nullable
as double?,dropLng: freezed == dropLng ? _self.dropLng : dropLng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
