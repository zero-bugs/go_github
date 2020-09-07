// four themes can select
import 'dart:convert';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:gogithub/common/git_api.dart';
import 'package:gogithub/filter/net_cache.dart';
import 'package:gogithub/models/cache_config.dart';
import 'package:gogithub/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config_const.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  // global cache
  static SharedPreferences _prefs;

  // config
  static Profile profile = Profile();

  // http cache
  static NetCacheInterceptor netCacheInterceptor = NetCacheInterceptor();

  // get selectable themes
  static List<MaterialColor> get themes => _themes;

  // is release version or not
  static bool get isRelease => bool.fromEnvironment(Env.DART_VM_PRODUCT);

  static Future init() async {
    // log init
    Fimber.plantTree(DebugTree());

    Fimber.d("Fimber init success.");
    WidgetsFlutterBinding.ensureInitialized();

    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString(CacheKey.USER_PROFILE);
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        Fimber.w('read user profile config failed', ex: e);
      }
    }
    Fimber.d("SharedPreference init success.");
    // set default cache policy
    profile.cache = profile.cache ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;

    Fimber.d("begin to init git client.");
    // init http request config
    GitApi.init();

    Fimber.d("Git client init success.");
  }

  static saveProfile() =>
      _prefs.setString(CacheKey.USER_PROFILE, jsonEncode(profile.toJson()));
}
