import 'dart:io';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:gogithub/widgets/border_view.dart';
import 'package:url_launcher/url_launcher.dart';

class StorageKeys {
  static const accounts = 'accounts';
  static const iTheme = 'theme';
  static const iBrightness = 'brightness';
  static const codeTheme = 'code-theme';
  static const codeThemeDark = 'code-theme-dark';
  static const iCodeFontSize = 'code-font-size';
  static const codeFontFamily = 'code-font-family';

  static getDefaultStartTabKey(String platform) =>
      'default-start-tab=$platform';
}

launchUrl(String url) async {
  if (url == null) return;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    Fimber.w("url can not launch");
  }
}

class CommonStyle {
  static const padding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static final border = BorderView();
  static const verticalGap = SizedBox(height: 18);
  static final monospace = Platform.isIOS ? 'Menlo' : 'monospace'; // FIXME:
}
