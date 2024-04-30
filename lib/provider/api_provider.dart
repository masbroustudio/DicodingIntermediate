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
      if (kDebugMode) {
        print(error.toString());
      }
      throw Exception('Login failed. Please check your credentials.');
    }
  }

  Future<StoryResponse?> register(User user) async {
    try {
      final registerResponse = await storyApiService.register(user);
      return registerResponse;
    } on Exception catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      throw Exception('Registration failed. Please try again later.');
    }
  }
}
