import 'index.dart';

void main() => Global.init().then((e) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Fimber.d("begin to render app.");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeModel>.value(value: ThemeModel()),
        ChangeNotifierProvider<UserModel>.value(value: UserModel()),
        ChangeNotifierProvider<LocaleModel>.value(value: LocaleModel()),
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
