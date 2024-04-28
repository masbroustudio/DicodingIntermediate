import 'package:flutter/foundation.dart';
import 'package:youstoryapp02/data/api/api_service.dart';
import 'package:youstoryapp02/data/model/story_response.dart';
import 'package:youstoryapp02/data/model/user.dart';

class ApiProvider {
  final StoryApiService storyApiService;

  ApiProvider(this.storyApiService);

  Future<StoryResponse?> login(String email, String password) async {
    try {
      final loginResponse = await storyApiService.login(email, password);
      return loginResponse;
    } on Exception catch (error) {
      // Handle login errors gracefully
      if (kDebugMode) {
        print(error.toString());
      } // Log the error for debugging
      throw Exception(
          'Login failed. Please check your credentials.'); // More user-friendly error message
    }
  }

  Future<StoryResponse?> register(User user) async {
    try {
      final registerResponse = await storyApiService.register(user);
      return registerResponse;
    } on Exception catch (error) {
      // Handle registration errors gracefully
      if (kDebugMode) {
        print(error.toString());
      } // Log the error for debugging
      throw Exception(
          'Registration failed. Please try again later.'); // More user-friendly error message
    }
  }
}
