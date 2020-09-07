import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gogithub/common/common_widget.dart';
import 'package:gogithub/common/git_api.dart';
import 'package:gogithub/common/global.dart';
import 'package:gogithub/l10n/localization_intl.dart';
import 'package:gogithub/models/user.dart';
import 'package:gogithub/states/user_notifier.dart';
import 'package:provider/provider.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  FocusNode _userNameFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _blank = FocusNode();

  bool pwdShow = false;
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  void initState() {
    // auto fill last login name, then focus password box
    _unameController.text = Global.profile.lastLogin;
    if (_unameController.text != null) {
      _nameAutoFocus = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    Fimber.d("login form global key:$_formKey");
    return Scaffold(
      appBar: AppBar(title: Text(gm.login)),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          child: Form(
            key: _formKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: _nameAutoFocus,
                  focusNode: _userNameFocus,
                  controller: _unameController,
                  decoration: InputDecoration(
                    labelText: gm.userName,
                    hintText: gm.userName,
                    prefixIcon: Icon(Icons.person),
                  ),
                  // check user name illegal or not
                  validator: (v) {
                    return v.trim().isNotEmpty ? null : gm.userNameRequired;
                  },
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_passwordFocus),
                ),
                TextFormField(
                  autofocus: !_nameAutoFocus,
                  focusNode: _passwordFocus,
                  controller: _pwdController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  enableInteractiveSelection: false,
                  key: _formKey,
                  obscureText: !pwdShow,
                  decoration: InputDecoration(
                    labelText: gm.password,
                    hintText: gm.password,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          !pwdShow ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          pwdShow = !pwdShow;
                        });
                      },
                    ),
                  ),
                  validator: (v) {
                    return v.trim().isNotEmpty ? null : gm.passwordRequired;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 55.0),
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: _onLogin,
                      textColor: Colors.white,
                      child: Text(gm.login),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(_blank);
          },
        ),
      ),
    );
  }

  void _onLogin() async {
    if ((_formKey.currentState as FormState).validate()) {
      showLoading(context);
      User user;
      try {
        user = await GitApi(context)
            .login(_unameController.text, _pwdController.text);
        // after login, page will build, update user but not trigger update all widget
        Fimber.d("user info:${user?.toJson()}");
        Provider.of<UserModel>(context, listen: false).user = user;
      } catch (e) {
        Fimber.w("obtain user info failed", ex: e);
        if (e.response?.statusCode == 401) {
          showToast(GmLocalizations.of(context).userNameOrPasswordWrong);
        } else {
          showToast(e.toString());
        }
      } finally {
        // hide loading box
        Navigator.of(context).pop();
      }

      if (user != null) {
        // back
        Navigator.of(context).pop();
      }
    }
  }
}
