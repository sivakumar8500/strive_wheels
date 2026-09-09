// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_overview_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TripOverviewModel {

 String get pickupLocation; String get destination; String get tripType; String get distanceText; String get vehicleName; String get vehicleSeats; String get vehicleLuggage; String get vehicleAmenity; String get vehicleImagePath; double get walletBalance; double get baseFare; double get distanceCharge; double get serviceSurcharge; double get taxesFees; double get grandTotal; String get currency;
/// Create a copy of TripOverviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripOverviewModelCopyWith<TripOverviewModel> get copyWith => _$TripOverviewModelCopyWithImpl<TripOverviewModel>(this as TripOverviewModel, _$identity);

  /// Serializes this TripOverviewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripOverviewModel&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.tripType, tripType) || other.tripType == tripType)&&(identical(other.distanceText, distanceText) || other.distanceText == distanceText)&&(identical(other.vehicleName, vehicleName) || other.vehicleName == vehicleName)&&(identical(other.vehicleSeats, vehicleSeats) || other.vehicleSeats == vehicleSeats)&&(identical(other.vehicleLuggage, vehicleLuggage) || other.vehicleLuggage == vehicleLuggage)&&(identical(other.vehicleAmenity, vehicleAmenity) || other.vehicleAmenity == vehicleAmenity)&&(identical(other.vehicleImagePath, vehicleImagePath) || other.vehicleImagePath == vehicleImagePath)&&(identical(other.walletBalance, walletBalance) || other.walletBalance == walletBalance)&&(identical(other.baseFare, baseFare) || other.baseFare == baseFare)&&(identical(other.distanceCharge, distanceCharge) || other.distanceCharge == distanceCharge)&&(identical(other.serviceSurcharge, serviceSurcharge) || other.serviceSurcharge == serviceSurcharge)&&(identical(other.taxesFees, taxesFees) || other.taxesFees == taxesFees)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pickupLocation,destination,tripType,distanceText,vehicleName,vehicleSeats,vehicleLuggage,vehicleAmenity,vehicleImagePath,walletBalance,baseFare,distanceCharge,serviceSurcharge,taxesFees,grandTotal,currency);

@override
String toString() {
  return 'TripOverviewModel(pickupLocation: $pickupLocation, destination: $destination, tripType: $tripType, distanceText: $distanceText, vehicleName: $vehicleName, vehicleSeats: $vehicleSeats, vehicleLuggage: $vehicleLuggage, vehicleAmenity: $vehicleAmenity, vehicleImagePath: $vehicleImagePath, walletBalance: $walletBalance, baseFare: $baseFare, distanceCharge: $distanceCharge, serviceSurcharge: $serviceSurcharge, taxesFees: $taxesFees, grandTotal: $grandTotal, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $TripOverviewModelCopyWith<$Res>  {
  factory $TripOverviewModelCopyWith(TripOverviewModel value, $Res Function(TripOverviewModel) _then) = _$TripOverviewModelCopyWithImpl;
@useResult
$Res call({
 String pickupLocation, String destination, String tripType, String distanceText, String vehicleName, String vehicleSeats, String vehicleLuggage, String vehicleAmenity, String vehicleImagePath, double walletBalance, double baseFare, double distanceCharge, double serviceSurcharge, double taxesFees, double grandTotal, String currency
});




}
/// @nodoc
class _$TripOverviewModelCopyWithImpl<$Res>
    implements $TripOverviewModelCopyWith<$Res> {
  _$TripOverviewModelCopyWithImpl(this._self, this._then);

  final TripOverviewModel _self;
  final $Res Function(TripOverviewModel) _then;

/// Create a copy of TripOverviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pickupLocation = null,Object? destination = null,Object? tripType = null,Object? distanceText = null,Object? vehicleName = null,Object? vehicleSeats = null,Object? vehicleLuggage = null,Object? vehicleAmenity = null,Object? vehicleImagePath = null,Object? walletBalance = null,Object? baseFare = null,Object? distanceCharge = null,Object? serviceSurcharge = null,Object? taxesFees = null,Object? grandTotal = null,Object? currency = null,}) {
  return _then(_self.copyWith(
pickupLocation: null == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,tripType: null == tripType ? _self.tripType : tripType // ignore: cast_nullable_to_non_nullable
as String,distanceText: null == distanceText ? _self.distanceText : distanceText // ignore: cast_nullable_to_non_nullable
as String,vehicleName: null == vehicleName ? _self.vehicleName : vehicleName // ignore: cast_nullable_to_non_nullable
as String,vehicleSeats: null == vehicleSeats ? _self.vehicleSeats : vehicleSeats // ignore: cast_nullable_to_non_nullable
as String,vehicleLuggage: null == vehicleLuggage ? _self.vehicleLuggage : vehicleLuggage // ignore: cast_nullable_to_non_nullable
as String,vehicleAmenity: null == vehicleAmenity ? _self.vehicleAmenity : vehicleAmenity // ignore: cast_nullable_to_non_nullable
as String,vehicleImagePath: null == vehicleImagePath ? _self.vehicleImagePath : vehicleImagePath // ignore: cast_nullable_to_non_nullable
as String,walletBalance: null == walletBalance ? _self.walletBalance : walletBalance // ignore: cast_nullable_to_non_nullable
as double,baseFare: null == baseFare ? _self.baseFare : baseFare // ignore: cast_nullable_to_non_nullable
as double,distanceCharge: null == distanceCharge ? _self.distanceCharge : distanceCharge // ignore: cast_nullable_to_non_nullable
as double,serviceSurcharge: null == serviceSurcharge ? _self.serviceSurcharge : serviceSurcharge // ignore: cast_nullable_to_non_nullable
as double,taxesFees: null == taxesFees ? _self.taxesFees : taxesFees // ignore: cast_nullable_to_non_nullable
as double,grandTotal: null == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TripOverviewModel].
extension TripOverviewModelPatterns on TripOverviewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripOverviewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripOverviewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripOverviewModel value)  $default,){
final _that = this;
switch (_that) {
case _TripOverviewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripOverviewModel value)?  $default,){
final _that = this;
switch (_that) {
case _TripOverviewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String pickupLocation,  String destination,  String tripType,  String distanceText,  String vehicleName,  String vehicleSeats,  String vehicleLuggage,  String vehicleAmenity,  String vehicleImagePath,  double walletBalance,  double baseFare,  double distanceCharge,  double serviceSurcharge,  double taxesFees,  double grandTotal,  String currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripOverviewModel() when $default != null:
return $default(_that.pickupLocation,_that.destination,_that.tripType,_that.distanceText,_that.vehicleName,_that.vehicleSeats,_that.vehicleLuggage,_that.vehicleAmenity,_that.vehicleImagePath,_that.walletBalance,_that.baseFare,_that.distanceCharge,_that.serviceSurcharge,_that.taxesFees,_that.grandTotal,_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String pickupLocation,  String destination,  String tripType,  String distanceText,  String vehicleName,  String vehicleSeats,  String vehicleLuggage,  String vehicleAmenity,  String vehicleImagePath,  double walletBalance,  double baseFare,  double distanceCharge,  double serviceSurcharge,  double taxesFees,  double grandTotal,  String currency)  $default,) {final _that = this;
switch (_that) {
case _TripOverviewModel():
return $default(_that.pickupLocation,_that.destination,_that.tripType,_that.distanceText,_that.vehicleName,_that.vehicleSeats,_that.vehicleLuggage,_that.vehicleAmenity,_that.vehicleImagePath,_that.walletBalance,_that.baseFare,_that.distanceCharge,_that.serviceSurcharge,_that.taxesFees,_that.grandTotal,_that.currency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String pickupLocation,  String destination,  String tripType,  String distanceText,  String vehicleName,  String vehicleSeats,  String vehicleLuggage,  String vehicleAmenity,  String vehicleImagePath,  double walletBalance,  double baseFare,  double distanceCharge,  double serviceSurcharge,  double taxesFees,  double grandTotal,  String currency)?  $default,) {final _that = this;
switch (_that) {
case _TripOverviewModel() when $default != null:
return $default(_that.pickupLocation,_that.destination,_that.tripType,_that.distanceText,_that.vehicleName,_that.vehicleSeats,_that.vehicleLuggage,_that.vehicleAmenity,_that.vehicleImagePath,_that.walletBalance,_that.baseFare,_that.distanceCharge,_that.serviceSurcharge,_that.taxesFees,_that.grandTotal,_that.currency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripOverviewModel implements TripOverviewModel {
  const _TripOverviewModel({required this.pickupLocation, required this.destination, required this.tripType, required this.distanceText, required this.vehicleName, required this.vehicleSeats, required this.vehicleLuggage, required this.vehicleAmenity, required this.vehicleImagePath, required this.walletBalance, required this.baseFare, required this.distanceCharge, required this.serviceSurcharge, required this.taxesFees, required this.grandTotal, required this.currency});
  factory _TripOverviewModel.fromJson(Map<String, dynamic> json) => _$TripOverviewModelFromJson(json);

@override final  String pickupLocation;
@override final  String destination;
@override final  String tripType;
@override final  String distanceText;
@override final  String vehicleName;
@override final  String vehicleSeats;
@override final  String vehicleLuggage;
@override final  String vehicleAmenity;
@override final  String vehicleImagePath;
@override final  double walletBalance;
@override final  double baseFare;
@override final  double distanceCharge;
@override final  double serviceSurcharge;
@override final  double taxesFees;
@override final  double grandTotal;
@override final  String currency;

/// Create a copy of TripOverviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripOverviewModelCopyWith<_TripOverviewModel> get copyWith => __$TripOverviewModelCopyWithImpl<_TripOverviewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripOverviewModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripOverviewModel&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.tripType, tripType) || other.tripType == tripType)&&(identical(other.distanceText, distanceText) || other.distanceText == distanceText)&&(identical(other.vehicleName, vehicleName) || other.vehicleName == vehicleName)&&(identical(other.vehicleSeats, vehicleSeats) || other.vehicleSeats == vehicleSeats)&&(identical(other.vehicleLuggage, vehicleLuggage) || other.vehicleLuggage == vehicleLuggage)&&(identical(other.vehicleAmenity, vehicleAmenity) || other.vehicleAmenity == vehicleAmenity)&&(identical(other.vehicleImagePath, vehicleImagePath) || other.vehicleImagePath == vehicleImagePath)&&(identical(other.walletBalance, walletBalance) || other.walletBalance == walletBalance)&&(identical(other.baseFare, baseFare) || other.baseFare == baseFare)&&(identical(other.distanceCharge, distanceCharge) || other.distanceCharge == distanceCharge)&&(identical(other.serviceSurcharge, serviceSurcharge) || other.serviceSurcharge == serviceSurcharge)&&(identical(other.taxesFees, taxesFees) || other.taxesFees == taxesFees)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pickupLocation,destination,tripType,distanceText,vehicleName,vehicleSeats,vehicleLuggage,vehicleAmenity,vehicleImagePath,walletBalance,baseFare,distanceCharge,serviceSurcharge,taxesFees,grandTotal,currency);

@override
String toString() {
  return 'TripOverviewModel(pickupLocation: $pickupLocation, destination: $destination, tripType: $tripType, distanceText: $distanceText, vehicleName: $vehicleName, vehicleSeats: $vehicleSeats, vehicleLuggage: $vehicleLuggage, vehicleAmenity: $vehicleAmenity, vehicleImagePath: $vehicleImagePath, walletBalance: $walletBalance, baseFare: $baseFare, distanceCharge: $distanceCharge, serviceSurcharge: $serviceSurcharge, taxesFees: $taxesFees, grandTotal: $grandTotal, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$TripOverviewModelCopyWith<$Res> implements $TripOverviewModelCopyWith<$Res> {
  factory _$TripOverviewModelCopyWith(_TripOverviewModel value, $Res Function(_TripOverviewModel) _then) = __$TripOverviewModelCopyWithImpl;
@override @useResult
$Res call({
 String pickupLocation, String destination, String tripType, String distanceText, String vehicleName, String vehicleSeats, String vehicleLuggage, String vehicleAmenity, String vehicleImagePath, double walletBalance, double baseFare, double distanceCharge, double serviceSurcharge, double taxesFees, double grandTotal, String currency
});




}
/// @nodoc
class __$TripOverviewModelCopyWithImpl<$Res>
    implements _$TripOverviewModelCopyWith<$Res> {
  __$TripOverviewModelCopyWithImpl(this._self, this._then);

  final _TripOverviewModel _self;
  final $Res Function(_TripOverviewModel) _then;

/// Create a copy of TripOverviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pickupLocation = null,Object? destination = null,Object? tripType = null,Object? distanceText = null,Object? vehicleName = null,Object? vehicleSeats = null,Object? vehicleLuggage = null,Object? vehicleAmenity = null,Object? vehicleImagePath = null,Object? walletBalance = null,Object? baseFare = null,Object? distanceCharge = null,Object? serviceSurcharge = null,Object? taxesFees = null,Object? grandTotal = null,Object? currency = null,}) {
  return _then(_TripOverviewModel(
pickupLocation: null == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,tripType: null == tripType ? _self.tripType : tripType // ignore: cast_nullable_to_non_nullable
as String,distanceText: null == distanceText ? _self.distanceText : distanceText // ignore: cast_nullable_to_non_nullable
as String,vehicleName: null == vehicleName ? _self.vehicleName : vehicleName // ignore: cast_nullable_to_non_nullable
as String,vehicleSeats: null == vehicleSeats ? _self.vehicleSeats : vehicleSeats // ignore: cast_nullable_to_non_nullable
as String,vehicleLuggage: null == vehicleLuggage ? _self.vehicleLuggage : vehicleLuggage // ignore: cast_nullable_to_non_nullable
as String,vehicleAmenity: null == vehicleAmenity ? _self.vehicleAmenity : vehicleAmenity // ignore: cast_nullable_to_non_nullable
as String,vehicleImagePath: null == vehicleImagePath ? _self.vehicleImagePath : vehicleImagePath // ignore: cast_nullable_to_non_nullable
as String,walletBalance: null == walletBalance ? _self.walletBalance : walletBalance // ignore: cast_nullable_to_non_nullable
as double,baseFare: null == baseFare ? _self.baseFare : baseFare // ignore: cast_nullable_to_non_nullable
as double,distanceCharge: null == distanceCharge ? _self.distanceCharge : distanceCharge // ignore: cast_nullable_to_non_nullable
as double,serviceSurcharge: null == serviceSurcharge ? _self.serviceSurcharge : serviceSurcharge // ignore: cast_nullable_to_non_nullable
as double,taxesFees: null == taxesFees ? _self.taxesFees : taxesFees // ignore: cast_nullable_to_non_nullable
as double,grandTotal: null == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
