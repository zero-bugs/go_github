import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gogithub/models/code.dart';
import 'package:gogithub/models/theme.dart';
import 'package:gogithub/utils/global.dart';
import 'package:gogithub/utils/extensions.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:uri/uri.dart';

class MarkdownView extends StatelessWidget {
  final String text;
  final List<String> basePaths;

  MarkdownView(this.text, {this.basePaths});

  Map<String, String> matchPattern(String url, String pattern) {
    var uri = Uri.parse(url);
    return UriParser(UriTemplate(pattern)).match(uri)?.parameters;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    final code = Provider.of<CodeModel>(context);
    final _basicStyle =
        TextStyle(fontSize: 16, color: theme.palette.text, height: 1.5);
    final _hStyle =
        _basicStyle.copyWith(fontWeight: FontWeight.w600, height: 1.25);

    return MarkdownBody(
      onTapLink: (url) {
        if (basePaths != null &&
            !url.startsWith('https://') &&
            !url.startsWith('http://')) {
          // Treat as relative path

          final x = basePaths.sublist(3).join('/');
          var y = path.join(x, url);
          if (y.startsWith('/')) y = y.substring(1);

          return Provider.of<ThemeModel>(context).push(context,
              '/${basePaths[0]}/${basePaths[1]}/${basePaths[2]}?path=${y.urlencode}');
        }

        // TODO: Relative paths
        if (url.startsWith('https://github.com')) {
          Map<String, String> m;

          m = matchPattern(url, '/{owner}/{name}/pull/{number}');
          if (m != null) {
            return Provider.of<ThemeModel>(context).push(context, url);
          }

          m = matchPattern(url, '/{owner}/{name}/issues/{number}');
          if (m != null) {
            return Provider.of<ThemeModel>(context).push(context, url);
          }

          m = matchPattern(url, '/{owner}/{name}');
          if (m != null) {
            return Provider.of<ThemeModel>(context).push(context, url);
          }

          m = matchPattern(url, '/{login}');
          if (m != null) {
            return Provider.of<ThemeModel>(context).push(context, url);
          }
        }

        launchUrl(url);
      },
      data: text,
      styleSheet: MarkdownStyleSheet(
        a: _basicStyle.copyWith(color: theme.palette.primary),
        p: _basicStyle,
        code: _basicStyle.copyWith(
          fontSize: 16 * 0.85,
          height: 1.45,
          fontFamily: code.fontFamilyUsed,
        ),
        h1: _hStyle.copyWith(fontSize: 32),
        h2: _hStyle.copyWith(fontSize: 24),
        h3: _hStyle.copyWith(fontSize: 20),
        h4: _hStyle,
        h5: _hStyle.copyWith(fontSize: 14),
        h6: _hStyle.copyWith(
            fontSize: 16 * 0.85, color: theme.palette.tertiaryText),
        em: _basicStyle.copyWith(fontStyle: FontStyle.italic),
        strong: _basicStyle.copyWith(fontWeight: FontWeight.w600),
        del: const TextStyle(decoration: TextDecoration.lineThrough),
        blockquote: _basicStyle.copyWith(color: theme.palette.tertiaryText),
        img: _basicStyle,
        checkbox: _basicStyle,
        blockSpacing: 16,
        listIndent: 32,
        listBullet: _basicStyle,
        // tableHead: _basicStyle,
        tableBody: _basicStyle,
        // tableHeadAlign: TextAlign.center,
        // tableBorder: TableBorder.all(color: Colors.grey.shade300, width: 0),
        // tableColumnWidth: const FlexColumnWidth(),
        // tableCellsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        blockquotePadding: EdgeInsets.symmetric(horizontal: 16),
        blockquoteDecoration: BoxDecoration(
          border: Border(left: BorderSide(color: Color(0xffdfe2e5), width: 4)),
        ),
        codeblockPadding: EdgeInsets.all(16),
        codeblockDecoration: BoxDecoration(
          color: theme.palette.grayBackground,
          borderRadius: BorderRadius.circular(3),
        ),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 4,
              color: theme.palette.grayBackground,
            ),
          ),
        ),
      ),
      // syntaxHighlighter: , // TODO:
    );
  }
}
