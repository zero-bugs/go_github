import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:github/github.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/models/github.dart';
import 'package:gogithub/models/notification.dart';
import 'package:gogithub/models/theme.dart';
import 'package:gogithub/widgets/action_entry.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/empty.dart';
import 'package:gogithub/widgets/list_group.dart';
import 'package:gogithub/widgets/notification_item.dart';
import 'package:gogithub/widgets/tab_stateful.dart';
import 'package:provider/provider.dart';

class GhNotificationScreen extends StatefulWidget {
  @override
  GhNotificationScreenState createState() => GhNotificationScreenState();
}

class GhNotificationScreenState extends State<GhNotificationScreen> {
  Future<Map<String, NotificationGroup>> fetchNotifications(int index) async {
    final ns =
        await Provider.of<AuthModel>(context, listen: false).ghClient.getJSON(
              '/notifications?all=${index == 2}&participating=${index == 1}',
              convert: (vs) =>
                  [for (var v in vs) GithubNotificationItem.fromJson(v)],
            );
    if (index == 0) {
      Provider.of<NotificationModel>(context, listen: false)
          .setCount(ns.length);
    }

    Map<String, NotificationGroup> _groupMap = {};

    ns.forEach((item) {
      final repo = item.repository.fullName;
      if (_groupMap[repo] == null) {
        _groupMap[repo] = NotificationGroup(repo);
      }

      _groupMap[repo].items.add(item);
    });

    if (_groupMap.isNotEmpty) {
      // query state of issues and pull requests
      var schema = '{';
      _groupMap.forEach((repo, group) {
        // Check if issue and pull request exist
        if (group.items.where((item) {
          return item.subject.type == 'Issue' ||
              item.subject.type == 'PullRequest';
        }).isEmpty) {
          return;
        }

        schema +=
            '${group.key}: repository(owner: "${group.owner}", name: "${group.name}") {';

        group.items.forEach((item) {
          switch (item.subject.type) {
            case 'Issue':
              schema += '''
${item.key}: issue(number: ${item.subject.number}) {
  state
}
''';
              break;
            case 'PullRequest':
              schema += '''
${item.key}: pullRequest(number: ${item.subject.number}) {
  state
}
''';
              break;
          }
        });

        schema += '}';
      });
      schema += '}';

      if (schema == '{}') return _groupMap;

      // Fimber.d(schema);
      var data = await Provider.of<AuthModel>(context).graphQuery(schema);
      _groupMap.forEach((repo, group) {
        group.items.forEach((item) {
          var groupData = data[group.key];
          if (groupData == null) return;

          var itemData = data[group.key][item.key];
          if (itemData != null) {
            item.state = itemData['state'];
          }
        });
      });
      // Fimber.d(data);
    }

    return _groupMap;
  }

  Widget _buildGroupItem(
    BuildContext context,
    MapEntry<String, NotificationGroup> entry,
    Map<String, NotificationGroup> groupMap,
  ) {
    final theme = Provider.of<ThemeModel>(context);
    final group = entry.value;
    return ListGroup(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            group.fullName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.palette.text,
            ),
          ),
          GestureDetector(
            onTap: () async {
              final auth = Provider.of<AuthModel>(context);
              await auth.ghClient.activity.markRepositoryNotificationsRead(
                  RepositorySlug.full(group.fullName));
              // await _onSwitchTab(); // TODO:
            },
            child: Icon(
              Octicons.check,
              color: theme.palette.tertiaryText,
              size: 24,
            ),
          ),
        ],
      ),
      items: group.items,
      itemBuilder: (item, index) {
        return NotificationItem(
          payload: item,
          markAsRead: () {
            if (mounted) {
              setState(() {
                groupMap[entry.key].items[index].unread = false;
              });
            }
          },
        );
      },
    );
  }

  @override
  Widget build(context) {
    return TabStatefulScaffold(
      title: AppBarTitle('Notifications'),
      tabs: ['Unread', 'Participating', 'All'],
      fetchData: fetchNotifications,
      bodyBuilder: (groupMap, activeTab) {
        if (groupMap.isEmpty) return EmptyWidget();

        return Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 10)),
            ...groupMap.entries
                .map((entry) => _buildGroupItem(context, entry, groupMap))
                .toList()
          ],
        );
      },
      actionBuilder: (_, refresh) => ActionEntry(
        iconData: Icons.done_all,
        onTap: () async {
          var value = await Provider.of<ThemeModel>(context)
              .showConfirm(context, Text('Mark all as read?'));
          if (value) {
            await Provider.of<AuthModel>(context)
                .ghClient
                .activity
                .markNotificationsRead();
            refresh();
          }
        },
      ),
    );
  }
}
