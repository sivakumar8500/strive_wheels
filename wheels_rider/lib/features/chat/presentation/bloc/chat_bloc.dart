import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/chat_message_model.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/get_chat_history_usecase.dart';
import '../../domain/usecases/listen_chat_messages_usecase.dart';
import '../../domain/usecases/send_chat_message_usecase.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatHistoryUseCase getChatHistoryUseCase;
  final SendChatMessageUseCase sendChatMessageUseCase;
  final ListenChatMessagesUseCase listenChatMessagesUseCase;

  StreamSubscription<Map<String, dynamic>>? _wsSubscription;

  ChatBloc({
    required this.getChatHistoryUseCase,
    required this.sendChatMessageUseCase,
    required this.listenChatMessagesUseCase,
    required int bookingId,
  }) : super(ChatState(bookingId: bookingId)) {
    on<ChatInitEvent>(_onInit);
    on<ChatMessageSentEvent>(_onSendMessage);
    on<ChatMessageReceivedEvent>(_onMessageReceived);
    on<ChatClosedEvent>(_onChatClosed);
  }

  Future<void> _onInit(
    ChatInitEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoadingHistory: true, bookingId: event.bookingId));

    try {
      final history = await getChatHistoryUseCase(event.bookingId);
      final sortedHistory = List<ChatMessageEntity>.from(history)
        ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
      emit(state.copyWith(messages: sortedHistory, isLoadingHistory: false));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      if (msg.contains('closed') || msg.contains('CANCELLED') || msg.contains('RIDER_CANCELLED')) {
        add(ChatEvent.chatClosed(
          msg,
          shouldNavigateHome: true,
        ));
      } else {
        emit(state.copyWith(isLoadingHistory: false, errorMessage: msg));
      }
    }

    await _wsSubscription?.cancel();
    _wsSubscription = listenChatMessagesUseCase(event.bookingId).listen(
      (eventMap) {
        final eventName = eventMap['event'] as String?;
        final data = (eventMap['data'] is Map)
            ? Map<String, dynamic>.from(eventMap['data'] as Map)
            : eventMap;

        if (eventName == 'booking.chat_message') {
          try {
            final model = ChatMessageModel.fromJson(data);
            add(ChatEvent.messageReceived(model.toEntity()));
          } catch (_) {}
        } else if (eventName == 'booking.chat_closed' ||
            eventName == 'booking.cancelled' ||
            eventName == 'booking.customer_cancelled' ||
            eventName == 'booking.rider_cancelled') {
          final reason = data['reason']?.toString() ??
              data['message']?.toString() ??
              'Trip completed or cancelled';
          final shouldNavigate = eventName == 'booking.cancelled' ||
              eventName == 'booking.customer_cancelled' ||
              eventName == 'booking.rider_cancelled' ||
              reason.contains('CANCELLED');
          add(ChatEvent.chatClosed(reason, shouldNavigateHome: shouldNavigate));
        }
      },
    );
  }

  Future<void> _onSendMessage(
    ChatMessageSentEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state.isClosed || event.message.trim().isEmpty) return;

    final trimmed = event.message.trim();
    try {
      final sentEntity = await sendChatMessageUseCase(
        bookingId: state.bookingId,
        message: trimmed,
      );
      if (sentEntity != null) {
        add(ChatEvent.messageReceived(sentEntity));
      }
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      if (msg.contains('closed') || msg.contains('CANCELLED')) {
        add(ChatEvent.chatClosed(
          msg,
          shouldNavigateHome: true,
        ));
      }
    }
  }

  void _onMessageReceived(
    ChatMessageReceivedEvent event,
    Emitter<ChatState> emit,
  ) {
    final existing = List<ChatMessageEntity>.from(state.messages);
    final exists = existing.any((m) =>
        (m.id != 0 && m.id == event.message.id) ||
        (m.senderId == event.message.senderId &&
            m.message == event.message.message &&
            m.sentAt.difference(event.message.sentAt).abs().inSeconds < 3));

    if (!exists) {
      existing.add(event.message);
      existing.sort((a, b) => a.sentAt.compareTo(b.sentAt));
      emit(state.copyWith(messages: existing));
    }
  }

  void _onChatClosed(
    ChatClosedEvent event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(
      isClosed: true,
      isLoadingHistory: false,
      shouldNavigateHome: event.shouldNavigateHome,
      closeReason: event.reason,
    ));
  }

  @override
  Future<void> close() {
    _wsSubscription?.cancel();
    return super.close();
  }
}
