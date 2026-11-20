// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_permission_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPermissionModel {

 bool get isEnabled;
/// Create a copy of NotificationPermissionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPermissionModelCopyWith<NotificationPermissionModel> get copyWith => _$NotificationPermissionModelCopyWithImpl<NotificationPermissionModel>(this as NotificationPermissionModel, _$identity);

  /// Serializes this NotificationPermissionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPermissionModel&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isEnabled);

@override
String toString() {
  return 'NotificationPermissionModel(isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class $NotificationPermissionModelCopyWith<$Res>  {
  factory $NotificationPermissionModelCopyWith(NotificationPermissionModel value, $Res Function(NotificationPermissionModel) _then) = _$NotificationPermissionModelCopyWithImpl;
@useResult
$Res call({
 bool isEnabled
});




}
/// @nodoc
class _$NotificationPermissionModelCopyWithImpl<$Res>
    implements $NotificationPermissionModelCopyWith<$Res> {
  _$NotificationPermissionModelCopyWithImpl(this._self, this._then);

  final NotificationPermissionModel _self;
  final $Res Function(NotificationPermissionModel) _then;

/// Create a copy of NotificationPermissionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isEnabled = null,}) {
  return _then(_self.copyWith(
isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPermissionModel].
extension NotificationPermissionModelPatterns on NotificationPermissionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPermissionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPermissionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPermissionModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPermissionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPermissionModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPermissionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPermissionModel() when $default != null:
return $default(_that.isEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isEnabled)  $default,) {final _that = this;
switch (_that) {
case _NotificationPermissionModel():
return $default(_that.isEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isEnabled)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPermissionModel() when $default != null:
return $default(_that.isEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPermissionModel extends NotificationPermissionModel {
  const _NotificationPermissionModel({required this.isEnabled}): super._();
  factory _NotificationPermissionModel.fromJson(Map<String, dynamic> json) => _$NotificationPermissionModelFromJson(json);

@override final  bool isEnabled;

/// Create a copy of NotificationPermissionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPermissionModelCopyWith<_NotificationPermissionModel> get copyWith => __$NotificationPermissionModelCopyWithImpl<_NotificationPermissionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPermissionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPermissionModel&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isEnabled);

@override
String toString() {
  return 'NotificationPermissionModel(isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class _$NotificationPermissionModelCopyWith<$Res> implements $NotificationPermissionModelCopyWith<$Res> {
  factory _$NotificationPermissionModelCopyWith(_NotificationPermissionModel value, $Res Function(_NotificationPermissionModel) _then) = __$NotificationPermissionModelCopyWithImpl;
@override @useResult
$Res call({
 bool isEnabled
});




}
/// @nodoc
class __$NotificationPermissionModelCopyWithImpl<$Res>
    implements _$NotificationPermissionModelCopyWith<$Res> {
  __$NotificationPermissionModelCopyWithImpl(this._self, this._then);

  final _NotificationPermissionModel _self;
  final $Res Function(_NotificationPermissionModel) _then;

/// Create a copy of NotificationPermissionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isEnabled = null,}) {
  return _then(_NotificationPermissionModel(
isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
