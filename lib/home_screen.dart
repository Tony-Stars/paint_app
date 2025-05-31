import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:paint_app/auth/bloc/auth_cubit.dart';
import 'package:paint_app/auth/data/user.dart';
import 'package:paint_app/canvas/data/canvas_object.dart';
import 'package:paint_app/canvas/data/canvas_repository.dart';
import 'package:paint_app/canvas/ui/canvas_object_builder.dart';
import 'package:paint_app/canvas/ui/canvas_drawer.dart';
import 'package:paint_app/chat/ui/chat_dialog.dart';
import 'package:paint_app/canvas/ui/canvas_painter.dart';
import 'package:paint_app/canvas/ui/elements/drawing_object.dart';
import 'package:paint_app/canvas/ui/text_editor.dart';
import 'package:paint_app/canvas/bloc/canvas_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/common/consts.dart';
// import 'package:web/web.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final builder = CanvasObjectBuilder();
  final textController = TextEditingController();

  DrawingShapeType? selectedBoxSpape;

  bool toolsVisible = true;
  bool chatVisible = false;

  var selectedTool = CanvasObjectType.line;

  // List<List<DrawingObject>> states = [[]];
  // var currentStateIndex = 0;
  CanvasObject? drawingElenent;

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

  void openChat(BuildContext context) async {
    final user = switch (context.read<AuthCubit>().state) {
      AuthState$Authed authed => authed.user,
      _ => null,
    };
    if (user != null) {
      await ChatDialog.show(context, user: user);
    }
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

  Future<ui.Image?> render(
    BuildContext context,
    List<CanvasObject> objects,
  ) async {
    final size = context.size;
    if (size != null) {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final painter = CanvasPainter(objects, null);
      painter.paint(canvas, size);
      final picture = recorder.endRecording();
      final image = await picture.toImage(
        size.width.floor(),
        size.height.floor(),
      );
      return image;
    }

    return Future.value(null);
  }

  Future<String?> canvasToBase64(
    BuildContext context,
    List<CanvasObject> objects,
  ) async {
    final image = await render(context, objects);
    if (image != null) {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data != null) {
        final bytes = base64.encode(data.buffer.asUint8List());
        // TODO refactoring
        final anchor = html.AnchorElement(
          href: 'data:application/octet-stream;base64,$bytes',
        )..target = 'blank';
        anchor.download = 'file.png';
        html.document.body?.append(anchor);
        anchor.click();
        anchor.remove();

        // return bytes;
      }
    }
    return null;
  }

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
    final repository = CanvasRepository(
      sessionId: sessionId,
      uri: Uri.parse('ws://localhost:5000/'),
    );
    return BlocProvider(
      create:
          (context) =>
              CanvasCubit(user: widget.user, repository: repository)..init(),
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
              drawer: CanvasDrawer(builder: builder),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  toolsVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  toolsVisible = !toolsVisible;
                  setState(() {});
                },
              ),
              body: ListenableBuilder(
                listenable: builder,
                builder: (context, child) {
                  return Stack(
                    children: [
                      GestureDetector(
                        onPanStart: onPanStart,
                        onPanUpdate: onPanUpdate,
                        onPanEnd: (details) => onPanEnd(context, details),
                        child: CustomPaint(
                          painter: CanvasPainter(
                            connected.canvasObjects,
                            drawingElenent,
                          ),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                      if (selectedTool == CanvasObjectType.text)
                        Positioned(
                          bottom: 100,
                          right: 30,
                          child: TextEditor(
                            controller: textController,
                            builder: builder,
                            onAdd:
                                (weight, size, style) =>
                                    drawText(weight, size, style, null),
                            onConfirm: () => stopDrawText(context),
                          ),
                        ),
                      if (toolsVisible)
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    tooltip: 'Настройки',
                                    onPressed: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                    icon: Icon(Icons.settings_outlined),
                                  ),
                                  IconButton(
                                    tooltip: 'Кисточка',
                                    onPressed: () {
                                      selectedBoxSpape = null;
                                      selectedTool = CanvasObjectType.line;
                                      builder.type = CanvasObjectType.line;
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.brush,
                                      color:
                                          selectedTool == CanvasObjectType.line
                                              ? builder.color
                                              : Colors.grey,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Текст',
                                    onPressed: () {
                                      if (selectedTool ==
                                          CanvasObjectType.text) {
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
                                              ? builder.color
                                              : Colors.grey,
                                    ),
                                  ),
                                  ...DrawingShapeType.values.map(
                                    (shape) =>
                                        _buildBoxShape(shape, builder.color),
                                  ),
                                  IconButton(
                                    tooltip: 'Изображение',
                                    onPressed: () async {
                                      await canvasToBase64(
                                        context,
                                        connected.canvasObjects,
                                      );
                                    },
                                    icon: Icon(Icons.image),
                                  ),
                                  IconButton(
                                    tooltip: 'Чат',
                                    onPressed: () => openChat(context),
                                    icon: Icon(Icons.chat_rounded),
                                  ),
                                  IconButton(
                                    tooltip: 'Очистить доску',
                                    onPressed: () => clear(context),
                                    icon: Icon(Icons.delete_outline),
                                  ),
                                  // TextButton(
                                  //   onPressed: () {
                                  //     Navigator.of(context).pushNamed('/test');
                                  //   },
                                  //   child: Text('test'),
                                  // ),
                                  // TextButton(
                                  //   onPressed: () {
                                  //     Navigator.of(context).pushNamed('/test2');
                                  //   },
                                  //   child: Text('test2'),
                                  // ),
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
                  );
                },
              ),
            ),
          };
        },
      ),
    );
  }

  Widget _buildBoxShape(DrawingShapeType shape, Color color) {
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
          color: isSelected ? color : Colors.grey,
          shape: switch (shape) {
            DrawingShapeType.circle => BoxShape.circle,
            DrawingShapeType.rectangle => BoxShape.rectangle,
          },
        ),
      ),
    );
  }
}
