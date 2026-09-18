// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileEntity {
  int get id;
  String get name;
  double get rating;
  String get profileImageUrl;
  double get totalEarnings;
  double get walletBalance;
  String get phone;
  String get email;
  String get dob;
  String get gender;
  String get status;
  String get vehicleMake;
  String get vehicleModel;
  String get vehicleNumber;
  String get vehicleType;
  String get vehicleColor;
  String get vehicleYear;
  String get fuelType;

  /// Create a copy of ProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfileEntityCopyWith<ProfileEntity> get copyWith =>
      _$ProfileEntityCopyWithImpl<ProfileEntity>(
          this as ProfileEntity, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfileEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.totalEarnings, totalEarnings) ||
                other.totalEarnings == totalEarnings) &&
            (identical(other.walletBalance, walletBalance) ||
                other.walletBalance == walletBalance) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.dob, dob) || other.dob == dob) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.vehicleMake, vehicleMake) ||
                other.vehicleMake == vehicleMake) &&
            (identical(other.vehicleModel, vehicleModel) ||
                other.vehicleModel == vehicleModel) &&
            (identical(other.vehicleNumber, vehicleNumber) ||
                other.vehicleNumber == vehicleNumber) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            (identical(other.vehicleColor, vehicleColor) ||
                other.vehicleColor == vehicleColor) &&
            (identical(other.vehicleYear, vehicleYear) ||
                other.vehicleYear == vehicleYear) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      rating,
      profileImageUrl,
      totalEarnings,
      walletBalance,
      phone,
      email,
      dob,
      gender,
      status,
      vehicleMake,
      vehicleModel,
      vehicleNumber,
      vehicleType,
      vehicleColor,
      vehicleYear,
      fuelType);

  @override
  String toString() {
    return 'ProfileEntity(id: $id, name: $name, rating: $rating, profileImageUrl: $profileImageUrl, totalEarnings: $totalEarnings, walletBalance: $walletBalance, phone: $phone, email: $email, dob: $dob, gender: $gender, status: $status, vehicleMake: $vehicleMake, vehicleModel: $vehicleModel, vehicleNumber: $vehicleNumber, vehicleType: $vehicleType, vehicleColor: $vehicleColor, vehicleYear: $vehicleYear, fuelType: $fuelType)';
  }
}

/// @nodoc
abstract mixin class $ProfileEntityCopyWith<$Res> {
  factory $ProfileEntityCopyWith(
          ProfileEntity value, $Res Function(ProfileEntity) _then) =
      _$ProfileEntityCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String name,
      double rating,
      String profileImageUrl,
      double totalEarnings,
      double walletBalance,
      String phone,
      String email,
      String dob,
      String gender,
      String status,
      String vehicleMake,
      String vehicleModel,
      String vehicleNumber,
      String vehicleType,
      String vehicleColor,
      String vehicleYear,
      String fuelType});
}

/// @nodoc
class _$ProfileEntityCopyWithImpl<$Res>
    implements $ProfileEntityCopyWith<$Res> {
  _$ProfileEntityCopyWithImpl(this._self, this._then);

  final ProfileEntity _self;
  final $Res Function(ProfileEntity) _then;

  /// Create a copy of ProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? rating = null,
    Object? profileImageUrl = null,
    Object? totalEarnings = null,
    Object? walletBalance = null,
    Object? phone = null,
    Object? email = null,
    Object? dob = null,
    Object? gender = null,
    Object? status = null,
    Object? vehicleMake = null,
    Object? vehicleModel = null,
    Object? vehicleNumber = null,
    Object? vehicleType = null,
    Object? vehicleColor = null,
    Object? vehicleYear = null,
    Object? fuelType = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      profileImageUrl: null == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      totalEarnings: null == totalEarnings
          ? _self.totalEarnings
          : totalEarnings // ignore: cast_nullable_to_non_nullable
              as double,
      walletBalance: null == walletBalance
          ? _self.walletBalance
          : walletBalance // ignore: cast_nullable_to_non_nullable
              as double,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      dob: null == dob
          ? _self.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleMake: null == vehicleMake
          ? _self.vehicleMake
          : vehicleMake // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleModel: null == vehicleModel
          ? _self.vehicleModel
          : vehicleModel // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleNumber: null == vehicleNumber
          ? _self.vehicleNumber
          : vehicleNumber // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleType: null == vehicleType
          ? _self.vehicleType
          : vehicleType // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleColor: null == vehicleColor
          ? _self.vehicleColor
          : vehicleColor // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleYear: null == vehicleYear
          ? _self.vehicleYear
          : vehicleYear // ignore: cast_nullable_to_non_nullable
              as String,
      fuelType: null == fuelType
          ? _self.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProfileEntity].
extension ProfileEntityPatterns on ProfileEntity {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProfileEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileEntity() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProfileEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileEntity():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProfileEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileEntity() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int id,
            String name,
            double rating,
            String profileImageUrl,
            double totalEarnings,
            double walletBalance,
            String phone,
            String email,
            String dob,
            String gender,
            String status,
            String vehicleMake,
            String vehicleModel,
            String vehicleNumber,
            String vehicleType,
            String vehicleColor,
            String vehicleYear,
            String fuelType)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileEntity() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.rating,
            _that.profileImageUrl,
            _that.totalEarnings,
            _that.walletBalance,
            _that.phone,
            _that.email,
            _that.dob,
            _that.gender,
            _that.status,
            _that.vehicleMake,
            _that.vehicleModel,
            _that.vehicleNumber,
            _that.vehicleType,
            _that.vehicleColor,
            _that.vehicleYear,
            _that.fuelType);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int id,
            String name,
            double rating,
            String profileImageUrl,
            double totalEarnings,
            double walletBalance,
            String phone,
            String email,
            String dob,
            String gender,
            String status,
            String vehicleMake,
            String vehicleModel,
            String vehicleNumber,
            String vehicleType,
            String vehicleColor,
            String vehicleYear,
            String fuelType)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileEntity():
        return $default(
            _that.id,
            _that.name,
            _that.rating,
            _that.profileImageUrl,
            _that.totalEarnings,
            _that.walletBalance,
            _that.phone,
            _that.email,
            _that.dob,
            _that.gender,
            _that.status,
            _that.vehicleMake,
            _that.vehicleModel,
            _that.vehicleNumber,
            _that.vehicleType,
            _that.vehicleColor,
            _that.vehicleYear,
            _that.fuelType);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int id,
            String name,
            double rating,
            String profileImageUrl,
            double totalEarnings,
            double walletBalance,
            String phone,
            String email,
            String dob,
            String gender,
            String status,
            String vehicleMake,
            String vehicleModel,
            String vehicleNumber,
            String vehicleType,
            String vehicleColor,
            String vehicleYear,
            String fuelType)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileEntity() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.rating,
            _that.profileImageUrl,
            _that.totalEarnings,
            _that.walletBalance,
            _that.phone,
            _that.email,
            _that.dob,
            _that.gender,
            _that.status,
            _that.vehicleMake,
            _that.vehicleModel,
            _that.vehicleNumber,
            _that.vehicleType,
            _that.vehicleColor,
            _that.vehicleYear,
            _that.fuelType);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ProfileEntity extends ProfileEntity {
  const _ProfileEntity(
      {required this.id,
      required this.name,
      required this.rating,
      required this.profileImageUrl,
      required this.totalEarnings,
      required this.walletBalance,
      required this.phone,
      required this.email,
      required this.dob,
      required this.gender,
      required this.status,
      this.vehicleMake = 'Toyota',
      this.vehicleModel = 'Innova Crysta',
      this.vehicleNumber = 'TS 09 EQ 1234',
      this.vehicleType = 'SUV',
      this.vehicleColor = 'Pearl White',
      this.vehicleYear = '2023',
      this.fuelType = 'Diesel'})
      : super._();

  @override
  final int id;
  @override
  final String name;
  @override
  final double rating;
  @override
  final String profileImageUrl;
  @override
  final double totalEarnings;
  @override
  final double walletBalance;
  @override
  final String phone;
  @override
  final String email;
  @override
  final String dob;
  @override
  final String gender;
  @override
  final String status;
  @override
  @JsonKey()
  final String vehicleMake;
  @override
  @JsonKey()
  final String vehicleModel;
  @override
  @JsonKey()
  final String vehicleNumber;
  @override
  @JsonKey()
  final String vehicleType;
  @override
  @JsonKey()
  final String vehicleColor;
  @override
  @JsonKey()
  final String vehicleYear;
  @override
  @JsonKey()
  final String fuelType;

  /// Create a copy of ProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfileEntityCopyWith<_ProfileEntity> get copyWith =>
      __$ProfileEntityCopyWithImpl<_ProfileEntity>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfileEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.totalEarnings, totalEarnings) ||
                other.totalEarnings == totalEarnings) &&
            (identical(other.walletBalance, walletBalance) ||
                other.walletBalance == walletBalance) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.dob, dob) || other.dob == dob) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.vehicleMake, vehicleMake) ||
                other.vehicleMake == vehicleMake) &&
            (identical(other.vehicleModel, vehicleModel) ||
                other.vehicleModel == vehicleModel) &&
            (identical(other.vehicleNumber, vehicleNumber) ||
                other.vehicleNumber == vehicleNumber) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            (identical(other.vehicleColor, vehicleColor) ||
                other.vehicleColor == vehicleColor) &&
            (identical(other.vehicleYear, vehicleYear) ||
                other.vehicleYear == vehicleYear) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      rating,
      profileImageUrl,
      totalEarnings,
      walletBalance,
      phone,
      email,
      dob,
      gender,
      status,
      vehicleMake,
      vehicleModel,
      vehicleNumber,
      vehicleType,
      vehicleColor,
      vehicleYear,
      fuelType);

  @override
  String toString() {
    return 'ProfileEntity(id: $id, name: $name, rating: $rating, profileImageUrl: $profileImageUrl, totalEarnings: $totalEarnings, walletBalance: $walletBalance, phone: $phone, email: $email, dob: $dob, gender: $gender, status: $status, vehicleMake: $vehicleMake, vehicleModel: $vehicleModel, vehicleNumber: $vehicleNumber, vehicleType: $vehicleType, vehicleColor: $vehicleColor, vehicleYear: $vehicleYear, fuelType: $fuelType)';
  }
}

/// @nodoc
abstract mixin class _$ProfileEntityCopyWith<$Res>
    implements $ProfileEntityCopyWith<$Res> {
  factory _$ProfileEntityCopyWith(
          _ProfileEntity value, $Res Function(_ProfileEntity) _then) =
      __$ProfileEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      double rating,
      String profileImageUrl,
      double totalEarnings,
      double walletBalance,
      String phone,
      String email,
      String dob,
      String gender,
      String status,
      String vehicleMake,
      String vehicleModel,
      String vehicleNumber,
      String vehicleType,
      String vehicleColor,
      String vehicleYear,
      String fuelType});
}

/// @nodoc
class __$ProfileEntityCopyWithImpl<$Res>
    implements _$ProfileEntityCopyWith<$Res> {
  __$ProfileEntityCopyWithImpl(this._self, this._then);

  final _ProfileEntity _self;
  final $Res Function(_ProfileEntity) _then;

  /// Create a copy of ProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? rating = null,
    Object? profileImageUrl = null,
    Object? totalEarnings = null,
    Object? walletBalance = null,
    Object? phone = null,
    Object? email = null,
    Object? dob = null,
    Object? gender = null,
    Object? status = null,
    Object? vehicleMake = null,
    Object? vehicleModel = null,
    Object? vehicleNumber = null,
    Object? vehicleType = null,
    Object? vehicleColor = null,
    Object? vehicleYear = null,
    Object? fuelType = null,
  }) {
    return _then(_ProfileEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      profileImageUrl: null == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      totalEarnings: null == totalEarnings
          ? _self.totalEarnings
          : totalEarnings // ignore: cast_nullable_to_non_nullable
              as double,
      walletBalance: null == walletBalance
          ? _self.walletBalance
          : walletBalance // ignore: cast_nullable_to_non_nullable
              as double,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      dob: null == dob
          ? _self.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleMake: null == vehicleMake
          ? _self.vehicleMake
          : vehicleMake // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleModel: null == vehicleModel
          ? _self.vehicleModel
          : vehicleModel // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleNumber: null == vehicleNumber
          ? _self.vehicleNumber
          : vehicleNumber // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleType: null == vehicleType
          ? _self.vehicleType
          : vehicleType // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleColor: null == vehicleColor
          ? _self.vehicleColor
          : vehicleColor // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleYear: null == vehicleYear
          ? _self.vehicleYear
          : vehicleYear // ignore: cast_nullable_to_non_nullable
              as String,
      fuelType: null == fuelType
          ? _self.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
