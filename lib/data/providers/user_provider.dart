import 'dart:developer';

import 'package:flutter/material.dart';

import '../network/response_call.dart';
import '../repositories/auth_repository.dart';

class UserProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  ResponseCall responseCall = ResponseCall.iddle("iddle");

  UserProvider({required this.authRepository});

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    responseCall = ResponseCall.loading("loading");
    notifyListeners();

    try {
      final result = await authRepository.register(
        name: name,
        email: email,
        password: password,
      );

      responseCall = ResponseCall.completed(result);
      notifyListeners();

      return result;
    } catch (e) {
      log(e.toString(), name: "USER PROVIDER");

      responseCall = ResponseCall.error(e.toString());
      notifyListeners();

      return false;
    }
  }
}
