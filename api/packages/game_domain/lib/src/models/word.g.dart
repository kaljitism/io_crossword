// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Word _$WordFromJson(Map<String, dynamic> json) => Word(
      id: json['id'] as String,
      position: const PointConverter()
          .fromJson(json['position'] as Map<String, dynamic>),
      axis: $enumDecode(_$WordAxisEnumMap, json['axis']),
      clue: json['clue'] as String,
      answer: json['answer'] as String,
      solvedTimestamp: (json['solvedTimestamp'] as num?)?.toInt(),
      mascot: $enumDecodeNullable(_$MascotEnumMap, json['mascot']),
    );

Map<String, dynamic> _$WordToJson(Word instance) => <String, dynamic>{
      'id': instance.id,
      'position': const PointConverter().toJson(instance.position),
      'axis': _$WordAxisEnumMap[instance.axis]!,
      'clue': instance.clue,
      'answer': instance.answer,
      'solvedTimestamp': instance.solvedTimestamp,
      'mascot': _$MascotEnumMap[instance.mascot],
    };

const _$WordAxisEnumMap = {
  WordAxis.horizontal: 'horizontal',
  WordAxis.vertical: 'vertical',
};

const _$MascotEnumMap = {
  Mascot.dash: 'dash',
  Mascot.sparky: 'sparky',
  Mascot.android: 'android',
  Mascot.dino: 'dino',
};
