import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/models/code.dart';
import 'package:gogithub/models/notification.dart';
import 'package:gogithub/models/theme.dart';

import 'app.dart';

void main() async {
  Fimber.plantTree(DebugTree());

  final notification = NotificationModel();
  final themeModel = ThemeModel();
  final authModel = AuthModel();
  final codeModel = CodeModel();

  await Future.wait([
    themeModel.init(),
    authModel.init(),
    codeModel.init(),
  ]);

  runApp(MyApp());
}
