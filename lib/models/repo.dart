import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'repo.g.dart';

@JsonSerializable()
class Repo {
  Repo();

  num id;
  String name;
  String fullName;
  User owner;
  Repo parent;
  bool private;
  String htmlUrl;
  String description;
  bool fork;
  String homepage;
  String language;
  num forksCount;
  num stargazersCount;
  num watchersCount;
  num size;
  String defaultBranch;
  num openIssuesCount;
  List topics;
  bool hasIssues;
  bool hasProjects;
  bool hasWiki;
  bool hasPages;
  bool hasDownloads;
  String pushedAt;
  String createdAt;
  String updatedAt;
  Map<String, dynamic> permissions;
  num subscribersCount;
  Map<String, dynamic> license;

  factory Repo.fromJson(Map<String, dynamic> json) => _$RepoFromJson(json);
  Map<String, dynamic> toJson() => _$RepoToJson(this);
}
