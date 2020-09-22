import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:gogithub/models/code.dart';
import 'package:gogithub/models/theme.dart';
import 'package:gogithub/utils/global.dart';
import 'package:provider/provider.dart';
import 'package:flutter_highlight/theme_map.dart';

class FilesItem extends StatelessWidget {
  final String filename;
  final String status;
  final int changes;
  final int additions;
  final int deletions;
  final String patch;

  FilesItem({
    @required this.filename,
    @required this.status,
    @required this.changes,
    @required this.deletions,
    @required this.additions,
    @required this.patch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    final codeProvider = Provider.of<CodeModel>(context);
    return Card(
      color: theme.palette.background,
      margin: EdgeInsets.all(0),
      child: ExpansionTile(
        title: Text(
          filename,
          style: TextStyle(
            color: theme.palette.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HighlightView(
              patch,
              language: 'diff',
              padding: CommonStyle.padding,
              theme: themeMap[theme.brightness == Brightness.dark
                  ? codeProvider.themeDark
                  : codeProvider.theme],
              textStyle: TextStyle(
                  fontSize: codeProvider.fontSize.toDouble(),
                  fontFamily: codeProvider.fontFamilyUsed),
            ),
          ),
        ],
      ),
    );
  }
}
