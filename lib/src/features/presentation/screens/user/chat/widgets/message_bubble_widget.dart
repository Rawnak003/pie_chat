import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piechat/src/core/app/app_spacing.dart';
import 'package:piechat/src/core/utils/constants/colors.dart';
import 'package:piechat/src/features/data/models/chat_message_model.dart';

class MessageBubbleWidget extends StatelessWidget {
  const MessageBubbleWidget({
    super.key,
    required this.message,
    required this.isMe,
  });

  final ChatMessageModel message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).primaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.horizontalPadding,
          vertical: AppSpacing.verticalPadding,
        ),
        margin: EdgeInsets.only(
          right:
              isMe ? AppSpacing.horizontalPadding : AppSpacing.verticalPadding,
          left:
              isMe ? AppSpacing.verticalPadding : AppSpacing.horizontalPadding,
          bottom: AppSpacing.verticalPadding,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('hh:mm a').format(message.timestamp.toDate()),
                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                ),
                if (isMe)
                  Icon(
                    Icons.done_all,
                    color:
                        message.status == MessageStatus.read
                            ? AppColor.blueColor
                            : AppColor.whiteColor,
                    size: 14,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
