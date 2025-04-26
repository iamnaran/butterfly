// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostResponse _$PostResponseFromJson(Map<String, dynamic> json) => PostResponse(
      posts: (json['posts'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      skip: (json['skip'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$PostResponseToJson(PostResponse instance) =>
    <String, dynamic>{
      'posts': instance.posts,
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
    };

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      body: json['body'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      reactions: json['reactions'] == null
          ? null
          : Reactions.fromJson(json['reactions'] as Map<String, dynamic>),
      views: (json['views'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'tags': instance.tags,
      'reactions': instance.reactions,
      'views': instance.views,
      'userId': instance.userId,
    };

Reactions _$ReactionsFromJson(Map<String, dynamic> json) => Reactions(
      likes: (json['likes'] as num?)?.toInt(),
      dislikes: (json['dislikes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReactionsToJson(Reactions instance) => <String, dynamic>{
      'likes': instance.likes,
      'dislikes': instance.dislikes,
    };
