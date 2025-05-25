import 'package:flutter/material.dart';
import 'package:flutter_app/canvas/ui/canvas_object_builder.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CanvasSidebar extends StatefulWidget {
  final CanvasObjectBuilder builder;

  const CanvasSidebar({super.key, required this.builder});

  @override
  State<CanvasSidebar> createState() => _CanvasSidebarState();
}

class _CanvasSidebarState extends State<CanvasSidebar> {
  var visible = true;
  // Color selectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.builder,
      builder: (context, child) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Colors.black12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Switch(
                  value: visible,
                  onChanged: (v) {
                    visible = v;
                    setState(() {});
                  },
                ),
                if (visible)
                  Column(
                    children: [
                      ColorPicker(
                        hexInputBar: true,
                        labelTypes: [],
                        pickerColor: widget.builder.color ?? Colors.black,
                        colorPickerWidth: 150,
                        onColorChanged: (color) {
                          widget.builder.color = color;
                          setState(() {});
                        },
                      ),
                      Text('data'),
                      Text('data'),
                      Text('data'),
                      Text('data'),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
