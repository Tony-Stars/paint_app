import 'dart:ui';

extension Opacity on Color {
  Color withOpacity2(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((255.0 * opacity).round());
  }
}
