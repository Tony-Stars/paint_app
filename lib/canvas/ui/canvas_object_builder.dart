import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_app/canvas/data/canvas_object.dart';
import 'package:flutter_app/canvas/data/canvas_point.dart';

class CanvasObjectBuilder extends ChangeNotifier {
  CanvasObjectType _type;

  Color? _color;
  //
  Offset? initPoint;
  Offset? currentPoint;
  //
  double? lineWidth;
  //
  String? text;
  FontWeight? fontWeight;
  double? fontSize;
  FontStyle? fontStyle;

  List<CanvasPoint> _linePonits = [];

  CanvasObjectBuilder({required CanvasObjectType type}) : _type = type;

  set type(CanvasObjectType value) {
    _type = value;
    notifyListeners();
  }

  set color(Color? value) {
    _color = value;
    notifyListeners();
  }

  CanvasObjectType get type => _type;
  Color? get color => _color;

  CanvasObject? build() {
    return switch (type) {
      CanvasObjectType.line
          when currentPoint != null && color != null && lineWidth != null =>
        _buildLine(color: color!, width: lineWidth!, point: currentPoint!),
      CanvasObjectType.rect
          when initPoint != null && color != null && currentPoint != null =>
        _buildRect(
          color: color!,
          initPoint: initPoint!,
          currentPoint: currentPoint!,
        ),
      CanvasObjectType.circle
          when initPoint != null && color != null && currentPoint != null =>
        CanvasObject$Circle(
          color: color!.toARGB32(),
          center: _toCanvasPoint(initPoint!),
          radius: (initPoint! - currentPoint!).distance,
        ),
      CanvasObjectType.text
          when color != null &&
              text != null &&
              fontWeight != null &&
              fontSize != null &&
              fontStyle != null &&
              currentPoint != null =>
        _buildText(
          color: color!,
          text: text!,
          fontSize: fontSize!,
          fontStyle: fontStyle!,
          fontWeight: fontWeight!,
          offset: currentPoint!,
        ),
      _ => null,
    };
  }

  CanvasPoint _toCanvasPoint(Offset offset) =>
      CanvasPoint(x: offset.dx, y: offset.dy);

  void addPoint(Offset point) {
    _linePonits = List.of(_linePonits)..add(_toCanvasPoint(point));
  }

  void clearPoints() {
    _linePonits = [];
  }

  CanvasObject$Line _buildLine({
    required Offset point,
    required Color color,
    required double width,
  }) {
    addPoint(currentPoint!);
    final points = List.of(_linePonits)..add(_toCanvasPoint(point));
    return CanvasObject$Line(
      points: points,
      color: color.toARGB32(),
      width: width,
    );
  }

  CanvasObject$Rect _buildRect({
    required Color color,
    required Offset initPoint,
    required Offset currentPoint,
  }) {
    final rect = Rect.fromPoints(initPoint, currentPoint);
    return CanvasObject$Rect(
      color: color.toARGB32(),
      center: _toCanvasPoint(rect.center),
      width: rect.width,
      height: rect.height,
    );
  }

  CanvasObject$Text _buildText({
    required Color color,
    required String text,
    required FontWeight fontWeight,
    required double fontSize,
    required FontStyle fontStyle,
    required Offset offset,
  }) {
    return CanvasObject$Text(
      color: color.toARGB32(),
      text: text,
      fontWeight: fontWeight.value,
      fontSize: fontSize,
      fontStyle: switch (fontStyle) {
        FontStyle.italic => CanvasTextFontStyle.italic,
        FontStyle.normal => CanvasTextFontStyle.normal,
      },
      offset: _toCanvasPoint(offset),
    );
  }

  void clear() {
    color = null;
    initPoint = null;
    currentPoint = null;
    _linePonits = [];
    lineWidth = null;
    text = null;
    fontWeight = null;
    fontSize = null;
    fontStyle = null;
    // textOffset = null;
  }
}
