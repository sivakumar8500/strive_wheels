// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileModel {
  @JsonKey(name: 'id')
  int? get id;
  @JsonKey(name: 'rating_avg')
  double? get rating;
  @JsonKey(name: 'total_earnings')
  double? get totalEarnings;
  @JsonKey(name: 'wallet_balance')
  double? get walletBalance;
  @JsonKey(name: 'user')
  Map<String, dynamic>? get user;
  @JsonKey(name: 'vehicle_detail')
  Map<String, dynamic>? get vehicleDetail;
  @JsonKey(name: 'corporate_detail')
  Map<String, dynamic>? get corporateDetail;
  @JsonKey(name: 'active_company')
  Map<String, dynamic>? get activeCompany;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfileModelCopyWith<ProfileModel> get copyWith =>
      _$ProfileModelCopyWithImpl<ProfileModel>(
          this as ProfileModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfileModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalEarnings, totalEarnings) ||
                other.totalEarnings == totalEarnings) &&
            (identical(other.walletBalance, walletBalance) ||
                other.walletBalance == walletBalance) &&
            const DeepCollectionEquality().equals(other.user, user) &&
            const DeepCollectionEquality()
                .equals(other.vehicleDetail, vehicleDetail) &&
            const DeepCollectionEquality()
                .equals(other.corporateDetail, corporateDetail) &&
            const DeepCollectionEquality()
                .equals(other.activeCompany, activeCompany));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      rating,
      totalEarnings,
      walletBalance,
      const DeepCollectionEquality().hash(user),
      const DeepCollectionEquality().hash(vehicleDetail),
      const DeepCollectionEquality().hash(corporateDetail),
      const DeepCollectionEquality().hash(activeCompany));

  @override
  String toString() {
    return 'ProfileModel(id: $id, rating: $rating, totalEarnings: $totalEarnings, walletBalance: $walletBalance, user: $user, vehicleDetail: $vehicleDetail, corporateDetail: $corporateDetail, activeCompany: $activeCompany)';
  }
}

/// @nodoc
abstract mixin class $ProfileModelCopyWith<$Res> {
  factory $ProfileModelCopyWith(
          ProfileModel value, $Res Function(ProfileModel) _then) =
      _$ProfileModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'rating_avg') double? rating,
      @JsonKey(name: 'total_earnings') double? totalEarnings,
      @JsonKey(name: 'wallet_balance') double? walletBalance,
      @JsonKey(name: 'user') Map<String, dynamic>? user,
      @JsonKey(name: 'vehicle_detail') Map<String, dynamic>? vehicleDetail,
      @JsonKey(name: 'corporate_detail') Map<String, dynamic>? corporateDetail,
      @JsonKey(name: 'active_company') Map<String, dynamic>? activeCompany});
}

/// @nodoc
class _$ProfileModelCopyWithImpl<$Res> implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._self, this._then);

  final ProfileModel _self;
  final $Res Function(ProfileModel) _then;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? rating = freezed,
    Object? totalEarnings = freezed,
    Object? walletBalance = freezed,
    Object? user = freezed,
    Object? vehicleDetail = freezed,
    Object? corporateDetail = freezed,
    Object? activeCompany = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      totalEarnings: freezed == totalEarnings
          ? _self.totalEarnings
          : totalEarnings // ignore: cast_nullable_to_non_nullable
              as double?,
      walletBalance: freezed == walletBalance
          ? _self.walletBalance
          : walletBalance // ignore: cast_nullable_to_non_nullable
              as double?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      vehicleDetail: freezed == vehicleDetail
          ? _self.vehicleDetail
          : vehicleDetail // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      corporateDetail: freezed == corporateDetail
          ? _self.corporateDetail
          : corporateDetail // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      activeCompany: freezed == activeCompany
          ? _self.activeCompany
          : activeCompany // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProfileModel].
extension ProfileModelPatterns on ProfileModel {
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
    TResult Function(_ProfileModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileModel() when $default != null:
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
    TResult Function(_ProfileModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileModel():
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
    TResult? Function(_ProfileModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileModel() when $default != null:
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
            @JsonKey(name: 'id') int? id,
            @JsonKey(name: 'rating_avg') double? rating,
            @JsonKey(name: 'total_earnings') double? totalEarnings,
            @JsonKey(name: 'wallet_balance') double? walletBalance,
            @JsonKey(name: 'user') Map<String, dynamic>? user,
            @JsonKey(name: 'vehicle_detail')
            Map<String, dynamic>? vehicleDetail,
            @JsonKey(name: 'corporate_detail')
            Map<String, dynamic>? corporateDetail,
            @JsonKey(name: 'active_company')
            Map<String, dynamic>? activeCompany)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileModel() when $default != null:
        return $default(
            _that.id,
            _that.rating,
            _that.totalEarnings,
            _that.walletBalance,
            _that.user,
            _that.vehicleDetail,
            _that.corporateDetail,
            _that.activeCompany);
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
            @JsonKey(name: 'id') int? id,
            @JsonKey(name: 'rating_avg') double? rating,
            @JsonKey(name: 'total_earnings') double? totalEarnings,
            @JsonKey(name: 'wallet_balance') double? walletBalance,
            @JsonKey(name: 'user') Map<String, dynamic>? user,
            @JsonKey(name: 'vehicle_detail')
            Map<String, dynamic>? vehicleDetail,
            @JsonKey(name: 'corporate_detail')
            Map<String, dynamic>? corporateDetail,
            @JsonKey(name: 'active_company')
            Map<String, dynamic>? activeCompany)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileModel():
        return $default(
            _that.id,
            _that.rating,
            _that.totalEarnings,
            _that.walletBalance,
            _that.user,
            _that.vehicleDetail,
            _that.corporateDetail,
            _that.activeCompany);
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
            @JsonKey(name: 'id') int? id,
            @JsonKey(name: 'rating_avg') double? rating,
            @JsonKey(name: 'total_earnings') double? totalEarnings,
            @JsonKey(name: 'wallet_balance') double? walletBalance,
            @JsonKey(name: 'user') Map<String, dynamic>? user,
            @JsonKey(name: 'vehicle_detail')
            Map<String, dynamic>? vehicleDetail,
            @JsonKey(name: 'corporate_detail')
            Map<String, dynamic>? corporateDetail,
            @JsonKey(name: 'active_company')
            Map<String, dynamic>? activeCompany)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileModel() when $default != null:
        return $default(
            _that.id,
            _that.rating,
            _that.totalEarnings,
            _that.walletBalance,
            _that.user,
            _that.vehicleDetail,
            _that.corporateDetail,
            _that.activeCompany);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ProfileModel extends ProfileModel {
  const _ProfileModel(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'rating_avg') this.rating,
      @JsonKey(name: 'total_earnings') this.totalEarnings,
      @JsonKey(name: 'wallet_balance') this.walletBalance,
      @JsonKey(name: 'user') final Map<String, dynamic>? user,
      @JsonKey(name: 'vehicle_detail')
      final Map<String, dynamic>? vehicleDetail,
      @JsonKey(name: 'corporate_detail')
      final Map<String, dynamic>? corporateDetail,
      @JsonKey(name: 'active_company')
      final Map<String, dynamic>? activeCompany})
      : _user = user,
        _vehicleDetail = vehicleDetail,
        _corporateDetail = corporateDetail,
        _activeCompany = activeCompany,
        super._();

  @override
  @JsonKey(name: 'id')
  final int? id;
  @override
  @JsonKey(name: 'rating_avg')
  final double? rating;
  @override
  @JsonKey(name: 'total_earnings')
  final double? totalEarnings;
  @override
  @JsonKey(name: 'wallet_balance')
  final double? walletBalance;
  final Map<String, dynamic>? _user;
  @override
  @JsonKey(name: 'user')
  Map<String, dynamic>? get user {
    final value = _user;
    if (value == null) return null;
    if (_user is EqualUnmodifiableMapView) return _user;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _vehicleDetail;
  @override
  @JsonKey(name: 'vehicle_detail')
  Map<String, dynamic>? get vehicleDetail {
    final value = _vehicleDetail;
    if (value == null) return null;
    if (_vehicleDetail is EqualUnmodifiableMapView) return _vehicleDetail;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _corporateDetail;
  @override
  @JsonKey(name: 'corporate_detail')
  Map<String, dynamic>? get corporateDetail {
    final value = _corporateDetail;
    if (value == null) return null;
    if (_corporateDetail is EqualUnmodifiableMapView) return _corporateDetail;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _activeCompany;
  @override
  @JsonKey(name: 'active_company')
  Map<String, dynamic>? get activeCompany {
    final value = _activeCompany;
    if (value == null) return null;
    if (_activeCompany is EqualUnmodifiableMapView) return _activeCompany;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfileModelCopyWith<_ProfileModel> get copyWith =>
      __$ProfileModelCopyWithImpl<_ProfileModel>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfileModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalEarnings, totalEarnings) ||
                other.totalEarnings == totalEarnings) &&
            (identical(other.walletBalance, walletBalance) ||
                other.walletBalance == walletBalance) &&
            const DeepCollectionEquality().equals(other._user, _user) &&
            const DeepCollectionEquality()
                .equals(other._vehicleDetail, _vehicleDetail) &&
            const DeepCollectionEquality()
                .equals(other._corporateDetail, _corporateDetail) &&
            const DeepCollectionEquality()
                .equals(other._activeCompany, _activeCompany));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      rating,
      totalEarnings,
      walletBalance,
      const DeepCollectionEquality().hash(_user),
      const DeepCollectionEquality().hash(_vehicleDetail),
      const DeepCollectionEquality().hash(_corporateDetail),
      const DeepCollectionEquality().hash(_activeCompany));

  @override
  String toString() {
    return 'ProfileModel(id: $id, rating: $rating, totalEarnings: $totalEarnings, walletBalance: $walletBalance, user: $user, vehicleDetail: $vehicleDetail, corporateDetail: $corporateDetail, activeCompany: $activeCompany)';
  }
}

/// @nodoc
abstract mixin class _$ProfileModelCopyWith<$Res>
    implements $ProfileModelCopyWith<$Res> {
  factory _$ProfileModelCopyWith(
          _ProfileModel value, $Res Function(_ProfileModel) _then) =
      __$ProfileModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'rating_avg') double? rating,
      @JsonKey(name: 'total_earnings') double? totalEarnings,
      @JsonKey(name: 'wallet_balance') double? walletBalance,
      @JsonKey(name: 'user') Map<String, dynamic>? user,
      @JsonKey(name: 'vehicle_detail') Map<String, dynamic>? vehicleDetail,
      @JsonKey(name: 'corporate_detail') Map<String, dynamic>? corporateDetail,
      @JsonKey(name: 'active_company') Map<String, dynamic>? activeCompany});
}

/// @nodoc
class __$ProfileModelCopyWithImpl<$Res>
    implements _$ProfileModelCopyWith<$Res> {
  __$ProfileModelCopyWithImpl(this._self, this._then);

  final _ProfileModel _self;
  final $Res Function(_ProfileModel) _then;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? rating = freezed,
    Object? totalEarnings = freezed,
    Object? walletBalance = freezed,
    Object? user = freezed,
    Object? vehicleDetail = freezed,
    Object? corporateDetail = freezed,
    Object? activeCompany = freezed,
  }) {
    return _then(_ProfileModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      totalEarnings: freezed == totalEarnings
          ? _self.totalEarnings
          : totalEarnings // ignore: cast_nullable_to_non_nullable
              as double?,
      walletBalance: freezed == walletBalance
          ? _self.walletBalance
          : walletBalance // ignore: cast_nullable_to_non_nullable
              as double?,
      user: freezed == user
          ? _self._user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      vehicleDetail: freezed == vehicleDetail
          ? _self._vehicleDetail
          : vehicleDetail // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      corporateDetail: freezed == corporateDetail
          ? _self._corporateDetail
          : corporateDetail // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      activeCompany: freezed == activeCompany
          ? _self._activeCompany
          : activeCompany // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

// dart format on
