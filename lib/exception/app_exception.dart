import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';

class DioException implements Exception {
  final String _message;
  final int _code;

  DioException([this._message, this._code]);

  @override
  String toString() {
    return 'AppException{_message: $_message, _code: $_code}';
  }

  factory DioException.create(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        {
          return BadRequestException("request cancel", -1);
        }
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        {
          return BadRequestException("connect time out", -1);
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        {
          return BadRequestException("request time out", -1);
        }
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        {
          return BadRequestException("response time out", -1);
        }
        break;
      case DioErrorType.RESPONSE:
        {
          try {
            int errorCode = error.response.statusCode;
            switch (errorCode) {
              case 400:
                {
                  return BadRequestException("request syntax wrong", errorCode);
                }
                break;
              case 401:
                {
                  return UnauthorisedException("no permission", errorCode);
                }
                break;
              case 403:
                {
                  return UnauthorisedException(
                      "server reject your request", errorCode);
                }
                break;
              case 404:
                {
                  return UnauthorisedException(
                      "cannot connect server", errorCode);
                }
                break;
              case 405:
                {
                  return UnauthorisedException(
                      "request method forbidden", errorCode);
                }
                break;
              case 500:
                {
                  return UnauthorisedException(
                      "server internal error", errorCode);
                }
                break;
              case 502:
                {
                  return UnauthorisedException("invalid request", errorCode);
                }
                break;
              case 503:
                {
                  return UnauthorisedException(
                      "service not available", errorCode);
                }
                break;
              case 505:
                {
                  return UnauthorisedException(
                      "HTTP protocol not supported", errorCode);
                }
                break;
              default:
                return DioException(error.response.statusMessage, errorCode);
            }
          } on Exception catch (e) {
            Fimber.w("unknown exception", ex: e);
            return DioException("unknown exception", -1);
          }
        }
        break;
      default:
        return DioException(error.message, -1);
    }
  }
}

class BadRequestException extends DioException {
  BadRequestException([String message, int code]) : super(message, code);
}

class UnauthorisedException extends DioException {
  UnauthorisedException([String message, int code]) : super(message, code);
}
