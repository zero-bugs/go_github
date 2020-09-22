import 'package:flutter/cupertino.dart';
import 'package:gogithub/models/theme.dart';
import 'package:provider/provider.dart';

import 'link.dart';

class AvatarSize {
  static const double extraSmall = 20;
  static const double small = 24;
  static const double medium = 36;
  static const double large = 48;
  static const double extraLarge = 64;
}

class Avatar extends StatelessWidget {
  final String url;
  final double size;
  final String linkUrl;
  final BorderRadius borderRadius;

  Avatar({
    @required this.url,
    this.size = AvatarSize.medium,
    this.linkUrl,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = 'imgs/avatar-default.png';
    final widget = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
      child: url == null
          ? Image.asset(fallback, width: size, height: size)
          : FadeInImage.assetNetwork(
              placeholder: fallback,
              image: url,
              width: size,
              height: size,
              fadeInDuration: Duration(milliseconds: 200),
              fadeOutDuration: Duration(milliseconds: 100),
            ),
    );
    if (linkUrl == null) return widget;
    return Link(
      child: widget,
      onTap: () {
        Provider.of<ThemeModel>(context).push(context, linkUrl);
      },
    );
  }
}

class GithubAvatar extends StatelessWidget {
  final String url;
  final double size;
  final String login;

  GithubAvatar({
    @required this.url,
    this.size = AvatarSize.medium,
    this.login,
  });

  @override
  Widget build(BuildContext context) {
    return Avatar(url: url, size: size, linkUrl: '/github/$login');
  }
}

class GitlabAvatar extends StatelessWidget {
  final String url;
  final double size;
  final int id;

  GitlabAvatar({
    @required this.url,
    @required this.id,
    this.size = AvatarSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Avatar(
      url: url,
      size: size,
      linkUrl: '/gitlab/user/$id',
    );
  }
}
