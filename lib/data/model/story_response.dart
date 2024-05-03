import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/data/model/login_result.dart';
import 'package:story_app/data/model/story.dart';

part 'story_response.g.dart';

@JsonSerializable()
class StoryResponse {
  final bool? error;
  final String? message;
  final LoginResult? loginResult;
  @JsonKey(name: "listStory")
  final List<Story>? listStory;
  final Story? story;

  StoryResponse({
    this.error,
    this.message,
    this.loginResult,
    this.listStory,
    this.story,
  });

  factory StoryResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryResponseToJson(this);
}
