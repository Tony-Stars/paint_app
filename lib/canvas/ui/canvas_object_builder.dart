import 'package:flutter/material.dart';
import 'package:paint_app/canvas/data/canvas_object.dart';
import 'package:paint_app/canvas/data/canvas_point.dart';
import 'package:paint_app/common/consts.dart';

class CanvasObjectBuilder extends ChangeNotifier {
  CanvasObjectType _type = CanvasObjectType.line;
  Color _color = Colors.black;
  PaintingStyle _paintingStyle = PaintingStyle.fill;
  double _lineWidth = defaultStrokeWidth;

  FontWeight _fontWeight;
  double _fontSize = defaultFontSize;
  FontStyle _fontStyle;

  //

  String? text;

  Offset? initPoint;
  Offset? currentPoint;

  List<CanvasPoint> _linePonits = [];

  CanvasObjectBuilder({
    CanvasObjectType type = CanvasObjectType.line,
    PaintingStyle paintingStyle = PaintingStyle.fill,
    double lineWidth = defaultStrokeWidth,
    double fontSize = defaultFontSize,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    Color color = Colors.black,
  }) : _type = type,
       _lineWidth = lineWidth,
       _paintingStyle = paintingStyle,
       _fontSize = fontSize,
       _fontWeight = fontWeight,
       _fontStyle = fontStyle,
       _color = color;

  set type(CanvasObjectType value) {
    _type = value;
    notifyListeners();
  }

  set color(Color value) {
    _color = value;
    notifyListeners();
  }

  set lineWidth(double value) {
    _lineWidth = value;
    notifyListeners();
  }

  set paintingStyle(PaintingStyle value) {
    _paintingStyle = value;
    notifyListeners();
  }

  set fontWeight(FontWeight value) {
    _fontWeight = value;
    notifyListeners();
  }

  set fontSize(double value) {
    _fontSize = value;
    notifyListeners();
  }

  set fontStyle(FontStyle value) {
    _fontStyle = value;
    notifyListeners();
  }

  CanvasObjectType get type => _type;
  Color get color => _color;
  double get lineWidth => _lineWidth;
  PaintingStyle get paintingStyle => _paintingStyle;
  FontWeight get fontWeight => _fontWeight;
  double get fontSize => _fontSize;
  FontStyle get fontStyle => _fontStyle;

  CanvasObject? build() {
    return switch (type) {
      CanvasObjectType.line when currentPoint != null => _buildLine(
        color: color,
        width: lineWidth,
        point: currentPoint!,
      ),
      CanvasObjectType.rect when initPoint != null && currentPoint != null =>
        _buildRect(
          color: color,
          initPoint: initPoint!,
          currentPoint: currentPoint!,
          paintingStyle: _paintingStyle,
          strokeWidth: _lineWidth,
        ),
      CanvasObjectType.circle when initPoint != null && currentPoint != null =>
        CanvasObject$Circle(
          color: color.toARGB32(),
          center: _toCanvasPoint(initPoint!),
          radius: (initPoint! - currentPoint!).distance,
          paintingStyle: _toCanvasPaintingStyle(_paintingStyle),
          strokeWidth: _lineWidth,
        ),
      CanvasObjectType.text when text != null && currentPoint != null =>
        _buildText(
          color: color,
          text: text!,
          fontSize: fontSize,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
          offset: currentPoint!,
        ),
      _ => null,
    };
  }

  CanvasPoint _toCanvasPoint(Offset offset) =>
      CanvasPoint(x: offset.dx, y: offset.dy);

  CanvasPaintingStyle _toCanvasPaintingStyle(PaintingStyle style) =>
      switch (style) {
        PaintingStyle.fill => CanvasPaintingStyle.fill,
        PaintingStyle.stroke => CanvasPaintingStyle.stroke,
      };

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
    required PaintingStyle paintingStyle,
    required double strokeWidth,
  }) {
    final rect = Rect.fromPoints(initPoint, currentPoint);
    return CanvasObject$Rect(
      color: color.toARGB32(),
      center: _toCanvasPoint(rect.center),
      width: rect.width,
      height: rect.height,
      paintingStyle: _toCanvasPaintingStyle(paintingStyle),
      strokeWidth: strokeWidth,
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
    color = Colors.black;
    initPoint = null;
    currentPoint = null;
    _linePonits = [];
    lineWidth = defaultStrokeWidth;
    text = null;
    fontWeight = FontWeight.normal;
    fontSize = defaultFontSize;
    fontStyle = FontStyle.normal;
    _paintingStyle = PaintingStyle.fill;
  }
}
