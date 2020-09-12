import 'package:fluro/fluro.dart';
import 'package:gogithub/widgets/code_theme.dart';

class RouterScreen {
  String path;
  HandlerFunc hander;
  RouterScreen(this.path, this.hander);
}

class CommonRouter {
  static final codeTheme =
      RouterScreen('/choose-code-theme', (context, p) => CodeThemeScreen());
  static final login = RouterScreen('/login', (context, p) => LoginScreen());
  static final settings =
      RouterScreen('/settings', (context, p) => SettingScreen());

  static final routes = [
    CommonRouter.codeTheme,
    CommonRouter.login,
    CommonRouter.settings
  ];
}
