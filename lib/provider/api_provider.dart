import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/story_response.dart';
import 'package:story_app/data/model/user.dart';

class ApiProvider {
  final StoryApiService storyApiService;

  ApiProvider(this.storyApiService);

  Future<StoryResponse?> login(String email, String password) async {
    // Make the login API call using storyApiService
    final loginResponse = await storyApiService.login(email, password);
    return loginResponse;
  }

  Future<StoryResponse?> register(User user) async {
    // Make the login API call using storyApiService
    final loginResponse = await storyApiService.register(user);
    return loginResponse;
  }
}
