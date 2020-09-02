import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User();

  String login;
  num id;
  String node_id;
  String avatar_url;
  String url;
  String html_url;
  String followers_url;
  String following_url;
  String gists_url;
  String starred_url;
  String subscriptions_url;
  String organizations_url;
  String repos_url;
  String events_url;
  String received_events_url;
  String type;
  bool site_admin;
  String name;
  String company;
  String blog;
  String location;
  String email;
  bool hireable;
  String bio;
  String twitter_username;
  num public_repos;
  num public_gists;
  num followers;
  num following;
  String created_at;
  String updated_at;
  num total_private_repos;
  num owned_private_repos;
  num dis_usage;
  num collaborators;
  bool two_factor_authentication;
  Plan plan;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Plan {
  Plan();
  String name;
  num space;
  num collaborators;
  num private_repos;
  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
  Map<String, dynamic> toJson() => _$PlanToJson(this);
}
