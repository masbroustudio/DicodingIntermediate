import 'dart:developer';

import 'package:flutter/material.dart';

import '../data/local/app_preferences.dart';
import '../data/models/user.dart';
import '../data/network/response_call.dart';
import '../data/repositories/auth_repository.dart';

class LoginProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  ResponseCall responseCall = ResponseCall.iddle("iddle");

  LoginProvider({required this.authRepository});

  Future<User?> login({required String email, required String password}) async {
    responseCall = ResponseCall.loading("loading");
    notifyListeners();

    try {
      final result =
          await authRepository.login(email: email, password: password);

      final isSessionSaved = await AppPreferences.saveSession(
        id: result.userId,
        userEmail: email,
        userName: result.name,
        userToken: result.token,
      );

      if (!isSessionSaved) return null;

      responseCall = ResponseCall.completed("complete");
      notifyListeners();

      return await AppPreferences.getUser();
    } catch (e) {
      log(e.toString(), name: "LOGIN PROVIDER");

      responseCall = ResponseCall.error(e.toString());
      notifyListeners();

      return null;
    }
  }
}
