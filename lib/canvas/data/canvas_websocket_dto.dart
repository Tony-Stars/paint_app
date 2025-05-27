import 'dart:convert';

import 'package:paint_app/canvas/data/canvas_object.dart';
import 'package:paint_app/canvas/data/canvas_object_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'canvas_websocket_dto.g.dart';

enum CanvasWebsocketMethod { connect, draw, clear }

@JsonSerializable()
class CanvasWebsocketDto {
  final int sessionId;
  final CanvasWebsocketMethod method;
  final CanvasWebsocketData data;

  const CanvasWebsocketDto({
    required this.sessionId,
    required this.method,
    required this.data,
  });

  factory CanvasWebsocketDto.fromJson(Map<String, dynamic> json) =>
      _$CanvasWebsocketDtoFromJson(json);

  factory CanvasWebsocketDto.fromString(String json) =>
      CanvasWebsocketDto.fromJson(jsonDecode(json));

  Map<String, dynamic> toJson() => _$CanvasWebsocketDtoToJson(this);
}

@JsonSerializable()
class CanvasWebsocketData {
  final CanvasConnectDto? connect;
  @JsonKey(fromJson: _drawFromJson)
  final CanvasObject? draw;
  final bool? clear;

  const CanvasWebsocketData({this.connect, this.draw, this.clear});

  factory CanvasWebsocketData.fromJson(Map<String, dynamic> json) =>
      _$CanvasWebsocketDataFromJson(json);

  Map<String, dynamic> toJson() => _$CanvasWebsocketDataToJson(this);

  static _drawFromJson(dynamic value) {
    if (value is Map<String, dynamic>) {
      return CanvasObjectDto.fromJson(value).toCanvasObject();
    }

    return null;
  }
}

@JsonSerializable()
class CanvasConnectDto {
  final String username;

  const CanvasConnectDto({required this.username});

  factory CanvasConnectDto.fromJson(Map<String, dynamic> json) =>
      _$CanvasConnectDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CanvasConnectDtoToJson(this);
}
