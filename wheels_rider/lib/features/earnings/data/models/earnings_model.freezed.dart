// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'earnings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EarningsActivityModel {

 String get id; String get type; String get title; String get subtitle; double get amount; DateTime get timestamp;
/// Create a copy of EarningsActivityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarningsActivityModelCopyWith<EarningsActivityModel> get copyWith => _$EarningsActivityModelCopyWithImpl<EarningsActivityModel>(this as EarningsActivityModel, _$identity);

  /// Serializes this EarningsActivityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EarningsActivityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,subtitle,amount,timestamp);

@override
String toString() {
  return 'EarningsActivityModel(id: $id, type: $type, title: $title, subtitle: $subtitle, amount: $amount, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $EarningsActivityModelCopyWith<$Res>  {
  factory $EarningsActivityModelCopyWith(EarningsActivityModel value, $Res Function(EarningsActivityModel) _then) = _$EarningsActivityModelCopyWithImpl;
@useResult
$Res call({
 String id, String type, String title, String subtitle, double amount, DateTime timestamp
});




}
/// @nodoc
class _$EarningsActivityModelCopyWithImpl<$Res>
    implements $EarningsActivityModelCopyWith<$Res> {
  _$EarningsActivityModelCopyWithImpl(this._self, this._then);

  final EarningsActivityModel _self;
  final $Res Function(EarningsActivityModel) _then;

/// Create a copy of EarningsActivityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? subtitle = null,Object? amount = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EarningsActivityModel].
extension EarningsActivityModelPatterns on EarningsActivityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EarningsActivityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EarningsActivityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EarningsActivityModel value)  $default,){
final _that = this;
switch (_that) {
case _EarningsActivityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EarningsActivityModel value)?  $default,){
final _that = this;
switch (_that) {
case _EarningsActivityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String title,  String subtitle,  double amount,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EarningsActivityModel() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.subtitle,_that.amount,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String title,  String subtitle,  double amount,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _EarningsActivityModel():
return $default(_that.id,_that.type,_that.title,_that.subtitle,_that.amount,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String title,  String subtitle,  double amount,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _EarningsActivityModel() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.subtitle,_that.amount,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EarningsActivityModel extends EarningsActivityModel {
  const _EarningsActivityModel({required this.id, required this.type, required this.title, required this.subtitle, required this.amount, required this.timestamp}): super._();
  factory _EarningsActivityModel.fromJson(Map<String, dynamic> json) => _$EarningsActivityModelFromJson(json);

@override final  String id;
@override final  String type;
@override final  String title;
@override final  String subtitle;
@override final  double amount;
@override final  DateTime timestamp;

/// Create a copy of EarningsActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarningsActivityModelCopyWith<_EarningsActivityModel> get copyWith => __$EarningsActivityModelCopyWithImpl<_EarningsActivityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EarningsActivityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EarningsActivityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,subtitle,amount,timestamp);

@override
String toString() {
  return 'EarningsActivityModel(id: $id, type: $type, title: $title, subtitle: $subtitle, amount: $amount, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$EarningsActivityModelCopyWith<$Res> implements $EarningsActivityModelCopyWith<$Res> {
  factory _$EarningsActivityModelCopyWith(_EarningsActivityModel value, $Res Function(_EarningsActivityModel) _then) = __$EarningsActivityModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String title, String subtitle, double amount, DateTime timestamp
});




}
/// @nodoc
class __$EarningsActivityModelCopyWithImpl<$Res>
    implements _$EarningsActivityModelCopyWith<$Res> {
  __$EarningsActivityModelCopyWithImpl(this._self, this._then);

  final _EarningsActivityModel _self;
  final $Res Function(_EarningsActivityModel) _then;

/// Create a copy of EarningsActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? subtitle = null,Object? amount = null,Object? timestamp = null,}) {
  return _then(_EarningsActivityModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$EarningsModel {

@JsonKey(name: 'total_earnings') double get totalEarnings; int get trips; double get hours; double get rating;@JsonKey(name: 'recent_activities') List<EarningsActivityModel> get recentActivities;
/// Create a copy of EarningsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarningsModelCopyWith<EarningsModel> get copyWith => _$EarningsModelCopyWithImpl<EarningsModel>(this as EarningsModel, _$identity);

  /// Serializes this EarningsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EarningsModel&&(identical(other.totalEarnings, totalEarnings) || other.totalEarnings == totalEarnings)&&(identical(other.trips, trips) || other.trips == trips)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.rating, rating) || other.rating == rating)&&const DeepCollectionEquality().equals(other.recentActivities, recentActivities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalEarnings,trips,hours,rating,const DeepCollectionEquality().hash(recentActivities));

@override
String toString() {
  return 'EarningsModel(totalEarnings: $totalEarnings, trips: $trips, hours: $hours, rating: $rating, recentActivities: $recentActivities)';
}


}

/// @nodoc
abstract mixin class $EarningsModelCopyWith<$Res>  {
  factory $EarningsModelCopyWith(EarningsModel value, $Res Function(EarningsModel) _then) = _$EarningsModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_earnings') double totalEarnings, int trips, double hours, double rating,@JsonKey(name: 'recent_activities') List<EarningsActivityModel> recentActivities
});




}
/// @nodoc
class _$EarningsModelCopyWithImpl<$Res>
    implements $EarningsModelCopyWith<$Res> {
  _$EarningsModelCopyWithImpl(this._self, this._then);

  final EarningsModel _self;
  final $Res Function(EarningsModel) _then;

/// Create a copy of EarningsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalEarnings = null,Object? trips = null,Object? hours = null,Object? rating = null,Object? recentActivities = null,}) {
  return _then(_self.copyWith(
totalEarnings: null == totalEarnings ? _self.totalEarnings : totalEarnings // ignore: cast_nullable_to_non_nullable
as double,trips: null == trips ? _self.trips : trips // ignore: cast_nullable_to_non_nullable
as int,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,recentActivities: null == recentActivities ? _self.recentActivities : recentActivities // ignore: cast_nullable_to_non_nullable
as List<EarningsActivityModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [EarningsModel].
extension EarningsModelPatterns on EarningsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EarningsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EarningsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EarningsModel value)  $default,){
final _that = this;
switch (_that) {
case _EarningsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EarningsModel value)?  $default,){
final _that = this;
switch (_that) {
case _EarningsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_earnings')  double totalEarnings,  int trips,  double hours,  double rating, @JsonKey(name: 'recent_activities')  List<EarningsActivityModel> recentActivities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EarningsModel() when $default != null:
return $default(_that.totalEarnings,_that.trips,_that.hours,_that.rating,_that.recentActivities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_earnings')  double totalEarnings,  int trips,  double hours,  double rating, @JsonKey(name: 'recent_activities')  List<EarningsActivityModel> recentActivities)  $default,) {final _that = this;
switch (_that) {
case _EarningsModel():
return $default(_that.totalEarnings,_that.trips,_that.hours,_that.rating,_that.recentActivities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_earnings')  double totalEarnings,  int trips,  double hours,  double rating, @JsonKey(name: 'recent_activities')  List<EarningsActivityModel> recentActivities)?  $default,) {final _that = this;
switch (_that) {
case _EarningsModel() when $default != null:
return $default(_that.totalEarnings,_that.trips,_that.hours,_that.rating,_that.recentActivities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EarningsModel extends EarningsModel {
  const _EarningsModel({@JsonKey(name: 'total_earnings') required this.totalEarnings, required this.trips, required this.hours, required this.rating, @JsonKey(name: 'recent_activities') required final  List<EarningsActivityModel> recentActivities}): _recentActivities = recentActivities,super._();
  factory _EarningsModel.fromJson(Map<String, dynamic> json) => _$EarningsModelFromJson(json);

@override@JsonKey(name: 'total_earnings') final  double totalEarnings;
@override final  int trips;
@override final  double hours;
@override final  double rating;
 final  List<EarningsActivityModel> _recentActivities;
@override@JsonKey(name: 'recent_activities') List<EarningsActivityModel> get recentActivities {
  if (_recentActivities is EqualUnmodifiableListView) return _recentActivities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentActivities);
}


/// Create a copy of EarningsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarningsModelCopyWith<_EarningsModel> get copyWith => __$EarningsModelCopyWithImpl<_EarningsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EarningsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EarningsModel&&(identical(other.totalEarnings, totalEarnings) || other.totalEarnings == totalEarnings)&&(identical(other.trips, trips) || other.trips == trips)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.rating, rating) || other.rating == rating)&&const DeepCollectionEquality().equals(other._recentActivities, _recentActivities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalEarnings,trips,hours,rating,const DeepCollectionEquality().hash(_recentActivities));

@override
String toString() {
  return 'EarningsModel(totalEarnings: $totalEarnings, trips: $trips, hours: $hours, rating: $rating, recentActivities: $recentActivities)';
}


}

/// @nodoc
abstract mixin class _$EarningsModelCopyWith<$Res> implements $EarningsModelCopyWith<$Res> {
  factory _$EarningsModelCopyWith(_EarningsModel value, $Res Function(_EarningsModel) _then) = __$EarningsModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_earnings') double totalEarnings, int trips, double hours, double rating,@JsonKey(name: 'recent_activities') List<EarningsActivityModel> recentActivities
});




}
/// @nodoc
class __$EarningsModelCopyWithImpl<$Res>
    implements _$EarningsModelCopyWith<$Res> {
  __$EarningsModelCopyWithImpl(this._self, this._then);

  final _EarningsModel _self;
  final $Res Function(_EarningsModel) _then;

/// Create a copy of EarningsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalEarnings = null,Object? trips = null,Object? hours = null,Object? rating = null,Object? recentActivities = null,}) {
  return _then(_EarningsModel(
totalEarnings: null == totalEarnings ? _self.totalEarnings : totalEarnings // ignore: cast_nullable_to_non_nullable
as double,trips: null == trips ? _self.trips : trips // ignore: cast_nullable_to_non_nullable
as int,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,recentActivities: null == recentActivities ? _self._recentActivities : recentActivities // ignore: cast_nullable_to_non_nullable
as List<EarningsActivityModel>,
  ));
}


}

// dart format on
