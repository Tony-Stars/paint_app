import 'package:flutter/material.dart';
import 'package:flutter_app/color_extension.dart';

class TextEditor extends StatefulWidget {
  final Color color;
  final TextEditingController controller;

  final void Function(FontWeight weight, double size, FontStyle style) onAdd;
  final void Function() onConfirm;

  const TextEditor({
    super.key,
    required this.controller,
    required this.color,
    required this.onAdd,
    required this.onConfirm,
  });

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  final selectedFontSize = ValueNotifier<double>(12);
  final selectedFontWeight = ValueNotifier(FontWeight.normal);
  final selectedFontStyle = ValueNotifier(FontStyle.normal);

  void selectFontWeight(FontWeight value) {
    selectedFontWeight.value = value;
  }

  void selectFontStyle(FontStyle value) {
    selectedFontStyle.value = value;
  }

  void selectFontSize(double value) {
    selectedFontSize.value = value.roundToDouble();
  }

  @override
  void dispose() {
    selectedFontSize.dispose();
    selectedFontWeight.dispose();
    selectedFontStyle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              TextField(
                controller: widget.controller,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
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
                                text: FontWeight.values[index].value.toString(),
                                selected: value == FontWeight.values[index],
                                onTap:
                                    () => selectFontWeight(
                                      FontWeight.values[index],
                                    ),
                              ),
                          separatorBuilder:
                              (context, index) => const SizedBox(width: 4),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListenableBuilder(
                  listenable: Listenable.merge([
                    selectedFontSize,
                    selectedFontWeight,
                    selectedFontStyle,
                    widget.controller,
                  ]),
                  builder:
                      (context, child) => DecoratedBox(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: Text(
                            widget.controller.text.isEmpty
                                ? 'Пример текста'
                                : widget.controller.text,
                            style: TextStyle(
                              fontSize: selectedFontSize.value,
                              fontWeight: selectedFontWeight.value,
                              fontStyle: selectedFontStyle.value,
                              color: widget.color,
                            ),
                          ),
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
                            selectedFontWeight.value,
                            selectedFontSize.value,
                            selectedFontStyle.value,
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
