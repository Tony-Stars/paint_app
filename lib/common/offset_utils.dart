import 'dart:ui';

import 'package:paint_app/canvas/data/canvas_point.dart';

extension ToOffset on CanvasPoint {
  Offset toOffset() => Offset(x, y);
}
