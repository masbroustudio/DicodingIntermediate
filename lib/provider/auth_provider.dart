import 'package:flutter/material.dart';
import 'package:story_app/data/db/auth_repository.dart';
import 'package:story_app/data/model/user.dart';
import 'package:story_app/provider/api_provider.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiProvider apiProvider;

  AuthProvider(this.authRepository, this.apiProvider);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoggedIn = false;

  Future<void> initialize() async {
    isLoggedIn = await authRepository.isLoggedIn();

    notifyListeners();
  }

  Future<void> setName(String name) async {
    await authRepository.setName(name);
  }

  Future<bool> register(User user) async {
    isLoadingLogin = true;
    notifyListeners();

    try {
      // Make a registration API call
      final registerResponse = await apiProvider.register(user);

      return !(registerResponse?.error == true);
    } catch (e) {
      return false;
    } finally {
      isLoadingLogin = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    isLoadingLogin = true;
    notifyListeners();

    // Make a login API call
    final loginResponse = await apiProvider.login(email, password);

    if (loginResponse != null && loginResponse.loginResult?.token != null) {
      await setName(loginResponse.loginResult?.name ?? '');
      await authRepository.login(loginResponse.loginResult?.token ?? '');
    }

    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogin = false;
    notifyListeners();
    return isLoggedIn;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    try {
      await authRepository.logout();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }

    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogout = false;
    notifyListeners();
    return !isLoggedIn;
  }
}
