// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'earnings_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EarningsActivityEntity {

 String get id; String get type; String get title; String get subtitle; double get amount; DateTime get timestamp;
/// Create a copy of EarningsActivityEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarningsActivityEntityCopyWith<EarningsActivityEntity> get copyWith => _$EarningsActivityEntityCopyWithImpl<EarningsActivityEntity>(this as EarningsActivityEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EarningsActivityEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,title,subtitle,amount,timestamp);

@override
String toString() {
  return 'EarningsActivityEntity(id: $id, type: $type, title: $title, subtitle: $subtitle, amount: $amount, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $EarningsActivityEntityCopyWith<$Res>  {
  factory $EarningsActivityEntityCopyWith(EarningsActivityEntity value, $Res Function(EarningsActivityEntity) _then) = _$EarningsActivityEntityCopyWithImpl;
@useResult
$Res call({
 String id, String type, String title, String subtitle, double amount, DateTime timestamp
});




}
/// @nodoc
class _$EarningsActivityEntityCopyWithImpl<$Res>
    implements $EarningsActivityEntityCopyWith<$Res> {
  _$EarningsActivityEntityCopyWithImpl(this._self, this._then);

  final EarningsActivityEntity _self;
  final $Res Function(EarningsActivityEntity) _then;

/// Create a copy of EarningsActivityEntity
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


/// Adds pattern-matching-related methods to [EarningsActivityEntity].
extension EarningsActivityEntityPatterns on EarningsActivityEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EarningsActivityEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EarningsActivityEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EarningsActivityEntity value)  $default,){
final _that = this;
switch (_that) {
case _EarningsActivityEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EarningsActivityEntity value)?  $default,){
final _that = this;
switch (_that) {
case _EarningsActivityEntity() when $default != null:
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
case _EarningsActivityEntity() when $default != null:
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
case _EarningsActivityEntity():
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
case _EarningsActivityEntity() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.subtitle,_that.amount,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc


class _EarningsActivityEntity implements EarningsActivityEntity {
  const _EarningsActivityEntity({required this.id, required this.type, required this.title, required this.subtitle, required this.amount, required this.timestamp});
  

@override final  String id;
@override final  String type;
@override final  String title;
@override final  String subtitle;
@override final  double amount;
@override final  DateTime timestamp;

/// Create a copy of EarningsActivityEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarningsActivityEntityCopyWith<_EarningsActivityEntity> get copyWith => __$EarningsActivityEntityCopyWithImpl<_EarningsActivityEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EarningsActivityEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,title,subtitle,amount,timestamp);

@override
String toString() {
  return 'EarningsActivityEntity(id: $id, type: $type, title: $title, subtitle: $subtitle, amount: $amount, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$EarningsActivityEntityCopyWith<$Res> implements $EarningsActivityEntityCopyWith<$Res> {
  factory _$EarningsActivityEntityCopyWith(_EarningsActivityEntity value, $Res Function(_EarningsActivityEntity) _then) = __$EarningsActivityEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String title, String subtitle, double amount, DateTime timestamp
});




}
/// @nodoc
class __$EarningsActivityEntityCopyWithImpl<$Res>
    implements _$EarningsActivityEntityCopyWith<$Res> {
  __$EarningsActivityEntityCopyWithImpl(this._self, this._then);

  final _EarningsActivityEntity _self;
  final $Res Function(_EarningsActivityEntity) _then;

/// Create a copy of EarningsActivityEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? subtitle = null,Object? amount = null,Object? timestamp = null,}) {
  return _then(_EarningsActivityEntity(
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
mixin _$EarningsEntity {

 double get totalEarnings; int get trips; double get hours; double get rating; List<EarningsActivityEntity> get recentActivities;
/// Create a copy of EarningsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarningsEntityCopyWith<EarningsEntity> get copyWith => _$EarningsEntityCopyWithImpl<EarningsEntity>(this as EarningsEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EarningsEntity&&(identical(other.totalEarnings, totalEarnings) || other.totalEarnings == totalEarnings)&&(identical(other.trips, trips) || other.trips == trips)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.rating, rating) || other.rating == rating)&&const DeepCollectionEquality().equals(other.recentActivities, recentActivities));
}


@override
int get hashCode => Object.hash(runtimeType,totalEarnings,trips,hours,rating,const DeepCollectionEquality().hash(recentActivities));

@override
String toString() {
  return 'EarningsEntity(totalEarnings: $totalEarnings, trips: $trips, hours: $hours, rating: $rating, recentActivities: $recentActivities)';
}


}

/// @nodoc
abstract mixin class $EarningsEntityCopyWith<$Res>  {
  factory $EarningsEntityCopyWith(EarningsEntity value, $Res Function(EarningsEntity) _then) = _$EarningsEntityCopyWithImpl;
@useResult
$Res call({
 double totalEarnings, int trips, double hours, double rating, List<EarningsActivityEntity> recentActivities
});




}
/// @nodoc
class _$EarningsEntityCopyWithImpl<$Res>
    implements $EarningsEntityCopyWith<$Res> {
  _$EarningsEntityCopyWithImpl(this._self, this._then);

  final EarningsEntity _self;
  final $Res Function(EarningsEntity) _then;

/// Create a copy of EarningsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalEarnings = null,Object? trips = null,Object? hours = null,Object? rating = null,Object? recentActivities = null,}) {
  return _then(_self.copyWith(
totalEarnings: null == totalEarnings ? _self.totalEarnings : totalEarnings // ignore: cast_nullable_to_non_nullable
as double,trips: null == trips ? _self.trips : trips // ignore: cast_nullable_to_non_nullable
as int,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,recentActivities: null == recentActivities ? _self.recentActivities : recentActivities // ignore: cast_nullable_to_non_nullable
as List<EarningsActivityEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [EarningsEntity].
extension EarningsEntityPatterns on EarningsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EarningsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EarningsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EarningsEntity value)  $default,){
final _that = this;
switch (_that) {
case _EarningsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EarningsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _EarningsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalEarnings,  int trips,  double hours,  double rating,  List<EarningsActivityEntity> recentActivities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EarningsEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalEarnings,  int trips,  double hours,  double rating,  List<EarningsActivityEntity> recentActivities)  $default,) {final _that = this;
switch (_that) {
case _EarningsEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalEarnings,  int trips,  double hours,  double rating,  List<EarningsActivityEntity> recentActivities)?  $default,) {final _that = this;
switch (_that) {
case _EarningsEntity() when $default != null:
return $default(_that.totalEarnings,_that.trips,_that.hours,_that.rating,_that.recentActivities);case _:
  return null;

}
}

}

/// @nodoc


class _EarningsEntity implements EarningsEntity {
  const _EarningsEntity({required this.totalEarnings, required this.trips, required this.hours, required this.rating, required final  List<EarningsActivityEntity> recentActivities}): _recentActivities = recentActivities;
  

@override final  double totalEarnings;
@override final  int trips;
@override final  double hours;
@override final  double rating;
 final  List<EarningsActivityEntity> _recentActivities;
@override List<EarningsActivityEntity> get recentActivities {
  if (_recentActivities is EqualUnmodifiableListView) return _recentActivities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentActivities);
}


/// Create a copy of EarningsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarningsEntityCopyWith<_EarningsEntity> get copyWith => __$EarningsEntityCopyWithImpl<_EarningsEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EarningsEntity&&(identical(other.totalEarnings, totalEarnings) || other.totalEarnings == totalEarnings)&&(identical(other.trips, trips) || other.trips == trips)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.rating, rating) || other.rating == rating)&&const DeepCollectionEquality().equals(other._recentActivities, _recentActivities));
}


@override
int get hashCode => Object.hash(runtimeType,totalEarnings,trips,hours,rating,const DeepCollectionEquality().hash(_recentActivities));

@override
String toString() {
  return 'EarningsEntity(totalEarnings: $totalEarnings, trips: $trips, hours: $hours, rating: $rating, recentActivities: $recentActivities)';
}


}

/// @nodoc
abstract mixin class _$EarningsEntityCopyWith<$Res> implements $EarningsEntityCopyWith<$Res> {
  factory _$EarningsEntityCopyWith(_EarningsEntity value, $Res Function(_EarningsEntity) _then) = __$EarningsEntityCopyWithImpl;
@override @useResult
$Res call({
 double totalEarnings, int trips, double hours, double rating, List<EarningsActivityEntity> recentActivities
});




}
/// @nodoc
class __$EarningsEntityCopyWithImpl<$Res>
    implements _$EarningsEntityCopyWith<$Res> {
  __$EarningsEntityCopyWithImpl(this._self, this._then);

  final _EarningsEntity _self;
  final $Res Function(_EarningsEntity) _then;

/// Create a copy of EarningsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalEarnings = null,Object? trips = null,Object? hours = null,Object? rating = null,Object? recentActivities = null,}) {
  return _then(_EarningsEntity(
totalEarnings: null == totalEarnings ? _self.totalEarnings : totalEarnings // ignore: cast_nullable_to_non_nullable
as double,trips: null == trips ? _self.trips : trips // ignore: cast_nullable_to_non_nullable
as int,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,recentActivities: null == recentActivities ? _self._recentActivities : recentActivities // ignore: cast_nullable_to_non_nullable
as List<EarningsActivityEntity>,
  ));
}


}

// dart format on
