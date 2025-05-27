// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_websocket_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatWebsocketDto _$ChatWebsocketDtoFromJson(Map<String, dynamic> json) =>
    ChatWebsocketDto(
      sessionId: (json['sessionId'] as num).toInt(),
      method: $enumDecode(_$ChatWebsocketMethodEnumMap, json['method']),
      data: ChatWebsocketData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatWebsocketDtoToJson(ChatWebsocketDto instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'method': _$ChatWebsocketMethodEnumMap[instance.method]!,
      'data': instance.data,
    };

const _$ChatWebsocketMethodEnumMap = {
  ChatWebsocketMethod.connect: 'connect',
  ChatWebsocketMethod.message: 'message',
  ChatWebsocketMethod.clear: 'clear',
};

ChatWebsocketData _$ChatWebsocketDataFromJson(Map<String, dynamic> json) =>
    ChatWebsocketData(
      connect:
          json['connect'] == null
              ? null
              : ChatConnectDto.fromJson(
                json['connect'] as Map<String, dynamic>,
              ),
      message:
          json['message'] == null
              ? null
              : ChatMessage.fromJson(json['message'] as Map<String, dynamic>),
      clear: json['clear'] as bool?,
    );

Map<String, dynamic> _$ChatWebsocketDataToJson(ChatWebsocketData instance) =>
    <String, dynamic>{
      'connect': instance.connect,
      'message': instance.message,
      'clear': instance.clear,
    };

ChatConnectDto _$ChatConnectDtoFromJson(Map<String, dynamic> json) =>
    ChatConnectDto(username: json['username'] as String);

Map<String, dynamic> _$ChatConnectDtoToJson(ChatConnectDto instance) =>
    <String, dynamic>{'username': instance.username};
