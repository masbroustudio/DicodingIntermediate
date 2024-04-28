import 'package:flutter/foundation.dart';
import 'package:youstoryapp02/data/db/auth_repository.dart';
import 'package:youstoryapp02/data/model/user.dart';
import 'package:youstoryapp02/provider/api_provider.dart';

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
      final registerResponse = await apiProvider.register(user);
      return registerResponse != null && registerResponse.error == false;
    } catch (error) {
      // Handle registration errors more gracefully
      if (kDebugMode) {
        print(error.toString());
      } // Log the error for debugging
      throw Exception('Registration failed. Please try again later.');
    } finally {
      isLoadingLogin = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    isLoadingLogin = true;
    notifyListeners();

    try {
      final loginResponse = await apiProvider.login(email, password);
      if (loginResponse != null && loginResponse.loginResult?.token != null) {
        await setName(loginResponse.loginResult?.name ?? '');
        await authRepository.login(loginResponse.loginResult?.token ?? '');
      }
      isLoggedIn = await authRepository.isLoggedIn();
      return isLoggedIn;
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      throw Exception('Login failed. Please check your credentials.');
    } finally {
      isLoadingLogin = false;
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    try {
      await authRepository.logout();
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      throw Exception('Logout failed. Please try again later.');
    } finally {
      isLoggedIn = await authRepository.isLoggedIn();
      isLoadingLogout = false;
      notifyListeners();
    }
    return !isLoggedIn;
  }
}
