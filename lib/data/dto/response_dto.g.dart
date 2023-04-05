// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseDto _$ResponseDtoFromJson(Map<String, dynamic> json) => ResponseDto(
      data: ResultsDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResponseDtoToJson(ResponseDto instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

ResultsDto _$ResultsDtoFromJson(Map<String, dynamic> json) => ResultsDto(
      results: json['results'],
      offset: json['offset'] as int?,
    );

Map<String, dynamic> _$ResultsDtoToJson(ResultsDto instance) =>
    <String, dynamic>{
      'offset': instance.offset,
      'results': instance.results,
    };
