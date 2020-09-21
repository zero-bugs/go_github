import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';

import 'app_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError err) {
    DioException exception = DioException.create(err);
    Fimber.d("DioError:${exception.toString()}");
    err.error = exception;
    return super.onError(err);
  }
}
