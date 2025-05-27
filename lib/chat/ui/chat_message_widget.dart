import 'package:flutter/material.dart';
import 'package:paint_app/auth/data/user.dart';
import 'package:paint_app/chat/data/chat_message.dart';

class ChatMessageWidget extends StatelessWidget {
  final User user;
  final ChatMessage message;

  const ChatMessageWidget({
    super.key,
    required this.user,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (user.id == message.userId) Spacer(flex: 1),
        Flexible(
          flex: 5,
          child: Align(
            alignment:
                user.id == message.userId
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Column(
                  crossAxisAlignment:
                      user.id == message.userId
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                  children: [
                    Text(message.username, style: TextStyle(fontSize: 12)),
                    SelectableText(
                      message.text,
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (user.id != message.userId) Spacer(flex: 1),
      ],
    );
  }
}
