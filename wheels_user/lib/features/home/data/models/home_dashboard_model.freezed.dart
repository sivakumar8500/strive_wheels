// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeDashboardModel {

 String get userName; String get greetingTitle; String get greetingSubtitle; String get recentRideTitle; String get recentRideDetails; int get selectedNavIndex; bool get isCorporate; String? get companyName; String? get employeeCode; String? get spendingLimit; String? get companyLocation;
/// Create a copy of HomeDashboardModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeDashboardModelCopyWith<HomeDashboardModel> get copyWith => _$HomeDashboardModelCopyWithImpl<HomeDashboardModel>(this as HomeDashboardModel, _$identity);

  /// Serializes this HomeDashboardModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeDashboardModel&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.greetingTitle, greetingTitle) || other.greetingTitle == greetingTitle)&&(identical(other.greetingSubtitle, greetingSubtitle) || other.greetingSubtitle == greetingSubtitle)&&(identical(other.recentRideTitle, recentRideTitle) || other.recentRideTitle == recentRideTitle)&&(identical(other.recentRideDetails, recentRideDetails) || other.recentRideDetails == recentRideDetails)&&(identical(other.selectedNavIndex, selectedNavIndex) || other.selectedNavIndex == selectedNavIndex)&&(identical(other.isCorporate, isCorporate) || other.isCorporate == isCorporate)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.employeeCode, employeeCode) || other.employeeCode == employeeCode)&&(identical(other.spendingLimit, spendingLimit) || other.spendingLimit == spendingLimit)&&(identical(other.companyLocation, companyLocation) || other.companyLocation == companyLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userName,greetingTitle,greetingSubtitle,recentRideTitle,recentRideDetails,selectedNavIndex,isCorporate,companyName,employeeCode,spendingLimit,companyLocation);

@override
String toString() {
  return 'HomeDashboardModel(userName: $userName, greetingTitle: $greetingTitle, greetingSubtitle: $greetingSubtitle, recentRideTitle: $recentRideTitle, recentRideDetails: $recentRideDetails, selectedNavIndex: $selectedNavIndex, isCorporate: $isCorporate, companyName: $companyName, employeeCode: $employeeCode, spendingLimit: $spendingLimit, companyLocation: $companyLocation)';
}


}

/// @nodoc
abstract mixin class $HomeDashboardModelCopyWith<$Res>  {
  factory $HomeDashboardModelCopyWith(HomeDashboardModel value, $Res Function(HomeDashboardModel) _then) = _$HomeDashboardModelCopyWithImpl;
@useResult
$Res call({
 String userName, String greetingTitle, String greetingSubtitle, String recentRideTitle, String recentRideDetails, int selectedNavIndex, bool isCorporate, String? companyName, String? employeeCode, String? spendingLimit, String? companyLocation
});




}
/// @nodoc
class _$HomeDashboardModelCopyWithImpl<$Res>
    implements $HomeDashboardModelCopyWith<$Res> {
  _$HomeDashboardModelCopyWithImpl(this._self, this._then);

  final HomeDashboardModel _self;
  final $Res Function(HomeDashboardModel) _then;

/// Create a copy of HomeDashboardModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userName = null,Object? greetingTitle = null,Object? greetingSubtitle = null,Object? recentRideTitle = null,Object? recentRideDetails = null,Object? selectedNavIndex = null,Object? isCorporate = null,Object? companyName = freezed,Object? employeeCode = freezed,Object? spendingLimit = freezed,Object? companyLocation = freezed,}) {
  return _then(_self.copyWith(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,greetingTitle: null == greetingTitle ? _self.greetingTitle : greetingTitle // ignore: cast_nullable_to_non_nullable
as String,greetingSubtitle: null == greetingSubtitle ? _self.greetingSubtitle : greetingSubtitle // ignore: cast_nullable_to_non_nullable
as String,recentRideTitle: null == recentRideTitle ? _self.recentRideTitle : recentRideTitle // ignore: cast_nullable_to_non_nullable
as String,recentRideDetails: null == recentRideDetails ? _self.recentRideDetails : recentRideDetails // ignore: cast_nullable_to_non_nullable
as String,selectedNavIndex: null == selectedNavIndex ? _self.selectedNavIndex : selectedNavIndex // ignore: cast_nullable_to_non_nullable
as int,isCorporate: null == isCorporate ? _self.isCorporate : isCorporate // ignore: cast_nullable_to_non_nullable
as bool,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,employeeCode: freezed == employeeCode ? _self.employeeCode : employeeCode // ignore: cast_nullable_to_non_nullable
as String?,spendingLimit: freezed == spendingLimit ? _self.spendingLimit : spendingLimit // ignore: cast_nullable_to_non_nullable
as String?,companyLocation: freezed == companyLocation ? _self.companyLocation : companyLocation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeDashboardModel].
extension HomeDashboardModelPatterns on HomeDashboardModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeDashboardModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeDashboardModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeDashboardModel value)  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeDashboardModel value)?  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userName,  String greetingTitle,  String greetingSubtitle,  String recentRideTitle,  String recentRideDetails,  int selectedNavIndex,  bool isCorporate,  String? companyName,  String? employeeCode,  String? spendingLimit,  String? companyLocation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeDashboardModel() when $default != null:
return $default(_that.userName,_that.greetingTitle,_that.greetingSubtitle,_that.recentRideTitle,_that.recentRideDetails,_that.selectedNavIndex,_that.isCorporate,_that.companyName,_that.employeeCode,_that.spendingLimit,_that.companyLocation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userName,  String greetingTitle,  String greetingSubtitle,  String recentRideTitle,  String recentRideDetails,  int selectedNavIndex,  bool isCorporate,  String? companyName,  String? employeeCode,  String? spendingLimit,  String? companyLocation)  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardModel():
return $default(_that.userName,_that.greetingTitle,_that.greetingSubtitle,_that.recentRideTitle,_that.recentRideDetails,_that.selectedNavIndex,_that.isCorporate,_that.companyName,_that.employeeCode,_that.spendingLimit,_that.companyLocation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userName,  String greetingTitle,  String greetingSubtitle,  String recentRideTitle,  String recentRideDetails,  int selectedNavIndex,  bool isCorporate,  String? companyName,  String? employeeCode,  String? spendingLimit,  String? companyLocation)?  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardModel() when $default != null:
return $default(_that.userName,_that.greetingTitle,_that.greetingSubtitle,_that.recentRideTitle,_that.recentRideDetails,_that.selectedNavIndex,_that.isCorporate,_that.companyName,_that.employeeCode,_that.spendingLimit,_that.companyLocation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeDashboardModel implements HomeDashboardModel {
  const _HomeDashboardModel({required this.userName, required this.greetingTitle, required this.greetingSubtitle, required this.recentRideTitle, required this.recentRideDetails, this.selectedNavIndex = 0, this.isCorporate = false, this.companyName, this.employeeCode, this.spendingLimit, this.companyLocation});
  factory _HomeDashboardModel.fromJson(Map<String, dynamic> json) => _$HomeDashboardModelFromJson(json);

@override final  String userName;
@override final  String greetingTitle;
@override final  String greetingSubtitle;
@override final  String recentRideTitle;
@override final  String recentRideDetails;
@override@JsonKey() final  int selectedNavIndex;
@override@JsonKey() final  bool isCorporate;
@override final  String? companyName;
@override final  String? employeeCode;
@override final  String? spendingLimit;
@override final  String? companyLocation;

/// Create a copy of HomeDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeDashboardModelCopyWith<_HomeDashboardModel> get copyWith => __$HomeDashboardModelCopyWithImpl<_HomeDashboardModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeDashboardModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeDashboardModel&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.greetingTitle, greetingTitle) || other.greetingTitle == greetingTitle)&&(identical(other.greetingSubtitle, greetingSubtitle) || other.greetingSubtitle == greetingSubtitle)&&(identical(other.recentRideTitle, recentRideTitle) || other.recentRideTitle == recentRideTitle)&&(identical(other.recentRideDetails, recentRideDetails) || other.recentRideDetails == recentRideDetails)&&(identical(other.selectedNavIndex, selectedNavIndex) || other.selectedNavIndex == selectedNavIndex)&&(identical(other.isCorporate, isCorporate) || other.isCorporate == isCorporate)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.employeeCode, employeeCode) || other.employeeCode == employeeCode)&&(identical(other.spendingLimit, spendingLimit) || other.spendingLimit == spendingLimit)&&(identical(other.companyLocation, companyLocation) || other.companyLocation == companyLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userName,greetingTitle,greetingSubtitle,recentRideTitle,recentRideDetails,selectedNavIndex,isCorporate,companyName,employeeCode,spendingLimit,companyLocation);

@override
String toString() {
  return 'HomeDashboardModel(userName: $userName, greetingTitle: $greetingTitle, greetingSubtitle: $greetingSubtitle, recentRideTitle: $recentRideTitle, recentRideDetails: $recentRideDetails, selectedNavIndex: $selectedNavIndex, isCorporate: $isCorporate, companyName: $companyName, employeeCode: $employeeCode, spendingLimit: $spendingLimit, companyLocation: $companyLocation)';
}


}

/// @nodoc
abstract mixin class _$HomeDashboardModelCopyWith<$Res> implements $HomeDashboardModelCopyWith<$Res> {
  factory _$HomeDashboardModelCopyWith(_HomeDashboardModel value, $Res Function(_HomeDashboardModel) _then) = __$HomeDashboardModelCopyWithImpl;
@override @useResult
$Res call({
 String userName, String greetingTitle, String greetingSubtitle, String recentRideTitle, String recentRideDetails, int selectedNavIndex, bool isCorporate, String? companyName, String? employeeCode, String? spendingLimit, String? companyLocation
});




}
/// @nodoc
class __$HomeDashboardModelCopyWithImpl<$Res>
    implements _$HomeDashboardModelCopyWith<$Res> {
  __$HomeDashboardModelCopyWithImpl(this._self, this._then);

  final _HomeDashboardModel _self;
  final $Res Function(_HomeDashboardModel) _then;

/// Create a copy of HomeDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userName = null,Object? greetingTitle = null,Object? greetingSubtitle = null,Object? recentRideTitle = null,Object? recentRideDetails = null,Object? selectedNavIndex = null,Object? isCorporate = null,Object? companyName = freezed,Object? employeeCode = freezed,Object? spendingLimit = freezed,Object? companyLocation = freezed,}) {
  return _then(_HomeDashboardModel(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,greetingTitle: null == greetingTitle ? _self.greetingTitle : greetingTitle // ignore: cast_nullable_to_non_nullable
as String,greetingSubtitle: null == greetingSubtitle ? _self.greetingSubtitle : greetingSubtitle // ignore: cast_nullable_to_non_nullable
as String,recentRideTitle: null == recentRideTitle ? _self.recentRideTitle : recentRideTitle // ignore: cast_nullable_to_non_nullable
as String,recentRideDetails: null == recentRideDetails ? _self.recentRideDetails : recentRideDetails // ignore: cast_nullable_to_non_nullable
as String,selectedNavIndex: null == selectedNavIndex ? _self.selectedNavIndex : selectedNavIndex // ignore: cast_nullable_to_non_nullable
as int,isCorporate: null == isCorporate ? _self.isCorporate : isCorporate // ignore: cast_nullable_to_non_nullable
as bool,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,employeeCode: freezed == employeeCode ? _self.employeeCode : employeeCode // ignore: cast_nullable_to_non_nullable
as String?,spendingLimit: freezed == spendingLimit ? _self.spendingLimit : spendingLimit // ignore: cast_nullable_to_non_nullable
as String?,companyLocation: freezed == companyLocation ? _self.companyLocation : companyLocation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
