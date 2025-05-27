import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

@JsonSerializable()
class ChatMessage {
  final String text;
  final int userId;
  final String username;
  // final DateTime sent_at;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  ChatMessage({
    required this.text,
    required this.userId,
    required this.username,
  });

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}
