// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuickService {

 int get id; String get title; String get subtitle; String get iconUrl; String get serviceCode; int get displayOrder; bool get isActive; String get createdAt;
/// Create a copy of QuickService
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickServiceCopyWith<QuickService> get copyWith => _$QuickServiceCopyWithImpl<QuickService>(this as QuickService, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickService&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.serviceCode, serviceCode) || other.serviceCode == serviceCode)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,iconUrl,serviceCode,displayOrder,isActive,createdAt);

@override
String toString() {
  return 'QuickService(id: $id, title: $title, subtitle: $subtitle, iconUrl: $iconUrl, serviceCode: $serviceCode, displayOrder: $displayOrder, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $QuickServiceCopyWith<$Res>  {
  factory $QuickServiceCopyWith(QuickService value, $Res Function(QuickService) _then) = _$QuickServiceCopyWithImpl;
@useResult
$Res call({
 int id, String title, String subtitle, String iconUrl, String serviceCode, int displayOrder, bool isActive, String createdAt
});




}
/// @nodoc
class _$QuickServiceCopyWithImpl<$Res>
    implements $QuickServiceCopyWith<$Res> {
  _$QuickServiceCopyWithImpl(this._self, this._then);

  final QuickService _self;
  final $Res Function(QuickService) _then;

/// Create a copy of QuickService
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


/// Adds pattern-matching-related methods to [QuickService].
extension QuickServicePatterns on QuickService {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickService value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickService() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickService value)  $default,){
final _that = this;
switch (_that) {
case _QuickService():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickService value)?  $default,){
final _that = this;
switch (_that) {
case _QuickService() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String subtitle,  String iconUrl,  String serviceCode,  int displayOrder,  bool isActive,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickService() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String subtitle,  String iconUrl,  String serviceCode,  int displayOrder,  bool isActive,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _QuickService():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String subtitle,  String iconUrl,  String serviceCode,  int displayOrder,  bool isActive,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _QuickService() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.iconUrl,_that.serviceCode,_that.displayOrder,_that.isActive,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _QuickService implements QuickService {
  const _QuickService({required this.id, required this.title, required this.subtitle, required this.iconUrl, required this.serviceCode, required this.displayOrder, required this.isActive, required this.createdAt});
  

@override final  int id;
@override final  String title;
@override final  String subtitle;
@override final  String iconUrl;
@override final  String serviceCode;
@override final  int displayOrder;
@override final  bool isActive;
@override final  String createdAt;

/// Create a copy of QuickService
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickServiceCopyWith<_QuickService> get copyWith => __$QuickServiceCopyWithImpl<_QuickService>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickService&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.serviceCode, serviceCode) || other.serviceCode == serviceCode)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,iconUrl,serviceCode,displayOrder,isActive,createdAt);

@override
String toString() {
  return 'QuickService(id: $id, title: $title, subtitle: $subtitle, iconUrl: $iconUrl, serviceCode: $serviceCode, displayOrder: $displayOrder, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$QuickServiceCopyWith<$Res> implements $QuickServiceCopyWith<$Res> {
  factory _$QuickServiceCopyWith(_QuickService value, $Res Function(_QuickService) _then) = __$QuickServiceCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String subtitle, String iconUrl, String serviceCode, int displayOrder, bool isActive, String createdAt
});




}
/// @nodoc
class __$QuickServiceCopyWithImpl<$Res>
    implements _$QuickServiceCopyWith<$Res> {
  __$QuickServiceCopyWithImpl(this._self, this._then);

  final _QuickService _self;
  final $Res Function(_QuickService) _then;

/// Create a copy of QuickService
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? iconUrl = null,Object? serviceCode = null,Object? displayOrder = null,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_QuickService(
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
