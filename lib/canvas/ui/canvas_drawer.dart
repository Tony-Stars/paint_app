import 'package:flutter/material.dart';
import 'package:paint_app/canvas/data/canvas_line_style.dart';
import 'package:paint_app/canvas/data/canvas_object.dart';
import 'package:paint_app/canvas/ui/canvas_object_builder.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:paint_app/common/color_extension.dart';

class CanvasDrawer extends StatefulWidget {
  final CanvasObjectBuilder builder;

  const CanvasDrawer({super.key, required this.builder});

  @override
  State<CanvasDrawer> createState() => _CanvasDrawerState();
}

class _CanvasDrawerState extends State<CanvasDrawer> {
  final textController = TextEditingController();

  final selectedFontSize = ValueNotifier<double>(12);
  final selectedFontWeight = ValueNotifier(FontWeight.normal);
  final selectedFontStyle = ValueNotifier(FontStyle.normal);

  void selectFontWeight(FontWeight value) {
    selectedFontWeight.value = value;
    widget.builder.fontWeight = value;
  }

  void selectFontStyle(FontStyle value) {
    selectedFontStyle.value = value;
    widget.builder.fontStyle = value;
  }

  void selectFontSize(double value) {
    selectedFontSize.value = value.roundToDouble();
    widget.builder.fontSize = value.roundToDouble();
  }

  @override
  void dispose() {
    selectedFontSize.dispose();
    selectedFontWeight.dispose();
    selectedFontStyle.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.builder,
      builder: (context, child) {
        return Drawer(
          width: 400,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.black12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ColorPicker(
                    portraitOnly: true,
                    hexInputBar: true,
                    labelTypes: [],
                    pickerColor: widget.builder.color,
                    colorPickerWidth: 250,
                    onColorChanged: (color) {
                      widget.builder.color = color;
                      setState(() {});
                    },
                  ),
                  Text('Толщина линии'),
                  Slider(
                    min: 0,
                    max: 40,
                    value: widget.builder.lineWidth,
                    onChanged: (value) {
                      widget.builder.lineWidth = value;
                      setState(() {});
                    },
                  ),
                  if (widget.builder.type == CanvasObjectType.line)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            widget.builder.lineStyle = CanvasLineStyle.straight;
                          },
                          icon: Icon(
                            Icons.block,
                            color:
                                widget.builder.lineStyle ==
                                        CanvasLineStyle.straight
                                    ? widget.builder.color
                                    : Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            widget.builder.lineStyle = CanvasLineStyle.arrow;
                          },
                          icon: Icon(
                            Icons.arrow_right,
                            color:
                                widget.builder.lineStyle ==
                                        CanvasLineStyle.arrow
                                    ? widget.builder.color
                                    : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  if (widget.builder.type == CanvasObjectType.rect ||
                      widget.builder.type == CanvasObjectType.circle) ...[
                    Text('Стиль фигуры'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            widget.builder.paintingStyle = PaintingStyle.stroke;
                          },
                          child: SizedBox.square(
                            dimension: 40,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: switch (widget.builder.paintingStyle) {
                                    PaintingStyle.stroke =>
                                      widget.builder.color,
                                    PaintingStyle.fill => Colors.grey,
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.builder.paintingStyle = PaintingStyle.fill;
                          },
                          child: SizedBox.square(
                            dimension: 40,
                            child: ColoredBox(
                              color: switch (widget.builder.paintingStyle) {
                                PaintingStyle.stroke => Colors.grey,
                                PaintingStyle.fill => widget.builder.color,
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (widget.builder.type == CanvasObjectType.text) ...[
                    Text('Толщина шрифта'),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SizedBox(
                        height: 30,
                        child: ValueListenableBuilder(
                          valueListenable: selectedFontWeight,
                          builder:
                              (context, value, child) => ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: FontWeight.values.length,
                                itemBuilder:
                                    (context, index) => TextEditorVariantButton(
                                      text:
                                          FontWeight.values[index].value
                                              .toString(),
                                      selected:
                                          value == FontWeight.values[index],
                                      onTap:
                                          () => selectFontWeight(
                                            FontWeight.values[index],
                                          ),
                                    ),
                                separatorBuilder:
                                    (context, index) =>
                                        const SizedBox(width: 4),
                              ),
                        ),
                      ),
                    ),
                    Text('Стиль текста'),
                    ValueListenableBuilder(
                      valueListenable: selectedFontStyle,
                      builder:
                          (context, value, child) => Row(
                            children: [
                              for (final style in FontStyle.values)
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: TextEditorVariantButton(
                                    text: switch (style) {
                                      FontStyle.italic => 'Курсив',
                                      FontStyle.normal => 'Обычный',
                                    },
                                    selected: style == value,
                                    onTap: () => selectFontStyle(style),
                                  ),
                                ),
                            ],
                          ),
                    ),
                    Text('Размер текста'),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ValueListenableBuilder(
                        valueListenable: selectedFontSize,
                        builder:
                            (context, value, child) => SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              child: Slider(
                                min: 5,
                                max: 25,
                                divisions: 25 - 5,
                                label: value.toString(),
                                value: selectedFontSize.value,
                                onChanged: (value) => selectFontSize(value),
                              ),
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TextEditorVariantButton extends StatelessWidget {
  final String text;
  final bool selected;

  final void Function() onTap;

  const TextEditorVariantButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color.fromARGB(
            255,
            13,
            136,
            17,
          ).withOpacity2(selected ? 1 : 0.3),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          child: Text(text, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
