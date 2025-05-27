import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:paint_app/chat/data/chat_message.dart';

part 'chat_websocket_dto.g.dart';

enum ChatWebsocketMethod { connect, message, clear }

@JsonSerializable()
class ChatWebsocketDto {
  final int sessionId;
  final ChatWebsocketMethod method;
  final ChatWebsocketData data;

  const ChatWebsocketDto({
    required this.sessionId,
    required this.method,
    required this.data,
  });

  factory ChatWebsocketDto.fromJson(Map<String, dynamic> json) =>
      _$ChatWebsocketDtoFromJson(json);

  factory ChatWebsocketDto.fromString(String json) =>
      ChatWebsocketDto.fromJson(jsonDecode(json));

  Map<String, dynamic> toJson() => _$ChatWebsocketDtoToJson(this);
}

@JsonSerializable()
class ChatWebsocketData {
  final ChatConnectDto? connect;
  final ChatMessage? message;
  final bool? clear;

  const ChatWebsocketData({this.connect, this.message, this.clear});

  factory ChatWebsocketData.fromJson(Map<String, dynamic> json) =>
      _$ChatWebsocketDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChatWebsocketDataToJson(this);
}

@JsonSerializable()
class ChatConnectDto {
  final String username;

  const ChatConnectDto({required this.username});

  factory ChatConnectDto.fromJson(Map<String, dynamic> json) =>
      _$ChatConnectDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatConnectDtoToJson(this);
}
