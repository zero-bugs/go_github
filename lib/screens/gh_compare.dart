import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/models/github.dart';
import 'package:gogithub/widgets/action_button.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/common/refresh_stateful.dart';
import 'package:gogithub/widgets/file_item.dart';
import 'package:provider/provider.dart';

class GhComparisonScreen extends StatelessWidget {
  final String owner;
  final String name;
  final String before;
  final String head;
  GhComparisonScreen(this.owner, this.name, this.before, this.head);

  Widget build(BuildContext context) {
    return RefreshStatefulScaffold(
      title: AppBarTitle('Files'),
      fetchData: () async {
        final auth = Provider.of<AuthModel>(context);
        final res = await auth.ghClient.getJSON(
          '/repos/$owner/$name/compare/$before...$head',
          convert: (vs) => GithubComparisonItem.fromJson(vs),
        );
        return res.files;
      },
      actionBuilder: (v, _) {
        return ActionButton(
          title: 'Actions',
          items: [
            ...ActionItem.getUrlActions(
                'https://github.com/$owner/$name/compare/$before...$head'),
          ],
        );
      },
      bodyBuilder: (v, _) {
        return Wrap(
          children: v
              .map<Widget>((vs) => FilesItem(
                    filename: vs.filename,
                    additions: vs.additions,
                    deletions: vs.deletions,
                    status: vs.status,
                    changes: vs.changes,
                    patch: vs.patch,
                  ))
              .toList(),
        );
      },
    );
  }
}
