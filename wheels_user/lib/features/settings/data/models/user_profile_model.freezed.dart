// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserProfileModel {

 String get name; String get membershipTier; String get totalRides; String get rating; String get phone; String get email; String get gender; bool get isCorporate; String? get companyName; String? get corporateEmail; String? get corporateId; String? get department; String? get designation;
/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileModelCopyWith<UserProfileModel> get copyWith => _$UserProfileModelCopyWithImpl<UserProfileModel>(this as UserProfileModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfileModel&&(identical(other.name, name) || other.name == name)&&(identical(other.membershipTier, membershipTier) || other.membershipTier == membershipTier)&&(identical(other.totalRides, totalRides) || other.totalRides == totalRides)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.isCorporate, isCorporate) || other.isCorporate == isCorporate)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.corporateEmail, corporateEmail) || other.corporateEmail == corporateEmail)&&(identical(other.corporateId, corporateId) || other.corporateId == corporateId)&&(identical(other.department, department) || other.department == department)&&(identical(other.designation, designation) || other.designation == designation));
}


@override
int get hashCode => Object.hash(runtimeType,name,membershipTier,totalRides,rating,phone,email,gender,isCorporate,companyName,corporateEmail,corporateId,department,designation);

@override
String toString() {
  return 'UserProfileModel(name: $name, membershipTier: $membershipTier, totalRides: $totalRides, rating: $rating, phone: $phone, email: $email, gender: $gender, isCorporate: $isCorporate, companyName: $companyName, corporateEmail: $corporateEmail, corporateId: $corporateId, department: $department, designation: $designation)';
}


}

/// @nodoc
abstract mixin class $UserProfileModelCopyWith<$Res>  {
  factory $UserProfileModelCopyWith(UserProfileModel value, $Res Function(UserProfileModel) _then) = _$UserProfileModelCopyWithImpl;
@useResult
$Res call({
 String name, String membershipTier, String totalRides, String rating, String phone, String email, String gender, bool isCorporate, String? companyName, String? corporateEmail, String? corporateId, String? department, String? designation
});




}
/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._self, this._then);

  final UserProfileModel _self;
  final $Res Function(UserProfileModel) _then;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? membershipTier = null,Object? totalRides = null,Object? rating = null,Object? phone = null,Object? email = null,Object? gender = null,Object? isCorporate = null,Object? companyName = freezed,Object? corporateEmail = freezed,Object? corporateId = freezed,Object? department = freezed,Object? designation = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,membershipTier: null == membershipTier ? _self.membershipTier : membershipTier // ignore: cast_nullable_to_non_nullable
as String,totalRides: null == totalRides ? _self.totalRides : totalRides // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,isCorporate: null == isCorporate ? _self.isCorporate : isCorporate // ignore: cast_nullable_to_non_nullable
as bool,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,corporateEmail: freezed == corporateEmail ? _self.corporateEmail : corporateEmail // ignore: cast_nullable_to_non_nullable
as String?,corporateId: freezed == corporateId ? _self.corporateId : corporateId // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfileModel].
extension UserProfileModelPatterns on UserProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _UserProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String membershipTier,  String totalRides,  String rating,  String phone,  String email,  String gender,  bool isCorporate,  String? companyName,  String? corporateEmail,  String? corporateId,  String? department,  String? designation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that.name,_that.membershipTier,_that.totalRides,_that.rating,_that.phone,_that.email,_that.gender,_that.isCorporate,_that.companyName,_that.corporateEmail,_that.corporateId,_that.department,_that.designation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String membershipTier,  String totalRides,  String rating,  String phone,  String email,  String gender,  bool isCorporate,  String? companyName,  String? corporateEmail,  String? corporateId,  String? department,  String? designation)  $default,) {final _that = this;
switch (_that) {
case _UserProfileModel():
return $default(_that.name,_that.membershipTier,_that.totalRides,_that.rating,_that.phone,_that.email,_that.gender,_that.isCorporate,_that.companyName,_that.corporateEmail,_that.corporateId,_that.department,_that.designation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String membershipTier,  String totalRides,  String rating,  String phone,  String email,  String gender,  bool isCorporate,  String? companyName,  String? corporateEmail,  String? corporateId,  String? department,  String? designation)?  $default,) {final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that.name,_that.membershipTier,_that.totalRides,_that.rating,_that.phone,_that.email,_that.gender,_that.isCorporate,_that.companyName,_that.corporateEmail,_that.corporateId,_that.department,_that.designation);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfileModel implements UserProfileModel {
  const _UserProfileModel({required this.name, required this.membershipTier, required this.totalRides, required this.rating, required this.phone, required this.email, required this.gender, required this.isCorporate, this.companyName, this.corporateEmail, this.corporateId, this.department, this.designation});
  

@override final  String name;
@override final  String membershipTier;
@override final  String totalRides;
@override final  String rating;
@override final  String phone;
@override final  String email;
@override final  String gender;
@override final  bool isCorporate;
@override final  String? companyName;
@override final  String? corporateEmail;
@override final  String? corporateId;
@override final  String? department;
@override final  String? designation;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileModelCopyWith<_UserProfileModel> get copyWith => __$UserProfileModelCopyWithImpl<_UserProfileModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfileModel&&(identical(other.name, name) || other.name == name)&&(identical(other.membershipTier, membershipTier) || other.membershipTier == membershipTier)&&(identical(other.totalRides, totalRides) || other.totalRides == totalRides)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.isCorporate, isCorporate) || other.isCorporate == isCorporate)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.corporateEmail, corporateEmail) || other.corporateEmail == corporateEmail)&&(identical(other.corporateId, corporateId) || other.corporateId == corporateId)&&(identical(other.department, department) || other.department == department)&&(identical(other.designation, designation) || other.designation == designation));
}


@override
int get hashCode => Object.hash(runtimeType,name,membershipTier,totalRides,rating,phone,email,gender,isCorporate,companyName,corporateEmail,corporateId,department,designation);

@override
String toString() {
  return 'UserProfileModel(name: $name, membershipTier: $membershipTier, totalRides: $totalRides, rating: $rating, phone: $phone, email: $email, gender: $gender, isCorporate: $isCorporate, companyName: $companyName, corporateEmail: $corporateEmail, corporateId: $corporateId, department: $department, designation: $designation)';
}


}

/// @nodoc
abstract mixin class _$UserProfileModelCopyWith<$Res> implements $UserProfileModelCopyWith<$Res> {
  factory _$UserProfileModelCopyWith(_UserProfileModel value, $Res Function(_UserProfileModel) _then) = __$UserProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String membershipTier, String totalRides, String rating, String phone, String email, String gender, bool isCorporate, String? companyName, String? corporateEmail, String? corporateId, String? department, String? designation
});




}
/// @nodoc
class __$UserProfileModelCopyWithImpl<$Res>
    implements _$UserProfileModelCopyWith<$Res> {
  __$UserProfileModelCopyWithImpl(this._self, this._then);

  final _UserProfileModel _self;
  final $Res Function(_UserProfileModel) _then;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? membershipTier = null,Object? totalRides = null,Object? rating = null,Object? phone = null,Object? email = null,Object? gender = null,Object? isCorporate = null,Object? companyName = freezed,Object? corporateEmail = freezed,Object? corporateId = freezed,Object? department = freezed,Object? designation = freezed,}) {
  return _then(_UserProfileModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,membershipTier: null == membershipTier ? _self.membershipTier : membershipTier // ignore: cast_nullable_to_non_nullable
as String,totalRides: null == totalRides ? _self.totalRides : totalRides // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,isCorporate: null == isCorporate ? _self.isCorporate : isCorporate // ignore: cast_nullable_to_non_nullable
as bool,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,corporateEmail: freezed == corporateEmail ? _self.corporateEmail : corporateEmail // ignore: cast_nullable_to_non_nullable
as String?,corporateId: freezed == corporateId ? _self.corporateId : corporateId // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
