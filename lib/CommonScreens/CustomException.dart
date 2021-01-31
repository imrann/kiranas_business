import 'package:http/http.dart';

class CustomException {
  returnResponse({Response response, bool connection}) {
    if (connection == false) {
      throw new AppException("Check your connection", "No Internet: ");
    } else {
      switch (response.statusCode) {
        case 400:
          throw new BadRequestException(response.statusCode.toString());
        case 401:
        case 403:
          throw new UnauthorisedException(
            response.statusCode.toString(),
          );
        case 500:
          throw new InternalServerError(response.statusCode.toString());
        case 404:
          throw new FileNotFoundException(response.statusCode.toString());
        default:
          throw new SomeOtherException("Something went Wrong!");
      }
    }
  }
}

class AppException implements Exception {
  final String message;
  final String prefix;
  //@override
  AppException([this.message, this.prefix]);
  @override
  String toString() {
    return "$prefix$message";
  }
}

// class SocketException extends AppException {
//   SocketException([String message])
//       : super(message, "#Error During Communication: ");
// }

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "#Bad Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "#Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([message]) : super(message, "#Invalid Input: ");
}

class InternalServerError extends AppException {
  InternalServerError([message, htmlTag]) : super(message, "#Server Error: ");
}

class FileNotFoundException extends AppException {
  FileNotFoundException([message, htmlTag]) : super(message, "#FileNotFound: ");
}

class SomeOtherException extends AppException {
  SomeOtherException([message, htmlTag]) : super(message, "Please try again: ");
}
