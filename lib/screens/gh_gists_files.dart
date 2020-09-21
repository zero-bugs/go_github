import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/models/github.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/common/refresh_stateful.dart';
import 'package:gogithub/widgets/object_tree.dart';
import 'package:provider/provider.dart';

class GhGistsFilesScreen extends StatelessWidget {
  final String id;
  final String login;
  GhGistsFilesScreen(this.login, this.id);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(context);
    return RefreshStatefulScaffold<GithubGistsItem>(
      title: AppBarTitle('Files'),
      fetchData: () async {
        final data = await auth.ghClient.getJSON(
          '/gists/$id',
          convert: (vs) => GithubGistsItem.fromJson(vs),
        );
        return data;
      },
      bodyBuilder: (payload, _) {
        return ObjectTree(
          items: payload.fileNames.map((v) {
            final uri = Uri(
              path: '/github/$login/gists/$id/${v.filename}',
              queryParameters: {
                'content': v.content,
                ...(v.rawUrl == null ? {} : {'raw': v.rawUrl}),
              },
            ).toString();
            return ObjectTreeItem(
              url: uri,
              type: 'file',
              name: v.filename,
              downloadUrl: v.rawUrl,
              size: v.size,
            );
          }),
        );
      },
    );
  }
}
