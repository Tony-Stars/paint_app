import 'package:flutter/material.dart';
import 'package:flutter_app/paint_app.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(PaintApp());
}
