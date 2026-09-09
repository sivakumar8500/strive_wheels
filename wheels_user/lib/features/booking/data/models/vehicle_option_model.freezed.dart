// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_option_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VehicleOptionModel {

 String get id; String get name; String get specs; String get price; String get rating; String get eta; String get imagePath;
/// Create a copy of VehicleOptionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleOptionModelCopyWith<VehicleOptionModel> get copyWith => _$VehicleOptionModelCopyWithImpl<VehicleOptionModel>(this as VehicleOptionModel, _$identity);

  /// Serializes this VehicleOptionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleOptionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.specs, specs) || other.specs == specs)&&(identical(other.price, price) || other.price == price)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.eta, eta) || other.eta == eta)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,specs,price,rating,eta,imagePath);

@override
String toString() {
  return 'VehicleOptionModel(id: $id, name: $name, specs: $specs, price: $price, rating: $rating, eta: $eta, imagePath: $imagePath)';
}


}

/// @nodoc
abstract mixin class $VehicleOptionModelCopyWith<$Res>  {
  factory $VehicleOptionModelCopyWith(VehicleOptionModel value, $Res Function(VehicleOptionModel) _then) = _$VehicleOptionModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String specs, String price, String rating, String eta, String imagePath
});




}
/// @nodoc
class _$VehicleOptionModelCopyWithImpl<$Res>
    implements $VehicleOptionModelCopyWith<$Res> {
  _$VehicleOptionModelCopyWithImpl(this._self, this._then);

  final VehicleOptionModel _self;
  final $Res Function(VehicleOptionModel) _then;

/// Create a copy of VehicleOptionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? specs = null,Object? price = null,Object? rating = null,Object? eta = null,Object? imagePath = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,specs: null == specs ? _self.specs : specs // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,eta: null == eta ? _self.eta : eta // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VehicleOptionModel].
extension VehicleOptionModelPatterns on VehicleOptionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleOptionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleOptionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleOptionModel value)  $default,){
final _that = this;
switch (_that) {
case _VehicleOptionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleOptionModel value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleOptionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String specs,  String price,  String rating,  String eta,  String imagePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleOptionModel() when $default != null:
return $default(_that.id,_that.name,_that.specs,_that.price,_that.rating,_that.eta,_that.imagePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String specs,  String price,  String rating,  String eta,  String imagePath)  $default,) {final _that = this;
switch (_that) {
case _VehicleOptionModel():
return $default(_that.id,_that.name,_that.specs,_that.price,_that.rating,_that.eta,_that.imagePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String specs,  String price,  String rating,  String eta,  String imagePath)?  $default,) {final _that = this;
switch (_that) {
case _VehicleOptionModel() when $default != null:
return $default(_that.id,_that.name,_that.specs,_that.price,_that.rating,_that.eta,_that.imagePath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VehicleOptionModel implements VehicleOptionModel {
  const _VehicleOptionModel({required this.id, required this.name, required this.specs, required this.price, required this.rating, required this.eta, required this.imagePath});
  factory _VehicleOptionModel.fromJson(Map<String, dynamic> json) => _$VehicleOptionModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String specs;
@override final  String price;
@override final  String rating;
@override final  String eta;
@override final  String imagePath;

/// Create a copy of VehicleOptionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleOptionModelCopyWith<_VehicleOptionModel> get copyWith => __$VehicleOptionModelCopyWithImpl<_VehicleOptionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleOptionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleOptionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.specs, specs) || other.specs == specs)&&(identical(other.price, price) || other.price == price)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.eta, eta) || other.eta == eta)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,specs,price,rating,eta,imagePath);

@override
String toString() {
  return 'VehicleOptionModel(id: $id, name: $name, specs: $specs, price: $price, rating: $rating, eta: $eta, imagePath: $imagePath)';
}


}

/// @nodoc
abstract mixin class _$VehicleOptionModelCopyWith<$Res> implements $VehicleOptionModelCopyWith<$Res> {
  factory _$VehicleOptionModelCopyWith(_VehicleOptionModel value, $Res Function(_VehicleOptionModel) _then) = __$VehicleOptionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String specs, String price, String rating, String eta, String imagePath
});




}
/// @nodoc
class __$VehicleOptionModelCopyWithImpl<$Res>
    implements _$VehicleOptionModelCopyWith<$Res> {
  __$VehicleOptionModelCopyWithImpl(this._self, this._then);

  final _VehicleOptionModel _self;
  final $Res Function(_VehicleOptionModel) _then;

/// Create a copy of VehicleOptionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? specs = null,Object? price = null,Object? rating = null,Object? eta = null,Object? imagePath = null,}) {
  return _then(_VehicleOptionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,specs: null == specs ? _self.specs : specs // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,eta: null == eta ? _self.eta : eta // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
