import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gogithub/models/gt_tr_developer.dart';
import 'package:gogithub/models/gt_tr_repository.dart';
import 'package:gogithub/models/theme.dart';
import 'package:gogithub/spider/gt_trending_spider.dart';
import 'package:gogithub/utils/global.dart';
import 'package:gogithub/widgets/app_bar_title.dart';
import 'package:gogithub/widgets/link.dart';
import 'package:gogithub/widgets/repository_item.dart';
import 'package:gogithub/widgets/tab_stateful.dart';
import 'package:gogithub/widgets/user_item.dart';

import 'package:provider/provider.dart';

class GhTrendingScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return TabStatefulScaffold<List>(
      title: AppBarTitle('Trending'),
      tabs: ['Repositories', 'Developers'],
      fetchData: (tabIndex) async {
        if (tabIndex == 0) {
          return getTrendingRepositories();
        } else {
          return getTrendingDevelopers();
        }
      },
      bodyBuilder: (payload, activeTab) {
        final theme = Provider.of<ThemeModel>(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: join(
            CommonStyle.border,
            activeTab == 0
                ? [
                    for (var v in payload.cast<TrendingRepository>())
                      RepositoryItem.gh(
                        owner: v.owner,
                        avatarUrl: v.avatar,
                        name: v.name,
                        description: v.description,
                        starCount: v.stars ?? 0,
                        forkCount: v.forkCount ?? 0,
                        primaryLanguageName: v.primaryLanguage?.name,
                        primaryLanguageColor: v.primaryLanguage?.color,
                        note: '${v.stars}',
                        isPrivate: false,
                        isFork: false, // TODO:
                      )
                  ]
                : [
                    for (var v in payload.cast<TrendingDeveloper>())
                      UserItem.gh(
                        login: v.username,
                        name: v.nickname,
                        avatarUrl: v.avatar,
                        bio: Link(
                          url:
                              '/github/${v.username}/${v.popularRepository == null ? "" : v.popularRepository.name}',
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Octicons.repo,
                                size: 17,
                                color: theme.palette.secondaryText,
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                  child: Text(
                                '${v.username} / ${v.popularRepository == null ? "" : v.popularRepository.name}',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: theme.palette.secondaryText,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ))
                            ],
                          ),
                        ),
                      )
                  ],
          ),
        );
      },
    );
  }
}
