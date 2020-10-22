import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as ioclient;

class DioClient {
  static Dio dio = Dio(BaseOptions(
    baseUrl: 'https://github.com',
//  headers: {
//    HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
//        "application/vnd.github.symmetra-preview+json, application/json",
//    HttpHeaders.contentTypeHeader: 'application/json',
//  },
    connectTimeout: 5000,
    receiveTimeout: 30000,
  ));

  static bool isInit = false;

  static init() async {
    //不校验证书
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) {
        print('graphql->x509 certificate $cert, host:$host, port:$port');
        return true;
      });

      return client;
    };
  }

  static getInstance() {
    if (!isInit) {
      isInit = true;
    }
    return dio;
  }
}

ioclient.IOClient constructNoTrustClient() {
  print("construct no trust certificate success");
  var _httpClient = HttpClient();
  _httpClient.badCertificateCallback =
      ((X509Certificate cert, String host, int port) {
    print('graphql->x509 certificate $cert, host:$host, port:$port');
    return true;
  });
  _httpClient.connectionTimeout = Duration(seconds: 120);
  // _httpClient.findProxy = ((uri) {
  //   return "PROXY xxxx:8080";
  // });
  // _httpClient.addProxyCredentials('xxxx', 8080, 'admin',
  //     HttpClientBasicCredentials('xxxx', 'xxxx'));

  return ioclient.IOClient(_httpClient);
}

http.Client httpClient = constructNoTrustClient();
