import 'package:paint_app/canvas/data/canvas_object.dart';
import 'package:paint_app/canvas/data/canvas_websocket_dto.dart';
import 'package:paint_app/common/websocket_wrapper.dart';

class CanvasRepository {
  final int sessionId;
  final Uri uri;

  WebsocketWrapper? websocket;

  CanvasRepository({required this.sessionId, required this.uri});

  Stream<CanvasWebsocketDto>? get stream =>
      websocket?.stream.map((event) => CanvasWebsocketDto.fromString(event));

  void connect({required String username}) {
    websocket = WebsocketWrapper.connect(uri: uri);
    final dto = CanvasWebsocketDto(
      sessionId: sessionId,
      method: CanvasWebsocketMethod.connect,
      data: CanvasWebsocketData(connect: CanvasConnectDto(username: username)),
    );
    websocket?.send(dto.toJson());
  }

  void draw(CanvasObject object) {
    final dto = CanvasWebsocketDto(
      sessionId: sessionId,
      method: CanvasWebsocketMethod.draw,
      data: CanvasWebsocketData(draw: object),
    );
    websocket?.send(dto.toJson());
  }

  clear() {
    final dto = CanvasWebsocketDto(
      sessionId: sessionId,
      method: CanvasWebsocketMethod.clear,
      data: CanvasWebsocketData(clear: true),
    );
    websocket?.send(dto.toJson());
  }

  Future<void> close() async {
    await websocket?.close();
    websocket = null;
  }
}
