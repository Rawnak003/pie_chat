import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:piechat/src/core/app/app_spacing.dart';
import 'package:piechat/src/core/utils/constants/colors.dart';
import 'package:piechat/src/features/logic/cubits/chats/chat_cubit.dart';
import 'package:piechat/src/features/logic/cubits/chats/chat_state.dart';
import 'package:piechat/src/features/presentation/controllers/user_controller/chat_controller.dart';
import 'package:piechat/src/features/presentation/screens/user/chat/widgets/message_bubble_widget.dart';
import 'package:piechat/src/features/presentation/screens/user/chat/widgets/send_message_field_widget.dart';

class ChatMessageScreen extends StatefulWidget {
  const ChatMessageScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  final String receiverId;
  final String receiverName;

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  final ChatController chatController = ChatController();

  @override
  void initState() {
    super.initState();
    chatController.chatCubit.enterChat(widget.receiverId);
    chatController.messageController.addListener(
      () => chatController.onTextChanged(() => setState(() {})),
    );
  }

  @override
  void dispose() {
    super.dispose();
    chatController.dispose();
    chatController.chatCubit.leaveChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                BlocBuilder<ChatCubit, ChatState>(
                  bloc: chatController.chatCubit,
                  builder: (context, state) {
                    if (state.isReceiverTyping) {
                      return Text(
                        'Typing...',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.primaryColor,
                        ),
                      );
                    }
                    if (state.isReceiverOnline) {
                      return Text(
                        'Online',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.greenColor,
                        ),
                      );
                    }
                    if (state.receiverLastSeen != null) {
                      final lastSeen = state.receiverLastSeen!.toDate();
                      return Text(
                        'Last seen at ${DateFormat('hh:mm a').format(lastSeen)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.greyColor,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          BlocBuilder<ChatCubit, ChatState>(
            bloc: chatController.chatCubit,
            builder: (context, state) {
              if (state.isUserBlocked) {
                return TextButton.icon(
                  onPressed:
                      () => chatController.chatCubit.unBlockUser(
                        widget.receiverId,
                      ),
                  label: Text('Unblock'),
                );
              }
              return PopupMenuButton<String>(
                icon: Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (value == 'block') {
                    final bool? confirmation = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text('Block ${widget.receiverName}?'),
                            content: Text(
                              'Are you sure you want to block this user?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Block'),
                              ),
                            ],
                          ),
                    );
                    if (confirmation == true) {
                      chatController.chatCubit.blockUser(widget.receiverId);
                    }
                  }
                },
                itemBuilder:
                    (context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'block',
                        child: Text('Block'),
                      ),
                    ],
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ChatCubit, ChatState>(
          bloc: chatController.chatCubit,
          builder: (context, state) {
            if (state.status == ChatStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ChatStatus.error) {
              return Center(child: Text(state.error ?? 'Something went wrong'));
            }
            final isBlocked = state.amIBlocked;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isMe =
                          message.senderId ==
                          chatController.chatCubit.currentUserId;
                      return MessageBubbleWidget(message: message, isMe: isMe);
                    },
                  ),
                ),
                isBlocked
                    ? Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'You are blocked by ${widget.receiverName}.',
                      ),
                    )
                    : SendMessageField(
                      chatController: chatController,
                      receiverId: widget.receiverId,
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}
