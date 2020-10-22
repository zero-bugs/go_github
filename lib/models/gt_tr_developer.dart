import 'package:json_annotation/json_annotation.dart';

part 'gt_tr_developer.g.dart';

@JsonSerializable(includeIfNull: false)
class TrendingDeveloper {
  String avatar;
  String username;
  String nickname;
  PopularRepository popularRepository;

  TrendingDeveloper({
    this.avatar,
    this.username,
    this.nickname,
    this.popularRepository,
  });

  Map<String, dynamic> toJson() => _$TrendingDeveloperToJson(this);

  factory TrendingDeveloper.fromJson(Map<String, dynamic> json) =>
      _$TrendingDeveloperFromJson(json);

  @override
  String toString() {
    return 'TrendingDeveloper{avatar: $avatar, username: $username, nickname: $nickname, popularRepository: $popularRepository}';
  }
}

@JsonSerializable(includeIfNull: false)
class PopularRepository {
  String url;
  String name;
  String description;
  String descriptionRawHtml;

  PopularRepository({
    this.url,
    this.name,
    this.description,
    this.descriptionRawHtml,
  });

  Map<String, dynamic> toJson() => _$PopularRepositoryToJson(this);

  factory PopularRepository.fromJson(Map<String, dynamic> json) =>
      _$PopularRepositoryFromJson(json);

  @override
  String toString() {
    return 'PopularRepository{url: $url, name: $name, description: $description, descriptionRawHtml: $descriptionRawHtml}';
  }
}
