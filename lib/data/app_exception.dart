class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() {
    return 'AppException: $message';
  }
}

class FetchDataException extends AppException {
    FetchDataException(String message) : super('$message Network Error');
}


class BadRequestException extends AppException {
  BadRequestException(String message) : super('$message Bad Request');
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException(String message) : super('$message Unauthorized');
}

class InvalidInputException extends AppException {
  InvalidInputException(String message) : super('$message Invalid Input');
}