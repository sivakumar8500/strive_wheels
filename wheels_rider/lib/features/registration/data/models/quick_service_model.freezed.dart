// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_service_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuickServiceModel {

 int get id; String get title; String get subtitle;@JsonKey(name: 'icon_url') String get iconUrl;@JsonKey(name: 'service_code') String get serviceCode;@JsonKey(name: 'display_order') int get displayOrder;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of QuickServiceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickServiceModelCopyWith<QuickServiceModel> get copyWith => _$QuickServiceModelCopyWithImpl<QuickServiceModel>(this as QuickServiceModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickServiceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.serviceCode, serviceCode) || other.serviceCode == serviceCode)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,iconUrl,serviceCode,displayOrder,isActive,createdAt);

@override
String toString() {
  return 'QuickServiceModel(id: $id, title: $title, subtitle: $subtitle, iconUrl: $iconUrl, serviceCode: $serviceCode, displayOrder: $displayOrder, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $QuickServiceModelCopyWith<$Res>  {
  factory $QuickServiceModelCopyWith(QuickServiceModel value, $Res Function(QuickServiceModel) _then) = _$QuickServiceModelCopyWithImpl;
@useResult
$Res call({
 int id, String title, String subtitle,@JsonKey(name: 'icon_url') String iconUrl,@JsonKey(name: 'service_code') String serviceCode,@JsonKey(name: 'display_order') int displayOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$QuickServiceModelCopyWithImpl<$Res>
    implements $QuickServiceModelCopyWith<$Res> {
  _$QuickServiceModelCopyWithImpl(this._self, this._then);

  final QuickServiceModel _self;
  final $Res Function(QuickServiceModel) _then;

/// Create a copy of QuickServiceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? iconUrl = null,Object? serviceCode = null,Object? displayOrder = null,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,iconUrl: null == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String,serviceCode: null == serviceCode ? _self.serviceCode : serviceCode // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickServiceModel].
extension QuickServiceModelPatterns on QuickServiceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickServiceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickServiceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickServiceModel value)  $default,){
final _that = this;
switch (_that) {
case _QuickServiceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickServiceModel value)?  $default,){
final _that = this;
switch (_that) {
case _QuickServiceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String subtitle, @JsonKey(name: 'icon_url')  String iconUrl, @JsonKey(name: 'service_code')  String serviceCode, @JsonKey(name: 'display_order')  int displayOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickServiceModel() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.iconUrl,_that.serviceCode,_that.displayOrder,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String subtitle, @JsonKey(name: 'icon_url')  String iconUrl, @JsonKey(name: 'service_code')  String serviceCode, @JsonKey(name: 'display_order')  int displayOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _QuickServiceModel():
return $default(_that.id,_that.title,_that.subtitle,_that.iconUrl,_that.serviceCode,_that.displayOrder,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String subtitle, @JsonKey(name: 'icon_url')  String iconUrl, @JsonKey(name: 'service_code')  String serviceCode, @JsonKey(name: 'display_order')  int displayOrder, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _QuickServiceModel() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.iconUrl,_that.serviceCode,_that.displayOrder,_that.isActive,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _QuickServiceModel implements QuickServiceModel {
  const _QuickServiceModel({required this.id, required this.title, required this.subtitle, @JsonKey(name: 'icon_url') required this.iconUrl, @JsonKey(name: 'service_code') required this.serviceCode, @JsonKey(name: 'display_order') required this.displayOrder, @JsonKey(name: 'is_active') required this.isActive, @JsonKey(name: 'created_at') required this.createdAt});
  

@override final  int id;
@override final  String title;
@override final  String subtitle;
@override@JsonKey(name: 'icon_url') final  String iconUrl;
@override@JsonKey(name: 'service_code') final  String serviceCode;
@override@JsonKey(name: 'display_order') final  int displayOrder;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of QuickServiceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickServiceModelCopyWith<_QuickServiceModel> get copyWith => __$QuickServiceModelCopyWithImpl<_QuickServiceModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickServiceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.serviceCode, serviceCode) || other.serviceCode == serviceCode)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,iconUrl,serviceCode,displayOrder,isActive,createdAt);

@override
String toString() {
  return 'QuickServiceModel(id: $id, title: $title, subtitle: $subtitle, iconUrl: $iconUrl, serviceCode: $serviceCode, displayOrder: $displayOrder, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$QuickServiceModelCopyWith<$Res> implements $QuickServiceModelCopyWith<$Res> {
  factory _$QuickServiceModelCopyWith(_QuickServiceModel value, $Res Function(_QuickServiceModel) _then) = __$QuickServiceModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String subtitle,@JsonKey(name: 'icon_url') String iconUrl,@JsonKey(name: 'service_code') String serviceCode,@JsonKey(name: 'display_order') int displayOrder,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$QuickServiceModelCopyWithImpl<$Res>
    implements _$QuickServiceModelCopyWith<$Res> {
  __$QuickServiceModelCopyWithImpl(this._self, this._then);

  final _QuickServiceModel _self;
  final $Res Function(_QuickServiceModel) _then;

/// Create a copy of QuickServiceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? iconUrl = null,Object? serviceCode = null,Object? displayOrder = null,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_QuickServiceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,iconUrl: null == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String,serviceCode: null == serviceCode ? _self.serviceCode : serviceCode // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
