import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/models/notification.dart';
import 'package:gogithub/models/theme.dart';
import 'package:gogithub/screens/gh_news.dart';
import 'package:gogithub/screens/gh_notification.dart';
import 'package:gogithub/screens/gh_search.dart';
import 'package:gogithub/screens/gh_trending.dart';
import 'package:gogithub/screens/gh_user.dart';
import 'package:gogithub/screens/login.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Created 5 different variables instead of a list as list doesn't work
  final GlobalKey<NavigatorState> tab1 = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> tab2 = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> tab3 = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> tab4 = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> tab5 = GlobalKey<NavigatorState>();

  _buildScreen(int index) {
    // return GlProjectScreen(32221);
    // return IssuesScreen('flutter', 'flutter', isPullRequest: true);
    // return IssueScreen('reactjs', 'rfcs', 29);
    // return IssueScreen('reactjs', 'rfcs', 68, isPullRequest: true);
    // return Image.asset('imgs/spinner.webp', width: 32, height: 32);
    final auth = Provider.of<AuthModel>(context);
    switch (auth.activeAccount.platform) {
      case PlatformType.github:
        switch (index) {
          case 0:
            return GhNewsScreen();
          case 1:
            return GhNotificationScreen();
          case 2:
            return GhTrendingScreen();
          case 3:
            return GhSearchScreen();
          case 4:
            return GhUserScreen(null);
        }
        break;
    }
  }

  Widget _buildNotificationIcon(BuildContext context, bool isActive) {
    final theme = Provider.of<ThemeModel>(context);
    final iconData = Icons.notifications;
    int count = Provider.of<NotificationModel>(context).count;
    if (count == 0) {
      return Icon(iconData);
    }

    // String text = count > 99 ? '99+' : count.toString();
    return Stack(
      children: <Widget>[
        Icon(iconData),
        Positioned(
            right: -2,
            top: -2,
            child: Icon(Octicons.primitive_dot,
                color: theme.palette.primary, size: 14))
      ],
    );
  }

  List<BottomNavigationBarItem> get _navigationItems {
    switch (Provider.of<AuthModel>(context).activeAccount.platform) {
      case PlatformType.github:
        return [
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            title: Text('News'),
          ),
          BottomNavigationBarItem(
            icon: _buildNotificationIcon(context, false),
            activeIcon: _buildNotificationIcon(context, true),
            title: Text('Notification'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
            title: Text('Trending'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person),
            title: Text('Me'),
          ),
        ];
    }
  }

  GlobalKey<NavigatorState> getNavigatorKey(int index) {
    switch (index) {
      case 0:
        return tab1;
      case 1:
        return tab2;
      case 2:
        return tab3;
      case 3:
        return tab4;
      case 4:
        return tab5;
    }
    return tab1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    final auth = Provider.of<AuthModel>(context);

    if (auth.activeAccount == null) {
      return LoginScreen();
    }

    switch (theme.theme) {
      case AppThemeType.cupertino:
        return WillPopScope(
          onWillPop: () async {
            return !await getNavigatorKey(auth.activeTab)
                .currentState
                ?.maybePop();
          },
          child: CupertinoTabScaffold(
            tabBuilder: (context, index) {
              return CupertinoTabView(
                navigatorKey: getNavigatorKey(index),
                builder: (context) {
                  return _buildScreen(index);
                },
              );
            },
            tabBar: CupertinoTabBar(
              items: _navigationItems,
              currentIndex: auth.activeTab,
              onTap: (index) {
                if (auth.activeTab == index) {
                  getNavigatorKey(index)
                      .currentState
                      ?.popUntil((route) => route.isFirst);
                } else {
                  auth.setActiveTab(index);
                }
              },
            ),
          ),
        );
      default:
        return Scaffold(
          body: _buildScreen(auth.activeTab),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: theme.palette.primary,
            items: _navigationItems,
            currentIndex: auth.activeTab,
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              auth.setActiveTab(index);
            },
          ),
        );
    }
  }
}
