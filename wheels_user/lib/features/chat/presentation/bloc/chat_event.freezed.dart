// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatEvent()';
}


}

/// @nodoc
class $ChatEventCopyWith<$Res>  {
$ChatEventCopyWith(ChatEvent _, $Res Function(ChatEvent) __);
}


/// Adds pattern-matching-related methods to [ChatEvent].
extension ChatEventPatterns on ChatEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChatInitEvent value)?  init,TResult Function( ChatMessageSentEvent value)?  sendMessage,TResult Function( ChatMessageReceivedEvent value)?  messageReceived,TResult Function( ChatClosedEvent value)?  chatClosed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChatInitEvent() when init != null:
return init(_that);case ChatMessageSentEvent() when sendMessage != null:
return sendMessage(_that);case ChatMessageReceivedEvent() when messageReceived != null:
return messageReceived(_that);case ChatClosedEvent() when chatClosed != null:
return chatClosed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChatInitEvent value)  init,required TResult Function( ChatMessageSentEvent value)  sendMessage,required TResult Function( ChatMessageReceivedEvent value)  messageReceived,required TResult Function( ChatClosedEvent value)  chatClosed,}){
final _that = this;
switch (_that) {
case ChatInitEvent():
return init(_that);case ChatMessageSentEvent():
return sendMessage(_that);case ChatMessageReceivedEvent():
return messageReceived(_that);case ChatClosedEvent():
return chatClosed(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChatInitEvent value)?  init,TResult? Function( ChatMessageSentEvent value)?  sendMessage,TResult? Function( ChatMessageReceivedEvent value)?  messageReceived,TResult? Function( ChatClosedEvent value)?  chatClosed,}){
final _that = this;
switch (_that) {
case ChatInitEvent() when init != null:
return init(_that);case ChatMessageSentEvent() when sendMessage != null:
return sendMessage(_that);case ChatMessageReceivedEvent() when messageReceived != null:
return messageReceived(_that);case ChatClosedEvent() when chatClosed != null:
return chatClosed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int bookingId)?  init,TResult Function( String message)?  sendMessage,TResult Function( ChatMessageEntity message)?  messageReceived,TResult Function( String reason,  bool shouldNavigateHome)?  chatClosed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChatInitEvent() when init != null:
return init(_that.bookingId);case ChatMessageSentEvent() when sendMessage != null:
return sendMessage(_that.message);case ChatMessageReceivedEvent() when messageReceived != null:
return messageReceived(_that.message);case ChatClosedEvent() when chatClosed != null:
return chatClosed(_that.reason,_that.shouldNavigateHome);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int bookingId)  init,required TResult Function( String message)  sendMessage,required TResult Function( ChatMessageEntity message)  messageReceived,required TResult Function( String reason,  bool shouldNavigateHome)  chatClosed,}) {final _that = this;
switch (_that) {
case ChatInitEvent():
return init(_that.bookingId);case ChatMessageSentEvent():
return sendMessage(_that.message);case ChatMessageReceivedEvent():
return messageReceived(_that.message);case ChatClosedEvent():
return chatClosed(_that.reason,_that.shouldNavigateHome);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int bookingId)?  init,TResult? Function( String message)?  sendMessage,TResult? Function( ChatMessageEntity message)?  messageReceived,TResult? Function( String reason,  bool shouldNavigateHome)?  chatClosed,}) {final _that = this;
switch (_that) {
case ChatInitEvent() when init != null:
return init(_that.bookingId);case ChatMessageSentEvent() when sendMessage != null:
return sendMessage(_that.message);case ChatMessageReceivedEvent() when messageReceived != null:
return messageReceived(_that.message);case ChatClosedEvent() when chatClosed != null:
return chatClosed(_that.reason,_that.shouldNavigateHome);case _:
  return null;

}
}

}

/// @nodoc


class ChatInitEvent implements ChatEvent {
  const ChatInitEvent(this.bookingId);
  

 final  int bookingId;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatInitEventCopyWith<ChatInitEvent> get copyWith => _$ChatInitEventCopyWithImpl<ChatInitEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatInitEvent&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId));
}


@override
int get hashCode => Object.hash(runtimeType,bookingId);

@override
String toString() {
  return 'ChatEvent.init(bookingId: $bookingId)';
}


}

/// @nodoc
abstract mixin class $ChatInitEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatInitEventCopyWith(ChatInitEvent value, $Res Function(ChatInitEvent) _then) = _$ChatInitEventCopyWithImpl;
@useResult
$Res call({
 int bookingId
});




}
/// @nodoc
class _$ChatInitEventCopyWithImpl<$Res>
    implements $ChatInitEventCopyWith<$Res> {
  _$ChatInitEventCopyWithImpl(this._self, this._then);

  final ChatInitEvent _self;
  final $Res Function(ChatInitEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bookingId = null,}) {
  return _then(ChatInitEvent(
null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ChatMessageSentEvent implements ChatEvent {
  const ChatMessageSentEvent(this.message);
  

 final  String message;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageSentEventCopyWith<ChatMessageSentEvent> get copyWith => _$ChatMessageSentEventCopyWithImpl<ChatMessageSentEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageSentEvent&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatEvent.sendMessage(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatMessageSentEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatMessageSentEventCopyWith(ChatMessageSentEvent value, $Res Function(ChatMessageSentEvent) _then) = _$ChatMessageSentEventCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChatMessageSentEventCopyWithImpl<$Res>
    implements $ChatMessageSentEventCopyWith<$Res> {
  _$ChatMessageSentEventCopyWithImpl(this._self, this._then);

  final ChatMessageSentEvent _self;
  final $Res Function(ChatMessageSentEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ChatMessageSentEvent(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ChatMessageReceivedEvent implements ChatEvent {
  const ChatMessageReceivedEvent(this.message);
  

 final  ChatMessageEntity message;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageReceivedEventCopyWith<ChatMessageReceivedEvent> get copyWith => _$ChatMessageReceivedEventCopyWithImpl<ChatMessageReceivedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageReceivedEvent&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatEvent.messageReceived(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatMessageReceivedEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatMessageReceivedEventCopyWith(ChatMessageReceivedEvent value, $Res Function(ChatMessageReceivedEvent) _then) = _$ChatMessageReceivedEventCopyWithImpl;
@useResult
$Res call({
 ChatMessageEntity message
});




}
/// @nodoc
class _$ChatMessageReceivedEventCopyWithImpl<$Res>
    implements $ChatMessageReceivedEventCopyWith<$Res> {
  _$ChatMessageReceivedEventCopyWithImpl(this._self, this._then);

  final ChatMessageReceivedEvent _self;
  final $Res Function(ChatMessageReceivedEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ChatMessageReceivedEvent(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as ChatMessageEntity,
  ));
}


}

/// @nodoc


class ChatClosedEvent implements ChatEvent {
  const ChatClosedEvent(this.reason, {this.shouldNavigateHome = false});
  

 final  String reason;
@JsonKey() final  bool shouldNavigateHome;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatClosedEventCopyWith<ChatClosedEvent> get copyWith => _$ChatClosedEventCopyWithImpl<ChatClosedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatClosedEvent&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.shouldNavigateHome, shouldNavigateHome) || other.shouldNavigateHome == shouldNavigateHome));
}


@override
int get hashCode => Object.hash(runtimeType,reason,shouldNavigateHome);

@override
String toString() {
  return 'ChatEvent.chatClosed(reason: $reason, shouldNavigateHome: $shouldNavigateHome)';
}


}

/// @nodoc
abstract mixin class $ChatClosedEventCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatClosedEventCopyWith(ChatClosedEvent value, $Res Function(ChatClosedEvent) _then) = _$ChatClosedEventCopyWithImpl;
@useResult
$Res call({
 String reason, bool shouldNavigateHome
});




}
/// @nodoc
class _$ChatClosedEventCopyWithImpl<$Res>
    implements $ChatClosedEventCopyWith<$Res> {
  _$ChatClosedEventCopyWithImpl(this._self, this._then);

  final ChatClosedEvent _self;
  final $Res Function(ChatClosedEvent) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,Object? shouldNavigateHome = null,}) {
  return _then(ChatClosedEvent(
null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,shouldNavigateHome: null == shouldNavigateHome ? _self.shouldNavigateHome : shouldNavigateHome // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
