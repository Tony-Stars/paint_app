import 'dart:async';

import 'package:flutter_app/canvas/data/canvas_object.dart';
import 'package:flutter_app/canvas/data/canvas_repository.dart';
import 'package:flutter_app/canvas/data/canvas_websocket_dto.dart';
import 'package:flutter_app/common/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CanvasCubit extends Cubit<WebsocketState> {
  final CanvasRepository repository;

  StreamSubscription<CanvasWebsocketDto>? drawSubscription;

  CanvasCubit({required this.repository})
    : super(const WebsocketState$Initial());

  void init() {
    try {
      repository.connect(username: 'user');
      drawSubscription = repository.stream?.listen(
        _mapCanvasWebsocketEvent,
        onError: (error) {
          Logger.error(error);
        },
      );

      emit(const WebsocketState$Connected(canvasObjects: []));
    } catch (e) {
      emit(const WebsocketState$Error());
      Logger.error(e);
    }
  }

  void _mapCanvasWebsocketEvent(CanvasWebsocketDto dto) {
    if (dto.data.draw != null) {
      draw(dto.data.draw!, notify: false);
    } else if (dto.data.clear != null) {
      clear(notify: false);
    }
  }

  void draw(CanvasObject object, {bool notify = true}) {
    final objects = switch (state) {
      WebsocketState$Connected connected => connected.canvasObjects,
      _ => null,
    };
    if (objects != null) {
      if (notify) {
        repository.draw(object);
      }
      final newObjects = List.of(objects)..add(object);
      emit(WebsocketState$Connected(canvasObjects: newObjects));
      // states = states.take(currentStateIndex + 1).toList();
      // states.add(drawingElenents);
      // currentStateIndex++;
    }
  }

  void clear({bool notify = true}) {
    if (state is WebsocketState$Connected) {
      if (notify) {
        repository.clear();
      }
      emit(const WebsocketState$Connected(canvasObjects: []));
    }
  }

  @override
  Future<void> close() async {
    drawSubscription?.cancel();
    drawSubscription = null;
    // clearSubscription?.cancel();
    // clearSubscription = null;
    await repository.close();
    return super.close();
  }
}

sealed class WebsocketState {
  const WebsocketState();
}

class WebsocketState$Initial extends WebsocketState {
  const WebsocketState$Initial();
}

class WebsocketState$Connected extends WebsocketState {
  // final List<List<DrawingObject>> states;
  final List<CanvasObject> canvasObjects;

  const WebsocketState$Connected({
    // required this.states,
    required this.canvasObjects,
  });
}

class WebsocketState$Error extends WebsocketState {
  const WebsocketState$Error();
}
