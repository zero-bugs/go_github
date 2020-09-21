import 'package:flutter/material.dart';
import 'package:gogithub/graphql/gh.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/scaffolds/list_stateful.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/issue_item.dart';
import 'package:gogithub/widgets/label.dart';
import 'package:provider/provider.dart';

class GhPullsScreen extends StatelessWidget {
  final String owner;
  final String name;
  GhPullsScreen(this.owner, this.name);

  Future<ListPayload<GhPullsPullRequest, String>> _query(BuildContext context,
      [String cursor]) async {
    final res =
        await Provider.of<AuthModel>(context).gqlClient.execute(GhPullsQuery(
                variables: GhPullsArguments(
              owner: owner,
              name: name,
              cursor: cursor,
            )));
    final pulls = res.data.repository.pullRequests;
    return ListPayload(
      cursor: pulls.pageInfo.endCursor,
      hasMore: pulls.pageInfo.hasNextPage,
      items: pulls.nodes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GhPullsPullRequest, String>(
      title: AppBarTitle('Pull requests'),
      onRefresh: () => _query(context),
      onLoadMore: (cursor) => _query(context, cursor),
      itemBuilder: (p) => IssueItem(
        isPr: true,
        author: p.author?.login,
        avatarUrl: p.author?.avatarUrl,
        commentCount: p.comments.totalCount,
        number: p.number,
        title: p.title,
        updatedAt: p.updatedAt,
        labels: p.labels.nodes.isEmpty
            ? null
            : Wrap(spacing: 4, runSpacing: 4, children: [
                for (var label in p.labels.nodes)
                  MyLabel(name: label.name, cssColor: label.color)
              ]),
        url:
            '/github/${p.repository.owner.login}/${p.repository.name}/pull/${p.number}',
      ),
      actionBuilder: () {},
    );
  }
}
