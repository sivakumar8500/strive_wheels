// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permissions_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PermissionsModel {

 bool get notificationsAllowed; bool get contactsAllowed; bool get locationAllowed;
/// Create a copy of PermissionsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionsModelCopyWith<PermissionsModel> get copyWith => _$PermissionsModelCopyWithImpl<PermissionsModel>(this as PermissionsModel, _$identity);

  /// Serializes this PermissionsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionsModel&&(identical(other.notificationsAllowed, notificationsAllowed) || other.notificationsAllowed == notificationsAllowed)&&(identical(other.contactsAllowed, contactsAllowed) || other.contactsAllowed == contactsAllowed)&&(identical(other.locationAllowed, locationAllowed) || other.locationAllowed == locationAllowed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationsAllowed,contactsAllowed,locationAllowed);

@override
String toString() {
  return 'PermissionsModel(notificationsAllowed: $notificationsAllowed, contactsAllowed: $contactsAllowed, locationAllowed: $locationAllowed)';
}


}

/// @nodoc
abstract mixin class $PermissionsModelCopyWith<$Res>  {
  factory $PermissionsModelCopyWith(PermissionsModel value, $Res Function(PermissionsModel) _then) = _$PermissionsModelCopyWithImpl;
@useResult
$Res call({
 bool notificationsAllowed, bool contactsAllowed, bool locationAllowed
});




}
/// @nodoc
class _$PermissionsModelCopyWithImpl<$Res>
    implements $PermissionsModelCopyWith<$Res> {
  _$PermissionsModelCopyWithImpl(this._self, this._then);

  final PermissionsModel _self;
  final $Res Function(PermissionsModel) _then;

/// Create a copy of PermissionsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notificationsAllowed = null,Object? contactsAllowed = null,Object? locationAllowed = null,}) {
  return _then(_self.copyWith(
notificationsAllowed: null == notificationsAllowed ? _self.notificationsAllowed : notificationsAllowed // ignore: cast_nullable_to_non_nullable
as bool,contactsAllowed: null == contactsAllowed ? _self.contactsAllowed : contactsAllowed // ignore: cast_nullable_to_non_nullable
as bool,locationAllowed: null == locationAllowed ? _self.locationAllowed : locationAllowed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PermissionsModel].
extension PermissionsModelPatterns on PermissionsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PermissionsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermissionsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PermissionsModel value)  $default,){
final _that = this;
switch (_that) {
case _PermissionsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PermissionsModel value)?  $default,){
final _that = this;
switch (_that) {
case _PermissionsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool notificationsAllowed,  bool contactsAllowed,  bool locationAllowed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermissionsModel() when $default != null:
return $default(_that.notificationsAllowed,_that.contactsAllowed,_that.locationAllowed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool notificationsAllowed,  bool contactsAllowed,  bool locationAllowed)  $default,) {final _that = this;
switch (_that) {
case _PermissionsModel():
return $default(_that.notificationsAllowed,_that.contactsAllowed,_that.locationAllowed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool notificationsAllowed,  bool contactsAllowed,  bool locationAllowed)?  $default,) {final _that = this;
switch (_that) {
case _PermissionsModel() when $default != null:
return $default(_that.notificationsAllowed,_that.contactsAllowed,_that.locationAllowed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PermissionsModel extends PermissionsModel {
  const _PermissionsModel({this.notificationsAllowed = false, this.contactsAllowed = false, this.locationAllowed = false}): super._();
  factory _PermissionsModel.fromJson(Map<String, dynamic> json) => _$PermissionsModelFromJson(json);

@override@JsonKey() final  bool notificationsAllowed;
@override@JsonKey() final  bool contactsAllowed;
@override@JsonKey() final  bool locationAllowed;

/// Create a copy of PermissionsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionsModelCopyWith<_PermissionsModel> get copyWith => __$PermissionsModelCopyWithImpl<_PermissionsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PermissionsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionsModel&&(identical(other.notificationsAllowed, notificationsAllowed) || other.notificationsAllowed == notificationsAllowed)&&(identical(other.contactsAllowed, contactsAllowed) || other.contactsAllowed == contactsAllowed)&&(identical(other.locationAllowed, locationAllowed) || other.locationAllowed == locationAllowed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationsAllowed,contactsAllowed,locationAllowed);

@override
String toString() {
  return 'PermissionsModel(notificationsAllowed: $notificationsAllowed, contactsAllowed: $contactsAllowed, locationAllowed: $locationAllowed)';
}


}

/// @nodoc
abstract mixin class _$PermissionsModelCopyWith<$Res> implements $PermissionsModelCopyWith<$Res> {
  factory _$PermissionsModelCopyWith(_PermissionsModel value, $Res Function(_PermissionsModel) _then) = __$PermissionsModelCopyWithImpl;
@override @useResult
$Res call({
 bool notificationsAllowed, bool contactsAllowed, bool locationAllowed
});




}
/// @nodoc
class __$PermissionsModelCopyWithImpl<$Res>
    implements _$PermissionsModelCopyWith<$Res> {
  __$PermissionsModelCopyWithImpl(this._self, this._then);

  final _PermissionsModel _self;
  final $Res Function(_PermissionsModel) _then;

/// Create a copy of PermissionsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notificationsAllowed = null,Object? contactsAllowed = null,Object? locationAllowed = null,}) {
  return _then(_PermissionsModel(
notificationsAllowed: null == notificationsAllowed ? _self.notificationsAllowed : notificationsAllowed // ignore: cast_nullable_to_non_nullable
as bool,contactsAllowed: null == contactsAllowed ? _self.contactsAllowed : contactsAllowed // ignore: cast_nullable_to_non_nullable
as bool,locationAllowed: null == locationAllowed ? _self.locationAllowed : locationAllowed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
