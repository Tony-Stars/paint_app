import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app/canvas/data/canvas_object.dart';
import 'package:flutter_app/canvas/data/canvas_repository.dart';
import 'package:flutter_app/canvas/ui/canvas_object_builder.dart';
import 'package:flutter_app/canvas/ui/canvas_sidebar.dart';
import 'package:flutter_app/canvas/ui/drawing_painter.dart';
import 'package:flutter_app/elements/drawing_object.dart';
import 'package:flutter_app/elements/to_drawing_object.dart';
import 'package:flutter_app/text_editor.dart';
import 'package:flutter_app/canvas/bloc/canvas_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final textController = TextEditingController();

  Color selectedColor = Colors.black;
  DrawingShapeType? selectedBoxSpape;
  double strokeWidth = 5;

  var selectedTool = CanvasObjectType.line;

  // List<List<DrawingObject>> states = [[]];
  // var currentStateIndex = 0;
  CanvasObject? drawingElenent;
  // Offset? initPoint; //  delete
  // Offset? currentPoint; //  delete
  final builder =
      CanvasObjectBuilder(type: CanvasObjectType.line)
        ..color = Colors.black
        ..lineWidth = 5;

  final shapes = DrawingShapeType.values;

  void drawText(
    FontWeight weight,
    double size,
    FontStyle style,
    Offset? offset,
  ) {
    if (textController.text.isNotEmpty) {
      final o = offset ?? Offset.zero;
      builder.fontWeight = weight;
      builder.fontSize = size;
      builder.fontStyle = style;
      builder.currentPoint = o;
      builder.text = textController.text;
      drawingElenent = builder.build();
      setState(() {});
    }
  }

  void stopDraw(BuildContext context, Offset localPosition) {
    if (selectedTool == CanvasObjectType.rect ||
        selectedTool == CanvasObjectType.circle ||
        selectedTool == CanvasObjectType.line) {
      if (drawingElenent != null) {
        addElement(context, drawingElenent!);
      }
    }
    setState(() {});
  }

  void stopDrawText(BuildContext context) {
    if (selectedTool == CanvasObjectType.text) {
      if (drawingElenent != null) {
        addElement(context, drawingElenent!);
        drawingElenent = null;
        builder.initPoint = null;
        builder.currentPoint = null;

        textController.clear();
        selectedTool = CanvasObjectType.line;

        builder.type = CanvasObjectType.line;
        setState(() {});
      }
    }
  }

  void addElement(BuildContext context, CanvasObject object) {
    drawingElenent = null;
    context.read<CanvasCubit>().draw(object);
    setState(() {});
    // states = states.take(currentStateIndex + 1).toList();
    // currentStateIndex++;
    // setState(() {});
  }

  void clear(BuildContext context) {
    context.read<CanvasCubit>().clear();
    // currentStateIndex++;
    // setState(() {});
  }

  // bool get canBack => currentStateIndex > 0;
  // bool get canForward => currentStateIndex < states.length - 1;

  // void back() {
  //   if (canBack) {
  //     currentStateIndex--;
  //     setState(() {});
  //   }
  // }

  // void forward() {
  //   if (canForward) {
  //     currentStateIndex++;
  //     setState(() {});
  //   }
  // }

  void onPanStart(DragStartDetails details) {
    builder.initPoint = details.localPosition;
    builder.currentPoint = details.localPosition;
    drawingElenent = builder.build();
    setState(() {});
  }

  void onPanUpdate(DragUpdateDetails details) {
    builder.currentPoint = details.localPosition;
    drawingElenent = builder.build();
    setState(() {});
  }

  void onPanEnd(BuildContext context, DragEndDetails details) {
    stopDraw(context, details.localPosition);
    builder.initPoint = null;
    builder.currentPoint = null;
    builder.clearPoints();
    setState(() {});
  }

  @override
  void dispose() {
    textController.clear();
    builder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionId = DateTime.now().millisecondsSinceEpoch;
    final repository = CanvasRepository(
      sessionId: sessionId,
      uri: Uri.parse('ws://localhost:5000/'),
    );
    return BlocProvider(
      create: (context) => CanvasCubit(repository: repository)..init(),
      child: BlocBuilder<CanvasCubit, WebsocketState>(
        builder: (context, state) {
          return switch (state) {
            WebsocketState$Initial _ => Scaffold(backgroundColor: Colors.white),
            WebsocketState$Error _ => const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: Text('Произошла ошибка')),
            ),
            WebsocketState$Connected connected => Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  GestureDetector(
                    onPanStart: onPanStart,
                    onPanUpdate: onPanUpdate,
                    onPanEnd: (details) => onPanEnd(context, details),
                    child: CustomPaint(
                      painter: DrawingPainter(
                        connected.canvasObjects,
                        drawingElenent,
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: CanvasSidebar(builder: builder),
                  ),
                  Positioned(
                    top: 40,
                    right: 30,
                    child: Row(
                      children: [
                        Slider(
                          min: 0,
                          max: 40,
                          value: strokeWidth,
                          onChanged: (val) {
                            strokeWidth = val;
                            builder.lineWidth = val;
                            setState(() {});
                          },
                        ),
                        ElevatedButton.icon(
                          onPressed: () => clear(context),
                          icon: Icon(Icons.clear),
                          label: const Text("Очистить доску"),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 100,
                    right: 30,
                    child: ColorPicker(
                      hexInputBar: true,
                      labelTypes: [],
                      pickerColor: selectedColor,
                      onColorChanged: (color) {
                        selectedColor = color;
                        builder.color = color;
                        setState(() {});
                      },
                    ),
                  ),
                  if (selectedTool == CanvasObjectType.text)
                    Positioned(
                      bottom: 100,
                      right: 30,
                      child: TextEditor(
                        controller: textController,
                        color: selectedColor,
                        onAdd:
                            (weight, size, style) =>
                                drawText(weight, size, style, null),
                        onConfirm: () => stopDrawText(context),
                      ),
                    ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.grey[200],
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                selectedBoxSpape = null;
                                selectedTool = CanvasObjectType.line;
                                builder.type = CanvasObjectType.line;
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.edit,
                                color:
                                    selectedTool == CanvasObjectType.line
                                        ? selectedColor
                                        : Colors.grey,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (selectedTool == CanvasObjectType.text) {
                                  selectedTool = CanvasObjectType.line;
                                  builder.type = CanvasObjectType.line;
                                } else {
                                  selectedTool = CanvasObjectType.text;
                                  builder.type = CanvasObjectType.text;
                                }

                                setState(() {});
                              },
                              icon: Icon(
                                Icons.abc,
                                color:
                                    selectedTool == CanvasObjectType.text
                                        ? selectedColor
                                        : Colors.grey,
                              ),
                            ),
                            ...shapes.map((shape) => _buildBoxShape(shape)),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/test');
                              },
                              child: Text('test'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/test2');
                              },
                              child: Text('test2'),
                            ),
                            // IconButton(
                            //   onPressed: canBack ? () => back() : null,
                            //   color: Colors.green,
                            //   disabledColor: Colors.grey,
                            //   icon: Icon(Icons.arrow_back_rounded),
                            // ),
                            // IconButton(
                            //   onPressed: canForward ? () => forward() : null,
                            //   color: Colors.green,
                            //   disabledColor: Colors.grey,
                            //   icon: Icon(Icons.arrow_forward_outlined),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          };
        },
      ),
    );
  }

  Widget _buildBoxShape(DrawingShapeType shape) {
    bool isSelected = selectedBoxSpape == shape;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedBoxSpape = null;
            selectedTool = CanvasObjectType.line;
            builder.type = CanvasObjectType.line;
          } else {
            selectedBoxSpape = shape;
            final newTool = switch (shape) {
              DrawingShapeType.rectangle => CanvasObjectType.rect,
              DrawingShapeType.circle => CanvasObjectType.circle,
            };
            selectedTool = newTool;
            builder.type = newTool;
          }
        });
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.grey,
          shape: switch (shape) {
            DrawingShapeType.circle => BoxShape.circle,
            DrawingShapeType.rectangle => BoxShape.rectangle,
          },
        ),
      ),
    );
  }
}
