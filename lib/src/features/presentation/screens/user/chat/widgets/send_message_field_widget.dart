import 'package:flutter/material.dart';
import 'package:piechat/src/core/app/app_spacing.dart';
import 'package:piechat/src/core/utils/constants/colors.dart';
import 'package:piechat/src/features/presentation/controllers/user_controller/chat_controller.dart';

class SendMessageField extends StatelessWidget {
  const SendMessageField({
    super.key,
    required this.chatController, required this.receiverId,
  });

  final ChatController chatController;
  final String receiverId;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.verticalPadding),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.emoji_emotions,
              color: AppColor.primaryColor,
            ),
          ),
          Expanded(
            child: TextField(
              controller: chatController.messageController,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                fillColor: Colors.grey[200],
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed:
                      () => chatController.handleSendMessage(
                    receiverId,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}