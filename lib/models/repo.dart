import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'repo.g.dart';

@JsonSerializable()
class Repo {
  Repo();
  num id;
  String node_id;
  String name;
  String full_name;
  User owner;
  Repo parent;
  bool private;
  String html_url;
  String description;
  bool fork;
  String homepage;
  String language;
  num forks_count;
  num stargazers_count;
  num watchers_count;
  num open_issues_count;
  num forks;
  num open_issues;
  num watchers;
  num subscribersCount;
  num size;
  String default_branch;
  List topics;
  bool has_issues;
  bool has_projects;
  bool has_downloads;
  bool has_wiki;
  bool has_pages;
  String git_url;
  String ssh_url;
  String clone_url;
  String svn_url;
  String pushed_at;
  String created_at;
  String updated_at;
  Map<String, dynamic> permissions;
  Map<String, dynamic> license;

  factory Repo.fromJson(Map<String, dynamic> json) => _$RepoFromJson(json);
  Map<String, dynamic> toJson() => _$RepoToJson(this);
}
