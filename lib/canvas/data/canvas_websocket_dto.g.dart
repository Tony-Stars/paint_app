// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canvas_websocket_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CanvasWebsocketDto _$CanvasWebsocketDtoFromJson(Map<String, dynamic> json) =>
    CanvasWebsocketDto(
      sessionId: (json['sessionId'] as num).toInt(),
      method: $enumDecode(_$CanvasWebsocketMethodEnumMap, json['method']),
      data: CanvasWebsocketData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CanvasWebsocketDtoToJson(CanvasWebsocketDto instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'method': _$CanvasWebsocketMethodEnumMap[instance.method]!,
      'data': instance.data,
    };

const _$CanvasWebsocketMethodEnumMap = {
  CanvasWebsocketMethod.connect: 'connect',
  CanvasWebsocketMethod.draw: 'draw',
  CanvasWebsocketMethod.clear: 'clear',
};

CanvasWebsocketData _$CanvasWebsocketDataFromJson(Map<String, dynamic> json) =>
    CanvasWebsocketData(
      connect:
          json['connect'] == null
              ? null
              : CanvasConnectDto.fromJson(
                json['connect'] as Map<String, dynamic>,
              ),
      draw: CanvasWebsocketData._drawFromJson(json['draw']),
      clear: json['clear'] as bool?,
    );

Map<String, dynamic> _$CanvasWebsocketDataToJson(
  CanvasWebsocketData instance,
) => <String, dynamic>{
  'connect': instance.connect,
  'draw': instance.draw,
  'clear': instance.clear,
};

CanvasConnectDto _$CanvasConnectDtoFromJson(Map<String, dynamic> json) =>
    CanvasConnectDto(username: json['username'] as String);

Map<String, dynamic> _$CanvasConnectDtoToJson(CanvasConnectDto instance) =>
    <String, dynamic>{'username': instance.username};
