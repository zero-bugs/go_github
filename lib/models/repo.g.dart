// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repo _$RepoFromJson(Map<String, dynamic> json) {
  return Repo()
    ..id = json['id'] as num
    ..name = json['name'] as String
    ..fullName = json['fullName'] as String
    ..owner = json['owner'] == null
        ? null
        : User.fromJson(json['owner'] as Map<String, dynamic>)
    ..parent = json['parent'] == null
        ? null
        : Repo.fromJson(json['parent'] as Map<String, dynamic>)
    ..private = json['private'] as bool
    ..htmlUrl = json['htmlUrl'] as String
    ..description = json['description'] as String
    ..fork = json['fork'] as bool
    ..homepage = json['homepage'] as String
    ..language = json['language'] as String
    ..forksCount = json['forksCount'] as num
    ..stargazersCount = json['stargazersCount'] as num
    ..watchersCount = json['watchersCount'] as num
    ..size = json['size'] as num
    ..defaultBranch = json['defaultBranch'] as String
    ..openIssuesCount = json['openIssuesCount'] as num
    ..topics = json['topics'] as List
    ..hasIssues = json['hasIssues'] as bool
    ..hasProjects = json['hasProjects'] as bool
    ..hasWiki = json['hasWiki'] as bool
    ..hasPages = json['hasPages'] as bool
    ..hasDownloads = json['hasDownloads'] as bool
    ..pushedAt = json['pushedAt'] as String
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..permissions = json['permissions'] as Map<String, dynamic>
    ..subscribersCount = json['subscribersCount'] as num
    ..license = json['license'] as Map<String, dynamic>;
}

Map<String, dynamic> _$RepoToJson(Repo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fullName': instance.fullName,
      'owner': instance.owner,
      'parent': instance.parent,
      'private': instance.private,
      'htmlUrl': instance.htmlUrl,
      'description': instance.description,
      'fork': instance.fork,
      'homepage': instance.homepage,
      'language': instance.language,
      'forksCount': instance.forksCount,
      'stargazersCount': instance.stargazersCount,
      'watchersCount': instance.watchersCount,
      'size': instance.size,
      'defaultBranch': instance.defaultBranch,
      'openIssuesCount': instance.openIssuesCount,
      'topics': instance.topics,
      'hasIssues': instance.hasIssues,
      'hasProjects': instance.hasProjects,
      'hasWiki': instance.hasWiki,
      'hasPages': instance.hasPages,
      'hasDownloads': instance.hasDownloads,
      'pushedAt': instance.pushedAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'permissions': instance.permissions,
      'subscribersCount': instance.subscribersCount,
      'license': instance.license
    };
