// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VehicleTypeModel {

 int get id; String get code; String get name; String? get description;@JsonKey(name: 'icon_url') String? get iconUrl;@JsonKey(name: 'max_passengers') int get maxPassengers;@JsonKey(name: 'max_weight_kg', fromJson: _toDouble) double get maxWeightKg;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at') String? get createdAt;
/// Create a copy of VehicleTypeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleTypeModelCopyWith<VehicleTypeModel> get copyWith => _$VehicleTypeModelCopyWithImpl<VehicleTypeModel>(this as VehicleTypeModel, _$identity);

  /// Serializes this VehicleTypeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleTypeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.maxPassengers, maxPassengers) || other.maxPassengers == maxPassengers)&&(identical(other.maxWeightKg, maxWeightKg) || other.maxWeightKg == maxWeightKg)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,description,iconUrl,maxPassengers,maxWeightKg,isActive,createdAt);

@override
String toString() {
  return 'VehicleTypeModel(id: $id, code: $code, name: $name, description: $description, iconUrl: $iconUrl, maxPassengers: $maxPassengers, maxWeightKg: $maxWeightKg, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $VehicleTypeModelCopyWith<$Res>  {
  factory $VehicleTypeModelCopyWith(VehicleTypeModel value, $Res Function(VehicleTypeModel) _then) = _$VehicleTypeModelCopyWithImpl;
@useResult
$Res call({
 int id, String code, String name, String? description,@JsonKey(name: 'icon_url') String? iconUrl,@JsonKey(name: 'max_passengers') int maxPassengers,@JsonKey(name: 'max_weight_kg', fromJson: _toDouble) double maxWeightKg,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class _$VehicleTypeModelCopyWithImpl<$Res>
    implements $VehicleTypeModelCopyWith<$Res> {
  _$VehicleTypeModelCopyWithImpl(this._self, this._then);

  final VehicleTypeModel _self;
  final $Res Function(VehicleTypeModel) _then;

/// Create a copy of VehicleTypeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? description = freezed,Object? iconUrl = freezed,Object? maxPassengers = null,Object? maxWeightKg = null,Object? isActive = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,maxPassengers: null == maxPassengers ? _self.maxPassengers : maxPassengers // ignore: cast_nullable_to_non_nullable
as int,maxWeightKg: null == maxWeightKg ? _self.maxWeightKg : maxWeightKg // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VehicleTypeModel].
extension VehicleTypeModelPatterns on VehicleTypeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleTypeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleTypeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleTypeModel value)  $default,){
final _that = this;
switch (_that) {
case _VehicleTypeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleTypeModel value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleTypeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code,  String name,  String? description, @JsonKey(name: 'icon_url')  String? iconUrl, @JsonKey(name: 'max_passengers')  int maxPassengers, @JsonKey(name: 'max_weight_kg', fromJson: _toDouble)  double maxWeightKg, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleTypeModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.description,_that.iconUrl,_that.maxPassengers,_that.maxWeightKg,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code,  String name,  String? description, @JsonKey(name: 'icon_url')  String? iconUrl, @JsonKey(name: 'max_passengers')  int maxPassengers, @JsonKey(name: 'max_weight_kg', fromJson: _toDouble)  double maxWeightKg, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _VehicleTypeModel():
return $default(_that.id,_that.code,_that.name,_that.description,_that.iconUrl,_that.maxPassengers,_that.maxWeightKg,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code,  String name,  String? description, @JsonKey(name: 'icon_url')  String? iconUrl, @JsonKey(name: 'max_passengers')  int maxPassengers, @JsonKey(name: 'max_weight_kg', fromJson: _toDouble)  double maxWeightKg, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at')  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _VehicleTypeModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.description,_that.iconUrl,_that.maxPassengers,_that.maxWeightKg,_that.isActive,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VehicleTypeModel implements VehicleTypeModel {
  const _VehicleTypeModel({required this.id, required this.code, required this.name, this.description, @JsonKey(name: 'icon_url') this.iconUrl, @JsonKey(name: 'max_passengers') this.maxPassengers = 1, @JsonKey(name: 'max_weight_kg', fromJson: _toDouble) this.maxWeightKg = 0.0, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at') this.createdAt});
  factory _VehicleTypeModel.fromJson(Map<String, dynamic> json) => _$VehicleTypeModelFromJson(json);

@override final  int id;
@override final  String code;
@override final  String name;
@override final  String? description;
@override@JsonKey(name: 'icon_url') final  String? iconUrl;
@override@JsonKey(name: 'max_passengers') final  int maxPassengers;
@override@JsonKey(name: 'max_weight_kg', fromJson: _toDouble) final  double maxWeightKg;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at') final  String? createdAt;

/// Create a copy of VehicleTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleTypeModelCopyWith<_VehicleTypeModel> get copyWith => __$VehicleTypeModelCopyWithImpl<_VehicleTypeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleTypeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleTypeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.maxPassengers, maxPassengers) || other.maxPassengers == maxPassengers)&&(identical(other.maxWeightKg, maxWeightKg) || other.maxWeightKg == maxWeightKg)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,description,iconUrl,maxPassengers,maxWeightKg,isActive,createdAt);

@override
String toString() {
  return 'VehicleTypeModel(id: $id, code: $code, name: $name, description: $description, iconUrl: $iconUrl, maxPassengers: $maxPassengers, maxWeightKg: $maxWeightKg, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$VehicleTypeModelCopyWith<$Res> implements $VehicleTypeModelCopyWith<$Res> {
  factory _$VehicleTypeModelCopyWith(_VehicleTypeModel value, $Res Function(_VehicleTypeModel) _then) = __$VehicleTypeModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String code, String name, String? description,@JsonKey(name: 'icon_url') String? iconUrl,@JsonKey(name: 'max_passengers') int maxPassengers,@JsonKey(name: 'max_weight_kg', fromJson: _toDouble) double maxWeightKg,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at') String? createdAt
});




}
/// @nodoc
class __$VehicleTypeModelCopyWithImpl<$Res>
    implements _$VehicleTypeModelCopyWith<$Res> {
  __$VehicleTypeModelCopyWithImpl(this._self, this._then);

  final _VehicleTypeModel _self;
  final $Res Function(_VehicleTypeModel) _then;

/// Create a copy of VehicleTypeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? description = freezed,Object? iconUrl = freezed,Object? maxPassengers = null,Object? maxWeightKg = null,Object? isActive = null,Object? createdAt = freezed,}) {
  return _then(_VehicleTypeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,maxPassengers: null == maxPassengers ? _self.maxPassengers : maxPassengers // ignore: cast_nullable_to_non_nullable
as int,maxWeightKg: null == maxWeightKg ? _self.maxWeightKg : maxWeightKg // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
