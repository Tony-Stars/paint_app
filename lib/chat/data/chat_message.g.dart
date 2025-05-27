// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
  text: json['text'] as String,
  userId: (json['userId'] as num).toInt(),
  username: json['username'] as String,
);

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'text': instance.text,
      'userId': instance.userId,
      'username': instance.username,
    };
