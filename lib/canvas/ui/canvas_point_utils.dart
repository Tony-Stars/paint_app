import 'dart:ui';

import 'package:paint_app/canvas/data/canvas_point.dart';

extension CanvasPointUtils on CanvasPoint {
  Offset toOffset() => Offset(x, y);
}

extension OffsetUtils on Offset {
  CanvasPoint toCanvasPoint() => CanvasPoint(x: dx, y: dy);
}
