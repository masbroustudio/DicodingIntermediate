import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AppPreferences {
  static const isLoggedIn = "IS_LOGGED_IN";
  static const token = "TOKEN";
  static const userId = "USER_ID";
  static const email = "EMAIL";
  static const name = "NAME";

  static Future<bool> checkIsLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getBool(isLoggedIn) ?? false;
  }

  static Future<bool> saveSession({
    required String id,
    required String userEmail,
    required String userName,
    required String userToken,
  }) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(userId, id);
    await preferences.setString(email, userEmail);
    await preferences.setString(name, userName);
    await preferences.setString(token, userToken);

    return await preferences.setBool(isLoggedIn, true);
  }

  static Future<String> getToken() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getString(token) ?? "";
  }

  static Future<User> getUser() async {
    final preferences = await SharedPreferences.getInstance();

    final id = preferences.getString(userId) ?? "";
    final userName = preferences.getString(name) ?? "";
    final userEmail = preferences.getString(email) ?? "";

    return User(id: id, name: userName, email: userEmail);
  }

  static Future<bool> clearSession() async {
    final preferences = await SharedPreferences.getInstance();

    return await preferences.clear();
  }
}
