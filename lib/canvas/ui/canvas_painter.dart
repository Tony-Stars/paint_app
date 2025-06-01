import 'package:flutter/material.dart';
import 'package:paint_app/canvas/data/canvas_object.dart';
import 'package:paint_app/canvas/ui/canvas_object_convert.dart';

class CanvasPainter extends CustomPainter {
  final List<CanvasObject> objects;
  final CanvasObject? current;

  CanvasPainter(this.objects, this.current);

  @override
  void paint(Canvas canvas, Size size) {
    for (final object in objects) {
      object.toPaintObject().paint(canvas, size);
    }

    current?.toPaintObject().paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
