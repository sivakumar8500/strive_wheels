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

@JsonKey(name: '_id') String get id; String get title; String get dateAndVehicle; String get status; String get amount; String get serviceType;
/// Create a copy of BookingHistoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingHistoryModelCopyWith<BookingHistoryModel> get copyWith => _$BookingHistoryModelCopyWithImpl<BookingHistoryModel>(this as BookingHistoryModel, _$identity);

  /// Serializes this BookingHistoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingHistoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dateAndVehicle, dateAndVehicle) || other.dateAndVehicle == dateAndVehicle)&&(identical(other.status, status) || other.status == status)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,dateAndVehicle,status,amount,serviceType);

@override
String toString() {
  return 'BookingHistoryModel(id: $id, title: $title, dateAndVehicle: $dateAndVehicle, status: $status, amount: $amount, serviceType: $serviceType)';
}


}

/// @nodoc
abstract mixin class $BookingHistoryModelCopyWith<$Res>  {
  factory $BookingHistoryModelCopyWith(BookingHistoryModel value, $Res Function(BookingHistoryModel) _then) = _$BookingHistoryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String title, String dateAndVehicle, String status, String amount, String serviceType
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? dateAndVehicle = null,Object? status = null,Object? amount = null,Object? serviceType = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dateAndVehicle: null == dateAndVehicle ? _self.dateAndVehicle : dateAndVehicle // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String title,  String dateAndVehicle,  String status,  String amount,  String serviceType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingHistoryModel() when $default != null:
return $default(_that.id,_that.title,_that.dateAndVehicle,_that.status,_that.amount,_that.serviceType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String title,  String dateAndVehicle,  String status,  String amount,  String serviceType)  $default,) {final _that = this;
switch (_that) {
case _BookingHistoryModel():
return $default(_that.id,_that.title,_that.dateAndVehicle,_that.status,_that.amount,_that.serviceType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String title,  String dateAndVehicle,  String status,  String amount,  String serviceType)?  $default,) {final _that = this;
switch (_that) {
case _BookingHistoryModel() when $default != null:
return $default(_that.id,_that.title,_that.dateAndVehicle,_that.status,_that.amount,_that.serviceType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingHistoryModel implements BookingHistoryModel {
  const _BookingHistoryModel({@JsonKey(name: '_id') required this.id, required this.title, required this.dateAndVehicle, required this.status, required this.amount, required this.serviceType});
  factory _BookingHistoryModel.fromJson(Map<String, dynamic> json) => _$BookingHistoryModelFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String title;
@override final  String dateAndVehicle;
@override final  String status;
@override final  String amount;
@override final  String serviceType;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingHistoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dateAndVehicle, dateAndVehicle) || other.dateAndVehicle == dateAndVehicle)&&(identical(other.status, status) || other.status == status)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,dateAndVehicle,status,amount,serviceType);

@override
String toString() {
  return 'BookingHistoryModel(id: $id, title: $title, dateAndVehicle: $dateAndVehicle, status: $status, amount: $amount, serviceType: $serviceType)';
}


}

/// @nodoc
abstract mixin class _$BookingHistoryModelCopyWith<$Res> implements $BookingHistoryModelCopyWith<$Res> {
  factory _$BookingHistoryModelCopyWith(_BookingHistoryModel value, $Res Function(_BookingHistoryModel) _then) = __$BookingHistoryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String title, String dateAndVehicle, String status, String amount, String serviceType
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? dateAndVehicle = null,Object? status = null,Object? amount = null,Object? serviceType = null,}) {
  return _then(_BookingHistoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dateAndVehicle: null == dateAndVehicle ? _self.dateAndVehicle : dateAndVehicle // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
