import 'package:json_annotation/json_annotation.dart';

part 'comic.g.dart';

@JsonSerializable(explicitToJson: true)
class Comic {
  int? id;
  String? title;
  Thumbnail? thumbnail;

  String? get thumb => '${thumbnail?.path}.${thumbnail?.extension}';

  Comic({this.id, this.title, this.thumbnail});

  factory Comic.fromJson(Map<String, dynamic> json) => _$ComicFromJson(json);

  Map<String, dynamic> toJson() => _$ComicToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Thumbnail {
  String? path;
  String? extension;

  Thumbnail({this.path, this.extension});

  factory Thumbnail.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailFromJson(json);

  Map<String, dynamic> toJson() => _$ThumbnailToJson(this);
}
