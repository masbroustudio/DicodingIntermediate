import 'dart:convert';

PostLoginResponse postLoginResponseFromJson(String str) =>
    PostLoginResponse.fromJson(json.decode(str));

String postLoginResponseToJson(PostLoginResponse data) =>
    json.encode(data.toJson());

class PostLoginResponse {
  final bool error;
  final String message;
  final LoginResult loginResult;

  PostLoginResponse({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory PostLoginResponse.fromJson(Map<String, dynamic> json) =>
      PostLoginResponse(
        error: json["error"],
        message: json["message"],
        loginResult: LoginResult.fromJson(json["loginResult"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "loginResult": loginResult.toJson(),
      };
}

class LoginResult {
  final String userId;
  final String name;
  final String token;

  LoginResult({
    required this.userId,
    required this.name,
    required this.token,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
        userId: json["userId"],
        name: json["name"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "token": token,
      };
}
