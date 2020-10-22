// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gt_tr_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendingRepository _$TrendingRepositoryFromJson(Map<String, dynamic> json) {
  return TrendingRepository(
    owner: json['owner'] as String,
    avatar: json['avatar'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    descriptionHTML: json['descriptionHTML'] as String,
    starCount: json['starCount'] as int,
    forkCount: json['forkCount'] as int,
    stars: json['stars'] as String,
    primaryLanguage: json['primaryLanguage'] == null
        ? null
        : PrimaryLanguage.fromJson(
            json['primaryLanguage'] as Map<String, dynamic>),
    buildBys: (json['buildBys'] as List)
        ?.map((e) => e == null
            ? null
            : RepositoryBuildBy.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TrendingRepositoryToJson(TrendingRepository instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('owner', instance.owner);
  writeNotNull('avatar', instance.avatar);
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('descriptionHTML', instance.descriptionHTML);
  writeNotNull('starCount', instance.starCount);
  writeNotNull('forkCount', instance.forkCount);
  writeNotNull('stars', instance.stars);
  writeNotNull('primaryLanguage', instance.primaryLanguage);
  writeNotNull('buildBys', instance.buildBys);
  return val;
}

RepositoryBuildBy _$RepositoryBuildByFromJson(Map<String, dynamic> json) {
  return RepositoryBuildBy(
    avatar: json['avatar'] as String,
    username: json['username'] as String,
  );
}

Map<String, dynamic> _$RepositoryBuildByToJson(RepositoryBuildBy instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('avatar', instance.avatar);
  writeNotNull('username', instance.username);
  return val;
}

PrimaryLanguage _$PrimaryLanguageFromJson(Map<String, dynamic> json) {
  return PrimaryLanguage(
    name: json['name'] as String,
    color: json['color'] as String,
  );
}

Map<String, dynamic> _$PrimaryLanguageToJson(PrimaryLanguage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('color', instance.color);
  return val;
}
