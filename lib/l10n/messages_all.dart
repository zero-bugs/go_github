import 'package:fimber/fimber.dart';
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
// ignore: implementation_imports
import 'package:intl/src/intl_helpers.dart' as messages_helper;

import 'messages_messages.dart' as messages_messages;
import 'messages_zh_CN.dart' as messages_zh_cn;

typedef Future<dynamic> LibraryLoader();

Map<String, LibraryLoader> _deferredLibraries = {
  // ignore: unnecessary_new
  'messages': () => new Future.value(null),
  // ignore: unnecessary_new
  'zh_CN': () => new Future.value(null),
};

Future<bool> initializeMessages(String localeName) async {
  var availableLocale = Intl.verifiedLocale(
      localeName, (locale) => _deferredLibraries[locale] != null,
      onFailure: (_) => null);

  if (availableLocale == null) {
    return new Future.value(false);
  }

  var lib = _deferredLibraries[availableLocale];
  // ignore: unnecessary_new
  await (lib == null ? new Future.value(false) : lib());
  // ignore: unnecessary_new
  messages_helper
      .initializeInternalMessageLookup(() => new CompositeMessageLookup());
  messages_helper.messageLookup
      .addLocale(availableLocale, _findGeneratedMessageFor);
  return new Future.value(true);
}

bool _messageExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    Fimber.w('message exist failed.', ex: e);
    return false;
  }
}

MessageLookupByLibrary _findExact(localeName) {
  switch (localeName) {
    case 'messages':
      return messages_messages.messages;
    case 'zh_CN':
      return messages_zh_cn.messages;
    default:
      return null;
  }
}

MessageLookupByLibrary _findGeneratedMessageFor(locale) {
  var acturalLocale =
      Intl.verifiedLocale(locale, _messageExistFor, onFailure: (_) => null);
  if (acturalLocale == null) return null;
  return _findExact(acturalLocale);
}
