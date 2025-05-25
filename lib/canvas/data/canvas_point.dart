import 'package:json_annotation/json_annotation.dart';

part 'canvas_point.g.dart';

@JsonSerializable()
class CanvasPoint {
  final double x;
  final double y;

  const CanvasPoint({required this.x, required this.y});

  factory CanvasPoint.fromJson(Map<String, dynamic> json) =>
      _$CanvasPointFromJson(json);

  Map<String, dynamic> toJson() => _$CanvasPointToJson(this);
}
