import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:piechat/src/core/app/app_spacing.dart';
import 'package:piechat/src/core/utils/constants/colors.dart';
import 'package:piechat/src/features/data/models/chat_message_model.dart';
import 'package:piechat/src/features/data/services/service_locator.dart';
import 'package:piechat/src/features/logic/cubits/chats/chat_cubit.dart';
import 'package:piechat/src/features/presentation/screens/user/chat/widgets/message_bubble_widget.dart';

class ChatMessageScreen extends StatefulWidget {
  const ChatMessageScreen({super.key, required this.receiverId, required this.receiverName});

  final String receiverId;
  final String receiverName;

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatCubit _chatCubit = getIt<ChatCubit>();

  @override
  void initState() {
    super.initState();
    _chatCubit.enterChat(widget.receiverId);
  }

  Future<void> _handleSendMessage() async {
    await _chatCubit.sendMessage(
      content: _messageController.text.trim(),
      receiverId: widget.receiverId,
    );
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColor.avatarBGColor,
                child: Text(widget.receiverName[0].toUpperCase()),
              ),
              const SizedBox(width: AppSpacing.horizontalPadding),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.receiverName),
                  const Text('Last seen at 12:00', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return MessageBubbleWidget(
                    message: ChatMessageModel(
                      id: "51423",
                      chatRoomId: '8273564',
                      senderId: '873465',
                      receiverId: "92875",
                      content: "Hello this is my first message",
                      type: MessageType.text,
                      status: MessageStatus.sent,
                      timestamp: Timestamp.now(),
                      readBy: [],
                    ),
                    isMe: true,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.verticalPadding),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.emoji_emotions, color: AppColor.primaryColor),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
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
                          onPressed: _handleSendMessage,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
