import 'package:json_annotation/json_annotation.dart';
import 'package:youstoryapp02/data/model/login_result.dart';
import 'package:youstoryapp02/data/model/story.dart';

part 'story_response.g.dart';

@JsonSerializable()
class StoryResponse {
  final LoginResult? loginResult;
  @JsonKey(name: "listStory")
  final List<Story>? listStory;
  final Story? story;
  final bool? error;
  final String? message;

  StoryResponse({
    this.loginResult,
    this.listStory,
    this.story,
    this.error,
    this.message,
  });

  factory StoryResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoryResponseToJson(this);
}
