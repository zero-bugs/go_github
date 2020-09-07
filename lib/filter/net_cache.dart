import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:gogithub/common/global.dart';
import 'package:gogithub/index.dart';

class CacheObject {
  Response response;
  int timeStamp;

  CacheObject(this.response)
      : timeStamp = DateTime.now().millisecondsSinceEpoch;

  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;

  bool isExpire() {
    return (DateTime.now().millisecondsSinceEpoch - this.timeStamp) / 1000 >=
        Global.profile.cache.maxAge;
  }

  @override
  String toString() {
    return 'CacheObject{response: $response, timeStamp: $timeStamp}';
  }
}

class NetCacheInterceptor extends Interceptor {
  var cache = LinkedHashMap<String, CacheObject>();

  @override
  Future onRequest(RequestOptions options) async {
    if (!Global.profile.cache.enable) return options;
    // scroll down refresh
    bool refresh = options.extra['refresh'] == true;
    if (refresh) {
      if (options.extra['list'] == true) {
        cache.removeWhere((key, value) => key.contains(options.path));
      } else {
        delete(options.uri.toString());
      }
      return options;
    }

    if (options.extra['noCache'] != true &&
        options.method.toLowerCase() == 'get') {
      String key = options.extra['cacheKey'] ?? options.uri.toString();
      var ob = cache[key];
      Fimber.d("cache object:$ob");
      if (ob != null && !ob.isExpire()) {
        return cache[key].response;
      } else {
        cache.remove(key);
      }
    }
  }

  void delete(String key) {
    cache.remove(key);
  }

  @override
  Future onResponse(Response response) async {
    if (Global.profile.cache.enable) {
      _saveCache(response);
    }
  }

  void _saveCache(Response response) {
    RequestOptions options = response.request;
    if (options.extra['noCache'] != true &&
        options.method.toLowerCase() == 'get') {
      if (cache.length == Global.profile.cache.maxCount)
        cache.remove(cache[cache.keys.first]);
    }

    String key = options.extra['cacheKey'] ?? options.uri.toString();
    cache[key] = CacheObject(response);
  }
}
