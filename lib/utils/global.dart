import 'dart:io';

import 'package:fimber/fimber.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gogithub/models/theme.dart';
import 'package:gogithub/widgets/border_view.dart';
import 'package:intl/intl.dart';
import 'package:primer/primer.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

// final pageSize = 5;
final pageSize = 30;
var createWarning =
    (String text) => Text(text, style: TextStyle(color: Colors.redAccent));
var warningSpan =
    TextSpan(text: 'xxx', style: TextStyle(color: Colors.redAccent));
final numberFormat = NumberFormat();
final dateFormat = DateFormat.yMMMMd();

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

class CommonStyle {
  static const padding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static final border = BorderView();
  static const verticalGap = SizedBox(height: 18);
  static final monospace = Platform.isIOS ? 'Menlo' : 'monospace'; // FIXME:
}

class GithubPalette {
  static const open = Color(0xff2cbe4e);
  static const closed = PrimerColors.red600;
  static const merged = PrimerColors.purple500;
}

launchUrl(String url) async {
  if (url == null) return;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    Fimber.w("url can not launch");
  }
}

List<T> join<T>(T seperator, List<T> xs) {
  List<T> result = [];
  xs.asMap().forEach((index, x) {
    if (x == null) return;

    result.add(x);
    if (index < xs.length - 1) {
      result.add(seperator);
    }
  });

  return result;
}

List<T> joinAll<T>(T seperator, List<List<T>> xss) {
  List<T> result = [];
  xss.asMap().forEach((index, x) {
    if (x == null || x.isEmpty) return;

    result.addAll(x);
    if (index < xss.length - 1) {
      result.add(seperator);
    }
  });

  return result;
}

Tuple2<String, String> parseRepositoryFullName(String fullName) {
  final ls = fullName.split('/');
  assert(ls.length == 2);
  return Tuple2(ls[0], ls[1]);
}

Color convertColor(String cssHex) {
  if (cssHex == null) {
    return Color(0xffededed); // Default color
  }

  if (cssHex.startsWith('#')) {
    cssHex = cssHex.substring(1);
  }
  if (cssHex.length == 3) {
    cssHex = cssHex.split('').map((char) => char + char).join('');
  }
  return Color(int.parse('ff' + cssHex, radix: 16));
}

int sortByKey<T>(T key, T a, T b) {
  if (a == key && b != key) return -1;
  if (a != key && b == key) return 1;
  return 0;
}

bool isNotNullOrEmpty(String text) {
  return text != null && text.isNotEmpty;
}

String getBranchQueryKey(String branch, {bool withParams = false}) {
  if (branch == null) return 'defaultBranchRef';
  return 'ref' + (withParams ? '(qualifiedName: "$branch")' : '');
}

TextSpan createLinkSpan(BuildContext context, String text, String url) {
  final theme = Provider.of<ThemeModel>(context);
  return TextSpan(
    text: text,
    style: TextStyle(
      color: theme.palette.primary,
      fontWeight: FontWeight.w600,
    ),
    recognizer: TapGestureRecognizer()
      ..onTap = () {
        theme.push(context, url);
      },
  );
}

Color getFontColorByBrightness(Color color) {
  var grayscale = color.red * 0.3 + color.green * 0.59 + color.blue * 0.11;
  // Fimber.d('color: $color, $grayscale');

  var showWhite = grayscale < 128;
  return showWhite ? Colors.white : Colors.black;
}

TextSpan createUserSpan(BuildContext context, String login) {
  return createLinkSpan(context, login, '/$login');
}
