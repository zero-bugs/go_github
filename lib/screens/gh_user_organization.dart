import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/models/github.dart';
import 'package:gogithub/scaffolds/list_stateful.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/user_organizations.dart';
import 'package:provider/provider.dart';

class GhUserOrganizationScreen extends StatelessWidget {
  final String login;
  GhUserOrganizationScreen(this.login);

  Future<ListPayload<GithubUserOrganizationItem, int>> _query(
      BuildContext context,
      [int page = 1]) async {
    final auth = Provider.of<AuthModel>(context);
    final res =
        await auth.ghClient.getJSON<List, List<GithubUserOrganizationItem>>(
      '/users/$login/orgs?page=$page',
      convert: (vs) =>
          [for (var v in vs) GithubUserOrganizationItem.fromJson(v)],
    );
    return ListPayload(
      cursor: page + 1,
      items: res,
      hasMore: res.isNotEmpty,
    );
  }

  Widget build(BuildContext context) {
    return ListStatefulScaffold<GithubUserOrganizationItem, int>(
      title: AppBarTitle('Organizations'),
      onRefresh: () => _query(context),
      onLoadMore: (cursor) => _query(context, cursor),
      itemBuilder: (v) {
        final String login = v.login;
        return UserOrganizationItem(
          avatarUrl: v.avatarUrl,
          login: v.login,
          url: '/github/$login',
          description: v.description,
        );
      },
      actionBuilder: () {},
    );
  }
}
