import 'dart:convert';

import 'package:paint_app/canvas/data/canvas_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'canvas_object_dto.g.dart';

@JsonSerializable()
class CanvasObjectDto {
  final CanvasObjectType type;
  final CanvasObject$Brush? brush;
  final CanvasObject$Line? line;
  final CanvasObject$Rect? rect;
  final CanvasObject$Circle? circle;
  final CanvasObject$Text? text;

  const CanvasObjectDto({
    required this.type,
    required this.brush,
    required this.line,
    required this.rect,
    required this.circle,
    required this.text,
  });

  factory CanvasObjectDto.fromString(String data) =>
      CanvasObjectDto.fromJson(jsonDecode(data));

  factory CanvasObjectDto.fromJson(Map<String, dynamic> json) =>
      _$CanvasObjectDtoFromJson(json);

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => _$CanvasObjectDtoToJson(this);

  CanvasObject toCanvasObject() => switch (type) {
    CanvasObjectType.brush => brush!,
    CanvasObjectType.line => line!,
    CanvasObjectType.rect => rect!,
    CanvasObjectType.circle => circle!,
    CanvasObjectType.text => text!,
  };
}
