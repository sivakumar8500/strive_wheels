// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fare_estimate_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FareEstimateModel {

@JsonKey(name: 'service_mode') String get serviceMode;@JsonKey(name: 'vehicle_type_id') int get vehicleTypeId;@JsonKey(name: 'estimated_distance_km') double get estimatedDistanceKm;@JsonKey(name: 'estimated_duration_mins') int get estimatedDurationMins;@JsonKey(name: 'base_fare') double get baseFare;@JsonKey(name: 'distance_charge') double get distanceCharge;@JsonKey(name: 'time_charge') double get timeCharge;@JsonKey(name: 'waiting_charge') double get waitingCharge;@JsonKey(name: 'discount_amount') double get discountAmount;@JsonKey(name: 'surge_multiplier') double get surgeMultiplier;@JsonKey(name: 'estimated_fare') double get estimatedFare;
/// Create a copy of FareEstimateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FareEstimateModelCopyWith<FareEstimateModel> get copyWith => _$FareEstimateModelCopyWithImpl<FareEstimateModel>(this as FareEstimateModel, _$identity);

  /// Serializes this FareEstimateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FareEstimateModel&&(identical(other.serviceMode, serviceMode) || other.serviceMode == serviceMode)&&(identical(other.vehicleTypeId, vehicleTypeId) || other.vehicleTypeId == vehicleTypeId)&&(identical(other.estimatedDistanceKm, estimatedDistanceKm) || other.estimatedDistanceKm == estimatedDistanceKm)&&(identical(other.estimatedDurationMins, estimatedDurationMins) || other.estimatedDurationMins == estimatedDurationMins)&&(identical(other.baseFare, baseFare) || other.baseFare == baseFare)&&(identical(other.distanceCharge, distanceCharge) || other.distanceCharge == distanceCharge)&&(identical(other.timeCharge, timeCharge) || other.timeCharge == timeCharge)&&(identical(other.waitingCharge, waitingCharge) || other.waitingCharge == waitingCharge)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.surgeMultiplier, surgeMultiplier) || other.surgeMultiplier == surgeMultiplier)&&(identical(other.estimatedFare, estimatedFare) || other.estimatedFare == estimatedFare));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serviceMode,vehicleTypeId,estimatedDistanceKm,estimatedDurationMins,baseFare,distanceCharge,timeCharge,waitingCharge,discountAmount,surgeMultiplier,estimatedFare);

@override
String toString() {
  return 'FareEstimateModel(serviceMode: $serviceMode, vehicleTypeId: $vehicleTypeId, estimatedDistanceKm: $estimatedDistanceKm, estimatedDurationMins: $estimatedDurationMins, baseFare: $baseFare, distanceCharge: $distanceCharge, timeCharge: $timeCharge, waitingCharge: $waitingCharge, discountAmount: $discountAmount, surgeMultiplier: $surgeMultiplier, estimatedFare: $estimatedFare)';
}


}

/// @nodoc
abstract mixin class $FareEstimateModelCopyWith<$Res>  {
  factory $FareEstimateModelCopyWith(FareEstimateModel value, $Res Function(FareEstimateModel) _then) = _$FareEstimateModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'service_mode') String serviceMode,@JsonKey(name: 'vehicle_type_id') int vehicleTypeId,@JsonKey(name: 'estimated_distance_km') double estimatedDistanceKm,@JsonKey(name: 'estimated_duration_mins') int estimatedDurationMins,@JsonKey(name: 'base_fare') double baseFare,@JsonKey(name: 'distance_charge') double distanceCharge,@JsonKey(name: 'time_charge') double timeCharge,@JsonKey(name: 'waiting_charge') double waitingCharge,@JsonKey(name: 'discount_amount') double discountAmount,@JsonKey(name: 'surge_multiplier') double surgeMultiplier,@JsonKey(name: 'estimated_fare') double estimatedFare
});




}
/// @nodoc
class _$FareEstimateModelCopyWithImpl<$Res>
    implements $FareEstimateModelCopyWith<$Res> {
  _$FareEstimateModelCopyWithImpl(this._self, this._then);

  final FareEstimateModel _self;
  final $Res Function(FareEstimateModel) _then;

/// Create a copy of FareEstimateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serviceMode = null,Object? vehicleTypeId = null,Object? estimatedDistanceKm = null,Object? estimatedDurationMins = null,Object? baseFare = null,Object? distanceCharge = null,Object? timeCharge = null,Object? waitingCharge = null,Object? discountAmount = null,Object? surgeMultiplier = null,Object? estimatedFare = null,}) {
  return _then(_self.copyWith(
serviceMode: null == serviceMode ? _self.serviceMode : serviceMode // ignore: cast_nullable_to_non_nullable
as String,vehicleTypeId: null == vehicleTypeId ? _self.vehicleTypeId : vehicleTypeId // ignore: cast_nullable_to_non_nullable
as int,estimatedDistanceKm: null == estimatedDistanceKm ? _self.estimatedDistanceKm : estimatedDistanceKm // ignore: cast_nullable_to_non_nullable
as double,estimatedDurationMins: null == estimatedDurationMins ? _self.estimatedDurationMins : estimatedDurationMins // ignore: cast_nullable_to_non_nullable
as int,baseFare: null == baseFare ? _self.baseFare : baseFare // ignore: cast_nullable_to_non_nullable
as double,distanceCharge: null == distanceCharge ? _self.distanceCharge : distanceCharge // ignore: cast_nullable_to_non_nullable
as double,timeCharge: null == timeCharge ? _self.timeCharge : timeCharge // ignore: cast_nullable_to_non_nullable
as double,waitingCharge: null == waitingCharge ? _self.waitingCharge : waitingCharge // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,surgeMultiplier: null == surgeMultiplier ? _self.surgeMultiplier : surgeMultiplier // ignore: cast_nullable_to_non_nullable
as double,estimatedFare: null == estimatedFare ? _self.estimatedFare : estimatedFare // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FareEstimateModel].
extension FareEstimateModelPatterns on FareEstimateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FareEstimateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FareEstimateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FareEstimateModel value)  $default,){
final _that = this;
switch (_that) {
case _FareEstimateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FareEstimateModel value)?  $default,){
final _that = this;
switch (_that) {
case _FareEstimateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'service_mode')  String serviceMode, @JsonKey(name: 'vehicle_type_id')  int vehicleTypeId, @JsonKey(name: 'estimated_distance_km')  double estimatedDistanceKm, @JsonKey(name: 'estimated_duration_mins')  int estimatedDurationMins, @JsonKey(name: 'base_fare')  double baseFare, @JsonKey(name: 'distance_charge')  double distanceCharge, @JsonKey(name: 'time_charge')  double timeCharge, @JsonKey(name: 'waiting_charge')  double waitingCharge, @JsonKey(name: 'discount_amount')  double discountAmount, @JsonKey(name: 'surge_multiplier')  double surgeMultiplier, @JsonKey(name: 'estimated_fare')  double estimatedFare)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FareEstimateModel() when $default != null:
return $default(_that.serviceMode,_that.vehicleTypeId,_that.estimatedDistanceKm,_that.estimatedDurationMins,_that.baseFare,_that.distanceCharge,_that.timeCharge,_that.waitingCharge,_that.discountAmount,_that.surgeMultiplier,_that.estimatedFare);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'service_mode')  String serviceMode, @JsonKey(name: 'vehicle_type_id')  int vehicleTypeId, @JsonKey(name: 'estimated_distance_km')  double estimatedDistanceKm, @JsonKey(name: 'estimated_duration_mins')  int estimatedDurationMins, @JsonKey(name: 'base_fare')  double baseFare, @JsonKey(name: 'distance_charge')  double distanceCharge, @JsonKey(name: 'time_charge')  double timeCharge, @JsonKey(name: 'waiting_charge')  double waitingCharge, @JsonKey(name: 'discount_amount')  double discountAmount, @JsonKey(name: 'surge_multiplier')  double surgeMultiplier, @JsonKey(name: 'estimated_fare')  double estimatedFare)  $default,) {final _that = this;
switch (_that) {
case _FareEstimateModel():
return $default(_that.serviceMode,_that.vehicleTypeId,_that.estimatedDistanceKm,_that.estimatedDurationMins,_that.baseFare,_that.distanceCharge,_that.timeCharge,_that.waitingCharge,_that.discountAmount,_that.surgeMultiplier,_that.estimatedFare);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'service_mode')  String serviceMode, @JsonKey(name: 'vehicle_type_id')  int vehicleTypeId, @JsonKey(name: 'estimated_distance_km')  double estimatedDistanceKm, @JsonKey(name: 'estimated_duration_mins')  int estimatedDurationMins, @JsonKey(name: 'base_fare')  double baseFare, @JsonKey(name: 'distance_charge')  double distanceCharge, @JsonKey(name: 'time_charge')  double timeCharge, @JsonKey(name: 'waiting_charge')  double waitingCharge, @JsonKey(name: 'discount_amount')  double discountAmount, @JsonKey(name: 'surge_multiplier')  double surgeMultiplier, @JsonKey(name: 'estimated_fare')  double estimatedFare)?  $default,) {final _that = this;
switch (_that) {
case _FareEstimateModel() when $default != null:
return $default(_that.serviceMode,_that.vehicleTypeId,_that.estimatedDistanceKm,_that.estimatedDurationMins,_that.baseFare,_that.distanceCharge,_that.timeCharge,_that.waitingCharge,_that.discountAmount,_that.surgeMultiplier,_that.estimatedFare);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FareEstimateModel implements FareEstimateModel {
  const _FareEstimateModel({@JsonKey(name: 'service_mode') this.serviceMode = 'NORMAL', @JsonKey(name: 'vehicle_type_id') this.vehicleTypeId = 1, @JsonKey(name: 'estimated_distance_km') this.estimatedDistanceKm = 0.0, @JsonKey(name: 'estimated_duration_mins') this.estimatedDurationMins = 0, @JsonKey(name: 'base_fare') this.baseFare = 0.0, @JsonKey(name: 'distance_charge') this.distanceCharge = 0.0, @JsonKey(name: 'time_charge') this.timeCharge = 0.0, @JsonKey(name: 'waiting_charge') this.waitingCharge = 0.0, @JsonKey(name: 'discount_amount') this.discountAmount = 0.0, @JsonKey(name: 'surge_multiplier') this.surgeMultiplier = 1.0, @JsonKey(name: 'estimated_fare') this.estimatedFare = 0.0});
  factory _FareEstimateModel.fromJson(Map<String, dynamic> json) => _$FareEstimateModelFromJson(json);

@override@JsonKey(name: 'service_mode') final  String serviceMode;
@override@JsonKey(name: 'vehicle_type_id') final  int vehicleTypeId;
@override@JsonKey(name: 'estimated_distance_km') final  double estimatedDistanceKm;
@override@JsonKey(name: 'estimated_duration_mins') final  int estimatedDurationMins;
@override@JsonKey(name: 'base_fare') final  double baseFare;
@override@JsonKey(name: 'distance_charge') final  double distanceCharge;
@override@JsonKey(name: 'time_charge') final  double timeCharge;
@override@JsonKey(name: 'waiting_charge') final  double waitingCharge;
@override@JsonKey(name: 'discount_amount') final  double discountAmount;
@override@JsonKey(name: 'surge_multiplier') final  double surgeMultiplier;
@override@JsonKey(name: 'estimated_fare') final  double estimatedFare;

/// Create a copy of FareEstimateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FareEstimateModelCopyWith<_FareEstimateModel> get copyWith => __$FareEstimateModelCopyWithImpl<_FareEstimateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FareEstimateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FareEstimateModel&&(identical(other.serviceMode, serviceMode) || other.serviceMode == serviceMode)&&(identical(other.vehicleTypeId, vehicleTypeId) || other.vehicleTypeId == vehicleTypeId)&&(identical(other.estimatedDistanceKm, estimatedDistanceKm) || other.estimatedDistanceKm == estimatedDistanceKm)&&(identical(other.estimatedDurationMins, estimatedDurationMins) || other.estimatedDurationMins == estimatedDurationMins)&&(identical(other.baseFare, baseFare) || other.baseFare == baseFare)&&(identical(other.distanceCharge, distanceCharge) || other.distanceCharge == distanceCharge)&&(identical(other.timeCharge, timeCharge) || other.timeCharge == timeCharge)&&(identical(other.waitingCharge, waitingCharge) || other.waitingCharge == waitingCharge)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.surgeMultiplier, surgeMultiplier) || other.surgeMultiplier == surgeMultiplier)&&(identical(other.estimatedFare, estimatedFare) || other.estimatedFare == estimatedFare));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serviceMode,vehicleTypeId,estimatedDistanceKm,estimatedDurationMins,baseFare,distanceCharge,timeCharge,waitingCharge,discountAmount,surgeMultiplier,estimatedFare);

@override
String toString() {
  return 'FareEstimateModel(serviceMode: $serviceMode, vehicleTypeId: $vehicleTypeId, estimatedDistanceKm: $estimatedDistanceKm, estimatedDurationMins: $estimatedDurationMins, baseFare: $baseFare, distanceCharge: $distanceCharge, timeCharge: $timeCharge, waitingCharge: $waitingCharge, discountAmount: $discountAmount, surgeMultiplier: $surgeMultiplier, estimatedFare: $estimatedFare)';
}


}

/// @nodoc
abstract mixin class _$FareEstimateModelCopyWith<$Res> implements $FareEstimateModelCopyWith<$Res> {
  factory _$FareEstimateModelCopyWith(_FareEstimateModel value, $Res Function(_FareEstimateModel) _then) = __$FareEstimateModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'service_mode') String serviceMode,@JsonKey(name: 'vehicle_type_id') int vehicleTypeId,@JsonKey(name: 'estimated_distance_km') double estimatedDistanceKm,@JsonKey(name: 'estimated_duration_mins') int estimatedDurationMins,@JsonKey(name: 'base_fare') double baseFare,@JsonKey(name: 'distance_charge') double distanceCharge,@JsonKey(name: 'time_charge') double timeCharge,@JsonKey(name: 'waiting_charge') double waitingCharge,@JsonKey(name: 'discount_amount') double discountAmount,@JsonKey(name: 'surge_multiplier') double surgeMultiplier,@JsonKey(name: 'estimated_fare') double estimatedFare
});




}
/// @nodoc
class __$FareEstimateModelCopyWithImpl<$Res>
    implements _$FareEstimateModelCopyWith<$Res> {
  __$FareEstimateModelCopyWithImpl(this._self, this._then);

  final _FareEstimateModel _self;
  final $Res Function(_FareEstimateModel) _then;

/// Create a copy of FareEstimateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serviceMode = null,Object? vehicleTypeId = null,Object? estimatedDistanceKm = null,Object? estimatedDurationMins = null,Object? baseFare = null,Object? distanceCharge = null,Object? timeCharge = null,Object? waitingCharge = null,Object? discountAmount = null,Object? surgeMultiplier = null,Object? estimatedFare = null,}) {
  return _then(_FareEstimateModel(
serviceMode: null == serviceMode ? _self.serviceMode : serviceMode // ignore: cast_nullable_to_non_nullable
as String,vehicleTypeId: null == vehicleTypeId ? _self.vehicleTypeId : vehicleTypeId // ignore: cast_nullable_to_non_nullable
as int,estimatedDistanceKm: null == estimatedDistanceKm ? _self.estimatedDistanceKm : estimatedDistanceKm // ignore: cast_nullable_to_non_nullable
as double,estimatedDurationMins: null == estimatedDurationMins ? _self.estimatedDurationMins : estimatedDurationMins // ignore: cast_nullable_to_non_nullable
as int,baseFare: null == baseFare ? _self.baseFare : baseFare // ignore: cast_nullable_to_non_nullable
as double,distanceCharge: null == distanceCharge ? _self.distanceCharge : distanceCharge // ignore: cast_nullable_to_non_nullable
as double,timeCharge: null == timeCharge ? _self.timeCharge : timeCharge // ignore: cast_nullable_to_non_nullable
as double,waitingCharge: null == waitingCharge ? _self.waitingCharge : waitingCharge // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,surgeMultiplier: null == surgeMultiplier ? _self.surgeMultiplier : surgeMultiplier // ignore: cast_nullable_to_non_nullable
as double,estimatedFare: null == estimatedFare ? _self.estimatedFare : estimatedFare // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
