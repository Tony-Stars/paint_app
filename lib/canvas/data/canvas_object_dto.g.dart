// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canvas_object_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CanvasObjectDto _$CanvasObjectDtoFromJson(
  Map<String, dynamic> json,
) => CanvasObjectDto(
  type: $enumDecode(_$CanvasObjectTypeEnumMap, json['type']),
  line:
      json['line'] == null
          ? null
          : CanvasObject$Line.fromJson(json['line'] as Map<String, dynamic>),
  rect:
      json['rect'] == null
          ? null
          : CanvasObject$Rect.fromJson(json['rect'] as Map<String, dynamic>),
  circle:
      json['circle'] == null
          ? null
          : CanvasObject$Circle.fromJson(
            json['circle'] as Map<String, dynamic>,
          ),
  text:
      json['text'] == null
          ? null
          : CanvasObject$Text.fromJson(json['text'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CanvasObjectDtoToJson(CanvasObjectDto instance) =>
    <String, dynamic>{
      'type': _$CanvasObjectTypeEnumMap[instance.type]!,
      'line': instance.line,
      'rect': instance.rect,
      'circle': instance.circle,
      'text': instance.text,
    };

const _$CanvasObjectTypeEnumMap = {
  CanvasObjectType.line: 'line',
  CanvasObjectType.rect: 'rect',
  CanvasObjectType.circle: 'circle',
  CanvasObjectType.text: 'text',
};
