import 'package:fimber/fimber.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/models/code.dart';
import 'package:gogithub/models/notification.dart';
import 'package:gogithub/models/theme.dart';
import 'package:gogithub/utils/router.dart';
import 'package:provider/provider.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Fimber.plantTree(DebugTree());
  Fimber.d('WidgetsFlutterBinding.ensureInitialized()');

  final notification = NotificationModel();
  final themeModel = ThemeModel();
  final authModel = AuthModel();
  final codeModel = CodeModel();

  await Future.wait([
    themeModel.init(),
    authModel.init(),
    codeModel.init(),
  ]);

  CommonRouter.routes.forEach((screen) {
    themeModel.router.define(CommonRouter.prefix + screen.path,
        handler: Handler(handlerFunc: screen.handler));
  });
  GithubRouter.routes.forEach((screen) {
    themeModel.router.define(GithubRouter.prefix + screen.path,
        handler: Handler(handlerFunc: screen.handler));
  });

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => notification,
      ),
      ChangeNotifierProvider(
        create: (context) => themeModel,
      ),
      ChangeNotifierProvider(
        create: (context) => authModel,
      ),
      ChangeNotifierProvider(
        create: (context) => codeModel,
      )
    ],
    child: MyApp(),
  ));
}
