import 'dart:developer';
import 'dart:io';

import '../models/story.dart';
import '../network/api_endpoints.dart';
import '../network/network_service.dart';
import '../responses/default_response.dart';
import '../responses/get_stories_response.dart';

class StoryRepository {
  Future<List<Story>> getAllStories({
    int page = 1,
    int size = 10,
  }) async {
    try {
      final response = await NetworkService.get(
        ApiEndpoints.baseUrl,
        ApiEndpoints.stories,
        withToken: true,
        headers: {},
        queryParameters: {
          "page": page.toString(),
          "size": size.toString(),
        },
      );

      final result = GetStoriesResponse.fromJson(response);

      return result.listStory;
    } catch (e) {
      log(e.toString(), name: "STORY REPOSITORY");
      rethrow;
    }
  }

  Future<bool> addStory({
    required String description,
    required File image,
  }) async {
    try {
      final response = await NetworkService.postWithImage(
        ApiEndpoints.baseUrl,
        ApiEndpoints.stories,
        withToken: true,
        images: {"photo": image},
        data: {"description": description},
        headers: {"Content-type": "multipart/form-data"},
      );

      final result = DefaultResponse.fromJson(response);

      if (result.error) return false;

      return true;
    } catch (e) {
      log(e.toString(), name: "STORY REPOSITORY");
      rethrow;
    }
  }
}
