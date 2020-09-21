import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:gogithub/exception/error_interceptor.dart';
import 'package:gogithub/utils/request_serilizer.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:artemis/artemis.dart';
import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:github/github.dart';
import 'package:gogithub/utils/constant.dart';
import 'package:gogithub/utils/global.dart';
import 'package:nanoid/nanoid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as ioclient;

import 'account.dart';

class PlatformType {
  static const github = 'github';
}

class AuthModel with ChangeNotifier {
  List<Account> _accounts;
  int activeAccountIndex;
  StreamSubscription<Uri> _sub;
  bool loading = false;

  List<Account> get accounts => _accounts;
  Account get activeAccount {
    if (activeAccountIndex == null || _accounts == null) return null;
    return _accounts[activeAccountIndex];
  }

  String get token => activeAccount?.token;

  static Dio dio = Dio(BaseOptions(
    baseUrl: gtApiBaseUrl,
    headers: {
      HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
          "application/vnd.github.symmetra-preview+json, application/json",
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  //https://docs.github.com/en/developers/apps/authorizing-oauth-apps#web-application-flow
  Future<String> _getTokenFromThirdPartServer(Uri uri) async {
    final r = await dio.post(
      "https://git-touch-oauth.now.sh/api/token",
      data: json.encode({
        'client_id': clientId,
        'code': uri.queryParameters['code'],
        'state': _oauthState,
      }),
    );
    Fimber.d(
        "http code:${r.statusCode}, http message:${r.statusMessage}, http response: $r");

    String tokenAcc = r?.data['access_token'] as String;
    return tokenAcc;
  }

  //https://docs.github.com/en/developers/apps/authorizing-oauth-apps#web-application-flow
  Future<String> _getTokenFromLocalForTest(Uri uri) async {
    final r = await dio.post(
      gtHomeDomain + "/login/oauth/access_token",
      data: json.encode({
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': uri.queryParameters['code'],
        'redirect_uri': 'gogithub://login',
        'state': _oauthState,
      }),
    );
    Fimber.d(
        "http code:${r.statusCode}, http message:${r.statusMessage}, http response: $r");
    String tokenAcc = r?.data['access_token'] as String;
    return tokenAcc;
  }

  Future<dynamic> graphQuery(String query, [String _token]) async {
    if (_token == null) {
      _token = token;
    }
    if (_token == null) {
      throw 'token is null';
    }

    var _options = Options();
    _options.headers.addAll({HttpHeaders.authorizationHeader: 'token $_token'});
    final res = await dio.post(
      gtApiBaseUrl + '/graphql',
      options: _options,
      data: json.encode({'query': query}),
    );

    Fimber.d("query data:${res.data}");
    dynamic resData = res?.data['data'];
    return resData;
  }

  _addAccount(Account account) async {
    _accounts = [...accounts, account];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.accounts, json.encode(_accounts));
  }

  removeAccount(int index) async {
    if (activeAccountIndex == index) {
      activeAccountIndex = null;
    }
    _accounts.removeAt(index);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.accounts, json.encode(_accounts));
    notifyListeners();
  }

  Future<void> _onSchemeDetected(Uri uri) async {
    await closeWebView();

    loading = true;
    notifyListeners();

    // get token by code
    // final _token = _getTokenFromThirdPartServer(uri);
    final _token = await _getTokenFromLocalForTest(uri);

    Fimber.d("token:$_token");
    await loginWithToken(_token ?? token);
  }

  Future<void> loginWithToken(String _token) async {
    try {
      String query = '''
{
  viewer {
    login
    avatarUrl
  }
}''';
      dynamic queryData = await graphQuery(query, _token);
      await _addAccount(Account(
        platform: PlatformType.github,
        domain: gtHomeDomain,
        token: _token,
        login: queryData['viewer']['login'] as String,
        avatarUrl: queryData['viewer']['avatarUrl'] as String,
      ));
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> init() async {
    //添加过滤器
    // dio.interceptors.add("")
    //设置用户token
    // dio.options.headers[HttpHeaders.authorizationHeader] = "";
    dio.interceptors.add(ErrorInterceptor());

    //不校验证书
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      // client.findProxy = (uri) {
      //   return "PROXY 10.95.249.53:8888";
      // };

      //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };

    _sub = getUriLinksStream().listen(_onSchemeDetected, onError: (err) {
      Fimber.e('getUriLinkStream failed', ex: err);
    });

    var prefs = await SharedPreferences.getInstance();
    try {
      String str = prefs.getString(StorageKeys.accounts);
      Fimber.d('read accounts :$str');
      _accounts = (json.decode(str ?? '[]') as List)
          .map((item) => Account.fromJson(item))
          .toList();
    } catch (err) {
      Fimber.w('prefs getAccount from cache failed', ex: err);
      _accounts = [];
    }
    notifyListeners();
  }

  ArtemisClient _gqlClient;
  ArtemisClient get gqlClient {
    if (token == null) return null;
    if (_gqlClient == null) {
      _gqlClient = ArtemisClient.fromLink(
        HttpLink(
          gtApiBaseUrl + '/graphql',
          defaultHeaders: {HttpHeaders.authorizationHeader: 'token $token'},
          serializer: GithubRequestSerializer(),
          httpClient: constructNoTrustClient(),
        ),
      );
    }
    return _gqlClient;
  }

  ioclient.IOClient constructNoTrustClient() {
    Fimber.d("construct no trust certificate success");
    var _httpClient = HttpClient();
    _httpClient.badCertificateCallback =
        ((X509Certificate cert, String host, int port) {
      Fimber.d('graphql->x509 certificate $cert, host:$host, port:$port');
      return true;
    });
    return ioclient.IOClient(_httpClient);
  }

  GitHub _ghClient;
  GitHub get ghClient {
    if (token == null) return null;
    if (_ghClient == null) {
      _ghClient = GitHub(
        auth: Authentication.withToken(token),
        client: constructNoTrustClient(),
      );
    }
    return _ghClient;
  }

  var rootKey = UniqueKey();
  setActiveAccountAndReload(int index) async {
    rootKey = UniqueKey();
    activeAccountIndex = index;
    final prefs = await SharedPreferences.getInstance();
    _activeTab = prefs.getInt(
            StorageKeys.getDefaultStartTabKey(activeAccount.platform)) ??
        0;
    _ghClient = null;
    _gqlClient = null;
    notifyListeners();
  }

  int _activeTab = 0;
  int get activeTab => _activeTab;

  Future<void> setActiveTab(int v) async {
    _activeTab = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        StorageKeys.getDefaultStartTabKey(activeAccount.platform), v);
    Fimber.d('write default start tab for ${activeAccount.platform}: $v');
    notifyListeners();
  }

  String _oauthState;
  void redirectToGithubOauth() {
    _oauthState = nanoid();
    var scope = Uri.encodeComponent('user,repo,read:org,notifications');
    launchUrl(
      'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=gogithub://login&scope=$scope&state=$_oauthState',
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
