// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_step_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegistrationStepResponse {

 bool get success; RegistrationStepData get data;
/// Create a copy of RegistrationStepResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationStepResponseCopyWith<RegistrationStepResponse> get copyWith => _$RegistrationStepResponseCopyWithImpl<RegistrationStepResponse>(this as RegistrationStepResponse, _$identity);

  /// Serializes this RegistrationStepResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistrationStepResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data);

@override
String toString() {
  return 'RegistrationStepResponse(success: $success, data: $data)';
}


}

/// @nodoc
abstract mixin class $RegistrationStepResponseCopyWith<$Res>  {
  factory $RegistrationStepResponseCopyWith(RegistrationStepResponse value, $Res Function(RegistrationStepResponse) _then) = _$RegistrationStepResponseCopyWithImpl;
@useResult
$Res call({
 bool success, RegistrationStepData data
});


$RegistrationStepDataCopyWith<$Res> get data;

}
/// @nodoc
class _$RegistrationStepResponseCopyWithImpl<$Res>
    implements $RegistrationStepResponseCopyWith<$Res> {
  _$RegistrationStepResponseCopyWithImpl(this._self, this._then);

  final RegistrationStepResponse _self;
  final $Res Function(RegistrationStepResponse) _then;

/// Create a copy of RegistrationStepResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as RegistrationStepData,
  ));
}
/// Create a copy of RegistrationStepResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegistrationStepDataCopyWith<$Res> get data {
  
  return $RegistrationStepDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [RegistrationStepResponse].
extension RegistrationStepResponsePatterns on RegistrationStepResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegistrationStepResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegistrationStepResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegistrationStepResponse value)  $default,){
final _that = this;
switch (_that) {
case _RegistrationStepResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegistrationStepResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RegistrationStepResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  RegistrationStepData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegistrationStepResponse() when $default != null:
return $default(_that.success,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  RegistrationStepData data)  $default,) {final _that = this;
switch (_that) {
case _RegistrationStepResponse():
return $default(_that.success,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  RegistrationStepData data)?  $default,) {final _that = this;
switch (_that) {
case _RegistrationStepResponse() when $default != null:
return $default(_that.success,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegistrationStepResponse implements RegistrationStepResponse {
  const _RegistrationStepResponse({required this.success, required this.data});
  factory _RegistrationStepResponse.fromJson(Map<String, dynamic> json) => _$RegistrationStepResponseFromJson(json);

@override final  bool success;
@override final  RegistrationStepData data;

/// Create a copy of RegistrationStepResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistrationStepResponseCopyWith<_RegistrationStepResponse> get copyWith => __$RegistrationStepResponseCopyWithImpl<_RegistrationStepResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegistrationStepResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegistrationStepResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data);

@override
String toString() {
  return 'RegistrationStepResponse(success: $success, data: $data)';
}


}

/// @nodoc
abstract mixin class _$RegistrationStepResponseCopyWith<$Res> implements $RegistrationStepResponseCopyWith<$Res> {
  factory _$RegistrationStepResponseCopyWith(_RegistrationStepResponse value, $Res Function(_RegistrationStepResponse) _then) = __$RegistrationStepResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, RegistrationStepData data
});


@override $RegistrationStepDataCopyWith<$Res> get data;

}
/// @nodoc
class __$RegistrationStepResponseCopyWithImpl<$Res>
    implements _$RegistrationStepResponseCopyWith<$Res> {
  __$RegistrationStepResponseCopyWithImpl(this._self, this._then);

  final _RegistrationStepResponse _self;
  final $Res Function(_RegistrationStepResponse) _then;

/// Create a copy of RegistrationStepResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,}) {
  return _then(_RegistrationStepResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as RegistrationStepData,
  ));
}

/// Create a copy of RegistrationStepResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegistrationStepDataCopyWith<$Res> get data {
  
  return $RegistrationStepDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$RegistrationStepData {

@JsonKey(name: 'registration_id') int get registrationId; String get status;@JsonKey(name: 'current_step') int get currentStep;@JsonKey(name: 'total_steps') int get totalSteps;@JsonKey(name: 'progress_percentage') double get progressPercentage;@JsonKey(name: 'completed_steps') List<int> get completedSteps;@JsonKey(name: 'next_step') int? get nextStep; String get message;
/// Create a copy of RegistrationStepData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationStepDataCopyWith<RegistrationStepData> get copyWith => _$RegistrationStepDataCopyWithImpl<RegistrationStepData>(this as RegistrationStepData, _$identity);

  /// Serializes this RegistrationStepData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistrationStepData&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.totalSteps, totalSteps) || other.totalSteps == totalSteps)&&(identical(other.progressPercentage, progressPercentage) || other.progressPercentage == progressPercentage)&&const DeepCollectionEquality().equals(other.completedSteps, completedSteps)&&(identical(other.nextStep, nextStep) || other.nextStep == nextStep)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,registrationId,status,currentStep,totalSteps,progressPercentage,const DeepCollectionEquality().hash(completedSteps),nextStep,message);

@override
String toString() {
  return 'RegistrationStepData(registrationId: $registrationId, status: $status, currentStep: $currentStep, totalSteps: $totalSteps, progressPercentage: $progressPercentage, completedSteps: $completedSteps, nextStep: $nextStep, message: $message)';
}


}

/// @nodoc
abstract mixin class $RegistrationStepDataCopyWith<$Res>  {
  factory $RegistrationStepDataCopyWith(RegistrationStepData value, $Res Function(RegistrationStepData) _then) = _$RegistrationStepDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'registration_id') int registrationId, String status,@JsonKey(name: 'current_step') int currentStep,@JsonKey(name: 'total_steps') int totalSteps,@JsonKey(name: 'progress_percentage') double progressPercentage,@JsonKey(name: 'completed_steps') List<int> completedSteps,@JsonKey(name: 'next_step') int? nextStep, String message
});




}
/// @nodoc
class _$RegistrationStepDataCopyWithImpl<$Res>
    implements $RegistrationStepDataCopyWith<$Res> {
  _$RegistrationStepDataCopyWithImpl(this._self, this._then);

  final RegistrationStepData _self;
  final $Res Function(RegistrationStepData) _then;

/// Create a copy of RegistrationStepData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? registrationId = null,Object? status = null,Object? currentStep = null,Object? totalSteps = null,Object? progressPercentage = null,Object? completedSteps = null,Object? nextStep = freezed,Object? message = null,}) {
  return _then(_self.copyWith(
registrationId: null == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,totalSteps: null == totalSteps ? _self.totalSteps : totalSteps // ignore: cast_nullable_to_non_nullable
as int,progressPercentage: null == progressPercentage ? _self.progressPercentage : progressPercentage // ignore: cast_nullable_to_non_nullable
as double,completedSteps: null == completedSteps ? _self.completedSteps : completedSteps // ignore: cast_nullable_to_non_nullable
as List<int>,nextStep: freezed == nextStep ? _self.nextStep : nextStep // ignore: cast_nullable_to_non_nullable
as int?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RegistrationStepData].
extension RegistrationStepDataPatterns on RegistrationStepData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegistrationStepData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegistrationStepData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegistrationStepData value)  $default,){
final _that = this;
switch (_that) {
case _RegistrationStepData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegistrationStepData value)?  $default,){
final _that = this;
switch (_that) {
case _RegistrationStepData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'registration_id')  int registrationId,  String status, @JsonKey(name: 'current_step')  int currentStep, @JsonKey(name: 'total_steps')  int totalSteps, @JsonKey(name: 'progress_percentage')  double progressPercentage, @JsonKey(name: 'completed_steps')  List<int> completedSteps, @JsonKey(name: 'next_step')  int? nextStep,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegistrationStepData() when $default != null:
return $default(_that.registrationId,_that.status,_that.currentStep,_that.totalSteps,_that.progressPercentage,_that.completedSteps,_that.nextStep,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'registration_id')  int registrationId,  String status, @JsonKey(name: 'current_step')  int currentStep, @JsonKey(name: 'total_steps')  int totalSteps, @JsonKey(name: 'progress_percentage')  double progressPercentage, @JsonKey(name: 'completed_steps')  List<int> completedSteps, @JsonKey(name: 'next_step')  int? nextStep,  String message)  $default,) {final _that = this;
switch (_that) {
case _RegistrationStepData():
return $default(_that.registrationId,_that.status,_that.currentStep,_that.totalSteps,_that.progressPercentage,_that.completedSteps,_that.nextStep,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'registration_id')  int registrationId,  String status, @JsonKey(name: 'current_step')  int currentStep, @JsonKey(name: 'total_steps')  int totalSteps, @JsonKey(name: 'progress_percentage')  double progressPercentage, @JsonKey(name: 'completed_steps')  List<int> completedSteps, @JsonKey(name: 'next_step')  int? nextStep,  String message)?  $default,) {final _that = this;
switch (_that) {
case _RegistrationStepData() when $default != null:
return $default(_that.registrationId,_that.status,_that.currentStep,_that.totalSteps,_that.progressPercentage,_that.completedSteps,_that.nextStep,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegistrationStepData implements RegistrationStepData {
  const _RegistrationStepData({@JsonKey(name: 'registration_id') required this.registrationId, required this.status, @JsonKey(name: 'current_step') required this.currentStep, @JsonKey(name: 'total_steps') required this.totalSteps, @JsonKey(name: 'progress_percentage') required this.progressPercentage, @JsonKey(name: 'completed_steps') required final  List<int> completedSteps, @JsonKey(name: 'next_step') this.nextStep, required this.message}): _completedSteps = completedSteps;
  factory _RegistrationStepData.fromJson(Map<String, dynamic> json) => _$RegistrationStepDataFromJson(json);

@override@JsonKey(name: 'registration_id') final  int registrationId;
@override final  String status;
@override@JsonKey(name: 'current_step') final  int currentStep;
@override@JsonKey(name: 'total_steps') final  int totalSteps;
@override@JsonKey(name: 'progress_percentage') final  double progressPercentage;
 final  List<int> _completedSteps;
@override@JsonKey(name: 'completed_steps') List<int> get completedSteps {
  if (_completedSteps is EqualUnmodifiableListView) return _completedSteps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedSteps);
}

@override@JsonKey(name: 'next_step') final  int? nextStep;
@override final  String message;

/// Create a copy of RegistrationStepData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistrationStepDataCopyWith<_RegistrationStepData> get copyWith => __$RegistrationStepDataCopyWithImpl<_RegistrationStepData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegistrationStepDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegistrationStepData&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.totalSteps, totalSteps) || other.totalSteps == totalSteps)&&(identical(other.progressPercentage, progressPercentage) || other.progressPercentage == progressPercentage)&&const DeepCollectionEquality().equals(other._completedSteps, _completedSteps)&&(identical(other.nextStep, nextStep) || other.nextStep == nextStep)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,registrationId,status,currentStep,totalSteps,progressPercentage,const DeepCollectionEquality().hash(_completedSteps),nextStep,message);

@override
String toString() {
  return 'RegistrationStepData(registrationId: $registrationId, status: $status, currentStep: $currentStep, totalSteps: $totalSteps, progressPercentage: $progressPercentage, completedSteps: $completedSteps, nextStep: $nextStep, message: $message)';
}


}

/// @nodoc
abstract mixin class _$RegistrationStepDataCopyWith<$Res> implements $RegistrationStepDataCopyWith<$Res> {
  factory _$RegistrationStepDataCopyWith(_RegistrationStepData value, $Res Function(_RegistrationStepData) _then) = __$RegistrationStepDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'registration_id') int registrationId, String status,@JsonKey(name: 'current_step') int currentStep,@JsonKey(name: 'total_steps') int totalSteps,@JsonKey(name: 'progress_percentage') double progressPercentage,@JsonKey(name: 'completed_steps') List<int> completedSteps,@JsonKey(name: 'next_step') int? nextStep, String message
});




}
/// @nodoc
class __$RegistrationStepDataCopyWithImpl<$Res>
    implements _$RegistrationStepDataCopyWith<$Res> {
  __$RegistrationStepDataCopyWithImpl(this._self, this._then);

  final _RegistrationStepData _self;
  final $Res Function(_RegistrationStepData) _then;

/// Create a copy of RegistrationStepData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? registrationId = null,Object? status = null,Object? currentStep = null,Object? totalSteps = null,Object? progressPercentage = null,Object? completedSteps = null,Object? nextStep = freezed,Object? message = null,}) {
  return _then(_RegistrationStepData(
registrationId: null == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,totalSteps: null == totalSteps ? _self.totalSteps : totalSteps // ignore: cast_nullable_to_non_nullable
as int,progressPercentage: null == progressPercentage ? _self.progressPercentage : progressPercentage // ignore: cast_nullable_to_non_nullable
as double,completedSteps: null == completedSteps ? _self._completedSteps : completedSteps // ignore: cast_nullable_to_non_nullable
as List<int>,nextStep: freezed == nextStep ? _self.nextStep : nextStep // ignore: cast_nullable_to_non_nullable
as int?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
