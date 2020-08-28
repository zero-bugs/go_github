import 'package:fimber/fimber.dart';
import 'package:flukit/flukit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gogithub/common/common_widget.dart';
import 'package:gogithub/common/git_api.dart';
import 'package:gogithub/l10n/localization_intl.dart';
import 'package:gogithub/models/repo.dart';
import 'package:gogithub/states/user_notifier.dart';
import 'package:gogithub/widgets/repo_item.dart';
import 'package:provider/provider.dart';

import 'route_keys.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    Fimber.d("begin to print home page.");
    return Scaffold(
      appBar: AppBar(
        title: Text(GmLocalizations.of(context).home),
      ),
      body: _buildBody(),
      drawer: MyDrawer(),
    );
  }

  Widget _buildBody() {
    UserModel userModel = Provider.of<UserModel>(context);
    Fimber.d("begin to print _buildBody.$userModel");
    if (!userModel.isLogin) {
      // user has not login in yet.
      return Center(
        child: RaisedButton(
          child: Text(GmLocalizations.of(context).login),
          onPressed: () => Navigator.of(context).pushNamed(ROUTE_LOGIN),
        ),
      );
    } else {
      // has login, then show project list
      return InfiniteListView<Repo>(
        onRetrieveData: (int page, List<Repo> items, bool refresh) async {
          var data = await GitApi(context).getRepos(
            refresh: refresh,
            queryParameters: {
              'page': page,
              'page_size': 20,
            },
          );

          items.addAll(data);
          return data.length > 0 && data.length % 20 == 0;
        },
        itemBuilder: (List list, int index, BuildContext ctx) {
          return RepoItem(list[index]);
        },
      );
    }
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(),
            Expanded(
              child: _buildMenus(),
            )
          ],
        ),
      ),
    );
  }

  // construct header
  Widget _buildMenus() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget child) {
        var gm = GmLocalizations.of(context);
        return ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Text(gm.theme),
              onTap: () => Navigator.pushNamed(context, ROUTE_THEMES),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(gm.language),
              onTap: () => Navigator.pushNamed(context, ROUTE_LANGUAGE),
            ),
            if (userModel.isLogin)
              ListTile(
                leading: const Icon(Icons.power_settings_new),
                title: Text(gm.logout),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      // double check before logout
                      return AlertDialog(
                        content: Text(gm.logoutTip),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(gm.cancel),
                            onPressed: () => Navigator.pop(context),
                          ),
                          FlatButton(
                            child: Text(gm.yes),
                            onPressed: () {
                              // trigger rebuild
                              userModel.user = null;
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
          ],
        );
      },
    );
  }

  //construct menu
  Widget _buildHeader() {
    return Consumer<UserModel>(
      builder: (BuildContext context, UserModel userModel, Widget child) {
        return GestureDetector(
          child: Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ClipOval(
                    child: userModel.isLogin
                        ? gmAvatar(userModel.user.avaterUrl, width: 80)
                        : Image.asset(
                            "imgs/avatar-default.png",
                            width: 80,
                          ),
                  ),
                ),
                Text(
                  userModel.isLogin
                      ? userModel.user.login
                      : GmLocalizations.of(context).login,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            if (!userModel.isLogin)
              Navigator.of(context).pushNamed(ROUTE_LOGIN);
          },
        );
      },
    );
  }
}
