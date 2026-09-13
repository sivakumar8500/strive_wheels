// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessageModel {

 int get id;@JsonKey(name: 'booking_id') int get bookingId;@JsonKey(name: 'sender_id') int get senderId;@JsonKey(name: 'sender_role') String get senderRole; String get message;@JsonKey(name: 'sent_at') String? get sentAt;
/// Create a copy of ChatMessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageModelCopyWith<ChatMessageModel> get copyWith => _$ChatMessageModelCopyWithImpl<ChatMessageModel>(this as ChatMessageModel, _$identity);

  /// Serializes this ChatMessageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderRole, senderRole) || other.senderRole == senderRole)&&(identical(other.message, message) || other.message == message)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingId,senderId,senderRole,message,sentAt);

@override
String toString() {
  return 'ChatMessageModel(id: $id, bookingId: $bookingId, senderId: $senderId, senderRole: $senderRole, message: $message, sentAt: $sentAt)';
}


}

/// @nodoc
abstract mixin class $ChatMessageModelCopyWith<$Res>  {
  factory $ChatMessageModelCopyWith(ChatMessageModel value, $Res Function(ChatMessageModel) _then) = _$ChatMessageModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'booking_id') int bookingId,@JsonKey(name: 'sender_id') int senderId,@JsonKey(name: 'sender_role') String senderRole, String message,@JsonKey(name: 'sent_at') String? sentAt
});




}
/// @nodoc
class _$ChatMessageModelCopyWithImpl<$Res>
    implements $ChatMessageModelCopyWith<$Res> {
  _$ChatMessageModelCopyWithImpl(this._self, this._then);

  final ChatMessageModel _self;
  final $Res Function(ChatMessageModel) _then;

/// Create a copy of ChatMessageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookingId = null,Object? senderId = null,Object? senderRole = null,Object? message = null,Object? sentAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as int,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as int,senderRole: null == senderRole ? _self.senderRole : senderRole // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessageModel].
extension ChatMessageModelPatterns on ChatMessageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessageModel value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'booking_id')  int bookingId, @JsonKey(name: 'sender_id')  int senderId, @JsonKey(name: 'sender_role')  String senderRole,  String message, @JsonKey(name: 'sent_at')  String? sentAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageModel() when $default != null:
return $default(_that.id,_that.bookingId,_that.senderId,_that.senderRole,_that.message,_that.sentAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'booking_id')  int bookingId, @JsonKey(name: 'sender_id')  int senderId, @JsonKey(name: 'sender_role')  String senderRole,  String message, @JsonKey(name: 'sent_at')  String? sentAt)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageModel():
return $default(_that.id,_that.bookingId,_that.senderId,_that.senderRole,_that.message,_that.sentAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'booking_id')  int bookingId, @JsonKey(name: 'sender_id')  int senderId, @JsonKey(name: 'sender_role')  String senderRole,  String message, @JsonKey(name: 'sent_at')  String? sentAt)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageModel() when $default != null:
return $default(_that.id,_that.bookingId,_that.senderId,_that.senderRole,_that.message,_that.sentAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessageModel implements ChatMessageModel {
  const _ChatMessageModel({this.id = 0, @JsonKey(name: 'booking_id') this.bookingId = 0, @JsonKey(name: 'sender_id') this.senderId = 0, @JsonKey(name: 'sender_role') this.senderRole = 'CUSTOMER', this.message = '', @JsonKey(name: 'sent_at') this.sentAt});
  factory _ChatMessageModel.fromJson(Map<String, dynamic> json) => _$ChatMessageModelFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey(name: 'booking_id') final  int bookingId;
@override@JsonKey(name: 'sender_id') final  int senderId;
@override@JsonKey(name: 'sender_role') final  String senderRole;
@override@JsonKey() final  String message;
@override@JsonKey(name: 'sent_at') final  String? sentAt;

/// Create a copy of ChatMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageModelCopyWith<_ChatMessageModel> get copyWith => __$ChatMessageModelCopyWithImpl<_ChatMessageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderRole, senderRole) || other.senderRole == senderRole)&&(identical(other.message, message) || other.message == message)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookingId,senderId,senderRole,message,sentAt);

@override
String toString() {
  return 'ChatMessageModel(id: $id, bookingId: $bookingId, senderId: $senderId, senderRole: $senderRole, message: $message, sentAt: $sentAt)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageModelCopyWith<$Res> implements $ChatMessageModelCopyWith<$Res> {
  factory _$ChatMessageModelCopyWith(_ChatMessageModel value, $Res Function(_ChatMessageModel) _then) = __$ChatMessageModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'booking_id') int bookingId,@JsonKey(name: 'sender_id') int senderId,@JsonKey(name: 'sender_role') String senderRole, String message,@JsonKey(name: 'sent_at') String? sentAt
});




}
/// @nodoc
class __$ChatMessageModelCopyWithImpl<$Res>
    implements _$ChatMessageModelCopyWith<$Res> {
  __$ChatMessageModelCopyWithImpl(this._self, this._then);

  final _ChatMessageModel _self;
  final $Res Function(_ChatMessageModel) _then;

/// Create a copy of ChatMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookingId = null,Object? senderId = null,Object? senderRole = null,Object? message = null,Object? sentAt = freezed,}) {
  return _then(_ChatMessageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as int,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as int,senderRole: null == senderRole ? _self.senderRole : senderRole // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
