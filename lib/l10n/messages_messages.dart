import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();
final _keepAnalysisHappy = Intl.defaultLocale;

typedef MessageIfAbsent(String messageStr, List args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'messages';

  @override
  Map<String, Function> get messages => <String, Function>{
        "auto": MessageLookupByLibrary.simpleMessage("Auto"),
        "cancel": MessageLookupByLibrary.simpleMessage("cancel"),
        "home": MessageLookupByLibrary.simpleMessage("Github"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "logout": MessageLookupByLibrary.simpleMessage("logout"),
        "logoutTip": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to quit your current account?"),
        "noDescription":
            MessageLookupByLibrary.simpleMessage("No description yet !"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordRequired":
            MessageLookupByLibrary.simpleMessage("Password required!"),
        "setting": MessageLookupByLibrary.simpleMessage("Setting"),
        "theme": MessageLookupByLibrary.simpleMessage("Theme"),
        "title": MessageLookupByLibrary.simpleMessage("Flutter APP"),
        "userName": MessageLookupByLibrary.simpleMessage("User Name"),
        "userNameOrPasswordWrong": MessageLookupByLibrary.simpleMessage(
            "User name or password is not correct!"),
        "userNameRequired":
            MessageLookupByLibrary.simpleMessage("User name required!"),
        "yes": MessageLookupByLibrary.simpleMessage("yes")
      };
}
