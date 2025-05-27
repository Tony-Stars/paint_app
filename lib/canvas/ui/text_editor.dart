import 'package:flutter/material.dart';
import 'package:paint_app/canvas/ui/canvas_object_builder.dart';

class TextEditor extends StatefulWidget {
  final TextEditingController controller;
  final CanvasObjectBuilder builder;

  final void Function(FontWeight weight, double size, FontStyle style) onAdd;
  final void Function() onConfirm;

  const TextEditor({
    super.key,
    required this.builder,
    required this.controller,
    required this.onAdd,
    required this.onConfirm,
  });

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.builder,
      builder: (context, child) {
        return SizedBox(
          width: 300,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.grey,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: widget.controller,
                      minLines: 1,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: widget.builder.fontSize,
                        fontWeight: widget.builder.fontWeight,
                        fontStyle: widget.builder.fontStyle,
                        color: widget.builder.color,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              () => widget.onAdd(
                                widget.builder.fontWeight,
                                widget.builder.fontSize,
                                widget.builder.fontStyle,
                              ),
                          child: const Text('Добавить'),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onConfirm,
                          child: Icon(Icons.check),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
