import 'package:paint_app/auth/data/user.dart';
import 'package:paint_app/chat/data/chat_message.dart';
import 'package:paint_app/chat/data/chat_websocket_dto.dart';
import 'package:paint_app/common/websocket_wrapper.dart';

class ChatRepository {
  final int sessionId;
  final Uri uri;

  WebsocketWrapper? websocket;

  ChatRepository({required this.sessionId, required this.uri});

  Stream<ChatWebsocketDto>? get stream =>
      websocket?.stream.map((event) => ChatWebsocketDto.fromString(event));

  void connect({required User user}) {
    websocket = WebsocketWrapper.connect(uri: uri);
    final dto = ChatWebsocketDto(
      sessionId: sessionId,
      method: ChatWebsocketMethod.connect,
      data: ChatWebsocketData(
        connect: ChatConnectDto(userId: user.id, username: user.username),
      ),
    );
    websocket?.send(dto.toJson());
  }

  void send(ChatMessage message) {
    final dto = ChatWebsocketDto(
      sessionId: sessionId,
      method: ChatWebsocketMethod.message,
      data: ChatWebsocketData(message: message),
    );
    websocket?.send(dto.toJson());
  }

  Future<void> close() async {
    await websocket?.close();
    websocket = null;
  }
}
