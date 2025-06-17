import 'package:flutter/material.dart';
import 'package:piechat/src/features/data/models/chat_message_model.dart';
import 'package:piechat/src/features/data/models/chat_room_model.dart';
import 'package:piechat/src/features/data/services/service_locator.dart';
import 'package:piechat/src/features/logic/cubits/chats/chat_cubit.dart';

class ChatController {
  final TextEditingController messageController = TextEditingController();
  final ChatCubit chatCubit = getIt<ChatCubit>();
  final ScrollController scrollController = ScrollController();
  List<ChatMessageModel> previousMessages = [];

  bool isTyping = false;

  Future<void> handleSendMessage(String receiverId) async {
    if(messageController.text.trim().isNotEmpty) {
      await chatCubit.sendMessage(
        content: messageController.text.trim(),
        receiverId: receiverId,
      );
      messageController.clear();
    }
  }

  void dispose() {
    messageController.dispose();
    scrollController.dispose();
  }

  String getOtherUsername(ChatRoomModel chat, String currentUserId) {
    try {
      final otherUserId = chat.participants.firstWhere(
            (id) => id != currentUserId,
        orElse: () => 'Unknown User',
      );
      return chat.participantsName?[otherUserId] ?? "Unknown User";
    } catch (e) {
      return "Unknown User";
    }
  }

  void onTextChanged(VoidCallback updateState) {
    final isComposing = messageController.text.trim().isNotEmpty;
    if (isTyping != isComposing) {
      isTyping = isComposing;
      updateState();
      chatCubit.startTyping();
    }
  }

  void onScrollToLoad() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent-200) {
      chatCubit.loadMoreMessages();
    }
  }

  void scrollToBottom() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void hasNewMessages(List<ChatMessageModel> messages) {
    if(messages.length != previousMessages.length) {
      scrollToBottom();
      previousMessages = messages;
    }
  }
}