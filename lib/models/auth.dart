import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'account.dart';

class AuthModel with ChangeNotifier {
  List<Account> _accounts;
  int activeAccountIndex;
  StreamSubscription<Uri> _sub;
  bool loading = false;

  List<Account> get accounts => _accounts;
  Account get activeAccount {
    if (activeAccountIndex == null || _accounts == null) return null;
    return _accounts[activeAccountIndex];
  }

  String get token => activeAccount.token;
}
