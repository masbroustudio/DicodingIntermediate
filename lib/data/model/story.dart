import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class Story {
  final String? id;
  final String? name;
  final String? description;
  final String? photoUrl;
  final double? lat;
  final double? lon;
  final DateTime? createdAt;

  Story({
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.lat,
    this.lon,
    this.createdAt,
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
