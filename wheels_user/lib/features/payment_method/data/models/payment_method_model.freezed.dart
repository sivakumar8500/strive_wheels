// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_method_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentMethodModel {

 String get selectedMethod; String get cardNumberMasked; String get expiryDate; String get cvvMasked; String get vehicleName; String get vehicleTier; String get vehicleImagePath; double get baseFare; double get serviceFee; double get taxes; double get grandTotal; String get currencySymbol;
/// Create a copy of PaymentMethodModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentMethodModelCopyWith<PaymentMethodModel> get copyWith => _$PaymentMethodModelCopyWithImpl<PaymentMethodModel>(this as PaymentMethodModel, _$identity);

  /// Serializes this PaymentMethodModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentMethodModel&&(identical(other.selectedMethod, selectedMethod) || other.selectedMethod == selectedMethod)&&(identical(other.cardNumberMasked, cardNumberMasked) || other.cardNumberMasked == cardNumberMasked)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.cvvMasked, cvvMasked) || other.cvvMasked == cvvMasked)&&(identical(other.vehicleName, vehicleName) || other.vehicleName == vehicleName)&&(identical(other.vehicleTier, vehicleTier) || other.vehicleTier == vehicleTier)&&(identical(other.vehicleImagePath, vehicleImagePath) || other.vehicleImagePath == vehicleImagePath)&&(identical(other.baseFare, baseFare) || other.baseFare == baseFare)&&(identical(other.serviceFee, serviceFee) || other.serviceFee == serviceFee)&&(identical(other.taxes, taxes) || other.taxes == taxes)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,selectedMethod,cardNumberMasked,expiryDate,cvvMasked,vehicleName,vehicleTier,vehicleImagePath,baseFare,serviceFee,taxes,grandTotal,currencySymbol);

@override
String toString() {
  return 'PaymentMethodModel(selectedMethod: $selectedMethod, cardNumberMasked: $cardNumberMasked, expiryDate: $expiryDate, cvvMasked: $cvvMasked, vehicleName: $vehicleName, vehicleTier: $vehicleTier, vehicleImagePath: $vehicleImagePath, baseFare: $baseFare, serviceFee: $serviceFee, taxes: $taxes, grandTotal: $grandTotal, currencySymbol: $currencySymbol)';
}


}

/// @nodoc
abstract mixin class $PaymentMethodModelCopyWith<$Res>  {
  factory $PaymentMethodModelCopyWith(PaymentMethodModel value, $Res Function(PaymentMethodModel) _then) = _$PaymentMethodModelCopyWithImpl;
@useResult
$Res call({
 String selectedMethod, String cardNumberMasked, String expiryDate, String cvvMasked, String vehicleName, String vehicleTier, String vehicleImagePath, double baseFare, double serviceFee, double taxes, double grandTotal, String currencySymbol
});




}
/// @nodoc
class _$PaymentMethodModelCopyWithImpl<$Res>
    implements $PaymentMethodModelCopyWith<$Res> {
  _$PaymentMethodModelCopyWithImpl(this._self, this._then);

  final PaymentMethodModel _self;
  final $Res Function(PaymentMethodModel) _then;

/// Create a copy of PaymentMethodModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedMethod = null,Object? cardNumberMasked = null,Object? expiryDate = null,Object? cvvMasked = null,Object? vehicleName = null,Object? vehicleTier = null,Object? vehicleImagePath = null,Object? baseFare = null,Object? serviceFee = null,Object? taxes = null,Object? grandTotal = null,Object? currencySymbol = null,}) {
  return _then(_self.copyWith(
selectedMethod: null == selectedMethod ? _self.selectedMethod : selectedMethod // ignore: cast_nullable_to_non_nullable
as String,cardNumberMasked: null == cardNumberMasked ? _self.cardNumberMasked : cardNumberMasked // ignore: cast_nullable_to_non_nullable
as String,expiryDate: null == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String,cvvMasked: null == cvvMasked ? _self.cvvMasked : cvvMasked // ignore: cast_nullable_to_non_nullable
as String,vehicleName: null == vehicleName ? _self.vehicleName : vehicleName // ignore: cast_nullable_to_non_nullable
as String,vehicleTier: null == vehicleTier ? _self.vehicleTier : vehicleTier // ignore: cast_nullable_to_non_nullable
as String,vehicleImagePath: null == vehicleImagePath ? _self.vehicleImagePath : vehicleImagePath // ignore: cast_nullable_to_non_nullable
as String,baseFare: null == baseFare ? _self.baseFare : baseFare // ignore: cast_nullable_to_non_nullable
as double,serviceFee: null == serviceFee ? _self.serviceFee : serviceFee // ignore: cast_nullable_to_non_nullable
as double,taxes: null == taxes ? _self.taxes : taxes // ignore: cast_nullable_to_non_nullable
as double,grandTotal: null == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as double,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentMethodModel].
extension PaymentMethodModelPatterns on PaymentMethodModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentMethodModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentMethodModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentMethodModel value)  $default,){
final _that = this;
switch (_that) {
case _PaymentMethodModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentMethodModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentMethodModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String selectedMethod,  String cardNumberMasked,  String expiryDate,  String cvvMasked,  String vehicleName,  String vehicleTier,  String vehicleImagePath,  double baseFare,  double serviceFee,  double taxes,  double grandTotal,  String currencySymbol)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentMethodModel() when $default != null:
return $default(_that.selectedMethod,_that.cardNumberMasked,_that.expiryDate,_that.cvvMasked,_that.vehicleName,_that.vehicleTier,_that.vehicleImagePath,_that.baseFare,_that.serviceFee,_that.taxes,_that.grandTotal,_that.currencySymbol);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String selectedMethod,  String cardNumberMasked,  String expiryDate,  String cvvMasked,  String vehicleName,  String vehicleTier,  String vehicleImagePath,  double baseFare,  double serviceFee,  double taxes,  double grandTotal,  String currencySymbol)  $default,) {final _that = this;
switch (_that) {
case _PaymentMethodModel():
return $default(_that.selectedMethod,_that.cardNumberMasked,_that.expiryDate,_that.cvvMasked,_that.vehicleName,_that.vehicleTier,_that.vehicleImagePath,_that.baseFare,_that.serviceFee,_that.taxes,_that.grandTotal,_that.currencySymbol);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String selectedMethod,  String cardNumberMasked,  String expiryDate,  String cvvMasked,  String vehicleName,  String vehicleTier,  String vehicleImagePath,  double baseFare,  double serviceFee,  double taxes,  double grandTotal,  String currencySymbol)?  $default,) {final _that = this;
switch (_that) {
case _PaymentMethodModel() when $default != null:
return $default(_that.selectedMethod,_that.cardNumberMasked,_that.expiryDate,_that.cvvMasked,_that.vehicleName,_that.vehicleTier,_that.vehicleImagePath,_that.baseFare,_that.serviceFee,_that.taxes,_that.grandTotal,_that.currencySymbol);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentMethodModel implements PaymentMethodModel {
  const _PaymentMethodModel({required this.selectedMethod, required this.cardNumberMasked, required this.expiryDate, required this.cvvMasked, required this.vehicleName, required this.vehicleTier, required this.vehicleImagePath, required this.baseFare, required this.serviceFee, required this.taxes, required this.grandTotal, required this.currencySymbol});
  factory _PaymentMethodModel.fromJson(Map<String, dynamic> json) => _$PaymentMethodModelFromJson(json);

@override final  String selectedMethod;
@override final  String cardNumberMasked;
@override final  String expiryDate;
@override final  String cvvMasked;
@override final  String vehicleName;
@override final  String vehicleTier;
@override final  String vehicleImagePath;
@override final  double baseFare;
@override final  double serviceFee;
@override final  double taxes;
@override final  double grandTotal;
@override final  String currencySymbol;

/// Create a copy of PaymentMethodModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentMethodModelCopyWith<_PaymentMethodModel> get copyWith => __$PaymentMethodModelCopyWithImpl<_PaymentMethodModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentMethodModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentMethodModel&&(identical(other.selectedMethod, selectedMethod) || other.selectedMethod == selectedMethod)&&(identical(other.cardNumberMasked, cardNumberMasked) || other.cardNumberMasked == cardNumberMasked)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.cvvMasked, cvvMasked) || other.cvvMasked == cvvMasked)&&(identical(other.vehicleName, vehicleName) || other.vehicleName == vehicleName)&&(identical(other.vehicleTier, vehicleTier) || other.vehicleTier == vehicleTier)&&(identical(other.vehicleImagePath, vehicleImagePath) || other.vehicleImagePath == vehicleImagePath)&&(identical(other.baseFare, baseFare) || other.baseFare == baseFare)&&(identical(other.serviceFee, serviceFee) || other.serviceFee == serviceFee)&&(identical(other.taxes, taxes) || other.taxes == taxes)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,selectedMethod,cardNumberMasked,expiryDate,cvvMasked,vehicleName,vehicleTier,vehicleImagePath,baseFare,serviceFee,taxes,grandTotal,currencySymbol);

@override
String toString() {
  return 'PaymentMethodModel(selectedMethod: $selectedMethod, cardNumberMasked: $cardNumberMasked, expiryDate: $expiryDate, cvvMasked: $cvvMasked, vehicleName: $vehicleName, vehicleTier: $vehicleTier, vehicleImagePath: $vehicleImagePath, baseFare: $baseFare, serviceFee: $serviceFee, taxes: $taxes, grandTotal: $grandTotal, currencySymbol: $currencySymbol)';
}


}

/// @nodoc
abstract mixin class _$PaymentMethodModelCopyWith<$Res> implements $PaymentMethodModelCopyWith<$Res> {
  factory _$PaymentMethodModelCopyWith(_PaymentMethodModel value, $Res Function(_PaymentMethodModel) _then) = __$PaymentMethodModelCopyWithImpl;
@override @useResult
$Res call({
 String selectedMethod, String cardNumberMasked, String expiryDate, String cvvMasked, String vehicleName, String vehicleTier, String vehicleImagePath, double baseFare, double serviceFee, double taxes, double grandTotal, String currencySymbol
});




}
/// @nodoc
class __$PaymentMethodModelCopyWithImpl<$Res>
    implements _$PaymentMethodModelCopyWith<$Res> {
  __$PaymentMethodModelCopyWithImpl(this._self, this._then);

  final _PaymentMethodModel _self;
  final $Res Function(_PaymentMethodModel) _then;

/// Create a copy of PaymentMethodModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedMethod = null,Object? cardNumberMasked = null,Object? expiryDate = null,Object? cvvMasked = null,Object? vehicleName = null,Object? vehicleTier = null,Object? vehicleImagePath = null,Object? baseFare = null,Object? serviceFee = null,Object? taxes = null,Object? grandTotal = null,Object? currencySymbol = null,}) {
  return _then(_PaymentMethodModel(
selectedMethod: null == selectedMethod ? _self.selectedMethod : selectedMethod // ignore: cast_nullable_to_non_nullable
as String,cardNumberMasked: null == cardNumberMasked ? _self.cardNumberMasked : cardNumberMasked // ignore: cast_nullable_to_non_nullable
as String,expiryDate: null == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String,cvvMasked: null == cvvMasked ? _self.cvvMasked : cvvMasked // ignore: cast_nullable_to_non_nullable
as String,vehicleName: null == vehicleName ? _self.vehicleName : vehicleName // ignore: cast_nullable_to_non_nullable
as String,vehicleTier: null == vehicleTier ? _self.vehicleTier : vehicleTier // ignore: cast_nullable_to_non_nullable
as String,vehicleImagePath: null == vehicleImagePath ? _self.vehicleImagePath : vehicleImagePath // ignore: cast_nullable_to_non_nullable
as String,baseFare: null == baseFare ? _self.baseFare : baseFare // ignore: cast_nullable_to_non_nullable
as double,serviceFee: null == serviceFee ? _self.serviceFee : serviceFee // ignore: cast_nullable_to_non_nullable
as double,taxes: null == taxes ? _self.taxes : taxes // ignore: cast_nullable_to_non_nullable
as double,grandTotal: null == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as double,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
