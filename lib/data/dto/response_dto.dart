import 'package:json_annotation/json_annotation.dart';

part 'response_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseDto {
  final ResultsDto data;

  ResponseDto({
    required this.data,
  });

  factory ResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ResultsDto {
  final int? offset;
  final dynamic results;

  ResultsDto({
    required this.results,
    this.offset,
  });

  factory ResultsDto.fromJson(Map<String, dynamic> json) =>
      _$ResultsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResultsDtoToJson(this);
}
