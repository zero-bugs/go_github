import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/models/github.dart';
import 'package:gogithub/scaffolds/list_stateful.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/gists_item.dart';
import 'package:provider/provider.dart';

class GhGistsScreen extends StatelessWidget {
  final String login;
  GhGistsScreen(this.login);

  Future<ListPayload<GithubGistsItem, int>> _query(BuildContext context,
      [int page = 1]) async {
    final auth = Provider.of<AuthModel>(context);
    final res = await auth.ghClient.getJSON<List, List<GithubGistsItem>>(
      '/users/$login/gists?page=$page',
      convert: (vs) => [for (var v in vs) GithubGistsItem.fromJson(v)],
    );
    return ListPayload(
      cursor: page + 1,
      items: res,
      hasMore: res.isNotEmpty,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GithubGistsItem, int>(
      title: AppBarTitle('Gists'),
      onRefresh: () => _query(context),
      onLoadMore: (cursor) => _query(context, cursor),
      itemBuilder: (v) {
        return GistsItem(
          description: v.description,
          login: login,
          files: v.files,
          filenames: v.fileNames,
          language: v.fileNames[0].language,
          avatarUrl: v.owner.avatarUrl,
          updatedAt: v.updatedAt,
          id: v.id,
        );
      },
      actionBuilder: () {},
    );
  }
}
