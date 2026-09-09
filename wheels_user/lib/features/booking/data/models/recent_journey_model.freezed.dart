// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_journey_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecentJourneyModel {

 String get id; String get title; String get origin; String get timestamp; String get iconType;
/// Create a copy of RecentJourneyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentJourneyModelCopyWith<RecentJourneyModel> get copyWith => _$RecentJourneyModelCopyWithImpl<RecentJourneyModel>(this as RecentJourneyModel, _$identity);

  /// Serializes this RecentJourneyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentJourneyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.iconType, iconType) || other.iconType == iconType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,origin,timestamp,iconType);

@override
String toString() {
  return 'RecentJourneyModel(id: $id, title: $title, origin: $origin, timestamp: $timestamp, iconType: $iconType)';
}


}

/// @nodoc
abstract mixin class $RecentJourneyModelCopyWith<$Res>  {
  factory $RecentJourneyModelCopyWith(RecentJourneyModel value, $Res Function(RecentJourneyModel) _then) = _$RecentJourneyModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String origin, String timestamp, String iconType
});




}
/// @nodoc
class _$RecentJourneyModelCopyWithImpl<$Res>
    implements $RecentJourneyModelCopyWith<$Res> {
  _$RecentJourneyModelCopyWithImpl(this._self, this._then);

  final RecentJourneyModel _self;
  final $Res Function(RecentJourneyModel) _then;

/// Create a copy of RecentJourneyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? origin = null,Object? timestamp = null,Object? iconType = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,iconType: null == iconType ? _self.iconType : iconType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentJourneyModel].
extension RecentJourneyModelPatterns on RecentJourneyModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentJourneyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentJourneyModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentJourneyModel value)  $default,){
final _that = this;
switch (_that) {
case _RecentJourneyModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentJourneyModel value)?  $default,){
final _that = this;
switch (_that) {
case _RecentJourneyModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String origin,  String timestamp,  String iconType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentJourneyModel() when $default != null:
return $default(_that.id,_that.title,_that.origin,_that.timestamp,_that.iconType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String origin,  String timestamp,  String iconType)  $default,) {final _that = this;
switch (_that) {
case _RecentJourneyModel():
return $default(_that.id,_that.title,_that.origin,_that.timestamp,_that.iconType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String origin,  String timestamp,  String iconType)?  $default,) {final _that = this;
switch (_that) {
case _RecentJourneyModel() when $default != null:
return $default(_that.id,_that.title,_that.origin,_that.timestamp,_that.iconType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecentJourneyModel implements RecentJourneyModel {
  const _RecentJourneyModel({required this.id, required this.title, required this.origin, required this.timestamp, required this.iconType});
  factory _RecentJourneyModel.fromJson(Map<String, dynamic> json) => _$RecentJourneyModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String origin;
@override final  String timestamp;
@override final  String iconType;

/// Create a copy of RecentJourneyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentJourneyModelCopyWith<_RecentJourneyModel> get copyWith => __$RecentJourneyModelCopyWithImpl<_RecentJourneyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecentJourneyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentJourneyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.iconType, iconType) || other.iconType == iconType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,origin,timestamp,iconType);

@override
String toString() {
  return 'RecentJourneyModel(id: $id, title: $title, origin: $origin, timestamp: $timestamp, iconType: $iconType)';
}


}

/// @nodoc
abstract mixin class _$RecentJourneyModelCopyWith<$Res> implements $RecentJourneyModelCopyWith<$Res> {
  factory _$RecentJourneyModelCopyWith(_RecentJourneyModel value, $Res Function(_RecentJourneyModel) _then) = __$RecentJourneyModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String origin, String timestamp, String iconType
});




}
/// @nodoc
class __$RecentJourneyModelCopyWithImpl<$Res>
    implements _$RecentJourneyModelCopyWith<$Res> {
  __$RecentJourneyModelCopyWithImpl(this._self, this._then);

  final _RecentJourneyModel _self;
  final $Res Function(_RecentJourneyModel) _then;

/// Create a copy of RecentJourneyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? origin = null,Object? timestamp = null,Object? iconType = null,}) {
  return _then(_RecentJourneyModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,iconType: null == iconType ? _self.iconType : iconType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
