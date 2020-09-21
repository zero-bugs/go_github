import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/models/github.dart';
import 'package:gogithub/scaffolds/list_stateful.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/contributor_item.dart';
import 'package:provider/provider.dart';

class GhContributorsScreen extends StatelessWidget {
  final String owner;
  final String name;
  GhContributorsScreen(this.owner, this.name);

  Future<ListPayload<GithubContributorItem, int>> _query(BuildContext context,
      [int page = 1]) async {
    final auth = Provider.of<AuthModel>(context);
    final res = await auth.ghClient.getJSON<List, List<GithubContributorItem>>(
      '/repos/$owner/$name/contributors?page=$page',
      convert: (vs) => [for (var v in vs) GithubContributorItem.fromJson(v)],
    );
    return ListPayload(
      cursor: page + 1,
      items: res,
      hasMore: res.isNotEmpty,
    );
  }

  Widget build(BuildContext context) {
    return ListStatefulScaffold<GithubContributorItem, int>(
      title: AppBarTitle('Contributors'),
      onRefresh: () => _query(context),
      onLoadMore: (cursor) => _query(context, cursor),
      itemBuilder: (v) {
        final String login = v.login;
        return ContributorItem(
          avatarUrl: v.avatarUrl,
          commits: v.contributions,
          login: v.login,
          url: '/github/$login?tab=contributors',
        );
      },
      actionBuilder: () {},
    );
  }
}
