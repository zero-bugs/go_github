import 'package:gogithub/models/gt_tr_developer.dart';
import 'package:gogithub/models/gt_tr_repository.dart';
import 'package:gogithub/utils/client.dart';
import 'package:html/parser.dart' show parse;

const URL_ADDRESS = 'https://github.com';

class TrendingType {
  static const repository = 'repository';
  static const developer = 'developer';
}

// 查询条件
class TrendingSince {
  static const daily = 'daily';
  static const weekly = 'weekly';
  static const monthly = 'monthly';
}

Future<List<TrendingRepository>> getTrendingRepositories({
  String since,
  String language,
  String spokenLanguageCode,
}) async {
  var url = '${URL_ADDRESS}/trending';
  if (language != null) {
    url += '/$language';
  }

  if (since != null && spokenLanguageCode != null) {
    url += '?since=$since&spoken_language_code=$spokenLanguageCode';
  } else if (since != null) {
    url += '?since=$since';
  } else if (spokenLanguageCode != null) {
    url += '?spoken_language_code=$spokenLanguageCode';
  }

  var res = await httpClient.get(url);
  var document = parse(res.body);
  var items = document.querySelectorAll('.Box-row');
  return items.map((item) {
    var colorNode = item.querySelector('.repo-language-color');
    PrimaryLanguage primaryLanguage;
    if (colorNode != null) {
      primaryLanguage = PrimaryLanguage(
        name: colorNode.nextElementSibling?.innerHtml?.trim(),
        color: RegExp(r'#[0-9a-fA-F]{3,6}')
            .firstMatch(colorNode.attributes['style'])
            ?.group(0),
      );
    }

    // print('primary language:${primaryLanguage?.toJson()}');

    var username = item
        .querySelector('.text-normal')
        ?.innerHtml
        ?.replaceFirst('/', '')
        ?.trim();

    var name = item
        .querySelector('.text-normal')
        ?.parent
        ?.innerHtml
        ?.replaceAll(RegExp(r'^[\s\S]*span>'), '')
        ?.trim();

    // print('name ${item.querySelector('.text-normal')?.parent?.innerHtml}');

    String description;
    String descriptionHTML;
    var descriptionRawHtml = item.querySelector('p')?.innerHtml?.trim();
    if (descriptionRawHtml != null) {
      description = descriptionRawHtml
          ?.replaceAll(RegExp(r'<g-emoji.*?>'), '')
          ?.replaceAll(RegExp(r'</g-emoji>'), '')
          ?.replaceAll(RegExp(r'<a.*?>'), '')
          ?.replaceAll(RegExp(r'</a>'), '');
      descriptionHTML = '<div>$descriptionRawHtml</div>';
    }

    var starCountStr = item
        .querySelector('.f6')
        ?.querySelector('.octicon-star')
        ?.parent
        ?.innerHtml
        ?.replaceAll(RegExp(r'^[\s\S]*svg>'), '')
        ?.replaceAll(',', '')
        ?.trim();

    var starCount = starCountStr == null ? null : int.tryParse(starCountStr);

    var forkCountStr = item
        .querySelector('.octicon-repo-forked')
        ?.parent
        ?.innerHtml
        ?.replaceAll(RegExp(r'^[\s\S]*svg>'), '')
        ?.replaceAll(',', '')
        ?.trim();
    var forkCount = forkCountStr == null ? null : int.tryParse(forkCountStr);

    var starsStr = item
        .querySelector('.float-sm-right')
        ?.innerHtml
        ?.replaceAll(RegExp(r'^[\s\S]*svg>'), '')
        ?.replaceAll(',', '')
        ?.trim();

    List<RepositoryBuildBy> buildBys = [];
    var buildByNodes = item.querySelectorAll('.avatar');
    if (buildByNodes != null && buildByNodes.isNotEmpty) {
      buildByNodes.forEach((e) {
        buildBys.add(RepositoryBuildBy(
          avatar: e.attributes['src'],
          username: e.attributes['alt'].replaceFirst('@', ''),
        ));
      });
    }

    return TrendingRepository(
      owner: username,
      avatar: '${URL_ADDRESS}/${username}.png',
      name: name,
      description: description,
      descriptionHTML: descriptionHTML,
      starCount: starCount,
      forkCount: forkCount,
      stars: starsStr,
      primaryLanguage: primaryLanguage,
      buildBys: buildBys,
    );
  }).toList();
}

Future<List<TrendingDeveloper>> getTrendingDevelopers({
  String since,
  String language,
}) async {
  var url = '${URL_ADDRESS}/trending/developers';
  if (language != null) {
    url += '/$language';
  }

  if (since != null) {
    url += '?since=$since';
  }

  var res = await httpClient.get(url);
  var document = parse(res.body);
  var items = document.querySelectorAll('.Box-row');
  return items.map((item) {
    PopularRepository popularRepository;
    var popularNode =
        item.querySelector('.d-sm-flex>div>div')?.nextElementSibling;
    if (popularNode != null) {
      var description = popularNode.querySelector('.mt-1')?.innerHtml?.trim();

      if (popularNode.querySelector('div>article>h1>a') != null &&
          popularNode.querySelector('div>article>h1>a').attributes == null) {
        popularNode.querySelector('div>article>h1>a').attributes = Map();
        print('current node:${popularNode.querySelector('div>article>h1>a')}');
        print('parent node:${popularNode.querySelector('div>article>h1')}');
      }

      popularRepository = PopularRepository(
        url: popularNode
            .querySelector('div>article>h1>a')
            ?.attributes
            .toString()
            ?.trim(),
        name: popularNode.querySelector('div>article>h1>a')?.text?.trim(),
        description: description
                ?.replaceAll(RegExp(r'<g-emoji.*?>'), '')
                ?.replaceAll(RegExp(r'</g-emoji>'), '')
                ?.replaceAll(RegExp(r'<a.*?>'), '')
                ?.replaceAll(RegExp(r'</a>'), '') ??
            '',
        descriptionRawHtml: '<div>${description ?? ''}</div>',
      );
    }

    return TrendingDeveloper(
      avatar: item.querySelector('.rounded-1')?.attributes['src']?.trim(),
      username: item.querySelector('.link-gray')?.innerHtml?.trim(),
      nickname: item
          .querySelector('.d-md-flex')
          ?.querySelector('.lh-condensed')
          ?.text
          ?.trim(),
      popularRepository: popularRepository,
    );
  }).toList();
}
