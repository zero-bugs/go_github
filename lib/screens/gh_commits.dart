import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gogithub/graphql/gh.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/scaffolds/list_stateful.dart';
import 'package:gogithub/utils/global.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/commit_item.dart';
import 'package:provider/provider.dart';

class GhCommitsScreen extends StatelessWidget {
  final String owner;
  final String name;
  final String branch;
  GhCommitsScreen(this.owner, this.name, {this.branch});

  Future<ListPayload<GhCommitsCommit, String>> _query(BuildContext context,
      [String cursor]) async {
    final res = await Provider.of<AuthModel>(context).gqlClient.execute(
        GhCommitsQuery(
            variables: GhCommitsArguments(
                owner: owner,
                name: name,
                hasRef: branch != null,
                ref: branch ?? '',
                after: cursor)));
    final ref = res.data.repository.defaultBranchRef ?? res.data.repository.ref;
    final history = (ref.target as GhCommitsCommit).history;
    return ListPayload(
      cursor: history.pageInfo.endCursor,
      hasMore: history.pageInfo.hasNextPage,
      items: history.nodes,
    );
  }

  Widget _buildStatus(GhCommitsStatusState state) {
    const size = 18.0;
    switch (state) {
      case GhCommitsStatusState.SUCCESS:
        return Icon(Octicons.check, color: GithubPalette.open, size: size);
      case GhCommitsStatusState.FAILURE:
        return Icon(Octicons.x, color: GithubPalette.closed, size: size);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GhCommitsCommit, String>(
      title: AppBarTitle('Commits'),
      onRefresh: () => _query(context),
      onLoadMore: (cursor) => _query(context, cursor),
      itemBuilder: (payload) {
        final login = payload.author?.user?.login;
        return CommitItem(
          url: payload.url,
          avatarUrl: payload.author?.avatarUrl,
          avatarLink: login == null ? null : '/github/$login',
          message: payload.messageHeadline,
          author: login ?? payload.author.name,
          createdAt: payload.committedDate,
          widgets: payload.status == null
              ? null
              : [
                  SizedBox(width: 4),
                  _buildStatus(payload.status.state),
                ],
        );
      },
      actionBuilder: () {},
    );
  }
}
