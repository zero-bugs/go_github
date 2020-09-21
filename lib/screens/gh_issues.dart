import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gogithub/graphql/gh.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/scaffolds/list_stateful.dart';
import 'package:gogithub/widgets/action_entry.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/issue_item.dart';
import 'package:gogithub/widgets/label.dart';
import 'package:provider/provider.dart';

class GhIssuesScreen extends StatelessWidget {
  final String owner;
  final String name;
  GhIssuesScreen(this.owner, this.name);

  Future<ListPayload<GhIssuesIssue, String>> _query(BuildContext context,
      [String cursor]) async {
    final res =
        await Provider.of<AuthModel>(context).gqlClient.execute(GhIssuesQuery(
                variables: GhIssuesArguments(
              owner: owner,
              name: name,
              cursor: cursor,
            )));
    final issues = res.data.repository.issues;
    return ListPayload(
      cursor: issues.pageInfo.endCursor,
      hasMore: issues.pageInfo.hasNextPage,
      items: issues.nodes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GhIssuesIssue, String>(
      title: AppBarTitle('Issues'),
      actionBuilder: () => ActionEntry(
        iconData: Octicons.plus,
        url: '/github/$owner/$name/issues/new',
      ),
      onRefresh: () => _query(context),
      onLoadMore: (cursor) => _query(context, cursor),
      itemBuilder: (p) => IssueItem(
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
            '/github/${p.repository.owner.login}/${p.repository.name}/issues/${p.number}',
      ),
    );
  }
}
