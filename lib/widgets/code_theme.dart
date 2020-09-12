import 'package:flutter/cupertino.dart';
import 'package:gogithub/models/code.dart';
import 'package:gogithub/models/theme.dart';
import 'package:gogithub/scaffolds/single.dart';
import 'package:provider/provider.dart';

class CodeThemeScreen extends StatelessWidget {
  String _getCode(bool isDark) => '''// ${isDark ? 'Dark' : 'Light'} Mode
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
''';

  @override
  Widget build(BuildContext context) {
    var codeProvider = Provider.of<CodeModel>(context);
    var theme = Provider.of<ThemeModel>(context);

    return SingleScaffold();
  }
}
