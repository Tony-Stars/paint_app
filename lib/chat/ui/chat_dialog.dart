import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/auth/data/user.dart';
import 'package:paint_app/chat/bloc/chat_cubit.dart';
import 'package:paint_app/chat/data/chat_message.dart';
import 'package:paint_app/chat/ui/chat_message_widget.dart';

class ChatDialog extends StatefulWidget {
  final User user;

  const ChatDialog({super.key, required this.user});

  static Future<void> show(BuildContext context, {required User user}) async {
    await showDialog(
      context: context,
      useSafeArea: false,
      builder: (ctx) => ChatDialog(user: user),
    );
  }

  @override
  State<ChatDialog> createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (controller.text.isNotEmpty) {}
    });
  }

  void send(BuildContext context) {
    if (controller.text.trim().isNotEmpty) {
      context.read<ChatCubit>().onMessage(
        ChatMessage(
          text: controller.text,
          username: widget.user.username,
          userId: widget.user.id,
        ),
      );
      controller.clear();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return switch (state) {
          ChatState$Initial _ => SizedBox(),
          ChatState$Error _ => Text('Произошла ошибка'),
          ChatState$Connected connected => Dialog(
            alignment: Alignment.centerRight,
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
            ),
            child: SizedBox(
              width: 400,
              child: DecoratedBox(
                decoration: BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: ListView(
                            padding: EdgeInsets.all(12),
                            reverse: true,
                            children: [
                              for (final message in connected.reversed)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: ChatMessageWidget(
                                    message: message,
                                    user: widget.user,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  controller: controller,
                                  minLines: 5,
                                  maxLines: 5,
                                  onChanged: (value) {
                                    if (value.isNotEmpty &&
                                        value.runes.last == 10) {
                                      send(context);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 6,
                              ),
                              child: IconButton(
                                onPressed: () => send(context),
                                icon: Icon(Icons.send),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        };
      },
    );
  }
}
