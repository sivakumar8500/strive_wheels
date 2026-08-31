// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CouponModel {

 int get id; String get code;@JsonKey(name: 'discount_type') String? get discountType;@JsonKey(name: 'discount_value') num? get discountValue;
/// Create a copy of CouponModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CouponModelCopyWith<CouponModel> get copyWith => _$CouponModelCopyWithImpl<CouponModel>(this as CouponModel, _$identity);

  /// Serializes this CouponModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CouponModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,discountType,discountValue);

@override
String toString() {
  return 'CouponModel(id: $id, code: $code, discountType: $discountType, discountValue: $discountValue)';
}


}

/// @nodoc
abstract mixin class $CouponModelCopyWith<$Res>  {
  factory $CouponModelCopyWith(CouponModel value, $Res Function(CouponModel) _then) = _$CouponModelCopyWithImpl;
@useResult
$Res call({
 int id, String code,@JsonKey(name: 'discount_type') String? discountType,@JsonKey(name: 'discount_value') num? discountValue
});




}
/// @nodoc
class _$CouponModelCopyWithImpl<$Res>
    implements $CouponModelCopyWith<$Res> {
  _$CouponModelCopyWithImpl(this._self, this._then);

  final CouponModel _self;
  final $Res Function(CouponModel) _then;

/// Create a copy of CouponModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? discountType = freezed,Object? discountValue = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discountValue: freezed == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [CouponModel].
extension CouponModelPatterns on CouponModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CouponModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CouponModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CouponModel value)  $default,){
final _that = this;
switch (_that) {
case _CouponModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CouponModel value)?  $default,){
final _that = this;
switch (_that) {
case _CouponModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String code, @JsonKey(name: 'discount_type')  String? discountType, @JsonKey(name: 'discount_value')  num? discountValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CouponModel() when $default != null:
return $default(_that.id,_that.code,_that.discountType,_that.discountValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String code, @JsonKey(name: 'discount_type')  String? discountType, @JsonKey(name: 'discount_value')  num? discountValue)  $default,) {final _that = this;
switch (_that) {
case _CouponModel():
return $default(_that.id,_that.code,_that.discountType,_that.discountValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String code, @JsonKey(name: 'discount_type')  String? discountType, @JsonKey(name: 'discount_value')  num? discountValue)?  $default,) {final _that = this;
switch (_that) {
case _CouponModel() when $default != null:
return $default(_that.id,_that.code,_that.discountType,_that.discountValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CouponModel implements CouponModel {
  const _CouponModel({required this.id, required this.code, @JsonKey(name: 'discount_type') this.discountType, @JsonKey(name: 'discount_value') this.discountValue});
  factory _CouponModel.fromJson(Map<String, dynamic> json) => _$CouponModelFromJson(json);

@override final  int id;
@override final  String code;
@override@JsonKey(name: 'discount_type') final  String? discountType;
@override@JsonKey(name: 'discount_value') final  num? discountValue;

/// Create a copy of CouponModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CouponModelCopyWith<_CouponModel> get copyWith => __$CouponModelCopyWithImpl<_CouponModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CouponModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CouponModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,discountType,discountValue);

@override
String toString() {
  return 'CouponModel(id: $id, code: $code, discountType: $discountType, discountValue: $discountValue)';
}


}

/// @nodoc
abstract mixin class _$CouponModelCopyWith<$Res> implements $CouponModelCopyWith<$Res> {
  factory _$CouponModelCopyWith(_CouponModel value, $Res Function(_CouponModel) _then) = __$CouponModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String code,@JsonKey(name: 'discount_type') String? discountType,@JsonKey(name: 'discount_value') num? discountValue
});




}
/// @nodoc
class __$CouponModelCopyWithImpl<$Res>
    implements _$CouponModelCopyWith<$Res> {
  __$CouponModelCopyWithImpl(this._self, this._then);

  final _CouponModel _self;
  final $Res Function(_CouponModel) _then;

/// Create a copy of CouponModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? discountType = freezed,Object? discountValue = freezed,}) {
  return _then(_CouponModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discountValue: freezed == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}

// dart format on
