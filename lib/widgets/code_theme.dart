import 'package:flutter/cupertino.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:gogithub/models/code.dart';
import 'package:gogithub/models/theme.dart';
import 'package:gogithub/scaffolds/single.dart';
import 'package:gogithub/utils/global.dart';
import 'package:provider/provider.dart';

import 'app_bar_title.dart';
import 'table_view.dart';

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

    return SingleScaffold(
      title: AppBarTitle('Code theme'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CommonStyle.verticalGap,
          TableView(
            headerText: 'FONT STYLE',
            items: [
              TableViewItem(
                text: Text('Font Size'),
                rightWidget: Text(codeProvider.fontSize.toString()),
                onTap: () {
                  theme.showPicker(
                    context,
                    PickerGroupItem(
                      value: codeProvider.fontSize.toString(),
                      items: CodeModel.fontSizes
                          .map((v) =>
                              PickerItem(v.toString(), text: v.toString()))
                          .toList(),
                      onChange: (value) {
                        codeProvider.setFontSize(int.tryParse(value) ?? 16);
                      },
                    ),
                  );
                },
              ),
              TableViewItem(
                text: Text('Font Family'),
                rightWidget: Text(codeProvider.fontFamily),
                onTap: () {
                  theme.showPicker(
                    context,
                    PickerGroupItem(
                      value: codeProvider.fontFamily,
                      items: CodeModel.fontFamilies
                          .map((v) => PickerItem(v, text: v))
                          .toList(),
                      onChange: (String value) {
                        codeProvider.setFontFamily(value);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          CommonStyle.verticalGap,
          TableView(
            headerText: 'SYNTAX HIGHLIGHTING',
            items: [
              TableViewItem(
                text: Text('Light Mode'),
                rightWidget: Text(codeProvider.theme),
                onTap: () {
                  theme.showPicker(
                    context,
                    PickerGroupItem(
                      value: codeProvider.theme,
                      items: CodeModel.themes
                          .map((v) => PickerItem(v, text: v))
                          .toList(),
                      onChange: (value) {
                        codeProvider.setTheme(value);
                      },
                    ),
                  );
                },
              ),
              TableViewItem(
                text: Text('Dark Mode'),
                rightWidget: Text(codeProvider.themeDark),
                onTap: () {
                  theme.showPicker(
                    context,
                    PickerGroupItem(
                      value: codeProvider.themeDark,
                      items: CodeModel.themes
                          .map((v) => PickerItem(v, text: v))
                          .toList(),
                      onChange: (value) {
                        codeProvider.setThemeDark(value);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          HighlightView(
            _getCode(false),
            language: 'dart',
            theme: themeMap[codeProvider.theme],
            textStyle: TextStyle(
              fontSize: codeProvider.fontSize.toDouble(),
              fontFamily: codeProvider.fontFamilyUsed,
            ),
            padding: CommonStyle.padding,
          ),
          HighlightView(
            _getCode(true),
            language: 'dart',
            theme: themeMap[codeProvider.themeDark],
            textStyle: TextStyle(
              fontSize: codeProvider.fontSize.toDouble(),
              fontFamily: codeProvider.fontFamilyUsed,
            ),
            padding: CommonStyle.padding,
          ),
        ],
      ),
    );
  }
}
