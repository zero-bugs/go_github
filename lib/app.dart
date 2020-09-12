import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/models/theme.dart';
import 'package:provider/provider.dart';

import 'widgets/home.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(context);
    return Container(
      key: auth.rootKey,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    switch (theme.theme) {
      case AppThemeType.cupertino:
        return CupertinoApp(
          theme: CupertinoThemeData(brightness: theme.brightness),
          home: Home(),
        );
      case AppThemeType.material:
      default:
        return MaterialApp(
          theme: ThemeData(
            brightness: theme.brightness,
            primaryColor:
                theme.brightness == Brightness.dark ? null : Colors.white,
            accentColor: theme.palette.primary,
            scaffoldBackgroundColor: theme.palette.background,
          ),
          home: Home(),
        );
    }
  }
}
