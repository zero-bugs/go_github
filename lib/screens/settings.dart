import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/models/code.dart';
import 'package:gogithub/models/theme.dart';
import 'package:gogithub/scaffolds/single.dart';
import 'package:gogithub/utils/constant.dart';
import 'package:gogithub/utils/global.dart';
import 'package:gogithub/widgets/action_button.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/table_view.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      setState(() {
        _version = info.version;
      });
    });
  }

  Widget _buildRightWidget(BuildContext context, bool checked) {
    final theme = Provider.of<ThemeModel>(context);
    if (!checked) return null;
    return Icon(Icons.check, color: theme.palette.primary, size: 24);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    final auth = Provider.of<AuthModel>(context);
    final code = Provider.of<CodeModel>(context);
    return SingleScaffold(
      title: AppBarTitle('Settings'),
      body: Column(
        children: <Widget>[
          CommonStyle.verticalGap,
          TableView(headerText: 'accounts', items: [
            TableViewItem(
              text: Text('Switch Accounts'),
              url: '/login',
              rightWidget: Text(auth.activeAccount.login),
            ),
            if (auth.activeAccount.platform == PlatformType.github)
              TableViewItem(
                text: Text('Review Permissions'),
                url:
                    'https://github.com/settings/connections/applications/$clientId',
                rightWidget: Text(auth.activeAccount.login),
              ),
          ]),
          CommonStyle.verticalGap,
          TableView(headerText: 'theme', items: [
            TableViewItem(
              text: Text('Brightness'),
              rightWidget: Text(theme.brightnessValue == AppBrightnessType.light
                  ? 'Light'
                  : theme.brightnessValue == AppBrightnessType.dark
                      ? 'Dark'
                      : 'Follow system'),
              onTap: () {
                theme.showActions(context, [
                  for (var t in [
                    Tuple2('Follow System', AppBrightnessType.followSystem),
                    Tuple2('Light', AppBrightnessType.light),
                    Tuple2('Dark', AppBrightnessType.dark),
                  ])
                    ActionItem(
                      text: t.item1,
                      onTap: (_) {
                        if (theme.brightnessValue != t.item2)
                          theme.setBrightness(t.item2);
                      },
                    )
                ]);
              },
            ),
            TableViewItem(
              text: Text('Scaffold Theme'),
              rightWidget: Text(theme.theme == AppThemeType.cupertino
                  ? 'Cupertino'
                  : 'Material'),
              onTap: () {
                theme.showActions(context, [
                  for (var t in [
                    Tuple2('Material', AppThemeType.material),
                    Tuple2('Cupertino', AppThemeType.cupertino),
                  ])
                    ActionItem(
                      text: t.item1,
                      onTap: (_) {
                        if (theme.theme != t.item2) {
                          theme.setTheme(t.item2);
                        }
                      },
                    )
                ]);
              },
            ),
            TableViewItem(
              text: Text('Code Theme'),
              url: '/choose-code-theme',
              rightWidget: Text('${code.fontFamily}, ${code.fontSize}pt'),
            ),
          ]),
          CommonStyle.verticalGap,
          TableView(headerText: 'feedback', items: [
            TableViewItem(
              text: Text('Submit an issue'),
              rightWidget: Text('pd4d10/git-touch'),
              url: (auth.activeAccount.platform == PlatformType.github
                      ? ''
                      : 'https://github.com') +
                  '/pd4d10/git-touch/issues/new',
            ),
            TableViewItem(
              text: Text('Rate This App'),
              onTap: () {
                LaunchReview.launch(
                  androidAppId: 'com.zbugs.gogithub',
                  iOSAppId: '123456789',
                );
              },
            ),
            TableViewItem(
              text: Text('Email'),
              rightWidget: Text('pd4d10@gmail.com'),
              hideRightChevron: true,
              url: 'mailto:pd4d10@gmail.com',
            ),
          ]),
          CommonStyle.verticalGap,
          TableView(headerText: 'about', items: [
            TableViewItem(text: Text('Version'), rightWidget: Text(_version)),
            TableViewItem(
              text: Text('Source Code'),
              rightWidget: Text('pd4d10/git-touch'),
              url: (auth.activeAccount.platform == PlatformType.github
                      ? ''
                      : 'https://github.com') +
                  '/pd4d10/git-touch',
            ),
          ])
        ],
      ),
    );
  }
}
