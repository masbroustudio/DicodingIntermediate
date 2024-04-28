// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryResponse _$StoryResponseFromJson(Map<String, dynamic> json) =>
    StoryResponse(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      loginResult: json['loginResult'] == null
          ? null
          : LoginResult.fromJson(json['loginResult'] as Map<String, dynamic>),
      listStory: (json['listStory'] as List<dynamic>?)
          ?.map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList(),
      story: json['story'] == null
          ? null
          : Story.fromJson(json['story'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StoryResponseToJson(StoryResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'loginResult': instance.loginResult,
      'listStory': instance.listStory,
      'story': instance.story,
    };
