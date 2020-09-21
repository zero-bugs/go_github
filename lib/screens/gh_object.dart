import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:github/github.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/utils/global.dart';
import 'package:gogithub/widgets/action_entry.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/blob_view.dart';
import 'package:gogithub/widgets/common/refresh_stateful.dart';
import 'package:gogithub/utils/extensions.dart';
import 'package:gogithub/widgets/object_tree.dart';
import 'package:provider/provider.dart';

class GhObjectScreen extends StatelessWidget {
  final String owner;
  final String name;
  final String ref;
  final String path;
  final String raw;
  GhObjectScreen(this.owner, this.name, this.ref, {this.path, this.raw});

  @override
  Widget build(BuildContext context) {
    return RefreshStatefulScaffold<RepositoryContents>(
      // canRefresh: !_isImage, // TODO:
      title: AppBarTitle(path == null ? 'Files' : path),
      fetchData: () async {
        // Do not request again for images
        if (path != null &&
            raw != null &&
            ['png', 'jpg', 'jpeg', 'gif', 'webp'].contains(path.ext)) {
          return RepositoryContents(
            file: GitHubFile(downloadUrl: raw, content: ''),
          );
        }

        final suffix = path == null ? '' : '/$path';
        final auth = Provider.of<AuthModel>(context);
        final res = await auth.ghClient.repositories
            .getContents(RepositorySlug(owner, name), suffix, ref: ref);
        if (res.isDirectory) {
          res.tree.sort((a, b) {
            return sortByKey('dir', a.type, b.type);
          });
        }
        return res;
      },
      actionBuilder: (data, _) {
        if (data.isFile) {
          return ActionEntry(
            iconData: Icons.settings,
            url: '/choose-code-theme',
          );
        }
      },
      bodyBuilder: (data, _) {
        if (data.isDirectory) {
          return ObjectTree(
            items: data.tree.map((v) {
              // if (item.type == 'commit') return null;
              final uri = Uri(
                path: '/github/$owner/$name/blob/$ref',
                queryParameters: {
                  'path': v.path,
                  ...(v.downloadUrl == null ? {} : {'raw': v.downloadUrl}),
                },
              ).toString();
              return ObjectTreeItem(
                name: v.name,
                type: v.type,
                url: uri.toString(),
                downloadUrl: v.downloadUrl,
                size: v.type == 'file' ? v.size : null,
              );
            }),
          );
        } else {
          // TODO: Markdown base path
          // basePaths: [owner, name, branch, ...paths]
          return BlobView(
            path,
            text: data.file.text,
            networkUrl: data.file.downloadUrl,
          );
        }
      },
    );
  }
}
