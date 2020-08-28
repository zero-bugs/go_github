import 'package:flutter/material.dart';
import 'package:gogithub/common/global.dart';

import 'user_profile_notifier.dart';

class ThemeModel extends ProfileModel {
  ColorSwatch get theme =>
      Global.themes.firstWhere((element) => element.value == profile.theme,
          orElse: () => Colors.blue);

  set theme(ColorSwatch color) {
    if (color != theme) {
      profile.theme = color[500].value;
      notifyListeners();
    }
  }
}
