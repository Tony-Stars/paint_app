// import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_app/canvas/data/canvas_point.dart';

extension ToOffset on CanvasPoint {
  Offset toOffset() => Offset(x, y);
}
