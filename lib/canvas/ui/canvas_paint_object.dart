import 'dart:math' as math;
import 'dart:ui' hide TextStyle;

import 'package:flutter/material.dart';
import 'package:paint_app/canvas/data/canvas_line_style.dart';

sealed class CanvasPaintObject {
  const CanvasPaintObject();

  void paint(Canvas canvas, Size size);
}

class CanvasPaintObject$Circle extends CanvasPaintObject {
  final Offset center;
  final double radius;
  final Color color;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  const CanvasPaintObject$Circle({
    required this.center,
    required this.radius,
    required this.color,
    required this.paintingStyle,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = paintingStyle
          ..strokeWidth = strokeWidth
          ..isAntiAlias = true
          ..color = color;
    canvas.drawCircle(center, radius, paint);
  }
}

class CanvasPaintObject$Rect extends CanvasPaintObject {
  final Rect rect;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  final Color color;

  const CanvasPaintObject$Rect({
    required this.rect,
    required this.paintingStyle,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = paintingStyle
          ..strokeWidth = strokeWidth;
    canvas.drawRect(rect, paint);
  }
}

class CanvasPaintObject$Text extends CanvasPaintObject {
  final FontWeight fontWeight;
  final double fontSize;
  final FontStyle fontStyle;
  final String text;
  final Color color;
  final Offset offset;

  const CanvasPaintObject$Text({
    required this.fontWeight,
    required this.fontSize,
    required this.fontStyle,
    required this.text,
    required this.offset,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
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

    final builder =
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
    final paragraph = builder.build();
    paragraph.layout(ParagraphConstraints(width: size.width));
    canvas.drawParagraph(paragraph, offset);
  }

  CanvasPaintObject$Text copyWith({required Offset offset}) {
    return CanvasPaintObject$Text(
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontStyle: fontStyle,
      text: text,
      offset: offset,
      color: color,
    );
  }
}

class CanvasPaintObject$Brush extends CanvasPaintObject {
  final List<Offset> poins;
  final double width;
  final Color color;

  const CanvasPaintObject$Brush({
    required this.poins,
    required this.width,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (poins.isEmpty) {
      return;
    }

    final paint =
        Paint()
          ..color = color
          ..isAntiAlias = true
          ..strokeWidth = width
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(poins.first.dx, poins.first.dy);
    for (final point in poins) {
      path.lineTo(point.dx, point.dy);
    }

    canvas.drawPath(path, paint);
  }
}

class CanvasPaintObject$Line extends CanvasPaintObject {
  final CanvasLineStyle style;
  final Offset from;
  final Offset to;
  final double width;
  final Color color;

  const CanvasPaintObject$Line({
    required this.style,
    required this.from,
    required this.to,
    required this.width,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round;

    final line = Path();
    line.moveTo(from.dx, from.dy);
    line.lineTo(to.dx, to.dy);
    canvas.drawPath(line, paint);

    if (style == CanvasLineStyle.arrow) {
      final angle = math.atan2(to.dy - from.dy, to.dx - from.dx);
      final arrowSize = 4 * width;
      final arrowAngle = math.pi / 6;

      final pointer = Path();
      pointer.moveTo(to.dx, to.dy);
      pointer.lineTo(
        to.dx - arrowSize * math.cos(angle - arrowAngle),
        to.dy - arrowSize * math.sin(angle - arrowAngle),
      );
      pointer.moveTo(to.dx, to.dy);
      pointer.lineTo(
        to.dx - arrowSize * math.cos(angle + arrowAngle),
        to.dy - arrowSize * math.sin(angle + arrowAngle),
      );
      canvas.drawPath(pointer, paint);
    }
  }
}
