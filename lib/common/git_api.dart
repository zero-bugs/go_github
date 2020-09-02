import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gogithub/filter/http_errors.dart';
import 'package:gogithub/index.dart';
import 'package:gogithub/models/repo.dart';
import 'package:gogithub/models/user.dart';

import 'global.dart';

class GitApi {
  static Dio dio = Dio(BaseOptions(baseUrl: 'https://api.github.com', headers: {
    HttpHeaders.acceptHeader:
        "application/vnd.github.squirrel-girl-preview,application/vnd.github.symmetra-preview+json",
  }));

  GitApi([this.context]) {
    _options = Options(extra: {"context": context});
  }

  BuildContext context;
  Options _options;

  static void init() {
    // add interceptor
    dio.interceptors.add(Global.netCacheInterceptor);
    dio.interceptors.add(ErrorInterceptor());
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;

    Fimber.d("product is release:${Global.isRelease}");

    // set debug grab http data packages
    if (!Global.isRelease) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
//        client.findProxy = (uri) {
//          return "PROXY 127.0.0.1:8888";
//        };
        // forbid certificate check
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }

  Future<User> login(String login, String pwd) async {
    String basic = 'Basic ' + base64.encode(utf8.encode('$login:$pwd'));
    var r = await dio.get(
      "/users/$login",
      options: _options.merge(
        headers: {HttpHeaders.authorizationHeader: basic},
        extra: {
          "noCache": true,
        },
      ),
    );
    // update authorization header for after use.
    dio.options.headers[HttpHeaders.authorizationHeader] = basic;
    // clear cache
    Global.netCacheInterceptor.cache.clear();
    Global.profile.token = basic;
    return User.fromJson(r.data);
  }

  Future<List<Repo>> getRepos(
      {Map<String, dynamic> queryParameters, refresh = false}) async {
    if (refresh) {
      _options.extra.addAll({
        "refresh": true,
        "list": true,
      });
    }

    var r = await dio.get<List>(
      "/user/repos",
      queryParameters: queryParameters,
      options: _options,
    );
    Fimber.d("repos:${r?.data?.toString()}");
    return r.data.map((e) => Repo.fromJson(e)).toList();
  }
}
