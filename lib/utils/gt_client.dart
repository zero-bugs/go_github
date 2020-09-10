import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gogithub/utils/constant.dart';

class GtClient {
  BuildContext context;
  Options _options;

  GtClient([this.context]) {
    _options = Options(extra: {"context": context});
  }

  static Dio dio = Dio(BaseOptions(
    baseUrl: apiGtBaseUrl,
    headers: {
      HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
          "application/vnd.github.symmetra-preview+json",
    },
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  static void init() {
    //添加过滤器
    // dio.interceptors.add("")
    //设置用户token
    dio.options.headers[HttpHeaders.authorizationHeader] = "";
  }
}
