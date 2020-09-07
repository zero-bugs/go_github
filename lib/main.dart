import 'dart:async';

import 'app.dart';
import 'index.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    Fimber.w("system error:$details");
  };

  runZoned(
    () {
//    ErrorWidget.builder = (FlutterErrorDetails details) {
//      Zone.current.handleUncaughtError(details.exception, details.stack);
//      return ErrorPage(details.exception.toString());
//    };
      runApp(MyApp());
    },
    onError: (Object obj, StackTrace stack) {
      Fimber.w("run app exception:$obj");
      Fimber.w("run app exception stack: $stack");
    },
    zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        Fimber.w("Zone:$self, ZoneDelegate:$parent, line:$line");
      },
    ),
  );
}
