import 'package:json_annotation/json_annotation.dart';

part 'post_response.g.dart';

@JsonSerializable()
class PostResponse {
  List<Post> posts;
  int total;
  int skip;
  int limit;

  PostResponse({
    required this.posts,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) =>
      _$PostResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostResponseToJson(this);
}

@JsonSerializable()
class Post {
  int? id;
  String? title;
  String? body;
  List<String>? tags;
  Reactions? reactions;
  int? views;
  int? userId;

  Post({
    this.id,
    this.title,
    this.body,
    this.tags,
    this.reactions,
    this.views,
    this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

@JsonSerializable()
class Reactions {
  int? likes;
  int? dislikes;

  Reactions({this.likes, this.dislikes});

  factory Reactions.fromJson(Map<String, dynamic> json) =>
      _$ReactionsFromJson(json);

  Map<String, dynamic> toJson() => _$ReactionsToJson(this);
}