// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ride_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RideHistoryModel {

 String get monthlySummaryTitle; String get tripCountText; String get distanceText; String get spentText; List<PastRideItemModel> get pastRides;
/// Create a copy of RideHistoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RideHistoryModelCopyWith<RideHistoryModel> get copyWith => _$RideHistoryModelCopyWithImpl<RideHistoryModel>(this as RideHistoryModel, _$identity);

  /// Serializes this RideHistoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RideHistoryModel&&(identical(other.monthlySummaryTitle, monthlySummaryTitle) || other.monthlySummaryTitle == monthlySummaryTitle)&&(identical(other.tripCountText, tripCountText) || other.tripCountText == tripCountText)&&(identical(other.distanceText, distanceText) || other.distanceText == distanceText)&&(identical(other.spentText, spentText) || other.spentText == spentText)&&const DeepCollectionEquality().equals(other.pastRides, pastRides));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monthlySummaryTitle,tripCountText,distanceText,spentText,const DeepCollectionEquality().hash(pastRides));

@override
String toString() {
  return 'RideHistoryModel(monthlySummaryTitle: $monthlySummaryTitle, tripCountText: $tripCountText, distanceText: $distanceText, spentText: $spentText, pastRides: $pastRides)';
}


}

/// @nodoc
abstract mixin class $RideHistoryModelCopyWith<$Res>  {
  factory $RideHistoryModelCopyWith(RideHistoryModel value, $Res Function(RideHistoryModel) _then) = _$RideHistoryModelCopyWithImpl;
@useResult
$Res call({
 String monthlySummaryTitle, String tripCountText, String distanceText, String spentText, List<PastRideItemModel> pastRides
});




}
/// @nodoc
class _$RideHistoryModelCopyWithImpl<$Res>
    implements $RideHistoryModelCopyWith<$Res> {
  _$RideHistoryModelCopyWithImpl(this._self, this._then);

  final RideHistoryModel _self;
  final $Res Function(RideHistoryModel) _then;

/// Create a copy of RideHistoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monthlySummaryTitle = null,Object? tripCountText = null,Object? distanceText = null,Object? spentText = null,Object? pastRides = null,}) {
  return _then(_self.copyWith(
monthlySummaryTitle: null == monthlySummaryTitle ? _self.monthlySummaryTitle : monthlySummaryTitle // ignore: cast_nullable_to_non_nullable
as String,tripCountText: null == tripCountText ? _self.tripCountText : tripCountText // ignore: cast_nullable_to_non_nullable
as String,distanceText: null == distanceText ? _self.distanceText : distanceText // ignore: cast_nullable_to_non_nullable
as String,spentText: null == spentText ? _self.spentText : spentText // ignore: cast_nullable_to_non_nullable
as String,pastRides: null == pastRides ? _self.pastRides : pastRides // ignore: cast_nullable_to_non_nullable
as List<PastRideItemModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [RideHistoryModel].
extension RideHistoryModelPatterns on RideHistoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RideHistoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RideHistoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RideHistoryModel value)  $default,){
final _that = this;
switch (_that) {
case _RideHistoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RideHistoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _RideHistoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String monthlySummaryTitle,  String tripCountText,  String distanceText,  String spentText,  List<PastRideItemModel> pastRides)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RideHistoryModel() when $default != null:
return $default(_that.monthlySummaryTitle,_that.tripCountText,_that.distanceText,_that.spentText,_that.pastRides);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String monthlySummaryTitle,  String tripCountText,  String distanceText,  String spentText,  List<PastRideItemModel> pastRides)  $default,) {final _that = this;
switch (_that) {
case _RideHistoryModel():
return $default(_that.monthlySummaryTitle,_that.tripCountText,_that.distanceText,_that.spentText,_that.pastRides);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String monthlySummaryTitle,  String tripCountText,  String distanceText,  String spentText,  List<PastRideItemModel> pastRides)?  $default,) {final _that = this;
switch (_that) {
case _RideHistoryModel() when $default != null:
return $default(_that.monthlySummaryTitle,_that.tripCountText,_that.distanceText,_that.spentText,_that.pastRides);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RideHistoryModel implements RideHistoryModel {
  const _RideHistoryModel({required this.monthlySummaryTitle, required this.tripCountText, required this.distanceText, required this.spentText, required final  List<PastRideItemModel> pastRides}): _pastRides = pastRides;
  factory _RideHistoryModel.fromJson(Map<String, dynamic> json) => _$RideHistoryModelFromJson(json);

@override final  String monthlySummaryTitle;
@override final  String tripCountText;
@override final  String distanceText;
@override final  String spentText;
 final  List<PastRideItemModel> _pastRides;
@override List<PastRideItemModel> get pastRides {
  if (_pastRides is EqualUnmodifiableListView) return _pastRides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pastRides);
}


/// Create a copy of RideHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RideHistoryModelCopyWith<_RideHistoryModel> get copyWith => __$RideHistoryModelCopyWithImpl<_RideHistoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RideHistoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RideHistoryModel&&(identical(other.monthlySummaryTitle, monthlySummaryTitle) || other.monthlySummaryTitle == monthlySummaryTitle)&&(identical(other.tripCountText, tripCountText) || other.tripCountText == tripCountText)&&(identical(other.distanceText, distanceText) || other.distanceText == distanceText)&&(identical(other.spentText, spentText) || other.spentText == spentText)&&const DeepCollectionEquality().equals(other._pastRides, _pastRides));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monthlySummaryTitle,tripCountText,distanceText,spentText,const DeepCollectionEquality().hash(_pastRides));

@override
String toString() {
  return 'RideHistoryModel(monthlySummaryTitle: $monthlySummaryTitle, tripCountText: $tripCountText, distanceText: $distanceText, spentText: $spentText, pastRides: $pastRides)';
}


}

/// @nodoc
abstract mixin class _$RideHistoryModelCopyWith<$Res> implements $RideHistoryModelCopyWith<$Res> {
  factory _$RideHistoryModelCopyWith(_RideHistoryModel value, $Res Function(_RideHistoryModel) _then) = __$RideHistoryModelCopyWithImpl;
@override @useResult
$Res call({
 String monthlySummaryTitle, String tripCountText, String distanceText, String spentText, List<PastRideItemModel> pastRides
});




}
/// @nodoc
class __$RideHistoryModelCopyWithImpl<$Res>
    implements _$RideHistoryModelCopyWith<$Res> {
  __$RideHistoryModelCopyWithImpl(this._self, this._then);

  final _RideHistoryModel _self;
  final $Res Function(_RideHistoryModel) _then;

/// Create a copy of RideHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monthlySummaryTitle = null,Object? tripCountText = null,Object? distanceText = null,Object? spentText = null,Object? pastRides = null,}) {
  return _then(_RideHistoryModel(
monthlySummaryTitle: null == monthlySummaryTitle ? _self.monthlySummaryTitle : monthlySummaryTitle // ignore: cast_nullable_to_non_nullable
as String,tripCountText: null == tripCountText ? _self.tripCountText : tripCountText // ignore: cast_nullable_to_non_nullable
as String,distanceText: null == distanceText ? _self.distanceText : distanceText // ignore: cast_nullable_to_non_nullable
as String,spentText: null == spentText ? _self.spentText : spentText // ignore: cast_nullable_to_non_nullable
as String,pastRides: null == pastRides ? _self._pastRides : pastRides // ignore: cast_nullable_to_non_nullable
as List<PastRideItemModel>,
  ));
}


}

// dart format on
