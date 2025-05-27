import 'package:paint_app/canvas/data/canvas_point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'canvas_object.g.dart';

enum CanvasObjectType { line, rect, circle, text }

sealed class CanvasObject {
  const CanvasObject();

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class CanvasObject$Line extends CanvasObject {
  final int color;
  final double width;
  final List<CanvasPoint> points;

  const CanvasObject$Line({
    required this.points,
    required this.color,
    required this.width,
  });

  factory CanvasObject$Line.fromJson(Map<String, dynamic> json) =>
      _$CanvasObject$LineFromJson(json);

  @override
  Map<String, dynamic> toJson() => {
    'type': CanvasObjectType.line.name,
    CanvasObjectType.line.name: _$CanvasObject$LineToJson(this),
  };
}

enum CanvasPaintingStyle { fill, stroke }

@JsonSerializable()
class CanvasObject$Rect extends CanvasObject {
  final int color;
  final CanvasPoint center;
  final double width;
  final double height;
  final CanvasPaintingStyle paintingStyle;
  final double? strokeWidth;

  const CanvasObject$Rect({
    required this.color,
    required this.center,
    required this.width,
    required this.height,
    required this.paintingStyle,
    required this.strokeWidth,
  });

  factory CanvasObject$Rect.fromJson(Map<String, dynamic> json) =>
      _$CanvasObject$RectFromJson(json);

  @override
  Map<String, dynamic> toJson() => {
    'type': CanvasObjectType.rect.name,
    CanvasObjectType.rect.name: _$CanvasObject$RectToJson(this),
  };
}

@JsonSerializable()
class CanvasObject$Circle extends CanvasObject {
  final int color;
  final CanvasPoint center;
  final double radius;
  final CanvasPaintingStyle paintingStyle;
  final double? strokeWidth;

  const CanvasObject$Circle({
    required this.color,
    required this.center,
    required this.radius,
    required this.paintingStyle,
    required this.strokeWidth,
  });

  factory CanvasObject$Circle.fromJson(Map<String, dynamic> json) =>
      _$CanvasObject$CircleFromJson(json);

  @override
  Map<String, dynamic> toJson() => {
    'type': CanvasObjectType.circle.name,
    CanvasObjectType.circle.name: _$CanvasObject$CircleToJson(this),
  };
}

enum CanvasTextFontStyle { normal, italic }

@JsonSerializable()
class CanvasObject$Text extends CanvasObject {
  final int color;
  final String text;
  final int fontWeight;
  final double fontSize;
  final CanvasTextFontStyle fontStyle;
  final CanvasPoint offset;

  const CanvasObject$Text({
    required this.color,
    required this.text,
    required this.fontWeight,
    required this.fontSize,
    required this.fontStyle,
    required this.offset,
  });

  factory CanvasObject$Text.fromJson(Map<String, dynamic> json) =>
      _$CanvasObject$TextFromJson(json);

  @override
  Map<String, dynamic> toJson() => {
    'type': CanvasObjectType.text.name,
    CanvasObjectType.text.name: _$CanvasObject$TextToJson(this),
  };
}
