import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/auth/data/user.dart';
import 'package:paint_app/chat/data/chat_message.dart';
import 'package:paint_app/chat/data/chat_repository.dart';
import 'package:paint_app/chat/data/chat_websocket_dto.dart';
import 'package:paint_app/common/logger.dart';

class ChatCubit extends Cubit<ChatState> {
  final User user;
  final ChatRepository repository;

  StreamSubscription<ChatWebsocketDto>? subscription;

  ChatCubit({required this.user, required this.repository})
    : super(ChatState$Initial());

  void init() {
    try {
      repository.connect(user: user);
      subscription = repository.stream?.listen(
        _mapChatWebsocketEvent,
        onError: (error) {
          Logger.error(error);
        },
      );

      emit(ChatState$Connected(messages: []));
    } catch (e) {
      emit(const ChatState$Error());
      Logger.error(e);
    }
  }

  void _mapChatWebsocketEvent(ChatWebsocketDto dto) {
    if (dto.data.message != null) {
      onMessage(dto.data.message!, notify: false);
    } else if (dto.data.clear != null) {
      // clear(notify: false);
    }
  }

  void onMessage(ChatMessage message, {bool notify = true}) {
    final messages = switch (state) {
      ChatState$Connected connected => List.of(connected.messages),
      _ => null,
    };
    if (messages != null) {
      if (notify) {
        repository.send(message);
      }

      messages.add(message);
      emit(ChatState$Connected(messages: messages));
    }
  }
}

sealed class ChatState {
  const ChatState();
}

class ChatState$Initial extends ChatState {
  const ChatState$Initial();
}

class ChatState$Error extends ChatState {
  const ChatState$Error();
}

class ChatState$Connected extends ChatState {
  final List<ChatMessage> messages;

  const ChatState$Connected({required this.messages});

  List<ChatMessage> get reversed => messages.reversed.toList();
}
