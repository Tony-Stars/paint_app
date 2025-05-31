import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:paint_app/canvas/data/canvas_object.dart';
import 'package:paint_app/canvas/ui/elements/to_drawing_object.dart';

class CanvasPainter extends CustomPainter {
  final List<CanvasObject> elenents;
  final CanvasObject? current;
  final ui.PictureRecorder recorder = ui.PictureRecorder();

  CanvasPainter(this.elenents, this.current);

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
