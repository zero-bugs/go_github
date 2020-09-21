import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/models/github.dart';
import 'package:gogithub/scaffolds/list_stateful.dart';
import 'package:gogithub/widgets/action_button.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/file_item.dart';
import 'package:provider/provider.dart';

class GhFilesScreen extends StatelessWidget {
  final String owner;
  final String name;
  final int pullNumber;
  GhFilesScreen(this.owner, this.name, this.pullNumber);

  Future<ListPayload<GithubFilesItem, int>> _query(BuildContext context,
      [int page = 1]) async {
    final auth = Provider.of<AuthModel>(context);
    final res = await auth.ghClient.getJSON<List, List<GithubFilesItem>>(
      '/repos/$owner/$name/pulls/$pullNumber/files?page=$page',
      convert: (vs) => [for (var v in vs) GithubFilesItem.fromJson(v)],
    );
    return ListPayload(
      cursor: page + 1,
      items: res,
      hasMore: res.isNotEmpty,
    );
  }

  Widget build(BuildContext context) {
    return ListStatefulScaffold<GithubFilesItem, int>(
      title: AppBarTitle('Files'),
      actionBuilder: () {
        return ActionButton(
          title: 'Actions',
          items: [
            ...ActionItem.getUrlActions(
                'https://github.com/$owner/$name/pull/$pullNumber/files'),
          ],
        );
      },
      onRefresh: () => _query(context),
      onLoadMore: (cursor) => _query(context, cursor),
      itemBuilder: (v) {
        return FilesItem(
          filename: v.filename,
          additions: v.additions,
          deletions: v.deletions,
          status: v.status,
          changes: v.changes,
          patch: v.patch,
        );
      },
    );
  }
}
