import 'dart:ui' hide TextStyle;

import 'package:flutter/material.dart';
import 'package:paint_app/canvas/data/canvas_point.dart';
import 'package:paint_app/canvas/data/canvas_object.dart';

sealed class DrawingObject {
  const DrawingObject();

  void draw(Canvas canvas, Size size);

  CanvasObject toCanvasObject();
}

sealed class DrawingShape extends DrawingObject {
  final Offset end;
  final Color color;

  const DrawingShape({required this.end, required this.color});
}

class DrawingCircle extends DrawingObject {
  final Offset center;
  final double radius;
  final Color color;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  DrawingCircle({
    required this.center,
    required this.radius,
    required this.color,
    required this.paintingStyle,
    required this.strokeWidth,
  });

  @override
  void draw(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = paintingStyle
          ..strokeWidth = strokeWidth
          ..color = color;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  CanvasObject toCanvasObject() {
    return CanvasObject$Circle(
      center: CanvasPoint(x: center.dx, y: center.dy),
      radius: radius,
      color: color.toARGB32(),
      paintingStyle: switch (paintingStyle) {
        PaintingStyle.fill => CanvasPaintingStyle.fill,
        PaintingStyle.stroke => CanvasPaintingStyle.stroke,
      },
      strokeWidth: strokeWidth,
    );
  }
}

class DrawingRect extends DrawingObject {
  final Rect rect;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  final Color color;

  DrawingRect({
    required this.rect,
    required this.paintingStyle,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void draw(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = paintingStyle
          ..strokeWidth = strokeWidth
          ..isAntiAlias = true;
    canvas.drawRect(rect, paint);
  }

  @override
  CanvasObject toCanvasObject() {
    return CanvasObject$Rect(
      center: CanvasPoint(x: rect.center.dx, y: rect.center.dy),
      width: rect.width,
      height: rect.height,
      color: color.toARGB32(),
      paintingStyle: switch (paintingStyle) {
        PaintingStyle.fill => CanvasPaintingStyle.fill,
        PaintingStyle.stroke => CanvasPaintingStyle.stroke,
      },
      strokeWidth: strokeWidth,
    );
  }
}

class DrawingText extends DrawingObject {
  final FontWeight fontWeight;
  final double fontSize;
  final FontStyle fontStyle;
  final String text;
  final Color color;
  final Offset offset;

  const DrawingText({
    required this.fontWeight,
    required this.fontSize,
    required this.fontStyle,
    required this.text,
    required this.offset,
    required this.color,
  });

  @override
  void draw(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..isAntiAlias = true;
    final style = TextStyle(
      color: paint.color,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontStyle: fontStyle,
    );

    final paragraphBuilder =
        ParagraphBuilder(
            ParagraphStyle(
              fontSize: style.fontSize,
              fontFamily: style.fontFamily,
              fontStyle: style.fontStyle,
              fontWeight: style.fontWeight,
              textAlign: TextAlign.justify,
            ),
          )
          ..pushStyle(style.getTextStyle())
          ..addText(text);
    final paragraph =
        paragraphBuilder.build()
          ..layout(ParagraphConstraints(width: size.width));
    canvas.drawParagraph(
      paragraph,
      offset ?? Offset(size.width / 2, size.height / 2),
    );
  }

  DrawingText copyWith({required Offset offset}) {
    return DrawingText(
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontStyle: fontStyle,
      text: text,
      offset: offset,
      color: color,
    );
  }

  @override
  CanvasObject toCanvasObject() {
    return CanvasObject$Text(
      text: text,
      color: color.toARGB32(),
      fontSize: fontSize,
      fontStyle: switch (fontStyle) {
        FontStyle.italic => CanvasTextFontStyle.italic,
        FontStyle.normal => CanvasTextFontStyle.normal,
      },
      fontWeight: fontWeight.value,
      offset: CanvasPoint(x: offset.dx, y: offset.dy),
    );
  }
}

class DrawingLine extends DrawingObject {
  final List<DrawingPoint> poins;
  final double width;
  final Color color;

  DrawingLine({required this.poins, required this.width, required this.color});

  List<Offset> offsetsList = [];

  factory DrawingLine.fromCanvasObject(CanvasObject$Line line) {
    return DrawingLine(
      poins:
          line.points
              .map((point) => DrawingPoint(Offset(point.x, point.y)))
              .toList(),
      width: line.width,
      color: Color(line.color),
    );
  }

  @override
  void draw(Canvas canvas, Size size) {
    // canvas.drawPath(path, paint);
    final paint =
        Paint()
          ..color = color
          ..isAntiAlias = true
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round;
    for (int i = 0; i < poins.length - 1; i++) {
      if (i != poins.length - 2) {
        canvas.drawLine(poins[i].offset, poins[i + 1].offset, paint);
      } else {
        offsetsList.clear();
        offsetsList.add(poins[i].offset);

        canvas.drawPoints(PointMode.points, offsetsList, paint);
      }
    }
  }

  @override
  CanvasObject toCanvasObject() {
    return CanvasObject$Line(
      points:
          poins
              .map(
                (point) => CanvasPoint(x: point.offset.dx, y: point.offset.dy),
              )
              .toList(),
      color: color.toARGB32(),
      width: width,
    );
  }
}

class DrawingPoint {
  final Offset offset;

  const DrawingPoint(this.offset);
}

enum DrawingShapeType { rectangle, circle }
