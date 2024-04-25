import 'dart:developer';

import '../network/api_endpoints.dart';
import '../network/network_service.dart';
import '../responses/default_response.dart';
import '../responses/post_login_response.dart';

class AuthRepository {
  Future<LoginResult> login(
      {required String email, required String password}) async {
    try {
      final response = await NetworkService.post(
        ApiEndpoints.baseUrl,
        ApiEndpoints.login,
        headers: {},
        data: {
          "email": email,
          "password": password,
        },
      );

      final result = PostLoginResponse.fromJson(response);

      return result.loginResult;
    } catch (e) {
      log(e.toString(), name: "AUTH REPOSITORY");
      rethrow;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await NetworkService.post(
        ApiEndpoints.baseUrl,
        ApiEndpoints.register,
        headers: {},
        data: {
          "name": name,
          "email": email,
          "password": password,
        },
      );

      final result = DefaultResponse.fromJson(response);

      if (result.error) return false;

      return true;
    } catch (e) {
      log(e.toString(), name: "AUTH REPOSITORY");
      rethrow;
    }
  }
}
