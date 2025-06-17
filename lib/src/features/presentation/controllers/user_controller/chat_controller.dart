import 'package:flutter/material.dart';
import 'package:piechat/src/features/data/models/chat_room_model.dart';
import 'package:piechat/src/features/data/services/service_locator.dart';
import 'package:piechat/src/features/logic/cubits/chats/chat_cubit.dart';

class ChatController {
  final TextEditingController messageController = TextEditingController();
  final ChatCubit chatCubit = getIt<ChatCubit>();

  bool isTyping = false;

  Future<void> handleSendMessage(String receiverId) async {
    await chatCubit.sendMessage(
      content: messageController.text.trim(),
      receiverId: receiverId,
    );
    messageController.clear();
  }

  void dispose() {
    messageController.dispose();
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
}