import 'package:fimber/fimber.dart';
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
