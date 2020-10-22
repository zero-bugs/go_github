import 'package:json_annotation/json_annotation.dart';

part 'gt_tr_repository.g.dart';

@JsonSerializable(includeIfNull: false)
class TrendingRepository {
  String owner;
  String avatar;
  String name;
  String description;
  String descriptionHTML;
  int starCount;
  int forkCount;
  String stars;
  PrimaryLanguage primaryLanguage;
  List<RepositoryBuildBy> buildBys;

  TrendingRepository({
    this.owner,
    this.avatar,
    this.name,
    this.description,
    this.descriptionHTML,
    this.starCount,
    this.forkCount,
    this.stars,
    this.primaryLanguage,
    this.buildBys,
  });

  @override
  String toString() {
    return 'TrendingRepository{owner: $owner, avatar: $avatar, name: $name, description: $description, descriptionHTML: $descriptionHTML, starCount: $starCount, forkCount: $forkCount, stars: $stars, primaryLanguage: $primaryLanguage, buildBys: $buildBys}';
  }

  Map<String, dynamic> toJson() => _$TrendingRepositoryToJson(this);

  factory TrendingRepository.fromJson(Map<String, dynamic> json) =>
      _$TrendingRepositoryFromJson(json);
}

@JsonSerializable(includeIfNull: false)
class RepositoryBuildBy {
  String avatar;
  String username;

  RepositoryBuildBy({
    this.avatar,
    this.username,
  });

  Map<String, dynamic> toJson() => _$RepositoryBuildByToJson(this);

  factory RepositoryBuildBy.fromJson(Map<String, dynamic> json) =>
      _$RepositoryBuildByFromJson(json);
}

@JsonSerializable(includeIfNull: false)
class PrimaryLanguage {
  String name;
  String color;

  PrimaryLanguage({this.name, this.color});

  Map<String, dynamic> toJson() => _$PrimaryLanguageToJson(this);

  factory PrimaryLanguage.fromJson(Map<String, dynamic> json) =>
      _$PrimaryLanguageFromJson(json);
}
