import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:youstoryapp02/data/db/auth_repository.dart';
import 'package:youstoryapp02/data/model/story_response.dart';
import 'package:youstoryapp02/data/model/user.dart';

class StoryApiService {
  final String baseUrl = 'https://story-api.dicoding.dev/v1';
  final AuthRepository authRepository;

  StoryApiService(this.authRepository);

  Future<StoryResponse> register(User user) async {
    final url = '$baseUrl/register';
    final body = jsonEncode(user.toJson());

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return StoryResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register user: ${response.statusCode}');
    }
  }

  Future<StoryResponse> login(String email, String password) async {
    final url = '$baseUrl/login';
    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return StoryResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<StoryResponse> addNewStory(
      List<int> bytes, String description, String fileName,
      {double? lat, double? lon}) async {
    final authToken = await authRepository.getToken();
    if (authToken == null) {
      throw Exception("Token not available");
    }

    final url = '$baseUrl/stories';
    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $authToken"
    };

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    request.fields.addAll({
      'description': description,
      'lat': lat?.toString() ?? '0.0',
      'lon': lon?.toString() ?? '0.0'
    });
    request.files
        .add(http.MultipartFile.fromBytes('photo', bytes, filename: fileName));

    final response = await http.Response.fromStream(await request.send());
    return StoryResponse.fromJson(jsonDecode(response.body));
  }

  Future<StoryResponse> getAllStories(
      {int? page, int? size, int? location}) async {
    final authToken = await authRepository.getToken();
    if (authToken == null) {
      throw Exception("Token not available");
    }

    final url = '$baseUrl/stories?page=$page&size=$size';
    final Map<String, String> headers = {"Authorization": "Bearer $authToken"};

    final response = await http.get(Uri.parse(url), headers: headers);
    return StoryResponse.fromJson(jsonDecode(response.body));
  }

  Future<StoryResponse> getDetailStory(String id) async {
    final authToken = await authRepository.getToken();
    if (authToken == null) {
      throw Exception("Token not available");
    }

    final url = '$baseUrl/stories/$id';
    final Map<String, String> headers = {"Authorization": "Bearer $authToken"};

    final response = await http.get(Uri.parse(url), headers: headers);
    return StoryResponse.fromJson(jsonDecode(response.body));
  }
}
