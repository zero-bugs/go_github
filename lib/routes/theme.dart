import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gogithub/common/global.dart';
import 'package:gogithub/l10n/localization_intl.dart';
import 'package:gogithub/states/theme_notifier.dart';
import 'package:provider/provider.dart';

class ThemeChangeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GmLocalizations.of(context).theme),
      ),
      body: ListView(
        children: Global.themes.map<Widget>((e) {
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              child: Container(
                color: e,
                height: 40,
              ),
            ),
            onTap: () {
              // after update theme, material app will rebuild
              Provider.of<ThemeModel>(context).theme = e;
            },
          );
        }).toList(),
      ),
    );
  }
}
