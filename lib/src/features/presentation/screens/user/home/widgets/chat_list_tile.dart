import 'package:flutter/material.dart';
import 'package:piechat/src/core/utils/constants/colors.dart';
import 'package:piechat/src/features/data/models/chat_room_model.dart';
import 'package:piechat/src/features/data/repositories/chat_repository.dart';
import 'package:piechat/src/features/data/services/service_locator.dart';
import 'package:piechat/src/features/presentation/controllers/user_controller/chat_controller.dart';

class ChatListTile extends StatelessWidget {
  final ChatRoomModel chat;
  final String currentUserId;
  final VoidCallback onTap;
  const ChatListTile({
    super.key,
    required this.chat,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = ChatController();
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: AppColor.secondaryColor,
        child: Text(
          chatController.getOtherUsername(chat, currentUserId)[0].toUpperCase(),
        ),
      ),
      title: Text(
        chatController.getOtherUsername(chat, currentUserId),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              chat.lastMessage ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
      trailing: StreamBuilder<int>(
        stream: getIt<ChatRepository>().getUnreadCount(chat.id, currentUserId),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == 0) {
            return const SizedBox();
          }
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              snapshot.data.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
