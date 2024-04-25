class DefaultResponse {
  final bool error;
  final String message;

  DefaultResponse({
    required this.error,
    required this.message,
  });

  factory DefaultResponse.fromJson(Map<String, dynamic> json) =>
      DefaultResponse(
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}
