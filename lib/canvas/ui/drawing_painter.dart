import 'package:flutter/material.dart';
import 'package:flutter_app/canvas/data/canvas_object.dart';
import 'package:flutter_app/elements/to_drawing_object.dart';

class DrawingPainter extends CustomPainter {
  final List<CanvasObject> elenents;
  final CanvasObject? current;

  DrawingPainter(this.elenents, this.current);

  @override
  void paint(Canvas canvas, Size size) {
    for (final element in elenents) {
      element.toDrawingObject().draw(canvas, size);
    }

    current?.toDrawingObject().draw(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
