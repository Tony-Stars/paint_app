// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canvas_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CanvasObject$Brush _$CanvasObject$BrushFromJson(Map<String, dynamic> json) =>
    CanvasObject$Brush(
      points:
          (json['points'] as List<dynamic>)
              .map((e) => CanvasPoint.fromJson(e as Map<String, dynamic>))
              .toList(),
      color: (json['color'] as num).toInt(),
      width: (json['width'] as num).toDouble(),
    );

Map<String, dynamic> _$CanvasObject$BrushToJson(CanvasObject$Brush instance) =>
    <String, dynamic>{
      'color': instance.color,
      'width': instance.width,
      'points': instance.points,
    };

CanvasObject$Line _$CanvasObject$LineFromJson(Map<String, dynamic> json) =>
    CanvasObject$Line(
      style: $enumDecode(_$CanvasLineStyleEnumMap, json['style']),
      color: (json['color'] as num).toInt(),
      width: (json['width'] as num).toDouble(),
      from: CanvasPoint.fromJson(json['from'] as Map<String, dynamic>),
      to: CanvasPoint.fromJson(json['to'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CanvasObject$LineToJson(CanvasObject$Line instance) =>
    <String, dynamic>{
      'style': _$CanvasLineStyleEnumMap[instance.style]!,
      'color': instance.color,
      'width': instance.width,
      'from': instance.from,
      'to': instance.to,
    };

const _$CanvasLineStyleEnumMap = {
  CanvasLineStyle.straight: 'straight',
  CanvasLineStyle.arrow: 'arrow',
};

CanvasObject$Rect _$CanvasObject$RectFromJson(Map<String, dynamic> json) =>
    CanvasObject$Rect(
      color: (json['color'] as num).toInt(),
      center: CanvasPoint.fromJson(json['center'] as Map<String, dynamic>),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      paintingStyle: $enumDecode(
        _$CanvasPaintingStyleEnumMap,
        json['paintingStyle'],
      ),
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CanvasObject$RectToJson(CanvasObject$Rect instance) =>
    <String, dynamic>{
      'color': instance.color,
      'center': instance.center,
      'width': instance.width,
      'height': instance.height,
      'paintingStyle': _$CanvasPaintingStyleEnumMap[instance.paintingStyle]!,
      'strokeWidth': instance.strokeWidth,
    };

const _$CanvasPaintingStyleEnumMap = {
  CanvasPaintingStyle.fill: 'fill',
  CanvasPaintingStyle.stroke: 'stroke',
};

CanvasObject$Circle _$CanvasObject$CircleFromJson(Map<String, dynamic> json) =>
    CanvasObject$Circle(
      color: (json['color'] as num).toInt(),
      center: CanvasPoint.fromJson(json['center'] as Map<String, dynamic>),
      radius: (json['radius'] as num).toDouble(),
      paintingStyle: $enumDecode(
        _$CanvasPaintingStyleEnumMap,
        json['paintingStyle'],
      ),
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CanvasObject$CircleToJson(
  CanvasObject$Circle instance,
) => <String, dynamic>{
  'color': instance.color,
  'center': instance.center,
  'radius': instance.radius,
  'paintingStyle': _$CanvasPaintingStyleEnumMap[instance.paintingStyle]!,
  'strokeWidth': instance.strokeWidth,
};

CanvasObject$Text _$CanvasObject$TextFromJson(Map<String, dynamic> json) =>
    CanvasObject$Text(
      color: (json['color'] as num).toInt(),
      text: json['text'] as String,
      fontWeight: (json['fontWeight'] as num).toInt(),
      fontSize: (json['fontSize'] as num).toDouble(),
      fontStyle: $enumDecode(_$CanvasTextFontStyleEnumMap, json['fontStyle']),
      offset: CanvasPoint.fromJson(json['offset'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CanvasObject$TextToJson(CanvasObject$Text instance) =>
    <String, dynamic>{
      'color': instance.color,
      'text': instance.text,
      'fontWeight': instance.fontWeight,
      'fontSize': instance.fontSize,
      'fontStyle': _$CanvasTextFontStyleEnumMap[instance.fontStyle]!,
      'offset': instance.offset,
    };

const _$CanvasTextFontStyleEnumMap = {
  CanvasTextFontStyle.normal: 'normal',
  CanvasTextFontStyle.italic: 'italic',
};
