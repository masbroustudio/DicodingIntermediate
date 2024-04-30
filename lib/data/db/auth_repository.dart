import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String tokenKey = "token";
  final String nameKey = "name";

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey) != null;
  }

  Future<bool> login(String token) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(tokenKey, token);
    log("preferences $preferences");
    return true;
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    preferences.remove(tokenKey);
    return true;
  }

  Future<bool> setName(String name) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(nameKey, name);
  }

  Future<String?> getName() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(nameKey);
  }

  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey);
  }
}
