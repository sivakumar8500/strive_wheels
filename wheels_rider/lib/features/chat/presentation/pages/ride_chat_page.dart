import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/chat_bubble.dart';

class RideChatPage extends StatefulWidget {
  final int bookingId;
  final int currentUserId;
  final String counterpartyName;
  final ChatBloc? chatBloc;

  const RideChatPage({
    super.key,
    required this.bookingId,
    required this.currentUserId,
    required this.counterpartyName,
    this.chatBloc,
  });

  @override
  State<RideChatPage> createState() => _RideChatPageState();
}

class _RideChatPageState extends State<RideChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _handleSend(BuildContext context, ChatBloc bloc, bool isClosed) {
    if (isClosed) return;
    final text = _textController.text;
    if (text.trim().isNotEmpty) {
      bloc.add(ChatEvent.sendMessage(text.trim()));
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget content = Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                widget.counterpartyName.isNotEmpty
                    ? widget.counterpartyName[0].toUpperCase()
                    : 'C',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.counterpartyName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Customer Chat',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          _scrollToBottom();
          if (state.shouldNavigateHome) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.closeReason ?? 'Ride cancelled. Returning to previous screen.',
                ),
                backgroundColor: const Color(0xFFEF4444),
                duration: const Duration(seconds: 4),
              ),
            );
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          }
        },
        builder: (context, state) {
          final bloc = context.read<ChatBloc>();

          return Column(
            children: [
              if (state.isClosed)
                Container(
                  width: double.infinity,
                  color: isDark ? Colors.red[900]?.withOpacity(0.4) : const Color(0xFFFEE2E2),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Text(
                    state.closeReason ?? 'Trip completed or cancelled. Chat is now closed.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? Colors.red[200] : const Color(0xFFDC2626),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              Expanded(
                child: state.isLoadingHistory && state.messages.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : state.messages.isEmpty
                        ? Center(
                            child: Text(
                              'No messages yet',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              final msg = state.messages[index];
                              final isMe = msg.isSentByMe(widget.currentUserId);
                              return ChatBubble(message: msg, isMe: isMe);
                            },
                          ),
              ),
              _buildInputSection(context, bloc, state),
            ],
          );
        },
      ),
    );

    if (widget.chatBloc != null) {
      return BlocProvider<ChatBloc>.value(
        value: widget.chatBloc!,
        child: content,
      );
    }

    return BlocProvider<ChatBloc>(
      create: (_) => sl<ChatBloc>(param1: widget.bookingId)
        ..add(ChatEvent.init(widget.bookingId)),
      child: content,
    );
  }

  Widget _buildInputSection(BuildContext context, ChatBloc bloc, ChatState state) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('chat_input_textfield'),
                controller: _textController,
                enabled: !state.isClosed,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: state.isClosed ? 'Chat is closed' : 'Type a message...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[500] : const Color(0xFF94A3B8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: isDark
                      ? theme.colorScheme.surfaceVariant
                      : const Color(0xFFF1F5F9),
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (_) => _handleSend(context, bloc, state.isClosed),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              key: const Key('chat_send_button'),
              onPressed: state.isClosed ? null : () => _handleSend(context, bloc, state.isClosed),
              icon: const Icon(Icons.send_rounded),
              color: theme.colorScheme.primary,
              disabledColor: isDark ? Colors.grey[700] : const Color(0xFFCBD5E1),
            ),
          ],
        ),
      ),
    );
  }
}
