class CustomException implements Exception {
  final String? message;
  final String? prefix;

  CustomException([this.message, this.prefix]);

  @override
  String toString() {
    return message.toString();
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String? message]) : super(message, "");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class NotFoundException extends CustomException {
  NotFoundException([message]) : super(message, "Not Found: ");
}

class ConflictException extends CustomException {
  ConflictException([message]) : super(message, "Conflict Database: ");
}

class InternalServerErrorException extends CustomException {
  InternalServerErrorException([message])
      : super(message, "Internal Server Error: ");
}
