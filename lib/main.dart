import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gogithub/common/global.dart';
import 'package:gogithub/l10n/localization_intl.dart';
import 'package:gogithub/routes/home_page.dart';
import 'package:gogithub/routes/language.dart';
import 'package:gogithub/routes/login.dart';
import 'package:gogithub/routes/route_keys.dart';
import 'package:gogithub/routes/theme.dart';
import 'package:gogithub/states/locale_notifier.dart';
import 'package:gogithub/states/theme_notifier.dart';
import 'package:gogithub/states/user_notifier.dart';
import 'package:provider/provider.dart';

void main() => Global.init().then((e) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Fimber.d("begin to render app.");
    return MultiProvider(
      providers: [
        Provider<ThemeModel>(create: (_) => ThemeModel()),
        Provider<UserModel>(create: (_) => UserModel()),
        Provider<UserModel>(create: (_) => UserModel()),
      ],
      child: Consumer2<ThemeModel, LocaleModel>(
        builder: (BuildContext context, themeModel, localeModel, Widget child) {
          Fimber.d("begin to print ThemeModel and LocaleModel.");

          return MaterialApp(
            theme: ThemeData(
              primarySwatch: themeModel.theme,
            ),
            onGenerateTitle: (context) {
              return GmLocalizations.of(context).title;
            },
            home: HomeRoute(),
            locale: localeModel.getLocale(),
            supportedLocales: [
              const Locale('en', 'US'),
              const Locale('zh', 'CN'),
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GmLocalizationsDelegate(),
            ],
            localeResolutionCallback:
                (Locale _locale, Iterable<Locale> supportedLocales) {
              if (localeModel.getLocale() != null) {
                return localeModel.getLocale();
              } else {
                Locale locale;
                if (supportedLocales.contains(_locale)) {
                  locale = _locale;
                } else {
                  locale = Locale('en', 'US');
                }
                return locale;
              }
            },

            // register route
            routes: <String, WidgetBuilder>{
              ROUTE_LOGIN: (context) => LoginRoute(),
              ROUTE_THEMES: (context) => ThemeChangeRoute(),
              ROUTE_LANGUAGE: (context) => LanguageRoute(),
            },
          );
        },
      ),
    );
  }
}
