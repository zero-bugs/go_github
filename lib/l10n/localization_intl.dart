import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'messages_all.dart';

class GmLocalizations {
  static Future<GmLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((b) {
      Intl.defaultLocale = localeName;
      return new GmLocalizations();
    });
  }

  static GmLocalizations of(BuildContext context) {
    return Localizations.of<GmLocalizations>(context, GmLocalizations);
  }

  String get title {
    return Intl.message(
      'Flutter App',
      name: 'title',
      desc: 'Title for the Demo application',
    );
  }

  String get home => Intl.message('Github', name: 'home');
  String get language => Intl.message('Language', name: 'language');
  String get login => Intl.message('Login', name: 'login');
  String get auto => Intl.message('Auto', name: 'auto');
  String get settings => Intl.message('Settings', name: 'settings');
  String get theme => Intl.message('Theme', name: 'theme');
  String get noDescription =>
      Intl.message('No description yet !', name: 'noDescription');
  String get userName => Intl.message('User Name', name: 'user name');
  String get userNameRequired =>
      Intl.message('User Name Required', name: 'user name required');
  String get password => Intl.message('Password', name: 'password');
  String get passwordRequired =>
      Intl.message('Password required!', name: 'passwordRequired');
  String get userNameOrPasswordWrong =>
      Intl.message('User name or password is not correct!',
          name: 'userNameOrPasswordWrong');
  String get logout => Intl.message('Logout', name: 'logout');
  String get logoutTip =>
      Intl.message('Are you sure you want to quit your current account?',
          name: 'logoutTip');
  String get yes => Intl.message('Yes', name: 'yes');
  String get cancel => Intl.message('Cancel', name: 'cancel');
}

class GmLocalizationsDelegate extends LocalizationsDelegate<GmLocalizations> {
  const GmLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<GmLocalizations> load(Locale locale) {
    return GmLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<GmLocalizations> old) {
    return false;
  }
}
