import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gogithub/models/theme.dart';
import 'package:gogithub/utils/global.dart';
import 'package:provider/provider.dart';
import 'package:github/src/const/language_color.dart';

import 'avatar.dart';
import 'link.dart';

class RepositoryItem extends StatelessWidget {
  final String owner;
  final String avatarUrl;
  final String name;
  final String description;
  final IconData iconData;
  final int starCount;
  final int forkCount;
  final String primaryLanguageName;
  final String primaryLanguageColor;
  final String note;
  final String url;
  final String avatarLink;

  RepositoryItem({
    @required this.owner,
    @required this.avatarUrl,
    @required this.name,
    @required this.description,
    @required this.starCount,
    @required this.forkCount,
    this.primaryLanguageName,
    this.primaryLanguageColor,
    this.note,
    this.iconData,
    @required this.url,
    @required this.avatarLink,
  });

  RepositoryItem.gh({
    @required this.owner,
    @required this.avatarUrl,
    @required this.name,
    @required this.description,
    @required this.starCount,
    @required this.forkCount,
    this.primaryLanguageName,
    this.primaryLanguageColor,
    this.note,
    @required bool isPrivate,
    @required bool isFork,
  })  : iconData = _buildIconData(isPrivate, isFork),
        avatarLink = '/github/$owner',
        url = '/github/$owner/$name';

  static IconData _buildIconData(bool isPrivate, bool isFork) {
    if (isPrivate == true) return Octicons.lock;
    if (isFork == true) return Octicons.repo_forked;
    return null;
  }

  static IconData _buildGlIconData(String visibility) {
    switch (visibility) {
      case 'internal':
        return FontAwesome.shield;
      case 'public':
        return FontAwesome.globe;
      case 'private':
        return FontAwesome.lock;
      default:
        return Octicons.repo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    return Link(
      url: url,
      child: Container(
        padding: CommonStyle.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Avatar(
                        url: avatarUrl,
                        size: AvatarSize.small,
                        linkUrl: avatarLink,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text: '$owner / ',
                              style: TextStyle(
                                fontSize: 18,
                                color: theme.palette.primary,
                              ),
                            ),
                            TextSpan(
                              text: name,
                              style: TextStyle(
                                fontSize: 18,
                                color: theme.palette.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (iconData != null) ...[
                        SizedBox(width: 6),
                        DefaultTextStyle(
                          child: Icon(iconData,
                              size: 18, color: theme.palette.secondaryText),
                          style: TextStyle(color: theme.palette.secondaryText),
                        ),
                      ]
                    ],
                  ),
                  SizedBox(height: 8),
                  if (description != null && description.isNotEmpty) ...[
                    Text(
                      description,
                      style: TextStyle(
                        color: theme.palette.secondaryText,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                  if (note != null) ...[
                    Text(
                      note,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.palette.tertiaryText,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                  DefaultTextStyle(
                    style: TextStyle(color: theme.palette.text, fontSize: 14),
                    child: Row(
                      children: <Widget>[
                        if (primaryLanguageName != null) ...[
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: convertColor(primaryLanguageColor ??
                                  languagesColor[primaryLanguageName]),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            primaryLanguageName,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 24),
                        ],
                        if (starCount > 0) ...[
                          Icon(Octicons.star,
                              size: 16, color: theme.palette.text),
                          SizedBox(width: 2),
                          Text(numberFormat.format(starCount)),
                          SizedBox(width: 24),
                        ],
                        if (forkCount > 0) ...[
                          Icon(Octicons.repo_forked,
                              size: 16, color: theme.palette.text),
                          SizedBox(width: 2),
                          Text(numberFormat.format(forkCount)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
