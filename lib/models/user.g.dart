// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..login = json['login'] as String
    ..id = json['id'] as num
    ..avaterUrl = json['avaterUrl'] as String
    ..url = json['url'] as String
    ..type = json['type'] as String
    ..siteAdmin = json['siteAdmin'] as bool
    ..name = json['name'] as String
    ..company = json['company'] as String
    ..blog = json['blog'] as String
    ..location = json['location'] as String
    ..email = json['email'] as String
    ..hireable = json['hireable'] as bool
    ..bio = json['bio'] as String
    ..publicRepos = json['publicRepos'] as num
    ..publicGists = json['publicGists'] as num
    ..followers = json['followers'] as num
    ..follower = json['follower'] as num
    ..createAt = json['createAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..totalPrivateRepos = json['totalPrivateRepos'] as num
    ..ownedPrivateRepos = json['ownedPrivateRepos'] as num;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'login': instance.login,
      'id': instance.id,
      'avaterUrl': instance.avaterUrl,
      'url': instance.url,
      'type': instance.type,
      'siteAdmin': instance.siteAdmin,
      'name': instance.name,
      'company': instance.company,
      'blog': instance.blog,
      'location': instance.location,
      'email': instance.email,
      'hireable': instance.hireable,
      'bio': instance.bio,
      'publicRepos': instance.publicRepos,
      'publicGists': instance.publicGists,
      'followers': instance.followers,
      'follower': instance.follower,
      'createAt': instance.createAt,
      'updatedAt': instance.updatedAt,
      'totalPrivateRepos': instance.totalPrivateRepos,
      'ownedPrivateRepos': instance.ownedPrivateRepos
    };
