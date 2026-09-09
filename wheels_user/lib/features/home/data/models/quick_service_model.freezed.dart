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

 int get id; String get title; String get subtitle;@JsonKey(name: 'icon_url') String? get iconUrl;
/// Create a copy of QuickServiceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickServiceModelCopyWith<QuickServiceModel> get copyWith => _$QuickServiceModelCopyWithImpl<QuickServiceModel>(this as QuickServiceModel, _$identity);

  /// Serializes this QuickServiceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickServiceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,iconUrl);

@override
String toString() {
  return 'QuickServiceModel(id: $id, title: $title, subtitle: $subtitle, iconUrl: $iconUrl)';
}


}

/// @nodoc
abstract mixin class $QuickServiceModelCopyWith<$Res>  {
  factory $QuickServiceModelCopyWith(QuickServiceModel value, $Res Function(QuickServiceModel) _then) = _$QuickServiceModelCopyWithImpl;
@useResult
$Res call({
 int id, String title, String subtitle,@JsonKey(name: 'icon_url') String? iconUrl
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? iconUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String subtitle, @JsonKey(name: 'icon_url')  String? iconUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickServiceModel() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.iconUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String subtitle, @JsonKey(name: 'icon_url')  String? iconUrl)  $default,) {final _that = this;
switch (_that) {
case _QuickServiceModel():
return $default(_that.id,_that.title,_that.subtitle,_that.iconUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String subtitle, @JsonKey(name: 'icon_url')  String? iconUrl)?  $default,) {final _that = this;
switch (_that) {
case _QuickServiceModel() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.iconUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuickServiceModel implements QuickServiceModel {
  const _QuickServiceModel({required this.id, required this.title, required this.subtitle, @JsonKey(name: 'icon_url') this.iconUrl});
  factory _QuickServiceModel.fromJson(Map<String, dynamic> json) => _$QuickServiceModelFromJson(json);

@override final  int id;
@override final  String title;
@override final  String subtitle;
@override@JsonKey(name: 'icon_url') final  String? iconUrl;

/// Create a copy of QuickServiceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickServiceModelCopyWith<_QuickServiceModel> get copyWith => __$QuickServiceModelCopyWithImpl<_QuickServiceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuickServiceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickServiceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,iconUrl);

@override
String toString() {
  return 'QuickServiceModel(id: $id, title: $title, subtitle: $subtitle, iconUrl: $iconUrl)';
}


}

/// @nodoc
abstract mixin class _$QuickServiceModelCopyWith<$Res> implements $QuickServiceModelCopyWith<$Res> {
  factory _$QuickServiceModelCopyWith(_QuickServiceModel value, $Res Function(_QuickServiceModel) _then) = __$QuickServiceModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String subtitle,@JsonKey(name: 'icon_url') String? iconUrl
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? iconUrl = freezed,}) {
  return _then(_QuickServiceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
