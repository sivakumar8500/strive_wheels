// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_ride_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleRideModel {

 String get pickupPoint; String get destination; double get distanceKm; int get durationMins; double get fareAmount; String get currencySymbol; String get selectedDate; String get selectedTime; bool get isAm; bool get instantNotification; List<String> get checklistItems;
/// Create a copy of ScheduleRideModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleRideModelCopyWith<ScheduleRideModel> get copyWith => _$ScheduleRideModelCopyWithImpl<ScheduleRideModel>(this as ScheduleRideModel, _$identity);

  /// Serializes this ScheduleRideModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleRideModel&&(identical(other.pickupPoint, pickupPoint) || other.pickupPoint == pickupPoint)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.durationMins, durationMins) || other.durationMins == durationMins)&&(identical(other.fareAmount, fareAmount) || other.fareAmount == fareAmount)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.selectedTime, selectedTime) || other.selectedTime == selectedTime)&&(identical(other.isAm, isAm) || other.isAm == isAm)&&(identical(other.instantNotification, instantNotification) || other.instantNotification == instantNotification)&&const DeepCollectionEquality().equals(other.checklistItems, checklistItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pickupPoint,destination,distanceKm,durationMins,fareAmount,currencySymbol,selectedDate,selectedTime,isAm,instantNotification,const DeepCollectionEquality().hash(checklistItems));

@override
String toString() {
  return 'ScheduleRideModel(pickupPoint: $pickupPoint, destination: $destination, distanceKm: $distanceKm, durationMins: $durationMins, fareAmount: $fareAmount, currencySymbol: $currencySymbol, selectedDate: $selectedDate, selectedTime: $selectedTime, isAm: $isAm, instantNotification: $instantNotification, checklistItems: $checklistItems)';
}


}

/// @nodoc
abstract mixin class $ScheduleRideModelCopyWith<$Res>  {
  factory $ScheduleRideModelCopyWith(ScheduleRideModel value, $Res Function(ScheduleRideModel) _then) = _$ScheduleRideModelCopyWithImpl;
@useResult
$Res call({
 String pickupPoint, String destination, double distanceKm, int durationMins, double fareAmount, String currencySymbol, String selectedDate, String selectedTime, bool isAm, bool instantNotification, List<String> checklistItems
});




}
/// @nodoc
class _$ScheduleRideModelCopyWithImpl<$Res>
    implements $ScheduleRideModelCopyWith<$Res> {
  _$ScheduleRideModelCopyWithImpl(this._self, this._then);

  final ScheduleRideModel _self;
  final $Res Function(ScheduleRideModel) _then;

/// Create a copy of ScheduleRideModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pickupPoint = null,Object? destination = null,Object? distanceKm = null,Object? durationMins = null,Object? fareAmount = null,Object? currencySymbol = null,Object? selectedDate = null,Object? selectedTime = null,Object? isAm = null,Object? instantNotification = null,Object? checklistItems = null,}) {
  return _then(_self.copyWith(
pickupPoint: null == pickupPoint ? _self.pickupPoint : pickupPoint // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,durationMins: null == durationMins ? _self.durationMins : durationMins // ignore: cast_nullable_to_non_nullable
as int,fareAmount: null == fareAmount ? _self.fareAmount : fareAmount // ignore: cast_nullable_to_non_nullable
as double,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,selectedDate: null == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as String,selectedTime: null == selectedTime ? _self.selectedTime : selectedTime // ignore: cast_nullable_to_non_nullable
as String,isAm: null == isAm ? _self.isAm : isAm // ignore: cast_nullable_to_non_nullable
as bool,instantNotification: null == instantNotification ? _self.instantNotification : instantNotification // ignore: cast_nullable_to_non_nullable
as bool,checklistItems: null == checklistItems ? _self.checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleRideModel].
extension ScheduleRideModelPatterns on ScheduleRideModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleRideModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleRideModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleRideModel value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleRideModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleRideModel value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleRideModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String pickupPoint,  String destination,  double distanceKm,  int durationMins,  double fareAmount,  String currencySymbol,  String selectedDate,  String selectedTime,  bool isAm,  bool instantNotification,  List<String> checklistItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleRideModel() when $default != null:
return $default(_that.pickupPoint,_that.destination,_that.distanceKm,_that.durationMins,_that.fareAmount,_that.currencySymbol,_that.selectedDate,_that.selectedTime,_that.isAm,_that.instantNotification,_that.checklistItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String pickupPoint,  String destination,  double distanceKm,  int durationMins,  double fareAmount,  String currencySymbol,  String selectedDate,  String selectedTime,  bool isAm,  bool instantNotification,  List<String> checklistItems)  $default,) {final _that = this;
switch (_that) {
case _ScheduleRideModel():
return $default(_that.pickupPoint,_that.destination,_that.distanceKm,_that.durationMins,_that.fareAmount,_that.currencySymbol,_that.selectedDate,_that.selectedTime,_that.isAm,_that.instantNotification,_that.checklistItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String pickupPoint,  String destination,  double distanceKm,  int durationMins,  double fareAmount,  String currencySymbol,  String selectedDate,  String selectedTime,  bool isAm,  bool instantNotification,  List<String> checklistItems)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleRideModel() when $default != null:
return $default(_that.pickupPoint,_that.destination,_that.distanceKm,_that.durationMins,_that.fareAmount,_that.currencySymbol,_that.selectedDate,_that.selectedTime,_that.isAm,_that.instantNotification,_that.checklistItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleRideModel implements ScheduleRideModel {
  const _ScheduleRideModel({required this.pickupPoint, required this.destination, required this.distanceKm, required this.durationMins, required this.fareAmount, required this.currencySymbol, required this.selectedDate, required this.selectedTime, required this.isAm, required this.instantNotification, required final  List<String> checklistItems}): _checklistItems = checklistItems;
  factory _ScheduleRideModel.fromJson(Map<String, dynamic> json) => _$ScheduleRideModelFromJson(json);

@override final  String pickupPoint;
@override final  String destination;
@override final  double distanceKm;
@override final  int durationMins;
@override final  double fareAmount;
@override final  String currencySymbol;
@override final  String selectedDate;
@override final  String selectedTime;
@override final  bool isAm;
@override final  bool instantNotification;
 final  List<String> _checklistItems;
@override List<String> get checklistItems {
  if (_checklistItems is EqualUnmodifiableListView) return _checklistItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_checklistItems);
}


/// Create a copy of ScheduleRideModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleRideModelCopyWith<_ScheduleRideModel> get copyWith => __$ScheduleRideModelCopyWithImpl<_ScheduleRideModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleRideModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleRideModel&&(identical(other.pickupPoint, pickupPoint) || other.pickupPoint == pickupPoint)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.durationMins, durationMins) || other.durationMins == durationMins)&&(identical(other.fareAmount, fareAmount) || other.fareAmount == fareAmount)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.selectedTime, selectedTime) || other.selectedTime == selectedTime)&&(identical(other.isAm, isAm) || other.isAm == isAm)&&(identical(other.instantNotification, instantNotification) || other.instantNotification == instantNotification)&&const DeepCollectionEquality().equals(other._checklistItems, _checklistItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pickupPoint,destination,distanceKm,durationMins,fareAmount,currencySymbol,selectedDate,selectedTime,isAm,instantNotification,const DeepCollectionEquality().hash(_checklistItems));

@override
String toString() {
  return 'ScheduleRideModel(pickupPoint: $pickupPoint, destination: $destination, distanceKm: $distanceKm, durationMins: $durationMins, fareAmount: $fareAmount, currencySymbol: $currencySymbol, selectedDate: $selectedDate, selectedTime: $selectedTime, isAm: $isAm, instantNotification: $instantNotification, checklistItems: $checklistItems)';
}


}

/// @nodoc
abstract mixin class _$ScheduleRideModelCopyWith<$Res> implements $ScheduleRideModelCopyWith<$Res> {
  factory _$ScheduleRideModelCopyWith(_ScheduleRideModel value, $Res Function(_ScheduleRideModel) _then) = __$ScheduleRideModelCopyWithImpl;
@override @useResult
$Res call({
 String pickupPoint, String destination, double distanceKm, int durationMins, double fareAmount, String currencySymbol, String selectedDate, String selectedTime, bool isAm, bool instantNotification, List<String> checklistItems
});




}
/// @nodoc
class __$ScheduleRideModelCopyWithImpl<$Res>
    implements _$ScheduleRideModelCopyWith<$Res> {
  __$ScheduleRideModelCopyWithImpl(this._self, this._then);

  final _ScheduleRideModel _self;
  final $Res Function(_ScheduleRideModel) _then;

/// Create a copy of ScheduleRideModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pickupPoint = null,Object? destination = null,Object? distanceKm = null,Object? durationMins = null,Object? fareAmount = null,Object? currencySymbol = null,Object? selectedDate = null,Object? selectedTime = null,Object? isAm = null,Object? instantNotification = null,Object? checklistItems = null,}) {
  return _then(_ScheduleRideModel(
pickupPoint: null == pickupPoint ? _self.pickupPoint : pickupPoint // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,durationMins: null == durationMins ? _self.durationMins : durationMins // ignore: cast_nullable_to_non_nullable
as int,fareAmount: null == fareAmount ? _self.fareAmount : fareAmount // ignore: cast_nullable_to_non_nullable
as double,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,selectedDate: null == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as String,selectedTime: null == selectedTime ? _self.selectedTime : selectedTime // ignore: cast_nullable_to_non_nullable
as String,isAm: null == isAm ? _self.isAm : isAm // ignore: cast_nullable_to_non_nullable
as bool,instantNotification: null == instantNotification ? _self.instantNotification : instantNotification // ignore: cast_nullable_to_non_nullable
as bool,checklistItems: null == checklistItems ? _self._checklistItems : checklistItems // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
