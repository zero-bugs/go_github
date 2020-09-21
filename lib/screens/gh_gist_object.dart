import 'package:flutter/material.dart';
import 'package:gogithub/scaffolds/common.dart';
import 'package:gogithub/widgets/action_entry.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/blob_view.dart';

class GistObjectScreen extends StatelessWidget {
  final String login;
  final String id;
  final String file;
  final String raw;
  final String content;

  GistObjectScreen(this.login, this.id, this.file, {this.raw, this.content});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        title: AppBarTitle(file),
        action: ActionEntry(
          iconData: Icons.settings,
          url: '/choose-code-theme',
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: BlobView(
              file,
              text: content,
            )));
  }
}
