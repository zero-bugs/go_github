import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gogithub/graphql/gh.dart';
import 'package:gogithub/models/auth.dart';
import 'package:gogithub/models/theme.dart';
import 'package:gogithub/scaffolds/list_stateful.dart';
import 'package:gogithub/utils/global.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/user_item.dart';
import 'package:provider/provider.dart';

enum UsersScreenType {
  follower,
  following,
  member,
  watch,
  star,
}

class GhUsersScreen extends StatelessWidget {
  final String login;
  final String repoName;
  final UsersScreenType type;

  GhUsersScreen(this.login, this.type, {this.repoName = ''});

  String get _title {
    switch (type) {
      case UsersScreenType.follower:
        return 'Followers';
      case UsersScreenType.following:
        return 'Following';
      case UsersScreenType.member:
        return 'Members';
      case UsersScreenType.watch:
        return 'Watchers';
      case UsersScreenType.star:
        return 'Stargazers';
      default:
        return null;
    }
  }

  Future<ListPayload<GhUsersUser, String>> _queryUsers(BuildContext context,
      [String cursor]) async {
    final res = await Provider.of<AuthModel>(context).gqlClient.execute(
        GhUsersQuery(
            variables: GhUsersArguments(
                login: login,
                repoName: repoName,
                isFollowers: type == UsersScreenType.follower,
                isFollowing: type == UsersScreenType.following,
                isStar: type == UsersScreenType.star,
                isWatch: type == UsersScreenType.watch,
                isMember: type == UsersScreenType.member,
                after: cursor)));

    switch (type) {
      case UsersScreenType.follower:
        final payload = res.data.user.followers;
        return ListPayload(
          cursor: payload.pageInfo.endCursor,
          hasMore: payload.pageInfo.hasNextPage,
          items: payload.nodes,
        );
      case UsersScreenType.following:
        final payload = res.data.user.following;
        return ListPayload(
          cursor: payload.pageInfo.endCursor,
          hasMore: payload.pageInfo.hasNextPage,
          items: payload.nodes,
        );
      case UsersScreenType.member:
        final payload = res.data.organization.membersWithRole;
        return ListPayload(
          cursor: payload.pageInfo.endCursor,
          hasMore: payload.pageInfo.hasNextPage,
          items: payload.nodes,
        );
      case UsersScreenType.watch:
        final payload = res.data.repository.watchers;
        return ListPayload(
          cursor: payload.pageInfo.endCursor,
          hasMore: payload.pageInfo.hasNextPage,
          items: payload.nodes,
        );
      case UsersScreenType.star:
        final payload = res.data.repository.stargazers;
        return ListPayload(
          cursor: payload.pageInfo.endCursor,
          hasMore: payload.pageInfo.hasNextPage,
          items: payload.nodes,
        );
      default:
        return null;
    }
  }

  Widget _buildBio(BuildContext context, String company, String location,
      DateTime createdAt) {
    final theme = Provider.of<ThemeModel>(context);
    if (company != null && company.isNotEmpty) {
      return Row(
        children: <Widget>[
          Icon(
            Octicons.organization,
            size: 15,
            color: theme.palette.secondaryText,
          ),
          SizedBox(width: 4),
          Expanded(child: Text(company, overflow: TextOverflow.ellipsis)),
        ],
      );
    }
    if (location != null && location.isNotEmpty) {
      return Row(
        children: <Widget>[
          Icon(
            Octicons.location,
            size: 15,
            color: theme.palette.secondaryText,
          ),
          SizedBox(width: 4),
          Expanded(child: Text(location, overflow: TextOverflow.ellipsis)),
        ],
      );
    }
    return Row(
      children: <Widget>[
        Icon(
          Octicons.clock,
          size: 15,
          color: theme.palette.secondaryText,
        ),
        SizedBox(width: 4),
        Expanded(
            child: Text('Joined on ${dateFormat.format(createdAt)}',
                overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GhUsersUser, String>(
      title: AppBarTitle(_title),
      onRefresh: () => _queryUsers(context),
      onLoadMore: (cursor) => _queryUsers(context, cursor),
      itemBuilder: (payload) {
        return UserItem.gh(
          login: payload.login,
          // name: payload.name,
          avatarUrl: payload.avatarUrl,
          bio: _buildBio(
              context, payload.company, payload.location, payload.createdAt),
        );
      },
      actionBuilder: () {},
    );
  }
}
