import 'package:flutter/material.dart';

import 'user_profile_notifier.dart';

class LocaleModel extends ProfileModel {
  String get locale => profile.locale;

  Locale getLocale() {
    if (profile.locale == null) return null;
    var t = profile.locale.split('_');
    return Locale(t[0], t[1]);
  }

  set locale(String locale) {
    if (locale != profile.locale) {
      profile.locale = locale;
      notifyListeners();
    }
  }
}
