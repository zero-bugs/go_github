import 'package:gogithub/models/user.dart';

import 'user_profile_notifier.dart';

class UserModel extends ProfileModel {
  User get user => profile.user;

  bool get isLogin => user != null;

  set user(User user) {
    if (user?.login != profile.user?.login) {
      profile.lastLogin = profile.user?.login;
      profile.user = user;
      notifyListeners();
    }
  }
}
