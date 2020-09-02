import 'package:dio/dio.dart';
import 'package:gogithub/exception/app_exception.dart';
import 'package:gogithub/index.dart';

class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError err) {
    DioException exception = DioException.create(err);
    Fimber.d("DioError:${exception.toString()}");
    err.error = exception;
    return super.onError(err);
  }
}
