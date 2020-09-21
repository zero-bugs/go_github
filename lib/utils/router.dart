import 'package:fluro/fluro.dart';
import 'package:gogithub/screens/gh_commits.dart';
import 'package:gogithub/screens/gh_compare.dart';
import 'package:gogithub/screens/gh_contributors.dart';
import 'package:gogithub/screens/gh_files.dart';
import 'package:gogithub/screens/gh_gist_object.dart';
import 'package:gogithub/screens/gh_gists.dart';
import 'package:gogithub/screens/gh_gists_files.dart';
import 'package:gogithub/screens/gh_issue.dart';
import 'package:gogithub/screens/gh_issue_form.dart';
import 'package:gogithub/screens/gh_issues.dart';
import 'package:gogithub/screens/gh_object.dart';
import 'package:gogithub/screens/gh_org_repos.dart';
import 'package:gogithub/screens/gh_pulls.dart';
import 'package:gogithub/screens/gh_repo.dart';
import 'package:gogithub/screens/gh_repos.dart';
import 'package:gogithub/screens/gh_user.dart';
import 'package:gogithub/screens/gh_user_organization.dart';
import 'package:gogithub/screens/gh_users.dart';
import 'package:gogithub/screens/login.dart';
import 'package:gogithub/screens/settings.dart';
import 'package:gogithub/widgets/code_theme.dart';

class RouterScreen {
  String path;
  HandlerFunc handler;
  RouterScreen(this.path, this.handler);
}

class CommonRouter {
  static const prefix = '';
  static final routes = [
    CommonRouter.codeTheme,
    CommonRouter.login,
    CommonRouter.settings
  ];
  static final codeTheme = RouterScreen('/choose-code-theme', (context, p) {
    return CodeThemeScreen();
  });
  static final login = RouterScreen('/login', (context, p) => LoginScreen());
  static final settings =
      RouterScreen('/settings', (context, parameters) => SettingsScreen());
}

class GithubRouter {
  static const prefix = '/github';
  static final routes = [
    GithubRouter.user,
    GithubRouter.repo,
    GithubRouter.issueAdd,
    GithubRouter.issues,
    GithubRouter.pulls,
    GithubRouter.issue,
    GithubRouter.pull,
    GithubRouter.commits,
    GithubRouter.object,
    GithubRouter.stargazers,
    GithubRouter.watchers,
    GithubRouter.contributors,
    GithubRouter.files,
    GithubRouter.gistFiles,
    GithubRouter.gistObject,
    GithubRouter.compare,
  ];
  static final user = RouterScreen('/:login', (_, p) {
    final login = p['login'].first;
    final tab = p['tab']?.first;
    switch (tab) {
      case 'followers':
        return GhUsersScreen(login, UsersScreenType.follower);
      case 'following':
        return GhUsersScreen(login, UsersScreenType.following);
      case 'people':
        return GhUsersScreen(login, UsersScreenType.member);
      case 'stars':
        return GhReposScreen.stars(login);
      case 'repositories':
        return GhReposScreen(login);
      case 'orgrepo':
        return GhOrgReposScreen(login);
      case 'organizations':
        return GhUserOrganizationScreen(login);
      case 'gists':
        return GhGistsScreen(login);
      default:
        return GhUserScreen(login);
    }
  });
  static final repo = RouterScreen('/:owner/:name', (_, p) {
    if (p['ref'] == null) {
      return GhRepoScreen(p['owner'].first, p['name'].first);
    } else {
      return GhRepoScreen(p['owner'].first, p['name'].first,
          branch: p['ref'].first);
    }
  });
  static final gistObject = RouterScreen('/:login/gists/:id/:file', (_, p) {
    return GistObjectScreen(
      p['login'].first,
      p['id'].first,
      p['file'].first,
      raw: p['raw']?.first,
      content: p['content'].first,
    );
  });
  static final gistFiles = RouterScreen('/:login/gists/:id', (_, p) {
    return GhGistsFilesScreen(p['login'].first, p['id'].first);
  });
  static final issueAdd = RouterScreen('/:owner/:name/issues/new', (_, p) {
    return GhIssueFormScreen(p['owner'].first, p['name'].first);
  });
  static final issues = RouterScreen('/:owner/:name/issues',
      (context, p) => GhIssuesScreen(p['owner'].first, p['name'].first));
  static final pulls = RouterScreen('/:owner/:name/pulls',
      (context, p) => GhPullsScreen(p['owner'].first, p['name'].first));
  static final issue = RouterScreen(
      '/:owner/:name/issues/:number',
      (context, p) => GhIssueScreen(
          p['owner'].first, p['name'].first, int.parse(p['number'].first)));
  static final pull = RouterScreen(
      '/:owner/:name/pull/:number',
      (context, p) => GhIssueScreen(
          p['owner'].first, p['name'].first, int.parse(p['number'].first),
          isPullRequest: true));
  static final files = RouterScreen(
      '/:owner/:name/pull/:number/files',
      (context, p) => GhFilesScreen(
            p['owner'].first,
            p['name'].first,
            int.parse(p['number'].first),
          ));
  static final compare = RouterScreen(
      '/:owner/:name/compare/:before/:head',
      (context, p) => GhComparisonScreen(p['owner'].first, p['name'].first,
          p['before'].first, p['head'].first));
  static final commits = RouterScreen('/:owner/:name/commits',
      (context, p) => GhCommitsScreen(p['owner'].first, p['name'].first));
  static final object = RouterScreen('/:owner/:name/blob/:ref', (_, p) {
    return GhObjectScreen(
      p['owner'].first,
      p['name'].first,
      p['ref'].first,
      path: p['path']?.first,
      raw: p['raw']?.first,
    );
  });
  static final stargazers = RouterScreen('/:owner/:name/stargazers', (_, p) {
    return GhUsersScreen(p['owner'].first, UsersScreenType.star,
        repoName: p['name'].first);
  });
  static final watchers = RouterScreen('/:owner/:name/watchers', (_, p) {
    return GhUsersScreen(p['owner'].first, UsersScreenType.watch,
        repoName: p['name'].first);
  });
  static final contributors =
      RouterScreen('/:owner/:name/contributors', (_, p) {
    return GhContributorsScreen(p['owner'].first, p['name'].first);
  });
}
