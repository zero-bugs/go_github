import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User();

  String login;
  num id;
  String avaterUrl;
  String url;
  String type;
  bool siteAdmin;
  String name;
  String company;
  String blog;
  String location;
  String email;
  bool hireable;
  String bio;
  num publicRepos;
  num publicGists;
  num followers;
  num follower;
  String createAt;
  String updatedAt;
  num totalPrivateRepos;
  num ownedPrivateRepos;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() =>_$UserToJson(this);
}