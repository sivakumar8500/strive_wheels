// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'past_ride_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PastRideItemModel {

 String get id; String get title; String get dateAndVehicle; String get status; String get amount; String get serviceType;
/// Create a copy of PastRideItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PastRideItemModelCopyWith<PastRideItemModel> get copyWith => _$PastRideItemModelCopyWithImpl<PastRideItemModel>(this as PastRideItemModel, _$identity);

  /// Serializes this PastRideItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PastRideItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dateAndVehicle, dateAndVehicle) || other.dateAndVehicle == dateAndVehicle)&&(identical(other.status, status) || other.status == status)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,dateAndVehicle,status,amount,serviceType);

@override
String toString() {
  return 'PastRideItemModel(id: $id, title: $title, dateAndVehicle: $dateAndVehicle, status: $status, amount: $amount, serviceType: $serviceType)';
}


}

/// @nodoc
abstract mixin class $PastRideItemModelCopyWith<$Res>  {
  factory $PastRideItemModelCopyWith(PastRideItemModel value, $Res Function(PastRideItemModel) _then) = _$PastRideItemModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String dateAndVehicle, String status, String amount, String serviceType
});




}
/// @nodoc
class _$PastRideItemModelCopyWithImpl<$Res>
    implements $PastRideItemModelCopyWith<$Res> {
  _$PastRideItemModelCopyWithImpl(this._self, this._then);

  final PastRideItemModel _self;
  final $Res Function(PastRideItemModel) _then;

/// Create a copy of PastRideItemModel
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


/// Adds pattern-matching-related methods to [PastRideItemModel].
extension PastRideItemModelPatterns on PastRideItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PastRideItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PastRideItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PastRideItemModel value)  $default,){
final _that = this;
switch (_that) {
case _PastRideItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PastRideItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _PastRideItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String dateAndVehicle,  String status,  String amount,  String serviceType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PastRideItemModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String dateAndVehicle,  String status,  String amount,  String serviceType)  $default,) {final _that = this;
switch (_that) {
case _PastRideItemModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String dateAndVehicle,  String status,  String amount,  String serviceType)?  $default,) {final _that = this;
switch (_that) {
case _PastRideItemModel() when $default != null:
return $default(_that.id,_that.title,_that.dateAndVehicle,_that.status,_that.amount,_that.serviceType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PastRideItemModel implements PastRideItemModel {
  const _PastRideItemModel({required this.id, required this.title, required this.dateAndVehicle, required this.status, required this.amount, required this.serviceType});
  factory _PastRideItemModel.fromJson(Map<String, dynamic> json) => _$PastRideItemModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String dateAndVehicle;
@override final  String status;
@override final  String amount;
@override final  String serviceType;

/// Create a copy of PastRideItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PastRideItemModelCopyWith<_PastRideItemModel> get copyWith => __$PastRideItemModelCopyWithImpl<_PastRideItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PastRideItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PastRideItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dateAndVehicle, dateAndVehicle) || other.dateAndVehicle == dateAndVehicle)&&(identical(other.status, status) || other.status == status)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,dateAndVehicle,status,amount,serviceType);

@override
String toString() {
  return 'PastRideItemModel(id: $id, title: $title, dateAndVehicle: $dateAndVehicle, status: $status, amount: $amount, serviceType: $serviceType)';
}


}

/// @nodoc
abstract mixin class _$PastRideItemModelCopyWith<$Res> implements $PastRideItemModelCopyWith<$Res> {
  factory _$PastRideItemModelCopyWith(_PastRideItemModel value, $Res Function(_PastRideItemModel) _then) = __$PastRideItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String dateAndVehicle, String status, String amount, String serviceType
});




}
/// @nodoc
class __$PastRideItemModelCopyWithImpl<$Res>
    implements _$PastRideItemModelCopyWith<$Res> {
  __$PastRideItemModelCopyWithImpl(this._self, this._then);

  final _PastRideItemModel _self;
  final $Res Function(_PastRideItemModel) _then;

/// Create a copy of PastRideItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? dateAndVehicle = null,Object? status = null,Object? amount = null,Object? serviceType = null,}) {
  return _then(_PastRideItemModel(
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
