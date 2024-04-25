import 'dart:convert';

import '../models/story.dart';

GetStoriesResponse getStoriesResponseFromJson(String str) =>
    GetStoriesResponse.fromJson(json.decode(str));

String getStoriesResponseToJson(GetStoriesResponse data) =>
    json.encode(data.toJson());

class GetStoriesResponse {
  final bool error;
  final String message;
  final List<Story> listStory;

  GetStoriesResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory GetStoriesResponse.fromJson(Map<String, dynamic> json) =>
      GetStoriesResponse(
        error: json["error"],
        message: json["message"],
        listStory:
            List<Story>.from(json["listStory"].map((x) => Story.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "listStory": List<dynamic>.from(listStory.map((x) => x.toJson())),
      };
}
