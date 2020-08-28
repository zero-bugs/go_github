import 'package:flutter/cupertino.dart';
import 'package:gogithub/common/global.dart';
import 'package:gogithub/models/profile.dart';

class ProfileModel extends ChangeNotifier {
  Profile _profile = Global.profile;

  Profile get profile => _profile;

  @override
  void notifyListeners() {
    Global.saveProfile();
    super.notifyListeners();
  }
}
