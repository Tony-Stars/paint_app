import 'dart:ui';

import 'package:paint_app/canvas/data/canvas_object.dart';
import 'package:paint_app/common/consts.dart';
import 'package:paint_app/canvas/ui/canvas_paint_object.dart';
import 'package:paint_app/canvas/ui/canvas_point_utils.dart';

extension CanvasObjectConvert on CanvasObject {
  CanvasPaintObject toPaintObject() {
    return switch (this) {
      CanvasObject$Brush object => CanvasPaintObject$Brush(
        poins: object.points.map((point) => point.toOffset()).toList(),
        width: object.width,
        color: Color(object.color),
      ),
      CanvasObject$Line object => CanvasPaintObject$Line(
        style: object.style,
        from: object.from.toOffset(),
        to: object.to.toOffset(),
        width: object.width,
        color: Color(object.color),
      ),
      CanvasObject$Rect object => CanvasPaintObject$Rect(
        rect: Rect.fromCenter(
          center: object.center.toOffset(),
          width: object.width,
          height: object.height,
        ),
        strokeWidth: object.strokeWidth ?? defaultStrokeWidth,
        paintingStyle: switch (object.paintingStyle) {
          CanvasPaintingStyle.fill => PaintingStyle.fill,
          CanvasPaintingStyle.stroke => PaintingStyle.stroke,
        },
        color: Color(object.color),
      ),
      CanvasObject$Circle object => CanvasPaintObject$Circle(
        center: object.center.toOffset(),
        radius: object.radius,
        strokeWidth: object.strokeWidth ?? defaultStrokeWidth,
        paintingStyle: switch (object.paintingStyle) {
          CanvasPaintingStyle.fill => PaintingStyle.fill,
          CanvasPaintingStyle.stroke => PaintingStyle.stroke,
        },
        color: Color(object.color),
      ),
      CanvasObject$Text object => CanvasPaintObject$Text(
        text: object.text,
        offset: object.offset.toOffset(),
        color: Color(object.color),
        fontSize: object.fontSize,
        fontStyle: switch (object.fontStyle) {
          CanvasTextFontStyle.italic => FontStyle.italic,
          CanvasTextFontStyle.normal => FontStyle.normal,
        },
        fontWeight: switch (object.fontWeight) {
          int i when i == 100 => FontWeight.w100,
          int i when i == 200 => FontWeight.w200,
          int i when i == 300 => FontWeight.w300,
          int i when i == 400 => FontWeight.w400,
          int i when i == 500 => FontWeight.w500,
          int i when i == 600 => FontWeight.w600,
          int i when i == 700 => FontWeight.w700,
          int i when i == 800 => FontWeight.w800,
          int i when i == 900 => FontWeight.w900,
          _ => throw UnimplementedError(),
        },
      ),
    };
  }
}
