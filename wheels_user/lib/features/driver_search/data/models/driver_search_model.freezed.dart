// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_search_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DriverSearchModel {

 String get statusTitle; String get statusSubtitle; String get estimatedConfirmationText; String get orderTime; String get scanRadiusText; int get activeStepIndex;
/// Create a copy of DriverSearchModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DriverSearchModelCopyWith<DriverSearchModel> get copyWith => _$DriverSearchModelCopyWithImpl<DriverSearchModel>(this as DriverSearchModel, _$identity);

  /// Serializes this DriverSearchModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DriverSearchModel&&(identical(other.statusTitle, statusTitle) || other.statusTitle == statusTitle)&&(identical(other.statusSubtitle, statusSubtitle) || other.statusSubtitle == statusSubtitle)&&(identical(other.estimatedConfirmationText, estimatedConfirmationText) || other.estimatedConfirmationText == estimatedConfirmationText)&&(identical(other.orderTime, orderTime) || other.orderTime == orderTime)&&(identical(other.scanRadiusText, scanRadiusText) || other.scanRadiusText == scanRadiusText)&&(identical(other.activeStepIndex, activeStepIndex) || other.activeStepIndex == activeStepIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusTitle,statusSubtitle,estimatedConfirmationText,orderTime,scanRadiusText,activeStepIndex);

@override
String toString() {
  return 'DriverSearchModel(statusTitle: $statusTitle, statusSubtitle: $statusSubtitle, estimatedConfirmationText: $estimatedConfirmationText, orderTime: $orderTime, scanRadiusText: $scanRadiusText, activeStepIndex: $activeStepIndex)';
}


}

/// @nodoc
abstract mixin class $DriverSearchModelCopyWith<$Res>  {
  factory $DriverSearchModelCopyWith(DriverSearchModel value, $Res Function(DriverSearchModel) _then) = _$DriverSearchModelCopyWithImpl;
@useResult
$Res call({
 String statusTitle, String statusSubtitle, String estimatedConfirmationText, String orderTime, String scanRadiusText, int activeStepIndex
});




}
/// @nodoc
class _$DriverSearchModelCopyWithImpl<$Res>
    implements $DriverSearchModelCopyWith<$Res> {
  _$DriverSearchModelCopyWithImpl(this._self, this._then);

  final DriverSearchModel _self;
  final $Res Function(DriverSearchModel) _then;

/// Create a copy of DriverSearchModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statusTitle = null,Object? statusSubtitle = null,Object? estimatedConfirmationText = null,Object? orderTime = null,Object? scanRadiusText = null,Object? activeStepIndex = null,}) {
  return _then(_self.copyWith(
statusTitle: null == statusTitle ? _self.statusTitle : statusTitle // ignore: cast_nullable_to_non_nullable
as String,statusSubtitle: null == statusSubtitle ? _self.statusSubtitle : statusSubtitle // ignore: cast_nullable_to_non_nullable
as String,estimatedConfirmationText: null == estimatedConfirmationText ? _self.estimatedConfirmationText : estimatedConfirmationText // ignore: cast_nullable_to_non_nullable
as String,orderTime: null == orderTime ? _self.orderTime : orderTime // ignore: cast_nullable_to_non_nullable
as String,scanRadiusText: null == scanRadiusText ? _self.scanRadiusText : scanRadiusText // ignore: cast_nullable_to_non_nullable
as String,activeStepIndex: null == activeStepIndex ? _self.activeStepIndex : activeStepIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DriverSearchModel].
extension DriverSearchModelPatterns on DriverSearchModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DriverSearchModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DriverSearchModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DriverSearchModel value)  $default,){
final _that = this;
switch (_that) {
case _DriverSearchModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DriverSearchModel value)?  $default,){
final _that = this;
switch (_that) {
case _DriverSearchModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String statusTitle,  String statusSubtitle,  String estimatedConfirmationText,  String orderTime,  String scanRadiusText,  int activeStepIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DriverSearchModel() when $default != null:
return $default(_that.statusTitle,_that.statusSubtitle,_that.estimatedConfirmationText,_that.orderTime,_that.scanRadiusText,_that.activeStepIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String statusTitle,  String statusSubtitle,  String estimatedConfirmationText,  String orderTime,  String scanRadiusText,  int activeStepIndex)  $default,) {final _that = this;
switch (_that) {
case _DriverSearchModel():
return $default(_that.statusTitle,_that.statusSubtitle,_that.estimatedConfirmationText,_that.orderTime,_that.scanRadiusText,_that.activeStepIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String statusTitle,  String statusSubtitle,  String estimatedConfirmationText,  String orderTime,  String scanRadiusText,  int activeStepIndex)?  $default,) {final _that = this;
switch (_that) {
case _DriverSearchModel() when $default != null:
return $default(_that.statusTitle,_that.statusSubtitle,_that.estimatedConfirmationText,_that.orderTime,_that.scanRadiusText,_that.activeStepIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DriverSearchModel implements DriverSearchModel {
  const _DriverSearchModel({required this.statusTitle, required this.statusSubtitle, required this.estimatedConfirmationText, required this.orderTime, required this.scanRadiusText, required this.activeStepIndex});
  factory _DriverSearchModel.fromJson(Map<String, dynamic> json) => _$DriverSearchModelFromJson(json);

@override final  String statusTitle;
@override final  String statusSubtitle;
@override final  String estimatedConfirmationText;
@override final  String orderTime;
@override final  String scanRadiusText;
@override final  int activeStepIndex;

/// Create a copy of DriverSearchModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DriverSearchModelCopyWith<_DriverSearchModel> get copyWith => __$DriverSearchModelCopyWithImpl<_DriverSearchModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DriverSearchModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DriverSearchModel&&(identical(other.statusTitle, statusTitle) || other.statusTitle == statusTitle)&&(identical(other.statusSubtitle, statusSubtitle) || other.statusSubtitle == statusSubtitle)&&(identical(other.estimatedConfirmationText, estimatedConfirmationText) || other.estimatedConfirmationText == estimatedConfirmationText)&&(identical(other.orderTime, orderTime) || other.orderTime == orderTime)&&(identical(other.scanRadiusText, scanRadiusText) || other.scanRadiusText == scanRadiusText)&&(identical(other.activeStepIndex, activeStepIndex) || other.activeStepIndex == activeStepIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusTitle,statusSubtitle,estimatedConfirmationText,orderTime,scanRadiusText,activeStepIndex);

@override
String toString() {
  return 'DriverSearchModel(statusTitle: $statusTitle, statusSubtitle: $statusSubtitle, estimatedConfirmationText: $estimatedConfirmationText, orderTime: $orderTime, scanRadiusText: $scanRadiusText, activeStepIndex: $activeStepIndex)';
}


}

/// @nodoc
abstract mixin class _$DriverSearchModelCopyWith<$Res> implements $DriverSearchModelCopyWith<$Res> {
  factory _$DriverSearchModelCopyWith(_DriverSearchModel value, $Res Function(_DriverSearchModel) _then) = __$DriverSearchModelCopyWithImpl;
@override @useResult
$Res call({
 String statusTitle, String statusSubtitle, String estimatedConfirmationText, String orderTime, String scanRadiusText, int activeStepIndex
});




}
/// @nodoc
class __$DriverSearchModelCopyWithImpl<$Res>
    implements _$DriverSearchModelCopyWith<$Res> {
  __$DriverSearchModelCopyWithImpl(this._self, this._then);

  final _DriverSearchModel _self;
  final $Res Function(_DriverSearchModel) _then;

/// Create a copy of DriverSearchModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusTitle = null,Object? statusSubtitle = null,Object? estimatedConfirmationText = null,Object? orderTime = null,Object? scanRadiusText = null,Object? activeStepIndex = null,}) {
  return _then(_DriverSearchModel(
statusTitle: null == statusTitle ? _self.statusTitle : statusTitle // ignore: cast_nullable_to_non_nullable
as String,statusSubtitle: null == statusSubtitle ? _self.statusSubtitle : statusSubtitle // ignore: cast_nullable_to_non_nullable
as String,estimatedConfirmationText: null == estimatedConfirmationText ? _self.estimatedConfirmationText : estimatedConfirmationText // ignore: cast_nullable_to_non_nullable
as String,orderTime: null == orderTime ? _self.orderTime : orderTime // ignore: cast_nullable_to_non_nullable
as String,scanRadiusText: null == scanRadiusText ? _self.scanRadiusText : scanRadiusText // ignore: cast_nullable_to_non_nullable
as String,activeStepIndex: null == activeStepIndex ? _self.activeStepIndex : activeStepIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
