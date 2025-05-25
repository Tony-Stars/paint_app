import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketWrapper {
  WebSocketChannel _channel;

  Stream<dynamic> get stream => _channel.stream;

  WebSocketSink get sink => _channel.sink;

  WebsocketWrapper({required WebSocketChannel channel}) : _channel = channel;

  factory WebsocketWrapper.connect({required Uri uri}) {
    final channel = WebSocketChannel.connect(uri);
    return WebsocketWrapper(channel: channel);
  }

  void send(Map<String, dynamic> data) {
    sink.add(jsonEncode(data));
  }

  Future<dynamic> close([int? closeCode, String? closeReason]) =>
      _channel.sink.close(closeCode, closeReason);
}
