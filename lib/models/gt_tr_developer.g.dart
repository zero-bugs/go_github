// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gt_tr_developer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendingDeveloper _$TrendingDeveloperFromJson(Map<String, dynamic> json) {
  return TrendingDeveloper(
    avatar: json['avatar'] as String,
    username: json['username'] as String,
    nickname: json['nickname'] as String,
    popularRepository: json['popularRepository'] == null
        ? null
        : PopularRepository.fromJson(
            json['popularRepository'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TrendingDeveloperToJson(TrendingDeveloper instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('avatar', instance.avatar);
  writeNotNull('username', instance.username);
  writeNotNull('nickname', instance.nickname);
  writeNotNull('popularRepository', instance.popularRepository);
  return val;
}

PopularRepository _$PopularRepositoryFromJson(Map<String, dynamic> json) {
  return PopularRepository(
    url: json['url'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    descriptionRawHtml: json['descriptionRawHtml'] as String,
  );
}

Map<String, dynamic> _$PopularRepositoryToJson(PopularRepository instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('url', instance.url);
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  writeNotNull('descriptionRawHtml', instance.descriptionRawHtml);
  return val;
}
