import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/models/github.dart';
import 'package:gogithub/models/notification.dart';
import 'package:gogithub/scaffolds/list_stateful.dart';
import 'package:gogithub/utils/global.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/event_item.dart';
import 'package:provider/provider.dart';

class GhNewsScreen extends StatefulWidget {
  @override
  GhNewsScreenState createState() => GhNewsScreenState();
}

class GhNewsScreenState extends State<GhNewsScreen> {
  @override
  initState() {
    super.initState();
    Future.microtask(() async {
      // Check if there are unread notification items.
      // 1 item is enough since count is not displayed for now.
      var items = await Provider.of<AuthModel>(context, listen: false)
          .ghClient
          .getJSON('/notifications?per_page=1');

      if (items is List && items.isNotEmpty) {
        Provider.of<NotificationModel>(context).setCount(1);
      }
    });
  }

  Future<ListPayload<GithubEvent, int>> fetchEvents([int page = 1]) async {
    final auth = Provider.of<AuthModel>(context);
    final login = auth.activeAccount.login;

    final events = await auth.ghClient.getJSON(
      '/users/$login/received_events?page=$page&per_page=$pageSize',
      convert: (vs) => [for (var v in vs) GithubEvent.fromJson(v)],
    );
    Fimber.d("events:${events.toString()}");
    return ListPayload(
      cursor: page + 1,
      hasMore: events.length == pageSize,
      items: events,
    );
  }

  @override
  Widget build(context) {
    return ListStatefulScaffold<GithubEvent, int>(
      title: AppBarTitle('News'),
      itemBuilder: (payload) => EventItem(payload),
      onRefresh: fetchEvents,
      onLoadMore: (page) => fetchEvents(page),
    );
  }
}
