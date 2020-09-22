import 'package:flutter/material.dart';
import 'package:gogithub/models/theme.dart';
import 'package:gogithub/utils/global.dart';
import 'package:provider/provider.dart';

import 'avatar.dart';
import 'link.dart';

const userGqlChunk = '''
  login
  name
  avatarUrl
  bio
''';

class UserItem extends StatelessWidget {
  final String login;
  final String name;
  final String avatarUrl;
  final Widget bio;
  final String url;

  UserItem.gh({
    @required this.login,
    @required this.name,
    @required this.avatarUrl,
    @required this.bio,
  }) : url = '/github/$login';

  UserItem({
    @required this.login,
    @required this.name,
    @required this.avatarUrl,
    @required this.bio,
    @required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    return Link(
      url: url,
      child: Container(
        padding: CommonStyle.padding,
        child: Row(
          children: <Widget>[
            Avatar(url: avatarUrl, size: AvatarSize.large),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      // Text(
                      //   name ?? login,
                      //   style: TextStyle(
                      //     color: theme.palette.text,
                      //     fontSize: 18,
                      //   ),
                      // ),
                      // SizedBox(width: 8),
                      Text(
                        login,
                        style: TextStyle(
                          color: theme.palette.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  if (bio != null)
                    DefaultTextStyle(
                      style: TextStyle(
                        color: theme.palette.secondaryText,
                        fontSize: 16,
                      ),
                      child: bio,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
